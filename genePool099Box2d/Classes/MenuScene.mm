//
//  MenuScene.m
//  menuTutorial
//
//  Created by Greg Dunn on 9/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "CCMenuItem.h"
#import "CCMenu.h"
#import "LevelSelectScene.h"
#import "OptionsScene.h"
#import "InstructionsScene.h"
#import "HighScoreScene.h"
#import "CreditsScene.h"
#import "cocos2d.h"
#import "LogoLayer.h"
#import "CCSprite.h"

@implementation MenuScene
- (id) init
{
	self = [super init];
	if (self != nil) {
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		bg.position = ccp(240, 160);
		[self addChild:bg];	
		
		LogoLayer *logoLayer = [LogoLayer node];
        [self addChild:logoLayer];
		
		//[CCMenuItemFont setFontName:@"Arial"];
		[CCMenuItemFont setFontSize:20];

		CCMenuItem *menuItem1 = [CCMenuItemFont itemFromString:@"Start Game" target:self selector:@selector(onGame:)];
		CCMenuItem *menuItem2 = [CCMenuItemFont itemFromString:@"Options" target:self selector:@selector(onOptions:)];
		CCMenuItem *menuItem3 = [CCMenuItemFont itemFromString:@"Instructions" target:self selector:@selector(onInstructions:)];
		CCMenuItem *menuItem4 = [CCMenuItemFont itemFromString:@"High Score" target:self selector:@selector(onHighScore:)];
		CCMenuItem *menuItem5 = [CCMenuItemFont itemFromString:@"Credits" target:self selector:@selector(onCredits:)];
		
		CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, menuItem4,menuItem5, nil];
		[menu alignItemsVerticallyWithPadding:10];
		menu.position = ccp(250,155);
		[self addChild:menu];
	}
	return self;
}
- (void)onGame:(id)sender
{
	//NSLog(@"on game");
	[[CCDirector sharedDirector] replaceScene:[LevelSelectScene node]];
}
- (void)onOptions:(id)sender
{
	//NSLog(@"on options");
	[[CCDirector sharedDirector] replaceScene:[OptionsScene node]];
}
- (void)onInstructions:(id)sender
{
	//NSLog(@"on instructions");
	[[CCDirector sharedDirector] replaceScene:[InstructionsScene node]];
}
- (void)onHighScore:(id)sender
{
	//NSLog(@"on high scores");
	[[CCDirector sharedDirector] replaceScene:[HighScoreScene node]];
}
- (void)onCredits:(id)sender
{
	//NSLog(@"on credits");
	[[CCDirector sharedDirector] replaceScene:[CreditsScene node]];
}
@end
