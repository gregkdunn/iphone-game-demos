//
//  GameScene.m
//  menuTutorial
//
//  Created by Greg Dunn on 9/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "cocos2d.h"
#import "Game.h"
#import "Storage.h"
#import "HighScoreScene.h"
#import "Level.h"
#import "Level0001.h"
#import "LevelSelectScene.h"
#import "MenuScene.h"

@implementation GameScene

@synthesize currentLevelIndex, game, currentLevel, currentGameScore, currentLivesLeft, gameHighScore;

- (id) init
{
	self = [super init];
	if (self != nil) {
		NSLog(@"GameScene->init");
		
		self.currentLevelIndex = [Storage getCurrentLevelIndex];
	    self.currentGameScore = [Storage getCurrentGameScore];
		self.currentLivesLeft = [Storage getCurrentLivesLeft];
		
		//On load - check for lives left
		 if ([self currentLivesLeft]  > 0 )
		 {	 
			 NSLog(@"GameScene->init->currentLivesLeft>0 : %i", [self currentLivesLeft]);		 
			 [self loadLevel:[self currentLevelIndex]];
			 [self startLevel];
		 } else { 
			  NSLog(@"GameScene->init->currentLivesLeft<0 : %i", [self currentLivesLeft]);
			 [self onGameOver];
		 }
	}
	return self;
}

- (void)loadLevel:(int)value{
	NSLog(@"GameScene->loadLevel: %i", value); 
	switch (value) {
		case 1:
			NSLog(@"GameScene->loadLevel->switch:1");
			currentLevel = [[Level0001 alloc] init];//addRelease
			break;
		default:
			NSLog(@"GameScene->loadLevel->switch:default"); 
			currentLevel = [[Level0001 alloc] init];//addRelease
			break;
	}
	

};

- (void)loadNextLevel{
	[Storage setCurrentLevelIndex:([Storage getCurrentLevelIndex] + 1)];
	[self loadLevel:[Storage getCurrentLevelIndex]];
};

- (void)startLevel{	
	NSLog(@"GameScene->startLevel");
	self.game = [[Game alloc] initWithLevel:[self currentLevel] atScore:[self currentGameScore] withLivesLeft:[self currentLivesLeft]];
	[self addChild:self.game];	
}

- (void)onGameOver
{
	[self onGameEnd];
};

- (void)onGameEnd
{
	[self setGameHighScore:[[Storage getUserValueForKey:@"gameHighScore" withDefault:@"0"] intValue]];
	
	if ([self currentGameScore] > [self gameHighScore])
	{
		[self onHighScore];
	} else {
		[self onMenu];
	}	
};

- (void)onLevelSelect
{
	[[CCDirector sharedDirector] replaceScene:[LevelSelectScene node]];
}

- (void)onHighScore
{
	//NSLog(@"on high scores");
	[[CCDirector sharedDirector] replaceScene:[HighScoreScene node]];
}

- (void)onMenu
{
	//NSLog(@"on menu scene");
	[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
}
@end
