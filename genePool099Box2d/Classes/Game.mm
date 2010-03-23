//
//  Game.m
//  genePool_8.2
//
//  Created by Greg Dunn on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "cocos2d.h"
#import "Game.h"
#import "GameScene.h"
#import "HighScoreScene.h"
#import "HUD.h"
#import "Level0001.h"
#import "Joystick.h"
#import "LevelSelectScene.h"
#import "MenuScene.h"
#import "SimpleAudioEngine.h"
#import "Storage.h"


@implementation Game

@synthesize currentLevel, currentLevelIndex, gameScore, levelScore, livesLeft, gameFieldLayer, hud, hudLayer, map, tileLayer, centerPoint, currentTile, screenSize, inputForceVector;

//Methods
- (id)init
{
	return [self initWithLevel:[[Level0001 alloc] init] atScore:0 withLivesLeft:(int)[Storage getDefaultLives]];
};


- (id)initWithLevel:(Level*)level atScore:(int)score withLivesLeft:(int)lives
{
	self = [super init];
	
	if(self != nil)
	{
      self.isTouchEnabled = YES;
	  self.isAccelerometerEnabled = YES;
	
	  NSLog(@"Game->initWithLevel");
	  [self setCurrentLevel:level];//addRetain
	  [self setGameScore:score];
	  [self setLivesLeft:lives];
	  [self setScreenSize:[currentLevel getLevelSize]];
	  //LOAD THEME		
	
	  //RESET LEVEL SCORE
	  [self setLevelScore:0];
	 
	  //PHYSICS
	  [self buildBox2dWorld];
	
	  //LEVEL
	  [self buildLevel];
	
	  //HUD
	  [self buildHUD];
	
	  //StartLevel
	  [self startLevel];	
	}	
	return self;
}


- (void)buildLevel
{
	NSLog(@"Game->buildLevel");
	gameFieldLayer = [[CCLayer alloc]init];
	[self addChild:gameFieldLayer];
	
	
	//Add Background
	CCSprite *bg = [currentLevel background];
	bg.position = ccp(320, 320);
	[gameFieldLayer addChild:bg];
	
	//Add Background TileMap
	map = [currentLevel backgroundTileMap];
	[gameFieldLayer addChild:map];

	tileLayer = (CCTMXLayer *)[map getChildByTag: 0];
	NSLog(@"buildLevel.tileLayer: %@", tileLayer);
	
	//Add Enemies
	
	//Add Items
	
	//Add Player
	[self spawnPlayer];

	
	//Add Objects	
	[self spawnCar];
    
}

- (void) buildBox2dWorld
{
	CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
	
	// Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);//(0.0f, -10.0f) default
	
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
	bool doSleep = false;//default true 
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	world = new b2World(gravity, doSleep);
	
	world->SetContinuousPhysics(true);
	
	// Debug Draw functions
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2DebugDraw::e_shapeBit;
			flags += b2DebugDraw::e_jointBit;
			flags += b2DebugDraw::e_aabbBit;
			flags += b2DebugDraw::e_pairBit;
			flags += b2DebugDraw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2PolygonShape groundBox;		
	
	// bottom
	groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox);
	
	// top
	groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox);
	
	// left
	groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox);
	
	// right
	groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox);
	
	// Create contact listener
	contactListener = new MyContactListener();
	world->SetContactListener(contactListener);	
	
}	

- (void) buildHUD
{
	NSLog(@"Game->buildHUD");
	hudLayer = [[CCLayer alloc]init];
	[self addChild:hudLayer];
	
	hud = [[HUD alloc]init];
	[hudLayer addChild:hud];
}


- (void) startLevel
{
	NSLog(@"Game->startLevel");
	[self schedule:@selector(secondUpdate:) interval:1.0];
	
	//Main Loop
	[self schedule: @selector(tick:) interval:1.0/60];
}


