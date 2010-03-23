//
//  EntityView.h
//  genePool9b2b
//
//  Created by Greg Dunn on 2/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCSprite.h"
#import "Vector3D.h"

@interface EntityView : CCSprite {
	CCAnimation *normalAnimation;
	CCAnimation *fastAnimation;
}

- (void) updateAnimation:(CCAnimation *)animation;

- (void) updateAnimationFast;

- (void) updateAnimationNormal;

- (CGPoint) updatePosition:(Vector3D *)localForceVector;

@end
