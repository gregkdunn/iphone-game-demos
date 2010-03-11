//
//  Inventory.m
//  genePool
//
//  Created by Greg Dunn on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Inventory.h"


@implementation Inventory

@synthesize size;

- (id) init{
		self = [super init];
		
		if(self != nil)
		{
			if(!count){
				count = 0;
			}	
			if(!size){
				size = 0;
			}	
			if(!itemArray){
				itemArray = [[NSMutableArray alloc]init];
			}
		}	
		return self;
}

- (id) initWithSize:(int)value{
	[self setSize:value];	
	return [self init];
}

- (void) onAdd{
	
}
	
- (void) onRemove{
	
}
	
- (BOOL) addItem:(id)value{
	if(size > count)//has open slot
	{
		[itemArray addObject:value];	
		count++;
		return TRUE;
	} else {
		return FALSE;
	}
	
	
}
	
- (BOOL) removeItem:(id)value{
	NSMutableArray *discardedItems = [NSMutableArray array];
	BOOL isRemoved = FALSE;
	for (id item in itemArray)
	{
		if (item == value)
		{	
			[discardedItems addObject:item];
			isRemoved = TRUE;
			count--;
		}
	}	
	
	[itemArray removeObjectsInArray:discardedItems];
	
	return isRemoved;
}

-(NSMutableArray*) getInventory{
	return itemArray;
}
@end
