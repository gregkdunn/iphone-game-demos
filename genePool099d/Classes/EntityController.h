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
#import "EntityView.h"

@interface EntityController : CCNode {
	Entity *entityModel;	
	EntityView *entityView;
	Vector3D *entityForceVector;	
}

@property (nonatomic, assign) Entity *entityModel;
@property (nonatomic, assign) EntityView *entityView;
@property (nonatomic, assign) Vector3D *entityForceVector;

- (void) setMaxVelocity:(CGPoint)localCGPoint;

- (CGPoint) updateVelocity:(CGPoint)localVelocity withDeltaTime:(ccTime)localDeltaTime;
- (CGPoint) updateVelocity:(CGPoint)localVelocity andRotation:(CGPoint)localRotation withDeltaTime:(float)localDeltaTime;
- (CGPoint) updatePosition:(Vector3D *)localForceVector;
@end
