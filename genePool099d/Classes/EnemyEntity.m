//
//  EnemyEntity.m
//  genePool9b2b
//
//  Created by Greg Dunn on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "EnemyEntity.h"


@implementation EnemyEntity

- (id) init
{
	self = [super init];
	
	if(self != nil)
	{
		[self setStats:[[Stats alloc]init]];
		[self setInventory:[[Inventory alloc]init]];
		[self setMobility:[[Mobility alloc]init]];	
	}	
	return self;
}

@end