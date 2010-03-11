//
//  Helper.h
//  AmuckSlider
//
//  Created by AppsAmuck on 3/13/09.
//  Copyright 2009 AppsAmuck LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject { }
+ (void)sendEmailWithSubject:(NSString*)aSubject withBody:(NSString*)aBody;
+ (NSString*)getUserValueForKey:(NSString*)aKey withDefault:(NSString*)aDefaultValue;
+ (void)setUserValue:(NSString*)aValue forKey:(NSString*)aKey;
@end
