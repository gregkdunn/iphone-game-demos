//
//  PlayerController.m
//  genePool9b2b
//
//  Created by Greg Dunn on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PlayerController.h"
#import "PlayerEntity.h"
#import "PlayerView.h"

@implementation PlayerController 
- (id) init
{
	self = [super init];
	
	if(self != nil)
	{
		
		[self setEntityView:[[PlayerView alloc] init]];
		[self setEntityModel:[[PlayerEntity alloc] init]];
		 
		[[entityModel mobility] updateMaxVectorWithCGPoint:CGPointMake(50,50)];
		[[[entityModel mobility] maxVector] setRotation:10];
		
		[self setEntityForceVector:[[Vector3D alloc] init]];
		
		[entityView setPosition:CGPointMake(0,0)];
		[entityView setAnchorPoint:ccp(0.5f,0.5f)];
		[self setAnchorPoint:ccp(0.5f,0.5f)];
		[self addChild:entityView]; 
	}	
	return self;
}


@end
