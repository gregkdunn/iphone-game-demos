//
//  ItemEntity.m
//  genePool9b2b
//
//  Created by Greg Dunn on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ItemEntity.h"

@implementation ItemEntity
@synthesize itemType;
- (id) init
{
	self = [super init];
	
	if(!self.itemType){
		[self setItemType:Stationary];
	}
	
	if(self != nil)
	{
		if((self.itemType == 2) || (self.itemType == 4))
		{
			[self setMobility:[[Mobility alloc]init]];
		}
		if(self.itemType > 2)
		{
			[self setStats:[[Stats alloc]init]];
			[self setInventory:[[Inventory alloc]init]];
		}	
	}	
	return self;
}

@end