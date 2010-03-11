//
//  HUDBarComponent.h
//  genePool_9.0a
//
//  Created by Greg Dunn on 12/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface HUDBarComponent : CCNode {
	
	NSString *componentLabel, *componentFormat, *componentImage, *fontName;
	int componentValue, fontSize;
	CCLabel *componentLabelView;
	CCSprite *componentValueView;
	
}

@property (nonatomic, copy) NSString *componentLabel, *componentFormat, *componentImage, *fontName;
@property (nonatomic, assign) int componentValue, fontSize;

-(id)init;
-(id)initWithValue:(int)value;
-(id)initWithValue:(int)localComponentValue andImage:(NSString*)localComponentImage andLabel:(NSString*)localComponentLabel;
-(id)initWithValue:(int)localComponentValue andImage:(NSString*)localComponentImage andLabel:(NSString*)localComponentLabel andComponentFormat:(NSString*)localComponentFormat;
-(id)initWithValue:(int)localComponentValue andImage:(NSString*)localComponentImage andLabel:(NSString*)localComponentLabel andFontName:(NSString*)localFontName andFontSize:(int)localFontSize;
-(id)initWithValue:(int)localComponentValue andImage:(NSString*)localComponentImage andLabel:(NSString*)localComponentLabel andComponentFormat:(NSString*)localComponentFormat andFontName:(NSString*)localFontName andFontSize:(int)localFontSize;
-(void)update;
-(void)updateValue:(int)value;
-(void)updateLabel:(NSString*)value;
-(void)updateValue:(int)localComponentValue andLabel:(NSString*)localComponentLabel;
-(void)resetValue;
-(void)resetLabel;
-(void)setDefaultFont;

- (void)notificationValueChange:(NSNotification *)notif; 
@end
