//
//  AmmoEntity.h
//  genePool9b2b
//
//  Created by Greg Dunn on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Armable.h"

typedef enum {
	Projectile = 1,
	Beam = 2,
	Defensive = 3 
} AmmoType;

@interface AmmoEntity : Entity {
	Armable *armable;
}

@end
