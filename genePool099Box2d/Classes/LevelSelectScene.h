//
//  LevelSelectScene.h
//  menuTutorial
//
//  Created by Greg Dunn on 9/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCScene.h"

@interface LevelSelectScene : CCScene {
	int currentLevelIndex, highestLevelIndex;
}

@property (nonatomic) int currentLevelIndex, highestLevelIndex;

- (void)displayLevelSelectMenu;
- (void)onLevelSelect:(id)sender;
- (void)onMain:(id)sender;

@end
