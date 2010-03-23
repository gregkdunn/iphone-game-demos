//
//  Helper.m
//  AmuckSlider
//
//  Created by AppsAmuck on 3/13/09.
//  Copyright 2009 AppsAmuck LLC. All rights reserved.
//

#import "Storage.h"


@implementation Storage

+ (void)sendEmailWithSubject:(NSString*)aSubject withBody:(NSString*)aBody{
	NSString *urlString = [NSString stringWithFormat: @"mailto:?subject=%@&body=%@", aSubject, aBody];
	urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSURL* mailURL = [NSURL URLWithString: urlString]; 
	[[UIApplication sharedApplication] openURL: mailURL]; 
}

 
+ (NSString*)getUserValueForKey:(NSString*)aKey withDefault:(NSString*)aDefaultValue {
	NSString *result = [[NSUserDefaults standardUserDefaults] stringForKey: aKey];
	if (result == nil || [result isEqualToString:@""]) {
		return aDefaultValue;
	}
	return result;
}

+ (void)setUserValue:(NSString*)aValue forKey:(NSString*)aKey {	
	[[NSUserDefaults standardUserDefaults] setObject: aValue forKey: aKey];
}

//STATIC METHODS

+ (int) getCurrentLevelIndex
{
	NSLog(@"Game->getCurrentLevelIndex");
	return [[Storage getUserValueForKey:@"currentlevel" withDefault:@"1"] intValue];
}

+ (void) setCurrentLevelIndex:(int)aLevelIndex
{
	int highestLevelIndex = [[Storage getUserValueForKey:@"highestlevel" withDefault:@"1"] intValue]; 
	if (highestLevelIndex < aLevelIndex)
	{
		[Storage setUserValue:[NSString stringWithFormat:@"%d", aLevelIndex] forKey:@"highestlevel"];
	}
	[Storage setUserValue:[NSString stringWithFormat:@"%d", aLevelIndex] forKey:@"currentlevel"];
}

+ (int) getCurrentGameScore
{
	return [[Storage getUserValueForKey:@"currentGameScore" withDefault:@"0"] intValue];
}

+ (void) setCurrentGameScore:(int)aGameScore
{
	[Storage setUserValue:[NSString stringWithFormat:@"%d", aGameScore] forKey:@"currentGameScore"];
}

+ (int) getCurrentHealth
{
	return [[Storage getUserValueForKey:@"currentHealth" withDefault:@"100"] intValue];
}

+ (void) setCurrentHealth:(int)aHealth
{
	[Storage setUserValue:[NSString stringWithFormat:@"%d", aHealth] forKey:@"currentHealth"];
}

+ (int) getCurrentLivesLeft {
	return [[Storage getUserValueForKey:@"currentLivesLeft" withDefault:@"0"] intValue];
}

+ (void) setCurrentLivesLeft:(int)aLivesLeft {
	[Storage setUserValue:[NSString stringWithFormat:@"%d", aLivesLeft] forKey:@"currentLivesLeft"];
}

+ (int) getDefaultLives {
	return [[Storage getUserValueForKey:@"defaultLivesLeft" withDefault:@"0"] intValue];
}

+ (void) setDefaultLives:(int)aLivesLeft
{
	NSLog(@"Game->setDefaultLivesLeft: %i", aLivesLeft);
	[Storage setUserValue:[NSString stringWithFormat:@"%d", aLivesLeft] forKey:@"defaultLivesLeft"];
}

@end
