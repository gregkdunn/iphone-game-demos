//
//  Mobility.m
//  genePool
//
//  Created by Greg Dunn on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Mobility.h"


@implementation Mobility

@synthesize forceVector, maxVector, previousRotation, friction, gravity, rotationMultiplier, speedMultiplier;

- (id) init{
	forceVector = [[Vector3D alloc] init];
	maxVector = [[Vector3D alloc] init];
	[[self maxVector] setX:50];
	[[self maxVector] setY:50];
	[[self maxVector] setZ:50];
	[[self maxVector] setRotation:50];
	return [self initWithMaxVector:maxVector andFriction:1 andGravity:1];
}

- (id) initWithMaxVector:(Vector3D*)localMaxVector{
	return [self initWithMaxVector:localMaxVector andFriction:1 andGravity:1];
}

- (id) initWithMaxVector:(Vector3D*)localMaxVector andFriction:(float)localFriction andGravity:(float)localGravity{
	self = [super init];
	
	if(self != nil)
	{
	[self setMaxVector:localMaxVector];
	[self setFriction:localFriction];
	[self setGravity:localGravity];
	previousRotation = 0;
	rotationMultiplier = 1;
	speedMultiplier = 1;
	}			
	return self;
}

-(void)updateMaxVector:(Vector3D *)localVector{	
	[[self maxVector] setX:localVector.x];
	[[self maxVector] setY:localVector.y];
	[[self maxVector] setRotation:localVector.rotation];
}

- (void) updateForceVector:(Vector3D*)localForceVector{
	[[self forceVector] setX: forceVector.x + localForceVector.x];
	[[self forceVector] setY: forceVector.y + localForceVector.y];
	[[self forceVector] setRotation: forceVector.rotation + localForceVector.rotation];
}

- (void) applyFriction{
	[[self forceVector] setX: forceVector.x * friction];
	[[self forceVector] setY: forceVector.y * friction];
}

- (void) applyGravity{
	[[self forceVector] setY: forceVector.y * gravity];
}

- (void) applySpeedMultiplier{
	[[self forceVector] setX: forceVector.x * speedMultiplier];
	[[self forceVector] setY: forceVector.y * speedMultiplier];
}

- (void) applyRotationMultiplier{
	[[self forceVector] setRotation: forceVector.rotation * rotationMultiplier];
}

- (Vector3D *) applyDeltaTime:(float)localDeltaTime toForceVector:(Vector3D*)localForceVector{
	[localForceVector setX: localForceVector.x * localDeltaTime];
	[localForceVector setY: localForceVector.y * localDeltaTime];
	//NSLog(@"mobility.DeltaTime:toForceVector forceVector.rotation:%f", self.forceVector.rotation);
	if(self.forceVector.rotation){
	 [self setPreviousRotation: self.forceVector.rotation];
	 [localForceVector setRotation: localForceVector.rotation - self.previousRotation];
	}
	[localForceVector setRotation: localForceVector.rotation * localDeltaTime];
	//UPDATE TO SET ROTATION FORCE RATHER THAN AN EXACT ROTATION 
	return localForceVector;
}

- (void) applyForce{
	[self applyFriction];
	[self applyGravity];
	if(abs(forceVector.x) > abs(maxVector.x)){
		if(forceVector.x > 0){
			[[self forceVector] setX: maxVector.x];
		} else {
			[[self forceVector] setX: -(maxVector.x)];
		}
	}
	if(abs(forceVector.y) > abs(maxVector.y)){
		if(forceVector.y > 0){
			[[self forceVector] setY: maxVector.y];
		} else {
			[[self forceVector] setY: -(maxVector.y)];
		}
	}
	if(abs(forceVector.z) > abs(maxVector.z)){
		if(forceVector.z > 0){
			[[self forceVector] setZ: maxVector.z];
		} else {
			[[self forceVector] setZ: -(maxVector.z)];
		}
	}
	
	if(abs(forceVector.rotation) - abs(previousRotation) > abs(maxVector.rotation)){
		if (((forceVector.rotation < 0) && (previousRotation < 0)) || ((forceVector.rotation > 0) && (previousRotation > 0))){
		  [[self forceVector] setRotation: previousRotation + maxVector.rotation];
		} else {
		  [[self forceVector] setRotation: (previousRotation - maxVector.rotation)];
		}	
	}
	[self applySpeedMultiplier];
	[self applyRotationMultiplier];
	
	//NSLog(@"mobility.applyForce.maxVector x:%f y:%f", maxVector.x, maxVector.y);
	//NSLog(@"mobility.applyForce.forceVector x:%f y:%f", forceVector.x, forceVector.y);
};

- (Vector3D*) applyForceWithVector:(Vector3D*)localForceVector andDeltaTime:(float)localDeltaTime{
	//NSLog(@"mobility.applyForceWithVector deltaTime:%f",localDeltaTime);
	[self updateForceVector:[self applyDeltaTime:localDeltaTime toForceVector:localForceVector]];
	[self applyForce];
	return self.forceVector;
}

- (void) dealloc {
	[forceVector release];
	[maxVector release];
	[super dealloc];
}

@end
