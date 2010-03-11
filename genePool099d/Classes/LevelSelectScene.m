//
//  LevelSelectScene.m
//  menuTutorial
//
//  Created by Greg Dunn on 9/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectScene.h"
#import "cocos2d.h"
#import "Game.h"
#import "GameScene.h"
#import "Helper.h"
#import "MenuScene.h"

@implementation LevelSelectScene

@synthesize currentLevelIndex, highestLevelIndex;

- (id) init
{
	self = [super init];
	if (self != nil) {
		
		currentLevelIndex = [Game getCurrentLevelIndex];
		highestLevelIndex = [[Helper getUserValueForKey:@"highestlevel" withDefault:@"1"] intValue];
		
		[self displayLevelSelectMenu];
				
	}
	return self;
}

- (void)displayLevelSelectMenu
{
	CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
	bg.position = ccp(240, 160);
	[self addChild:bg];
	CCLabel *label = [CCLabel labelWithString:@"level select scene" fontName:@"Arial" fontSize:13];
	label.position = ccp(240, 300);
	[self addChild:label];
	
	[CCMenuItemFont setFontSize:20];
	
	CCMenuItem *menuLevel1 = [CCMenuItemFont itemFromString:@"Level One" target:self selector:@selector(onLevelSelect:)];
	[menuLevel1 setTag:0001];
	
	CCMenuItem *menuLevel2 = [CCMenuItemFont itemFromString:@"Level Two" target:self selector:@selector(onLevelSelect:)];
	[menuLevel2 setTag:0002];
	if (highestLevelIndex < 2) {[menuLevel2 setIsEnabled:FALSE];};
	
	CCMenuItem *menuLevel3 = [CCMenuItemFont itemFromString:@"Level Three" target:self selector:@selector(onLevelSelect:)];
	[menuLevel3 setTag:0003];
	if (highestLevelIndex < 3) {[menuLevel3 setIsEnabled:FALSE];};
	
	CCMenu *menu = [CCMenu menuWithItems:menuLevel1, menuLevel2, menuLevel3, nil];
	[menu alignItemsVerticallyWithPadding:10];
	menu.position = ccp(240,170);
	[self addChild:menu];	
	
	CCMenuItem *menuItemMain = [CCMenuItemFont itemFromString:@"Back to Main" target:self selector:@selector(onMain:)];
	
	CCMenu *menuMain = [CCMenu menuWithItems: menuItemMain, nil];
	[menuMain alignItemsVerticallyWithPadding:10];
	menuMain.position = ccp(240,20);
	[self addChild:menuMain];		
	
}

- (void)onLevelSelect:(id)sender
{
	//NSLog(@"on level select: %i", [sender tag]);
	[Game setCurrentLevelIndex:[sender tag]];//Set to whatever button was pressed.
	[Game setCurrentLivesLeft:[Game getDefaultLivesLeft]];
	NSLog(@"LevelSelectScene->onLevelSelect->currentLivesLeft: %i", [Game getCurrentLivesLeft]);
	[[CCDirector sharedDirector] replaceScene:[GameScene node]];
}

- (void)onMain:(id)sender
{
	//NSLog(@"on main");
	[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
}
@end
