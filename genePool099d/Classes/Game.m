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
#import "Helper.h"
#import "HighScoreScene.h"
#import "HUD.h"
#import "Joystick.h"
#import "LevelSelectScene.h"
#import "MenuScene.h"

@implementation Game

@synthesize currentLevel, currentLevelIndex, gameScore, levelScore, livesLeft, gameFieldLayer, hud, hudLayer, map, tileLayer, centerPoint, currentTile;

//Methods
- (id)init
{
	self = [super init];
	
	if(self != nil)
	{		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		NSLog(@"Game->init");
				
		//LOAD THEME		
		
		//RESET LEVEL SCORE
		[self setLevelScore:0];
		
		//LEVEL
		[self buildLevel];
		
		//HUD
		[self buildHUD];
				
		//StartLevel
		[self startLevel];
		
		
		
	}	
	return self;
};


- (id)initWithLevel:(Level*)level atScore:(int)score withLivesLeft:(int)lives
{
	NSLog(@"Game->initWithLevel");
	[self setCurrentLevel:level];//addRetain
	[self setGameScore:score];
	[self setLivesLeft:lives];

	return [self init];
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
	player = [PlayerController node];
	[[[player entityModel] mobility] setFriction:[currentLevel worldFriction]];
	[[[player entityModel] mobility] setGravity:[currentLevel worldGravity]];
	
	[player setPosition:[currentLevel playerInitialLocation]];
	[player setAnchorPoint:ccp(0.5f,0.5f)];
	[gameFieldLayer addChild:player];
	
    
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
	//Main Loop
	[self schedule: @selector(tick:) interval:1.0/60];
}



- (void) onGameOver
{
	[[CCDirector sharedDirector] replaceScene:[GameScene node]];
}

- (void) onLevelEnd
{
	self.gameScore += self.levelScore; 
	[Game setCurrentGameScore:gameScore];
	[Game setCurrentLevelIndex:self.currentLevelIndex+=1];
	[[CCDirector sharedDirector] replaceScene:[GameScene node]];
};


- (void) tick: (ccTime)dt
{
	//NSLog(@"...Tick...");
	//NSLog(@"game.Tick dt:%f",dt);
	//CGPoint vel = [hud getJoystickVelocity];
    //CGPoint rot = [hud getJoystickAngle];
	
	//if((vel.x != 0) || (vel.y != 0)){
		[player updateVelocity:[hud getJoystickVelocity] andRotation:[hud getJoystickAngle] withDeltaTime:dt];
    //}
	 
    //NSLog(@"game.Tick dt:%f",dt);
	//NSLog(@"game.tick.velocity x:%f y:%f",vel.x, vel.y);
	//NSLog(@"game.tick.rotation x:%f y:%f",rot.x, rot.y);
	
	
	[self keepPlayerInBounds];
	
	currentTile = [tileLayer tileGIDAt:[self coordinatesAtPosition:[player position]]];
	[self reactToTile:currentTile withEntity:player];
	//NSLog(@"game.tick tileID:%i",currentTile);
	
	[self setViewpointCenter:[player position]];
	CGPoint coord = [self coordinatesAtPosition:[player position]];
    //NSLog(@"game.tick.coordinates x:%f y:%f", coord.x, coord.y);
	
}

- (void) keepPlayerInBounds
{	
	float newX = player.position.x;
	float newY = player.position.y;
	
	if (player.position.x < 0 ) {
		newX = 0 + tileLayer.mapTileSize.width + (player.contentSize.width / 2); 

	} else if (player.position.x > (tileLayer.mapTileSize.width * tileLayer.layerSize.width) ) {
		newX = (tileLayer.mapTileSize.width * (tileLayer.layerSize.width - 1)) + (player.contentSize.width / 2);

	};
	if (player.position.y < 0 ) {
		newY = 0 + tileLayer.mapTileSize.height + (player.contentSize.height / 2); 

	} else if (player.position.y > (tileLayer.mapTileSize.height * tileLayer.layerSize.height) ) {
		newY = (tileLayer.mapTileSize.height * (tileLayer.layerSize.height - 1)) + (player.contentSize.height / 2);
	};
	if((player.position.x != newX) || (player.position.y != newY)) {
		[player setPosition: ccp(newX, newY)];
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
			//[[[localEntity entityModel] mobility] setRotationMultiplier: -3];
			break;
	}
	
}

