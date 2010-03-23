//
//  Level.m
//  genePool_8.2
//
//  Created by Greg Dunn on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Level.h"
#import "CCTMXLayer.h"

@implementation Level

@synthesize background, overlay, backgroundTileMap, overlayTileMap, worldFriction, worldGravity, playerInitialLocation, enemies, items, hasIntro, hasOutro, introBG, introMovie, introCountdown, outroBG, outroMovie;

- (id) init
{
	if ((self = [super init]))
	{ 
		
	}
	return (self);
} // init

-(Boolean)completedGoal
{
    if(true)
	{
		return true;
	} else {
		return false;
	}
}

-(CCTMXLayer *)getBackgroundMapLayer{
    return (CCTMXLayer *)[backgroundTileMap getChildByTag:0];
}

-(CGSize)getLevelSize{
    CCTMXLayer *mapLayer = (CCTMXLayer *)[backgroundTileMap getChildByTag:0];
	return CGSizeMake((mapLayer.layerSize.width * mapLayer.mapTileSize.width), (mapLayer.layerSize.height * mapLayer.mapTileSize.height));
}


-(CGPoint)coordinatesAtPosition:(CGPoint)point{
	CCTMXLayer *mapLayer = (CCTMXLayer *)[backgroundTileMap getChildByTag:0];
	return CGPointMake((int)(point.x / (int)mapLayer.mapTileSize.width), (int)(mapLayer.layerSize.width - (point.y / (int)mapLayer.mapTileSize.height)));
}

@end
