//
//  EntityController.h
//  genePool9b2b
//
//  Created by Greg Dunn on 2/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCNode.h"
#import "Vector3D.h"

#import "Entity.h"
#import "CCSprite.h"

@interface EntityController : CCNode {
	Entity *entityModel;	
	CCSprite *entityView;
	Vector3D *entityForceVector;	
}

@property (nonatomic, assign) Entity *entityModel;
@property (nonatomic, assign) CCSprite *entityView;
@property (nonatomic, assign) Vector3D *entityForceVector;

- (void) setMaxVelocity:(Vector3D *)localVector;
- (CGPoint) updateForceVector:(Vector3D *)localVector withDeltaTime:(ccTime)localDeltaTime;
- (CGPoint) updateViewPosition:(Vector3D *)localForceVector;
@end