- (CGPoint) coordinatesAtPosition:(CGPoint)point
{
	return ccp((int)(point.x / (int)tileLayer.mapTileSize.width), (int)(tileLayer.layerSize.width - (point.y / (int)tileLayer.mapTileSize.height)));
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
	
	if(point.x > (([currentLevel backgroundTileMap].mapSize.width * [currentLevel backgroundTileMap].tileSize.width) - 240))
	{
		viewPoint.x = -(([currentLevel backgroundTileMap].mapSize.width * [currentLevel backgroundTileMap].tileSize.width) -480);
		//NSLog(@"VIEWPOINT.X: %f  Y: %f", viewPoint.x, viewPoint.y);

	}
	
	if(point.y > (([currentLevel backgroundTileMap].mapSize.height * [currentLevel backgroundTileMap].tileSize.height) - 160))
	{
		viewPoint.y = -(([currentLevel backgroundTileMap].mapSize.height * [currentLevel backgroundTileMap].tileSize.height) -320);
		//NSLog(@"VIEWPOINT.X: %f  Y: %f", viewPoint.x, viewPoint.y);

	}
	
	[gameFieldLayer setPosition:viewPoint];
	 
}

 
//Touch Controls
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"GAME.ccTouchesBegan");
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"GAME.ccTouchesMoved");
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"GAME.ccTouchesEnded");
}

- (void) dealloc{
	
	[super dealloc];
}

//STATIC METHODS

+ (int) getCurrentLevelIndex
{
	NSLog(@"Game->getCurrentLevelIndex");
	return [[Helper getUserValueForKey:@"currentlevel" withDefault:@"1"] intValue];
}

+ (void) setCurrentLevelIndex:(int)aLevelIndex
{
	int highestLevelIndex = [[Helper getUserValueForKey:@"highestlevel" withDefault:@"1"] intValue]; 
	if (highestLevelIndex < aLevelIndex)
	{
		[Helper setUserValue:[NSString stringWithFormat:@"%d", aLevelIndex] forKey:@"highestlevel"];
	}
	[Helper setUserValue:[NSString stringWithFormat:@"%d", aLevelIndex] forKey:@"currentlevel"];
}

+ (int) getCurrentGameScore
{
	return [[Helper getUserValueForKey:@"currentGameScore" withDefault:@"0"] intValue];
}

+ (void) setCurrentGameScore:(int)aGameScore
{
	[Helper setUserValue:[NSString stringWithFormat:@"%d", aGameScore] forKey:@"currentGameScore"];
}

+ (int) getCurrentHealth
{
	return [[Helper getUserValueForKey:@"currentHealth" withDefault:@"100"] intValue];
}

+ (void) setCurrentHealth:(int)aHealth
{
	[Helper setUserValue:[NSString stringWithFormat:@"%d", aHealth] forKey:@"currentHealth"];
}

+ (int) getCurrentLivesLeft {
	return [[Helper getUserValueForKey:@"currentLivesLeft" withDefault:@"0"] intValue];
}

+ (void) setCurrentLivesLeft:(int)aLivesLeft {
	[Helper setUserValue:[NSString stringWithFormat:@"%d", aLivesLeft] forKey:@"currentLivesLeft"];
}

+ (int) getDefaultLivesLeft {
	return [[Helper getUserValueForKey:@"defaultLivesLeft" withDefault:@"0"] intValue];
}

+ (void) setDefaultLivesLeft:(int)aLivesLeft
{
	NSLog(@"Game->setDefaultLivesLeft: %i", aLivesLeft);
	[Helper setUserValue:[NSString stringWithFormat:@"%d", aLivesLeft] forKey:@"defaultLivesLeft"];
}

@end
