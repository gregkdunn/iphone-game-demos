//
//  Level.h
//  genePool_8.2
//
//  Created by Greg Dunn on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCNode.h"
#import "CCTMXTiledMap.h"

@interface Level : CCNode {

	CCSprite *background, *overlay;
	
	CCTMXTiledMap *backgroundTileMap, *overlayTileMap;
	
	float worldFriction, worldGravity;
	
	CGPoint playerInitialLocation;
	
	NSMutableArray *enemies;//Enemy objects with starting coordinates and state
	NSMutableArray *items;//Item objects with starting coordinates
		
	Boolean hasIntro;
	CCNode *introBG, *introMovie, *introCountdown;
		
	Boolean hasOutro;
	CCNode *outroBG, *outroMovie;
	
}
@property (nonatomic, assign) CCSprite *background, *overlay;
@property (nonatomic, assign) CCTMXTiledMap *backgroundTileMap, *overlayTileMap;

@property (nonatomic) float worldFriction, worldGravity;

@property (nonatomic) CGPoint playerInitialLocation;

@property (nonatomic, assign) NSMutableArray *enemies, *items;

@property (nonatomic) Boolean hasIntro, hasOutro;
@property (nonatomic, assign) CCNode *introBG, *introMovie, *introCountdown, *outroBG, *outroMovie;

-(Boolean)completedGoal;

@end
