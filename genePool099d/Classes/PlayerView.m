//
//  PlayerView.m
//  genePool_8.2
//
//  Created by Greg Dunn on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PlayerView.h"
#import "cocos2d.h"


@implementation PlayerView
- (id) init
{
	self = [super init];
	
	if(self != nil)
	{
		CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"greyDots.png"];
		CCSpriteFrame *frame0 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(32*0, 32*0, 32, 32) offset:CGPointZero];
		CCSpriteFrame *frame1 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(32*1, 32*0, 32, 32) offset:CGPointZero];
		CCSpriteFrame *frame2 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(32*2, 32*0, 32, 32) offset:CGPointZero];
		CCSpriteFrame *frame3 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(32*3, 32*0, 32, 32) offset:CGPointZero];
		
		//normal
		NSMutableArray *normalAnimFrames = [NSMutableArray array];
		[normalAnimFrames addObject:frame0];
		[normalAnimFrames addObject:frame1];
		[normalAnimFrames addObject:frame2];
		[normalAnimFrames addObject:frame3];
		normalAnimation = [CCAnimation animationWithName:@"Normal" delay:0.2f frames:normalAnimFrames];
		
		//fast
		NSMutableArray *fastAnimFrames = [NSMutableArray array];
		[fastAnimFrames addObject:frame0];
		[fastAnimFrames addObject:frame1];
		[fastAnimFrames addObject:frame2];
		[fastAnimFrames addObject:frame3];
		fastAnimation = [CCAnimation animationWithName:@"Fast" delay:0.1f frames:fastAnimFrames];
		
		// Animation using Sprite Sheet
		sprite = [CCSprite spriteWithSpriteFrame:frame0];
		sprite.position = ccp(0,0);
		sprite.anchorPoint = ccp(0.5f,0.5f);
		[self addChild:sprite];
		[self updateAnimation:normalAnimation];
		
	}	
	return self;
}

- (void) dealloc{
	
	[super dealloc];
}

@end
