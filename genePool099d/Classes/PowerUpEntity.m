//
//  PowerUpEntity.m
//  genePool9b2b
//
//  Created by Greg Dunn on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PowerUpEntity.h"


@implementation PowerUpEntity
@synthesize powerUpType;
- (id) init
{
	self = [super init];
	
	if(self != nil)
	{
		[self setStats:[[Stats alloc]init]];
		if((self.powerUpType == 2) || (self.powerUpType == 4))
		{
			[self setMobility:[[Mobility alloc]init]];
		}	
	}	
	return self;
}

@end