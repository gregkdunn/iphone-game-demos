//
//  Vector3D.h
//  genePool
//
//  Created by Greg Dunn on 10/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Vector3D : NSObject {
	float x;
	float y;
	float z; 
	float rotation;
}

@property(nonatomic) float x, y, z, rotation;

//Methods
- (id) init;
- (id) initWithCGPoint:(CGPoint)localPoint;
- (id) initWithX:(float)localX Y:(float)localY Z:(float)localZ andRotation:(float)localRotation;
- (void) add: (Vector3D *) v3D;
- (void) scaleTo: (float) value;
- (void) limitTo: (Vector3D *) v3D;
- (void) rotateBy: (float) value;

-(NSString *) description;

@end
