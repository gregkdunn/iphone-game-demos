//
//  Global.h
//  genePool
//
//  Created by Greg Dunn on 10/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Global : NSObject 
{
	int gameDifficulty;
	int currentLevel; // Current level
	int highestLevel; // Highest achieved level (in current session / loaded from db)	
	int currentLevelScore; // Score for current Level
	int previousLevelsScore; // Score for all levels up to current	
	int totalScore; // Total Score for current game
};

@property(nonatomic) int gameDifficulty, currentLevel, highestLevel, currentLevelScore, previousLevelsScore, totalScore;


// methods
+ (Global *)instance; // <-- important, notice the +

@end
