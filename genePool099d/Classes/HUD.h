//
//  HUD.h
//  bit101
//
//  Created by Greg Dunn on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"
#import "HUDComponent.h";
#import "HUDBarComponent.h";
#import "HUDButtonComponent.h";
#import "HUDTimerComponent.h";
#import "Joystick.h"

typedef enum tagPaddleState {
	jsBaseTouched,
	jsBaseUntouched
} leftJSState;


@interface HUD : CCLayer {
	
	HUDComponent *scoreBoard;
	
	HUDBarComponent *healthBar;

	HUDBarComponent *energyBar;
	
	HUDButtonComponent *pauseButton;
	
	HUDTimerComponent *scoreTimer;
	
	Joystick *joyStick;
	
	CGRect joyStickRect;

@private
 leftJSState state;
}


- (void)updateHealth:(int)value;

- (void)quitGame:(id)sender;

- (void)pauseLevel:(id)sender;
- (void)unpauseLevel:(id)sender;

- (void)quitLevel;
- (void)restartLevel;

- (CGPoint)getJoystickVelocity;
- (CGPoint)getJoystickAngle;

//Touch Controls
-(BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
