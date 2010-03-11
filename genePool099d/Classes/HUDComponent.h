//
//  HUDComponent.h
//  genePool_9.0a
//
//  Created by Greg Dunn on 12/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface HUDComponent : CCNode {
	
	NSString *componentLabel, *componentFormat, *fontName;
	int componentValue, fontSize;
	CCLabel *componentView;
	
}

@property (nonatomic, copy) NSString *componentLabel, *fontName, *componentFormat;
@property (nonatomic, assign) int componentValue, fontSize;


-(id)init;
-(id)initWithValue:(int)localComponentValue andLabel:(NSString*)localComponentLabel;
-(id)initWithValue:(int)localComponentValue andLabel:(NSString*)localComponentLabel andComponentFormat:(NSString*)localComponentFormat;
-(id)initWithValue:(int)localComponentValue andLabel:(NSString*)localComponentLabel andComponentFormat:(NSString*)localComponentFormat andFontName:(NSString*)localFontName andFontSize:(int)localFontSize;
-(void)update;
-(void)updateValue:(int)value;
-(void)updateLabel:(NSString*)value;
-(void)updateValue:(int)localComponentValue andLabel:(NSString*)localComponentLabel;
-(void)resetValue;
-(void)resetLabel;
-(void)setDefaultFont;
@end