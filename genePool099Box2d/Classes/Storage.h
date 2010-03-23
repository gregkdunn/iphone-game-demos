//
//  Helper.h
//  AmuckSlider
//
//  Created by AppsAmuck on 3/13/09.
//  Copyright 2009 AppsAmuck LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Storage : NSObject { }
+ (void)sendEmailWithSubject:(NSString*)aSubject withBody:(NSString*)aBody;
+ (NSString*)getUserValueForKey:(NSString*)aKey withDefault:(NSString*)aDefaultValue;
+ (void)setUserValue:(NSString*)aValue forKey:(NSString*)aKey;

+(int)getCurrentLevelIndex;
+(void)setCurrentLevelIndex:(int)aLevelIndex;

+(int)getCurrentGameScore;
+(void)setCurrentGameScore:(int)aGameScore;

+(int)getCurrentHealth;
+(void)setCurrentHealth:(int)aHealth;

+(int)getCurrentLivesLeft;
+(void)setCurrentLivesLeft:(int)aLivesLeft;

+(int)getDefaultLives;
+(void)setDefaultLives:(int)aLivesLeft;
@end
