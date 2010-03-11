//
//  Vector3D.m
//  genePool
//
//  Created by Greg Dunn on 10/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Vector3D.h"

@implementation Vector3D

@synthesize x, y, z, rotation;

-(id)init{
	return [self initWithX:0 Y:0 Z:0 andRotation:0];	
}


-(id)initWithCGPoint:(CGPoint)localPoint{
	return 	[self initWithX:localPoint.x Y:localPoint.y Z:0 andRotation:0];
}

-(id)initWithX:(float)localX Y:(float)localY Z:(float)localZ andRotation:(float)localRotation{
	self = [super init];
	if(self != nil)
	{		
		NSLog(@"Vector3D->init");
		[self setX:localX];
		[self setY:localY];
		[self setY:localZ];
		[self setY:localRotation];			
	}	
	return self;	
}

- (void) add: (Vector3D *) v3D
{
	x += v3D.x;
	y += v3D.y;
	z += v3D.z;
}

- (void) limitTo: (Vector3D *) v3D
{
	if(x > v3D.x){x = v3D.x;};
	if(x < -(v3D.x)){x = -(v3D.x);};
	if(y > v3D.y){y = v3D.y;};
	if(y < -(v3D.y)){y = -(v3D.y);};
	if(z > v3D.z){z = v3D.z;};
	if(z < -(v3D.z)){z = -(v3D.x);};
	if(rotation > v3D.rotation){rotation = v3D.rotation;};
	if(rotation < -(v3D.rotation)){rotation = -(v3D.rotation);};
}

- (void) scaleTo: (float) value
{
	x *= value;
	y *= value;
	z *= value;
}

- (void) rotateBy: (float) value
{
	rotation += value;
}



@end
