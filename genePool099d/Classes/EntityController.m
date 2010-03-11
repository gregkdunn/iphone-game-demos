//
//  EntityController.m
//  genePool9b2b
//
//  Created by Greg Dunn on 2/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "EntityController.h"


@implementation EntityController

@synthesize entityModel, entityView, entityForceVector;
- (id) init
{
	self = [super init];
	
	if(self != nil)
	{
		
	}	
	return self;
}


- (void) setMaxVelocity:(CGPoint)localCGPoint{
	[[[self entityModel] mobility] updateMaxVectorWithCGPoint:localCGPoint];
}

- (CGPoint) updateVelocity:(CGPoint)localVelocity withDeltaTime:(ccTime)localDeltaTime{
	return [[self entityView] updatePosition:[[[self entityModel] mobility] applyForceWithCGPoint:localVelocity andDeltaTime:localDeltaTime] ];
	//Takes outside velocity via CGPoint, updates Player Model which returns updated Force Vector (Vector3D) and updates Player View.
}

- (CGPoint) updateVelocity:(CGPoint)localVelocity andRotation:(CGPoint)localRotation withDeltaTime:(ccTime)localDeltaTime{
	//NSLog(@"player.updateVelocity x:%f y:%f",localVelocity.x, localVelocity.y);
	[[self entityForceVector] setX:(localVelocity.x * 2)];
	[[self entityForceVector] setY:(localVelocity.y * 2)];
	[[self entityForceVector] setRotation:localRotation.x];
	
	return [self updatePosition:[[[self entityModel] mobility] applyForceWithVector:[self entityForceVector] andDeltaTime:localDeltaTime] ];
	
	//Takes outside velocity and rotation via CGPoint, updates Player Model which returns updated Force Vector (Vector3D) and updates Player View.
}

- (CGPoint) updatePosition:(Vector3D *)localForceVector{
	NSLog(@"PlayerController.updatePosition self.rotation:%f localForceVector:%f", self.rotation, localForceVector.rotation);
	[self setPosition: ccp((self.position.x + localForceVector.x), (self.position.y + localForceVector.y))];
	[self setRotation: localForceVector.rotation];
	//NSLog(@"player.position.x: %f player.position.y: %f", self.position.x, self.position.y);
	//NSLog(@"player.width: %f player.height: %f", self.contentSize.width, self.contentSize.height);
	//NSLog(@"player.anchor.x: %f player.anchor.y: %f", self.anchorPoint.x, self.anchorPoint.y);
	//NSLog(@"playerView.position.x: %f playerView.positionView.y: %f", self.entityView.position.x, self.entityView.position.y);
	//NSLog(@"playerView.width: %f playerView.height: %f", self.entityView.contentSize.width, self.entityView.contentSize.height);
	//NSLog(@"playerView.anchor.x: %f playerView.anchor.y: %f", self.entityView.anchorPoint.x, self.entityView.anchorPoint.x);
	return self.position;
}

- (void) dealloc{
	[[self entityModel] release];
	[[self entityView] release];
	[[self entityForceVector] release];
	[super dealloc];
}

@end
