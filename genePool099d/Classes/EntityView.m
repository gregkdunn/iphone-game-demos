//
//  EntityView.m
//  genePool9b2b
//
//  Created by Greg Dunn on 2/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "EntityView.h"

@implementation EntityView

- (void) updateAnimation:(CCAnimation *)animation{
	[sprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] ]];
}

- (void) updateAnimationFast{
	[self updateAnimation:fastAnimation];
}

- (void) updateAnimationNormal{
	[self updateAnimation:normalAnimation];
}

- (CGPoint) updatePosition:(Vector3D *)localForceVector{
	NSLog(@"PlayerView.updatePosition self.rotation:%f localForceVector:%f", sprite.rotation, localForceVector.rotation);
	sprite.position = ccp((self.position.x + localForceVector.x), (self.position.y + localForceVector.y));
	sprite.rotation = localForceVector.rotation;
	return sprite.position;
}

@end
