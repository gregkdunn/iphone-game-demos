//
//  Joystick.m
//
//  Created by Jason Booth on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Joystick.h"
#import "CCDirector.h"
#import "CCSprite.h"

@implementation Joystick

@synthesize staticCenter;

-(id)initWithRect:(CGRect)rect 
{
  self = [super init];
	if( self ) 
	{
    bounds = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    center = CGPointMake(0,0);
    curPosition = CGPointMake(0,0);
    active = NO;
    staticCenter = NO;
  }
  return self;
}

-(id)initWithRect:(CGRect)rect andBase:(CCSprite *)localJSBase
{
	jsBase = localJSBase;
	return [self initWithRect:rect];
}

-(id)initWithRect:(CGRect)rect andBase:(CCSprite *)localJSBase andNub:(CCSprite *)localJSNub
{
	jsBase = localJSBase;
	jsNub = localJSNub;
	return [self initWithRect:rect];	
}

-(void)setStaticCenter:(float)x y:(float)y
{
  center = CGPointMake(x, y);
  staticCenter = YES;
}

-(bool)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  //NSLog(@"joystickTouchesBegan");
  if (active)
    return NO;
  NSArray *allTouches = [touches allObjects];
  for (UITouch* t in allTouches)
  {
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[t locationInView:[t view]]];
    if (CGRectContainsPoint(bounds, location))
    {
      active = YES;
      touchAddress = (int)t;
      if (!staticCenter)
        center = CGPointMake(location.x, location.y);
      curPosition = CGPointMake(location.x, location.y);
		
	  if(jsBase != nil)
	  {
		  jsBase.opacity = (GLubyte)60;
		  jsNub.position = curPosition;
	  }
		
      return YES;
    }
  }
  return NO;
}

-(bool)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  //NSLog(@"joystickTouchesMoved");
  if (!active)
    return NO;
  NSArray *allTouches = [touches allObjects];
  for (UITouch* t in allTouches)
  {
    if ((int)t == touchAddress)
    {
      curPosition = [[CCDirector sharedDirector] convertToGL:[t locationInView:[t view]]];
	  if (abs([self getCurrentDegreeVelocity].y) < (jsBase.contentSize.width/2))
	  {
	    jsNub.position = curPosition;
      }  
	  return YES;
    }
  }
  return NO;
}

-(bool)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  //NSLog(@"joystickTouchesEnded");	 
  if (!active) return NO;
  NSArray *allTouches = [touches allObjects];
  for (UITouch* t in allTouches)
  {
    if ((int)t == touchAddress)
    {
      active = NO;
      if (!staticCenter)
        center = CGPointMake(0,0);
      curPosition = CGPointMake(0,0);
		
		
	  if(jsBase != nil)
	  {
	 	jsBase.opacity = (GLubyte)30;
		jsNub.position = CGPointMake(jsBase.position.x, jsBase.position.y);  
	  }	
		
      return YES;
    }
  }
  return NO;
}

-(CGPoint)getCurrentVelocity
{
  return CGPointMake(curPosition.x - center.x, curPosition.y - center.y);
}

-(CGPoint)getCurrentDegreeVelocity
{
  float dx = center.x - curPosition.x;
  float dy = center.y - curPosition.y;
  CGPoint vel = [self getCurrentVelocity];
  vel.y = sqrt((vel.x*vel.x + vel.y*vel.y));
  vel.x = atan2f(-dy, dx) * (180/3.14);
  return vel;
}

@end
