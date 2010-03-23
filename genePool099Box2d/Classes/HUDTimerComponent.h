//
//  HUDTimerComponent.h
//  genePool_9.0a
//
//  Created by Greg Dunn on 12/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUDComponent.h"

@interface HUDTimerComponent : HUDComponent {
	
	int increment;
	int startTime;
}

@property (nonatomic, assign) int increment, startTime;
-(void)startTimer;
-(void)stopTimer;
-(void)setTimer:(int)value ;
-(void)resetTimer;
-(void)tick:(ccTime)dt;

@end
