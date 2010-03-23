//
//  Stats.h
//  genePool
//
//  Created by Greg Dunn on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Stats : NSObject {

	int level; //RPG Level
	int xp;//RPG Level Experience Points
	int health; 
	int maxHealth; 
	int mass; 
	int pointValue; //Point Value
	int xpValue;// xp Value if killed
	
	NSArray *color; //255,255,255,255;
}

@property(nonatomic) int level, xp, health, maxHealth, mass, pointValue, xpValue;
@property(nonatomic, assign) NSArray *color;

//Methods
-(void) absorb: (Stats *) value;
-(void) updateXP:(int)value;
-(void) updateHealth:(int)value;
-(void) updateMaxHealth:(int)value;
-(void) updateLevel:(int)value;
-(void)updateColor:(NSArray*)value;
-(NSNumber*) testColorProperty:(int)position withValue:(int)value;
-(void) updateMass:(int)value;
-(void) updatePointValue:(int)value;
-(void) updateXPValue:(int)value;
@end
