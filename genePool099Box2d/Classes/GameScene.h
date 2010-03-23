//
//  GameScene.h
//  menuTutorial
//
//  Created by Greg Dunn on 9/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "Level.h"
#import "CCScene.h"

@interface GameScene : CCScene {
	Game* game;
	Level* currentLevel;
	int currentLevelIndex, currentGameScore, currentLivesLeft, gameHighScore;
}

@property (nonatomic, assign) Game* game;
@property (nonatomic, assign) Level* currentLevel;
@property (nonatomic) int currentLevelIndex, currentGameScore, currentLivesLeft, gameHighScore;

- (void)loadLevel:(int)value;
- (void)loadNextLevel;
- (void)startLevel;

- (void)onGameOver;
- (void)onGameEnd;

- (void)onHighScore;
- (void)onMenu;
- (void)onLevelSelect;


@end
