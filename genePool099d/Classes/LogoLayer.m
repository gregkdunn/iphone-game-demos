//
//  LogoLayer.m
//  menuTutorial
//
//  Created by Greg Dunn on 9/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LogoLayer.h"
#import "cocos2d.h"

@implementation LogoLayer

- (id) init
{
	self = [super init];
	
	if(self != nil)
	{
		// display background image in scene
		CCSprite *background = [CCSprite spriteWithFile:@"label.png"];
		background.position = ccp(80,90);
		[self addChild:background]; 
	}	
	return self;
}
@end