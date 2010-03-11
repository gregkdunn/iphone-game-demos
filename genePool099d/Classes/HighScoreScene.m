//
//  HighScoreScene.m
//  menuTutorial
//
//  Created by Greg Dunn on 9/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HighScoreScene.h"
#import "CCLabel.h"
#import "cocos2d.h"
#import "MenuScene.h"
#import "CCSprite.h"

@implementation HighScoreScene
- (id) init
{
	self = [super init];
	if (self != nil) {
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		bg.position = ccp(240, 160);
		[self addChild:bg];
		CCLabel *label = [CCLabel labelWithString:@"high score scene" fontName:@"Arial" fontSize:13];
		label.position = ccp(240, 300);
		[self addChild:label];
		
		//[MenuItemFont setFontName:@"Arial"];
		[CCMenuItemFont setFontSize:20];
		
		CCMenuItem *menuItem1 = [CCMenuItemFont itemFromString:@"Back to Main" target:self selector:@selector(onMain:)];
		
		CCMenu *menu = [CCMenu menuWithItems:menuItem1, nil];
		[menu alignItemsVerticallyWithPadding:10];
		menu.position = ccp(240,20);
		[self addChild:menu];
	}
	return self;
}
- (void)onMain:(id)sender
{
	//NSLog(@"on game");
	[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
}

@end