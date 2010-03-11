//
//  Entity.h
//  genePool
//
//  Created by Greg Dunn on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stats.h"
#import "Inventory.h"
#import "Mobility.h"

typedef enum {
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3
} Direction;

typedef enum {
	Player = 0,
	Enemy = 1,
	Weapon = 2,
	Ammo = 3,
	PowerUp = 5,
	Item = 6
} EntityType;

@interface Entity : NSObject {
	
	int width;
	int height;
	float x;
	float y;
	float z; 
	float rotation;
	Direction facing;
	EntityType entityType;
    NSString *entityID;
	Stats *stats;
	Inventory *inventory;
	Mobility *mobility;
}
@property(nonatomic) int width, height;
@property(nonatomic) float x, y, z, rotation;
@property(nonatomic) Direction facing;
@property(nonatomic, assign) EntityType entityType;
@property(nonatomic, assign) NSString *entityID;	Stats *stats;


@property(nonatomic, assign) Stats *stats;
@property(nonatomic, assign) Inventory *inventory;
@property(nonatomic, assign) Mobility *mobility;

@end
