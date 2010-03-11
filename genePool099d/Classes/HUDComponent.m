//
//  HUDComponent.m
//  genePool_9.0a
//
//  Created by Greg Dunn on 12/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HUDComponent.h"

@implementation HUDComponent

@synthesize componentLabel, componentValue, fontName, fontSize, componentFormat;

-(id)init{
	self = [super init];
	
	if(self != nil)
	{		
		NSLog(@"HUDComponent->init");
		self.componentValue = 0;
		self.componentLabel = @"";
		self.componentFormat = @"%@ %i";
		componentView = [CCLabel labelWithString:[self componentLabel] dimensions:CGSizeMake(100,15) alignment:UITextAlignmentLeft fontName:[self fontName] fontSize:[self fontSize]];
		[self update];
		componentView.position = ccp(0,0);
		[self addChild:componentView];
	}	
	return self;
	
}

-(id)initWithValue:(int)value{
	NSLog(@"Scoreboard->initWithScore");
	[self setDefaultFont];	
	[self init];
	[self setComponentValue:value];
	[self update];
	return self;
}

-(id)initWithValue:(int)localComponentValue andLabel:(NSString*)localComponentLabel{
	[self setDefaultFont];	
	[self init];
	[self setComponentValue:localComponentValue];
	[self setComponentLabel:localComponentLabel];
	[self update];
	return self;
}

-(id)initWithValue:(int)localComponentValue andLabel:(NSString*)localComponentLabel andComponentFormat:(NSString*)localComponentFormat{
	[self setDefaultFont];
	[self init];
	[self setComponentValue:localComponentValue];
	[self setComponentLabel:localComponentLabel];
	[self setComponentFormat:localComponentFormat];
	[self update];
	return self;
}

-(id)initWithValue:(int)localComponentValue andLabel:(NSString*)localComponentLabel andComponentFormat:(NSString*)localComponentFormat andFontName:(NSString*)localFontName andFontSize:(int)localFontSize{
	[self setFontName:localFontName];
	[self setFontSize:localFontSize];
	[self init];
	[self setComponentValue:localComponentValue];
	[self setComponentLabel:localComponentLabel];
	[self setComponentFormat:localComponentFormat];	
	[self update];
	return self;
}

-(void)update{
	[componentView setString: [NSString stringWithFormat:[self componentFormat], [self componentLabel], [self componentValue] ]];
}

-(void)updateValue:(int)value{
	[self setComponentValue:value];
	[self update];
}

-(void)updateLabel:(NSString*)value{
	[self setComponentLabel:value];
	[self update];  
}

-(void)updateValue:(int)localComponentValue andLabel:(NSString*)localComponentLabel{
	[self setComponentValue:localComponentValue];
	[self setComponentLabel:localComponentLabel];
	[self update];  
}

-(void)resetValue{
	[self updateValue:0];
}

-(void)resetLabel{
	[self updateLabel:@""];
}

-(void)setDefaultFont{
	[self setFontName:@"Arial"];
	[self setFontSize:12];
}

-(void)dealloc{
	[super dealloc];
}

@end