//
//  Global.m
//  genePool
//
//  Created by Greg Dunn on 10/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Global.h"
@implementation Global
static Global *_instance = nil;  // <-- important 

+(Global *)instance
{ 
	// skip everything
	if(_instance) return _instance; 
	
	// Singleton
	@synchronized([Global class]) //<-- important, honestly not sure what synchronized is yet, im learning as i go along too - but its very important!
	{
		if(!_instance)
		{
			_instance = [[self alloc] init];
			
			NSLog(@"Creating global instance!"); //<-- You should see this once only in your program
		}
		
		return _instance;
	}
	
	return nil;
}

@synthesize gameDifficulty, 
            currentLevel,
            highestLevel,
            currentLevelScore,
            previousLevelsScore,
            totalScore;

@end