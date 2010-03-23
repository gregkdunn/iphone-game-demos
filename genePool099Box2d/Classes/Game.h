//
//  Game.h
//  genePool_8.2
//
//  Created by Greg Dunn on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h";
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"
#import "HUD.h";
#import "Level.h"
#import "PlayerController.h"
#import "PlayerView.h"
#import "Vector3D.h"

#define PTM_RATIO 32

@interface Game : CCLayer{

	
	int currentLevelIndex, gameScore, levelScore, livesLeft;
	HUD *hud;
	Level *currentLevel;
	CCLayer *gameFieldLayer, *hudLayer; 
	CCTMXTiledMap *map;
	CCTMXLayer *tileLayer;
	PlayerController *player;
	CCSprite *playerView;
	CGPoint centerPoint;
	CGPoint viewPoint;
	unsigned int currentTile;
	
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    MyContactListener *contactListener;
	CGSize screenSize;
	
	Vector3D *inputForceVector;
}

@property (nonatomic) int currentLevelIndex, gameScore, levelScore, livesLeft;
@property (nonatomic, assign) HUD *hud;
@property (nonatomic, assign) Level *currentLevel;
@property (nonatomic, assign) CCLayer *gameFieldLayer, *hudLayer;
@property (nonatomic, assign) CCTMXTiledMap *map;
@property (nonatomic, assign) CCTMXLayer *tileLayer;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) unsigned int currentTile;
@property (nonatomic, assign) CGSize screenSize;
@property (nonatomic, assign) Vector3D *inputForceVector;


//Methods
-(id)init;
-(id)initWithLevel:(Level*)level atScore:(int)score withLivesLeft:(int)lives;

-(void)buildLevel;
-(void)buildBox2dWorld;
-(void)buildHUD;
-(void)startLevel;
-(void)onLevelEnd;
-(void)onGameOver;

-(void)tick:(ccTime)dt;

-(void)reactToTile:(int)localCurrentTile withEntity:(EntityController*) localEntity;

-(void)keepPlayerInBounds;
-(void)setViewpointCenter:(CGPoint)point;

-(void)stepPhysicsWorld:(ccTime)dt;


@end
