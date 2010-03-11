//
//  HUDButtonComponent.m
//  StickWars - Siege
//
//  Created by EricH on 8/3/09.
//

#import "HUDButtonComponent.h"


@implementation HUDButtonComponent
+ (id)buttonWithText:(NSString*)text atPosition:(CGPoint)position target:(id)target selector:(SEL)selector {
	CCMenu *menu = [CCMenu menuWithItems:[CCButtonItem buttonWithText:text target:target selector:selector], nil];
	menu.position = position;
	return menu;
}

+ (id)buttonWithImage:(NSString*)file atPosition:(CGPoint)position target:(id)target selector:(SEL)selector {
	CCMenu *menu = [CCMenu menuWithItems:[CCButtonItem buttonWithImage:file target:target selector:selector], nil];
	menu.position = position;
	return menu;
}
@end

@implementation CCButtonItem
+ (id)buttonWithText:(NSString*)text target:(id)target selector:(SEL)selector {
	return [[[self alloc] initWithText:text target:target selector:selector] autorelease];
}

+ (id)buttonWithImage:(NSString*)file target:(id)target selector:(SEL)selector {
	return [[[self alloc] initWithImage:file target:target selector:selector] autorelease];
}

+ (id)buttonWithImage:(NSString*)file andImage:(NSString *)otherFile atPosition:(CGPoint)position target:(id)target selector:(SEL)selector {
	CCButtonItem *button1 = [CCButtonItem buttonWithImage:file target:target selector:selector];
	CCButtonItem *button2 = [CCButtonItem buttonWithImage:otherFile target:target selector:selector];
	CCMenuItemToggle *toggle = [CCMenuItemToggle itemWithTarget:target selector:selector items:button1,button2,nil];
	CCMenu *menu = [CCMenu menuWithItems:toggle, nil];
	menu.position = position;
	return menu;
}

- (id)initWithText:(NSString*)text target:(id)target selector:(SEL)selector {
	if((self = [super initWithTarget:target selector:selector])) {
		back = [[CCSprite spriteWithFile:@"button.png"] retain];
		back.anchorPoint = ccp(0,0);
		backPressed = [[CCSprite spriteWithFile:@"button_p.png"] retain];
		backPressed.anchorPoint = ccp(0,0);
		[self addChild:back];
		
		self.contentSize = back.contentSize;
		
		CCLabel* textLabel = [CCLabel labelWithString:text fontName:@"Arial" fontSize:12];
		textLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
		textLabel.anchorPoint = ccp(0.5, 0.3);
		[self addChild:textLabel z:1];
	}
	return self;
}

- (id)initWithImage:(NSString*)file target:(id)target selector:(SEL)selector {
	if((self = [super initWithTarget:target selector:selector])) {
		
		back = [[CCSprite spriteWithFile:@"button.png"] retain];
		back.anchorPoint = ccp(0,0);
		backPressed = [[CCSprite spriteWithFile:@"button_p.png"] retain];
		backPressed.anchorPoint = ccp(0,0);
		[self addChild:back];
		
		self.contentSize = back.contentSize;
		
		CCSprite* image = [CCSprite spriteWithFile:file];
		[self addChild:image z:1];
		image.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
	}
	return self;
}

-(void) selected {
	[self removeChild:back cleanup:NO];
	[self addChild:backPressed];
	[super selected];
}

-(void) unselected {
	[self removeChild:backPressed cleanup:NO];
	[self addChild:back];
	[super unselected];
}

// this prevents double taps
- (void)activate {
	[super activate];
	[self setIsEnabled:NO];
	[self schedule:@selector(resetButton:) interval:0.5];
}

- (void)resetButton:(ccTime)dt {
	[self unschedule:@selector(resetButton:)];
	[self setIsEnabled:YES];
}

- (void)dealloc {
	[back release];
	[backPressed release];
	[super dealloc];
}

@end