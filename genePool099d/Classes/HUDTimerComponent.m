//
//  HUDTimerComponent.m
//  genePool_9.0a
//
//  Created by Greg Dunn on 12/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HUDTimerComponent.h"


@implementation HUDTimerComponent

@synthesize startTime, increment;

-(void)startTimer{
	[self setStartTime:[self componentValue]];
	[self schedule: @selector(tick:) interval: 1.0f];
}

-(void)stopTimer {
	[self unschedule: @selector(tick:)];
}

-(void)setTimer:(int)value {
	[self setComponentValue:value];
}

-(void)resetTimer {
	[self setComponentValue:[self startTime]];
}

-(void)tick:(ccTime)dt{
	//NSLog(@"TIMER->Tick: %i / %i", self.componentValue , self.increment);
	[self updateValue:(self.componentValue + self.increment)];
}


@end
