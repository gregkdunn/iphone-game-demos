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
	[self runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] ]];
}

- (void) updateAnimationFast{
	[self updateAnimation:fastAnimation];
}

- (void) updateAnimationNormal{
	[self updateAnimation:normalAnimation];
}

@end
