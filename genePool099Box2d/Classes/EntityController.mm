//
//  EntityController.m
//  genePool9b2b
//
//  Created by Greg Dunn on 2/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "EntityController.h"
#define entityForceMultiplier 2
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


-(void)setMaxVelocity:(Vector3D *)localVector{
	[[[self entityModel] mobility] updateMaxVector:localVector];
}

-(CGPoint)updateForceVector:(Vector3D *)localVector withDeltaTime:(ccTime)localDeltaTime
{
	[[self entityForceVector] setX:(localVector.x * entityForceMultiplier)];
	[[self entityForceVector] setY:(localVector.y * entityForceMultiplier)];
	[[self entityForceVector] setZ:localVector.z];
	[[self entityForceVector] setRotation:localVector.rotation];
	//NSLog(@"FORCEVECTOR - %@",entityForceVector);
	return [self updateViewPosition:[[[self entityModel] mobility] applyForceWithVector:[self entityForceVector] andDeltaTime:localDeltaTime] ];	
}

-(CGPoint)updateViewPosition:(Vector3D *)localForceVector{
	//NSLog(@"PlayerController.updatePosition self.rotation:%f localForceVector:%f", self.rotation, localForceVector.rotation);
	[[self entityView] setPosition: ccp((self.entityView.position.x + localForceVector.x), (self.entityView.position.y + localForceVector.y))];
	[[self entityView] setRotation: localForceVector.rotation];
	//NSLog(@"player.position.x: %f player.position.y: %f", self.position.x, self.position.y);
	//NSLog(@"player.width: %f player.height: %f", self.contentSize.width, self.contentSize.height);
	//NSLog(@"player.anchor.x: %f player.anchor.y: %f", self.anchorPoint.x, self.anchorPoint.y);
	//NSLog(@"playerView.position.x: %f playerView.positionView.y: %f", self.entityView.position.x, self.entityView.position.y);
	//NSLog(@"playerView.width: %f playerView.height: %f", self.entityView.contentSize.width, self.entityView.contentSize.height);
	//NSLog(@"playerView.anchor.x: %f playerView.anchor.y: %f", self.entityView.anchorPoint.x, self.entityView.anchorPoint.x);
	return [[self entityView] position];
}

-(void)dealloc{
	[[self entityModel] release];
	[[self entityView] release];
	[[self entityForceVector] release];
	[super dealloc];
}

@end
