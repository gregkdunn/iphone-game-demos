//
//  HUDBarComponent.m
//  genePool_9.0a
//
//  Created by Greg Dunn on 12/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HUDBarComponent.h"


@implementation HUDBarComponent

@synthesize componentFormat, componentImage, componentLabel, componentValue, fontName, fontSize;

-(id)init{
	self = [super init];
	
	if(self != nil)
	{		
		NSLog(@"HUDBarComponent->init");
		if (self.componentValue == NULL)
		{	
			self.componentValue = 0;
		}		
		if (self.componentImage == NULL)
		{	
			self.componentImage = @"hudBar2.png";
		}
		if (self.componentLabel == nil)
		{
			self.componentLabel = @"";
		}
		if (self.componentFormat == nil)
		{
			self.componentFormat = @"%i";
		}
		componentLabelView = [CCLabel labelWithString:[self componentLabel] dimensions:CGSizeMake(100,15) alignment:UITextAlignmentLeft fontName:[self fontName] fontSize:[self fontSize]];
		componentLabelView.position = ccp(0,0);
		
		componentValueView = [CCSprite spriteWithFile:[self componentImage] rect:CGRectMake((100 - [self componentValue]), 0, 100, 10)];
		componentValueView.position = ccp(0,3);
		componentValueView.opacity = (GLubyte)120;
		
		//[self update];
		
		[self addChild:componentValueView];
		[self addChild:componentLabelView];
	}	
	return self;
	
}

-(id)initWithValue:(int)value{
	NSLog(@"HUDBarComponent->initWithValue");
	[self setDefaultFont];	
	[self init];
	[self setComponentValue:value];
	[self update];
	return self;
}

-(id)initWithValue:(int)localComponentValue andImage:(NSString*)localComponentImage andLabel:(NSString*)localComponentLabel{
	[self setDefaultFont];	
	[self init];
	[self setComponentImage:localComponentImage];
	[self setComponentValue:localComponentValue];
	[self setComponentLabel:localComponentLabel];
	[self update];
	return self;
}

-(id)initWithValue:(int)localComponentValue andImage:(NSString*)localComponentImage andLabel:(NSString*)localComponentLabel andComponentFormat:(NSString*)localComponentFormat{
	[self setDefaultFont];
	[self init];
	[self setComponentValue:localComponentValue];
	[self setComponentImage:localComponentImage];
	[self setComponentLabel:localComponentLabel];
	[self setComponentFormat:localComponentFormat];
	[self update];
	return self;
}

-(id)initWithValue:(int)localComponentValue andImage:(NSString*)localComponentImage andLabel:(NSString*)localComponentLabel andFontName:(NSString*)localFontName andFontSize:(int)localFontSize{
	[self setFontName:localFontName];
	[self setFontSize:localFontSize];
	[self init];
	[self setComponentValue:localComponentValue];
	[self setComponentImage:localComponentImage];
	[self setComponentLabel:localComponentLabel];	
	[self update];
	return self;
}

-(id)initWithValue:(int)localComponentValue andImage:(NSString*)localComponentImage andLabel:(NSString*)localComponentLabel andComponentFormat:(NSString*)localComponentFormat andFontName:(NSString*)localFontName andFontSize:(int)localFontSize{
	[self setFontName:localFontName];
	[self setFontSize:localFontSize];
	[self init];
	[self setComponentValue:localComponentValue];
	[self setComponentImage:localComponentImage];
	[self setComponentLabel:localComponentLabel];
	[self setComponentFormat:localComponentFormat];	
	[self update];
	return self;
}

-(void)update{
	[componentLabelView setString: [NSString stringWithFormat:[self componentFormat], [self componentLabel], [self componentValue] ]];
	[componentValueView setTextureRect:CGRectMake((100 - [self componentValue]), 0, 100, 10)];
	//[componentValueView setOffsetPosition:CGPointMake(100 - [self componentValue],0)];
}

-(void)updateValue:(int)value{
	if(value > 0)
	{
		[self setComponentValue:value];
	} else {
		[self setComponentValue:0];
	}
	[self update];
}

-(void)updateLabel:(NSString*)value{
	[self setComponentLabel:value];
	[self update];  
}

-(void)updateValue:(int)localComponentValue andLabel:(NSString*)localComponentLabel{
	[self setComponentValue:localComponentValue];
	[self updateValue:localComponentValue];
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


- (void)notificationValueChange:(NSNotification *)notification 
{
	NSLog(@"Received Notification - Value Changed! ");
	if([[notification object] health]){
		NSLog(@"Health Exists! ");
		[self updateValue:(int)[[notification object] health]];
	} else {
		NSLog(@"Health No Exists! ");
	}
}


-(void)dealloc{
	[super dealloc];
	//componentLabelView
	//componentValueView
	//componentFormat
	//componentImage
	//componentLabel
	//componentValue
	//fontName
	//fontSize
}

@end
