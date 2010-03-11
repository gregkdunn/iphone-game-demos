//
//  PowerUpEntity.h
//  genePool9b2b
//
//  Created by Greg Dunn on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

typedef enum {
	Stationary = 1,
	Movable = 2,
	Destructable = 3,
	MovableAndDestructable = 4 
} PowerUpType;

@interface PowerUpEntity : Entity {
	PowerUpType powerUpType;
}

@property(nonatomic) PowerUpType powerUpType;

@end
