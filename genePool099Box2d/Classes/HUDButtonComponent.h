//
//  HUDButtonComponent.h
//  StickWars - Siege
//
//  Created by EricH on 8/3/09.
//
//[self addChild:[Button buttonWithText:@"back" atPosition:ccp(80, 50) target:self selector:@selector(back:)]];
//[self addChild:[Button buttonWithImage:@"openFeint.png" atPosition:ccp(400, 50) target:self selector:@selector(openOpenFeint:)]];

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HUDButtonComponent : CCMenu {
}
+ (id)buttonWithText:(NSString*)text atPosition:(CGPoint)position target:(id)target selector:(SEL)selector;
+ (id)buttonWithImage:(NSString*)file atPosition:(CGPoint)position target:(id)target selector:(SEL)selector;
@end

@interface CCButtonItem : CCMenuItem {
	CCSprite *back;
	CCSprite *backPressed;
}
+ (id)buttonWithText:(NSString*)text target:(id)target selector:(SEL)selector;
+ (id)buttonWithImage:(NSString*)file target:(id)target selector:(SEL)selector;
+ (id)buttonWithImage:(NSString*)file andImage:(NSString *)otherFile atPosition:(CGPoint)position target:(id)target selector:(SEL)selector;

- (id)initWithText:(NSString*)text target:(id)target selector:(SEL)selector;
- (id)initWithImage:(NSString*)file target:(id)target selector:(SEL)selector;

@end