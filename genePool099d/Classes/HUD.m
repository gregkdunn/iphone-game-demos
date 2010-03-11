//
//  HUD.m
//  genePool
//
//  Created by Greg Dunn on 10/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HUD.h"
#import "cocos2d.h"
#import "Game.h"
#import "GameScene.h"
#import "LevelSelectScene.h"
#import "MenuScene.h"

@implementation HUD

- (id) init
{
	self = [super init];
	
	if(self != nil)
	{
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		//Scene Label
		CCLabel *label = [CCLabel labelWithString:@"game scene" fontName:@"Arial" fontSize:13];
		label.position = ccp(240, 300);
		[self addChild:label];
		
		//[MenuItemFont setFontName:@"Arial"];
		[CCMenuItemFont setFontSize:20];
		
		CCMenuItem *menuItem1 = [CCMenuItemFont itemFromString:@"x" target:self selector:@selector(quitGame:)];
		
		CCMenu *menu = [CCMenu menuWithItems:menuItem1, nil];
		[menu alignItemsVerticallyWithPadding:10];
		menu.position = ccp(470,310);
		[self addChild:menu];
		
		scoreBoard = [[HUDComponent alloc]initWithValue:[Game getCurrentGameScore] andLabel:@"Score:"  andComponentFormat:@"%@ %06i" andFontName:@"Arial" andFontSize:12];
		scoreBoard.position = ccp(70, 300);					  
		[self addChild:scoreBoard];
		/*
		healthBar = [[HUDBarComponent alloc]initWithValue:[Game getCurrentHealth] andImage:@"Resources/hudBar2.png" andLabel:@"Health:" andComponentFormat:@"%@ %i" andFontName:@"Arial" andFontSize:12];
		healthBar.position = ccp(70, 277);					  
		[self addChild:healthBar];		
		[[NSNotificationCenter defaultCenter] addObserver:healthBar selector:@selector(notificationValueChange:) name:@"PlayerHealthChange" object:nil]; 
		
		energyBar = [[HUDBarComponent alloc]initWithValue:[Game getCurrentHealth] andImage:@"Resources/hudBar2.png" andLabel:@"Energy:" andComponentFormat:@"%@ %i" andFontName:@"Arial" andFontSize:12];
		energyBar.position = ccp(70, 257);					  
		[self addChild:energyBar];	
		*/
		pauseButton = [HUDButtonComponent buttonWithImage:@"label40x41.png" atPosition:ccp(470, 280) target:self selector:@selector(pauseLevel:)];
		pauseButton.tag = 'pbtn';
		[self addChild:pauseButton];
		
		scoreTimer = [[HUDTimerComponent alloc]initWithValue:0 andLabel:@"Timer:"  andComponentFormat:@"%@ %03i" andFontName:@"Arial" andFontSize:12];
		scoreTimer.position = ccp(469, 253);					  
		scoreTimer.increment = 1;
		[self addChild:scoreTimer];
		[scoreTimer startTimer];
		
		int offset = 30;	
		CCSprite *jsBase = [CCSprite spriteWithFile:@"joystickBase.png"];
		jsBase.opacity = (GLubyte)30;
		jsBase.position = ccp((offset + (jsBase.contentSize.width / 2)),(offset + (jsBase.contentSize.height / 2)));
		[self addChild:jsBase]; 

		CCSprite *jsNub = [CCSprite spriteWithFile:@"joystickNub.png"];
		jsNub.opacity = (GLubyte)60;
		//NSLog(@">>>jsBase X Position:%f Width:%f", jsBase.position.x, jsBase.contentSize.width);
		//NSLog(@">>>jsBase Y Position:%f Height:%f", jsBase.position.y, jsBase.contentSize.height);
		jsNub.position = ccp(jsBase.position.x, jsBase.position.y);
		[self addChild:jsNub]; 		
		
		joyStickRect = CGRectMake(offset, offset, jsBase.contentSize.width, jsBase.contentSize.height);
		[joyStick setStaticCenter:jsNub.position.x y:jsNub.position.y];
		joyStick = [[Joystick alloc]initWithRect:joyStickRect andBase:jsBase andNub:jsNub];
		
	}	
	return self;
}
-(int)getHealth
{
	return [healthBar componentValue];
}

-(void)updateHealth:(int)value
{
	[healthBar updateValue:value];
}


- (void)quitGame:(id)sender
{
	//NSLog(@"on game");
	[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
}

- (void)quitLevel
{
	//Goto Level Select Screen
	[[CCDirector sharedDirector] replaceScene:[LevelSelectScene node]];
};

- (void)restartLevel
{
	[[CCDirector sharedDirector] replaceScene:[GameScene node]];
};

- (void)pauseLevel:(id)sender
{
	[[CCDirector sharedDirector] pause];
	[self removeChild:pauseButton cleanup:TRUE];
	pauseButton = [HUDButtonComponent buttonWithText:@"back" atPosition:ccp(480, 280) target:self selector:@selector(unpauseLevel:)];
	pauseButton.tag = 'pbtn';
	[self addChild:pauseButton];
};

- (void)unpauseLevel:(id)sender
{
	[[CCDirector sharedDirector] resume];
	[self removeChild:pauseButton cleanup:TRUE];
	pauseButton = [HUDButtonComponent buttonWithImage:@"label40x41.png" atPosition:ccp(460, 280) target:self selector:@selector(pauseLevel:)];
	pauseButton.tag = 'pbtn';
	[self addChild:pauseButton];
};



-(CGPoint)getJoystickVelocity
{
	return [joyStick getCurrentVelocity];
}

-(CGPoint)getJoystickAngle
{
	return [joyStick getCurrentDegreeVelocity];
}

//Touch Controls
-(BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
	
	return [joyStick touchesBegan:touches withEvent:event];
}

-(BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"ccTouchesMoved");
	
	return [joyStick touchesMoved:touches withEvent:event];
}

-(BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"ccTouchesEnded");
	
	return [joyStick touchesEnded:touches withEvent:event];
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:healthBar];
	[super dealloc];
}



@end