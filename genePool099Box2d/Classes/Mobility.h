//
//  Mobility.h
//  genePool
//
//  Created by Greg Dunn on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Vector3D.h"

@interface Mobility : NSObject {

	Vector3D *forceVector;
	Vector3D *maxVector;
	float previousRotation;
	float friction;
	float gravity;
	
	float speedMultiplier;
	float rotationMultiplier;
}
@property (assign)Vector3D *forceVector;
@property (assign)Vector3D *maxVector;
@property float previousRotation;
@property float friction;
@property float gravity;

@property float speedMultiplier;
@property float rotationMultiplier;

//Methods
-(id)init;
-(id)initWithMaxVector:(Vector3D*)localMaxVector;
-(id)initWithMaxVector:(Vector3D*)localMaxVector andFriction:(float)localFriction andGravity:(float)localGravity;
-(void)updateMaxVector:(Vector3D *)localVector;
-(void)updateForceVector:(Vector3D*)localForceVector;
-(void)applyFriction;
-(void)applyGravity;
-(void)applyForce;
-(Vector3D *)applyDeltaTime:(float)localDeltaTime toForceVector:(Vector3D*)localForceVector;
-(Vector3D *)applyForceWithVector:(Vector3D*)localForceVector andDeltaTime:(ccTime)localDeltaTime;	

@end