- (void) tick: (ccTime)dt
{
	//NSLog(@"...Tick...");

	[player updateForceVector:[hud getInputVector] withDeltaTime:dt];

	[self keepPlayerInBounds];
	
	currentTile = [tileLayer tileGIDAt:[currentLevel coordinatesAtPosition:[playerView position]]];
    [self reactToTile:currentTile withEntity:player];
	
	[self setViewpointCenter:[playerView position]];

	[self stepPhysicsWorld:dt];
	
	 //NSLog(@"PLAYER X:%f Y:%f ROT:%f",playerView.position.x,playerView.position.y,playerView.rotation);
}

- (void) keepPlayerInBounds
{	
	float newX = playerView.position.x;
	float newY = playerView.position.y;
	
	if (playerView.position.x < 0 ) {
		newX = 0 + tileLayer.mapTileSize.width + (playerView.contentSize.width / 2); 

	} else if (playerView.position.x > ([currentLevel getLevelSize].width) ) {
		newX = (tileLayer.mapTileSize.width * (tileLayer.layerSize.width - 1)) + (playerView.contentSize.width / 2);

	};
	if (playerView.position.y < 0 ) {
		newY = 0 + tileLayer.mapTileSize.height + (playerView.contentSize.height / 2); 

	} else if (playerView.position.y > ([currentLevel getLevelSize].height) ) {
		newY = (tileLayer.mapTileSize.height * (tileLayer.layerSize.height - 1)) + (playerView.contentSize.height / 2);
	};
	if((playerView.position.x != newX) || (playerView.position.y != newY)) {
		[playerView setPosition: ccp(newX, newY)];
	}
}

- (void) reactToTile:(int)localCurrentTile withEntity:(EntityController*) localEntity
{
	
	switch(localCurrentTile){
		case 0:
			[[[localEntity entityModel] mobility] setSpeedMultiplier: 1];
			[[[localEntity entityModel] mobility] setRotationMultiplier: 1];
			break;
		default:
			[[[localEntity entityModel] mobility] setSpeedMultiplier: -3];
			[[[localEntity entityModel] mobility] setRotationMultiplier: -1];
			if([[self hud] removeHealth:10] <= 0)
			{
				[self onGameOver];
			}
			break;
	}
	
}


- (void) setViewpointCenter:(CGPoint)point
{
	//NSLog(@"point x:%f y:%f",point.x, point.y);
	CGPoint localCenterPoint = ccp(240,160);
	
	viewPoint = ccpSub(localCenterPoint, point);
	//NSLog(@"viewPoint x:%f y:%f",viewPoint.x, viewPoint.y );
	
	//NSLog(@"VIEWPOINT.X: %f  Y: %f", viewPoint.x, viewPoint.y);
	
	// dont scroll so far so we see anywhere outside the visible map which would show up as black bars
	if(point.x < localCenterPoint.x)
	{
		viewPoint.x = 0;
	}

	if(point.y < localCenterPoint.y)
	{
		viewPoint.y = 0;
	}
	
	if(point.x > (([currentLevel getLevelSize].width) - 240))
	{
		viewPoint.x = -(([currentLevel getLevelSize].width) -480);
		//NSLog(@"VIEWPOINT.X: %f  Y: %f", viewPoint.x, viewPoint.y);

	}
	
	if(point.y > (([currentLevel getLevelSize].height) - 160))
	{
		viewPoint.y = -(([currentLevel getLevelSize].height) -320);
		//NSLog(@"VIEWPOINT.X: %f  Y: %f", viewPoint.x, viewPoint.y);

	}
	
	[gameFieldLayer setPosition:viewPoint];
	 
}


- (void) stepPhysicsWorld: (ccTime)dt
{
    world->Step(dt, 8, 1);
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            
            b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO,
                                       sprite.position.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
            
            b->SetTransform(b2Position, b2Angle);
        }
    }
    
    std::vector<b2Body *>toDestroy; 
    std::vector<MyContact>::iterator pos;
    for(pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            
            if (spriteA.tag == 1 && spriteB.tag == 0) {
                toDestroy.push_back(bodyA);
            } else if (spriteA.tag == 0 && spriteB.tag == 1) {
                toDestroy.push_back(bodyB);
            } 
        }        
    }
	
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;     
        if (body->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *) body->GetUserData();
            [gameFieldLayer removeChild:sprite cleanup:YES];
        }
        world->DestroyBody(body);
    }
	
    if (toDestroy.size() > 0) {
        //[[SimpleAudioEngine sharedEngine] playEffect:@"hahaha.caf"];
	    NSLog(@">>>SCORE<<<");
		[[self hud] addScore:1];
    }
	
}

