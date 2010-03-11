//
//  Stats.m
//  genePool
//
//  Created by Greg Dunn on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Stats.h"

@implementation Stats

@synthesize level, xp, health, maxHealth, color, mass, pointValue, xpValue;

- (void) absorb: (Stats *) value{
	[self updateXP: value.xp];
	[self updateHealth: value.health];
	[self updateMaxHealth: value.maxHealth];
	[self updateColor: value.color];
	[self updateMass: value.mass];
	[self updatePointValue: value.pointValue];
	[self updateXPValue: value.xpValue];
}

-(void) updateXP:(int)value{
	if((self.xp+value)  < (1000*self.level)) 
	{	
		[self setXp: self.xp+value];
	} else {
		[self updateLevel:1];
		[self updateXP:(value-(1000*level))];
	}
}

-(void) updateHealth:(int)value{
	[self setHealth: self.health+value];
	//[[NSNotificationCenter defaultCenter] postNotificationName:"PlayerHealthChange" object:self];

}


-(void) updateMaxHealth:(int)value{
	[self setMaxHealth: self.maxHealth+value];
}

-(void) updateLevel:(int)value{
	[self setXp: self.level+value];
}

-(void) updateColor:(NSArray*)value{
	
	NSMutableArray *anArray = [[NSMutableArray alloc] init];
	for(int i=0; i < 4; i++) {
		[anArray insertObject:[self testColorProperty:i withValue:[[value objectAtIndex:0]intValue] ] atIndex:i];
	}
	[self setColor:anArray];
}

-(NSNumber*) testColorProperty:(int)position withValue:(int)value{
	int testValue = ([[[self color] objectAtIndex:position]intValue] + value);
	if(testValue > 255)
	{
		return [[NSNumber alloc] numberWithInt:255];		
	} 
	else if(testValue < 0)
	{
		return [[NSNumber alloc] numberWithInt:0];
	}
	else
	{
		return [[NSNumber alloc] numberWithInt:([[[self color] objectAtIndex:position]intValue] + ((value - [[[self color] objectAtIndex:position]intValue])/2))];
	}
}

-(void) updateMass:(int)value{
	[self setMass: self.mass+value];
}

-(void) updatePointValue:(int)value{
	[self setPointValue: self.pointValue+value];
}

-(void) updateXPValue:(int)value{
	[self setXpValue: self.xpValue+value];
}

@end
