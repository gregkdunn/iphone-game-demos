//
//  LevelOne.m
//  genePool_8.2
//
//  Created by Greg Dunn on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Level0001.h"
#import "cocos2d.h"

@implementation Level0001
- (id) init
{
	if ((self = [super init]))
	{ 
		
		[self setBackground:[CCSprite spriteWithFile:@"levelBG001b.png"]];
		//[self setOverlay:[CCSprite spriteWithFile:@"level001BG.png"]];
		
		[self setBackgroundTileMap:[CCTMXTiledMap tiledMapWithTMXFile:@"testTIleMap001.tmx"]];
		//[self setOverlay:(CCTMXTiledMap *) ];
		
		[self setWorldFriction:0.6];
		[self setWorldGravity:0.8];
		
		[self setPlayerInitialLocation:ccp(100,100)];
		

		//[self setEnemies:<#(NSMutableArray *)#>];
		//[self setItems:<#(NSMutableArray *)#>];

		[self setHasIntro:FALSE];
	    //[self setIntroBG:(CCNode *)];
		//[self setIntroMovie:(CCNode *)];
		//[self setIntroCountdown:(CCNode *)];

		
		[self setHasOutro:FALSE];
		//[self setOutroBG:(CCNode *)];
		//[self setOutroMovie:(CCNode *)];

	}
	return (self);
} // init
@end