//END GAME
- (void) onGameOver
{
	[[CCDirector sharedDirector] replaceScene:[LevelSelectScene node]];
}

- (void) onLevelEnd
{
	self.gameScore += self.levelScore; 
	[Storage setCurrentGameScore:gameScore];
	[Storage setCurrentLevelIndex:self.currentLevelIndex+=1];
	[[CCDirector sharedDirector] replaceScene:[GameScene node]];
};



//Touch Controls
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"GAME.ccTouchesBegan");
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"GAME.ccTouchesMoved");
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"GAME.ccTouchesEnded");
}



//Add to Physics
- (void)addBoxBodyForSprite:(CCSprite *)sprite {
    
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO);
    spriteBodyDef.userData = sprite;
    b2Body *spriteBody = world->CreateBody(&spriteBodyDef);
    
    b2PolygonShape spriteShape;
    spriteShape.SetAsBox(sprite.contentSize.width/PTM_RATIO/2, sprite.contentSize.height/PTM_RATIO/2);
	
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.density = 10.0;
    spriteShapeDef.isSensor = true;
	
    spriteBody->CreateFixture(&spriteShapeDef);
}

//Remove from Physics and Stage
- (void)spriteDone:(id)sender {
    
    CCSprite *sprite = (CCSprite *)sender;
    
    b2Body *spriteBody = NULL;
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *curSprite = (CCSprite *)b->GetUserData();
            if (sprite == curSprite) {
                spriteBody = b;
                break;
            }
        }
    }
    if (spriteBody != NULL) {
        world->DestroyBody(spriteBody);
    }
    
    [gameFieldLayer removeChild:sprite cleanup:YES];
    
}

- (void)secondUpdate:(ccTime)dt {
    
    [self spawnCat];
    
}

- (void)spawnCat {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *cat = [CCSprite spriteWithFile:@"blocks.png"];
    
    int minY = cat.contentSize.height/2;
    int maxY = screenSize.height - (cat.contentSize.height/2);
    int rangeY = maxY - minY;
    int actualY = arc4random() % rangeY;
    
    int startX = screenSize.width/2;
    int endX = -(cat.contentSize.width/2);
    
    CGPoint startPos = ccp(startX, actualY);
    CGPoint endPos = ccp(endX, actualY);
    
    cat.position = startPos;
    cat.tag = 1;
    
	
    [self addBoxBodyForSprite:cat];
    [gameFieldLayer addChild:cat z:0 tag:1];
    
}

- (void)spawnCar {
    //NSLog(@"spawnCar");
    CCSprite *car = [CCSprite spriteWithFile:@"greyDots.png"];
    car.position = ccp((screenSize.width/2),car.contentSize.height);
    car.tag = 2;
    
    [self addBoxBodyForSprite:car];
    [gameFieldLayer addChild:car z:0 tag:2];
    
}


- (void)spawnPlayer {
	player = [[PlayerController alloc]init];
	[[[player entityModel] mobility] setFriction:[currentLevel worldFriction]];
	[[[player entityModel] mobility] setGravity:[currentLevel worldGravity]];
	
	
	// Animation using Sprite Sheet
	playerView = [CCSprite spriteWithFile:@"label40x41.png"];
	[player setEntityView:playerView];
	
	[playerView setPosition:[currentLevel playerInitialLocation]];
	[playerView setAnchorPoint: ccp(0.5f,0.5f)];
	
	[self addBoxBodyForSprite:playerView];
    [gameFieldLayer addChild:playerView z:3 tag:0];
    
}

//DEBUG DRAW
-(void) draw
{
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
}



- (void) dealloc{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	[super dealloc];
}

@end
