//
//  Level.m
//  genePool_8.2
//
//  Created by Greg Dunn on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Level.h"


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

@end
