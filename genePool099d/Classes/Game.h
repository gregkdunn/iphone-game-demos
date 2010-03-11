//
//  Game.h
//  genePool_8.2
//
//  Created by Greg Dunn on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLayer.h";
#import "HUD.h";
#import "Level.h"
#import "CCTMXTiledMap.h"
#import "PlayerController.h"

@interface Game : CCLayer{

	
	int currentLevelIndex, gameScore, levelScore, livesLeft;
	HUD *hud;
	Level *currentLevel;
	CCLayer *gameFieldLayer, *hudLayer; 
	CCTMXTiledMap *map;
	CCTMXLayer *tileLayer;
	PlayerController *player;
	CGPoint centerPoint;
	CGPoint viewPoint;
	unsigned int currentTile;
}

@property (nonatomic) int currentLevelIndex, gameScore, levelScore, livesLeft;
@property (nonatomic, assign) HUD *hud;
@property (nonatomic, assign) Level *currentLevel;
@property (nonatomic, assign) CCLayer *gameFieldLayer, *hudLayer;
@property (nonatomic, assign) CCTMXTiledMap *map;
@property (nonatomic, assign) CCTMXLayer *tileLayer;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) unsigned int currentTile;

//Methods
- (id)init;
- (id)initWithLevel:(Level*)level atScore:(int)score withLivesLeft:(int)lives;

- (void)buildLevel;
- (void)buildHUD;
- (void)startLevel;
- (void)onLevelEnd;
- (void)onGameOver;

-(void)tick: (ccTime)dt;

- (CGPoint)coordinatesAtPosition:(CGPoint)point;

- (void) reactToTile:(int)localCurrentTile withEntity:(EntityController*) localEntity;

- (void) keepPlayerInBounds;
- (void) setViewpointCenter:(CGPoint)point;

+ (int) getCurrentLevelIndex;
+ (void) setCurrentLevelIndex:(int)aLevelIndex;

+ (int) getCurrentGameScore;
+ (void) setCurrentGameScore:(int)aGameScore;

+ (int) getCurrentHealth;
+ (void) setCurrentHealth:(int)aHealth;

+ (int) getCurrentLivesLeft;
+ (void) setCurrentLivesLeft:(int)aLivesLeft;

+ (int) getDefaultLivesLeft;
+ (void) setDefaultLivesLeft:(int)aLivesLeft;


@end
