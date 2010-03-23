//
//  Entity.m
//  genePool
//
//  Created by Greg Dunn on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"


@implementation Entity

@synthesize width, height, x, y, z, rotation, facing, entityType, entityID, stats, inventory, mobility;

- (id) init
{
	self = [super init];
	
	if(self != nil)
	{
	
	}	
	return self;
}

-(void) dealloc {
    [stats release];
    [inventory release];
    [mobility release];
	
    [super dealloc];
}

@end
