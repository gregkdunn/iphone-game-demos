//
//  Inventory.h
//  genePool
//
//  Created by Greg Dunn on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSArray.h>

@interface Inventory : NSObject {
	int size, count; 
	NSMutableArray *itemArray;
	
}

@property int size;

//Methods
-(id)init;
-(id)initWithSize:(int)value;

-(void) onAdd;
-(void) onRemove;
-(BOOL) addItem:(id)value;
-(BOOL) removeItem:(id)value;
-(NSMutableArray*) getInventory;

@end
