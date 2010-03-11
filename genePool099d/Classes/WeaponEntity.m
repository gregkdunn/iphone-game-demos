//
//  WeaponEntity.m
//  genePool9b2b
//
//  Created by Greg Dunn on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "WeaponEntity.h"


@implementation WeaponEntity

- (id) init
{
	self = [super init];
	
	if(self != nil)
	{
		[self setArmable:[[Armable alloc]init]];
		[self setInventory:[[Inventory alloc]init]];
		[self setMobility:[[Mobility alloc]init]];	
	}	
	return self;
}

@end
