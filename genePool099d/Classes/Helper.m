//
//  Helper.m
//  AmuckSlider
//
//  Created by AppsAmuck on 3/13/09.
//  Copyright 2009 AppsAmuck LLC. All rights reserved.
//

#import "Helper.h"


@implementation Helper

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

@end
