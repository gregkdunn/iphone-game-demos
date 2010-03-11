/* cocos2d for iPhone
 *
 * http://www.cocos2d-iphone.org
 *
 * Copyright (C) 2009 Valentin Milea
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the 'cocos2d for iPhone' license.
 *
 * You will find a copy of this license within the cocos2d for iPhone
 * distribution inside the "LICENSE" file.
 *
 */

#import "CCTouchDispatcher.h"
#import "CCTouchHandler.h"


@implementation CCTouchDispatcher

@synthesize dispatchEvents;

static CCTouchDispatcher *sharedDispatcher = nil;

+(CCTouchDispatcher*) sharedDispatcher
{
	@synchronized(self) {
		if (sharedDispatcher == nil)
			sharedDispatcher = [[self alloc] init]; // assignment not done here
	}
	return sharedDispatcher;
}

+(id) allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		NSAssert(sharedDispatcher == nil, @"Attempted to allocate a second instance of a singleton.");
		return [super allocWithZone:zone];
	}
	return nil; // on subsequent allocation attempts return nil
}

-(id) init
{
	if((self = [super init])) {
	
		dispatchEvents = YES;
		targetedHandlers = [[NSMutableArray alloc] initWithCapacity:8];
		standardHandlers = [[NSMutableArray alloc] initWithCapacity:4];
		
		handlersToAdd = [[NSMutableArray alloc] initWithCapacity:8];
		handlersToRemove = [[NSMutableArray alloc] initWithCapacity:8];
		
		toRemove = NO;
		toAdd = NO;
		toQuit = NO;
		locked = NO;

		handlerHelperData[ccTouchBegan] = (struct ccTouchHandlerHelperData) {@selector(ccTouchesBegan:withEvent:),@selector(ccTouchBegan:withEvent:),ccTouchSelectorBeganBit};
		handlerHelperData[ccTouchMoved] = (struct ccTouchHandlerHelperData) {@selector(ccTouchesMoved:withEvent:),@selector(ccTouchMoved:withEvent:),ccTouchSelectorMovedBit};
		handlerHelperData[ccTouchEnded] = (struct ccTouchHandlerHelperData) {@selector(ccTouchesEnded:withEvent:),@selector(ccTouchEnded:withEvent:),ccTouchSelectorEndedBit};
		handlerHelperData[ccTouchCancelled] = (struct ccTouchHandlerHelperData) {@selector(ccTouchesCancelled:withEvent:),@selector(ccTouchCancelled:withEvent:),ccTouchSelectorCancelledBit};
		
	}
	
	return self;
}

-(void) dealloc
{
	[targetedHandlers release];
	[standardHandlers release];
	[handlersToAdd release];
	[handlersToRemove release];
	[super dealloc];
}

//
// handlers management
//

#pragma mark TouchDispatcher - Add Hanlder

-(void) forceAddHandler:(CCTouchHandler*)handler array:(NSMutableArray*)array
{
	NSUInteger i = 0;
	
	for( CCTouchHandler *h in array ) {
		if( h.priority < handler.priority )
			i++;
		
		if( h.delegate == handler.delegate )
			[NSException raise:NSInvalidArgumentException format:@"Delegate already added to touch dispatcher."];
	}
	[array insertObject:handler atIndex:i];		
}

-(void) addStandardDelegate:(id<CCStandardTouchDelegate>) delegate priority:(int)priority
{
	CCTouchHandler *handler = [CCStandardTouchHandler handlerWithDelegate:delegate priority:priority];
	if( ! locked ) {
		[self forceAddHandler:handler array:standardHandlers];
	} else {
		[handlersToAdd addObject:handler];
		toAdd = YES;
	}
}

-(void) addTargetedDelegate:(id<CCTargetedTouchDelegate>) delegate priority:(int)priority swallowsTouches:(BOOL)swallowsTouches
{
	CCTouchHandler *handler = [CCTargetedTouchHandler handlerWithDelegate:delegate priority:priority swallowsTouches:swallowsTouches];
	if( ! locked ) {
		[self forceAddHandler:handler array:targetedHandlers];
	} else {
		[handlersToAdd addObject:handler];
		toAdd = YES;
	}
}

#pragma mark TouchDispatcher - removeDelegate

-(void) forceRemoveDelegate:(id)delegate
{
	// XXX: remove it from both handlers ???
	
	for( CCTouchHandler *handler in targetedHandlers ) {
		if( handler.delegate == delegate ) {
			[targetedHandlers removeObject:handler];
			break;
		}
	}
	
	for( CCTouchHandler *handler in standardHandlers ) {
		if( handler.delegate == delegate ) {
			[standardHandlers removeObject:handler];
			break;
		}
	}	
}

-(void) removeDelegate:(id) delegate
{
	if( delegate == nil )
		return;
	
	if( ! locked ) {
		[self forceRemoveDelegate:delegate];
	} else {
		[handlersToRemove addObject:delegate];
		toRemove = YES;
	}
}

#pragma mark TouchDispatcher  - removeAllDelegates

-(void) forceRemoveAllDelegates
{
	[standardHandlers removeAllObjects];
	[targetedHandlers removeAllObjects];
}
-(void) removeAllDelegates
{
	if( ! locked )
		[self forceRemoveAllDelegates];
	else
		toQuit = YES;
}

#pragma mark Changing priority of added handlers

-(void) setPriority:(int) priority forDelegate:(id) delegate
{
	NSAssert(NO, @"Set priority no implemented yet. Don't forget to report this bug!");
//	if( delegate == nil )
//		[NSException raise:NSInvalidArgumentException format:@"Got nil touch delegate"];
//	
//	CCTouchHandler *handler = nil;
//	for( handler in touchHandlers )
//		if( handler.delegate == delegate ) break;
//	
//	if( handler == nil )
//		[NSException raise:NSInvalidArgumentException format:@"Touch delegate not found"];
//	
//	if( handler.priority != priority ) {
//		handler.priority = priority;
//		
//		[handler retain];
//		[touchHandlers removeObject:handler];
//		[self addHandler:handler];
//		[handler release];
//	}
}


//
// dispatch events
//
-(void) touches:(NSSet*)touches withEvent:(UIEvent*)event withTouchType:(unsigned int)idx;
{
	NSAssert(idx >=0 && idx < 4, @"Invalid idx value");

	id mutableTouches;
	locked = YES;
	
	// optimization to prevent a mutable copy when it is not necessary
	unsigned int targetedHandlersCount = [targetedHandlers count];
	unsigned int standardHandlersCount = [standardHandlers count];	
	BOOL needsMutableSet = (targetedHandlersCount && standardHandlersCount);
	
	mutableTouches = (needsMutableSet ? [touches mutableCopy] : touches);

	struct ccTouchHandlerHelperData helper = handlerHelperData[idx];
	//
	// process the target handlers 1st
	//
	if( targetedHandlersCount > 0 ) {
		for( UITouch *touch in touches ) {
			for(CCTargetedTouchHandler *handler in targetedHandlers) {
				
				BOOL claimed = NO;
				if( idx == ccTouchBegan ) {
					claimed = [handler.delegate ccTouchBegan:touch withEvent:event];
					if( claimed )
						[handler.claimedTouches addObject:touch];
				} 
				
				// else (moved, ended, cancelled)
				else if( [handler.claimedTouches containsObject:touch] ) {
					claimed = YES;
					if( handler.enabledSelectors & helper.type )
						[handler.delegate performSelector:helper.touchSel withObject:touch withObject:event];
					
					if( helper.type & (ccTouchSelectorCancelledBit | ccTouchSelectorEndedBit) )
						[handler.claimedTouches removeObject:touch];
				}
					
				if( claimed && handler.swallowsTouches ) {
					if( needsMutableSet )
						[mutableTouches removeObject:touch];
					break;
				}
			}
		}
	}
	
	//
	// process standard handlers 2nd
	//
	if( standardHandlersCount > 0 && [mutableTouches count]>0 ) {
		for( CCTouchHandler *handler in standardHandlers ) {
			if( handler.enabledSelectors & helper.type )
				[handler.delegate performSelector:helper.touchesSel withObject:mutableTouches withObject:event];
		}
	}
	if( needsMutableSet )
		[mutableTouches release];
	
	//
	// Optimization. To prevent a [handlers copy] which is expensive
	// the add/removes/quit is done after the iterations
	//
	locked = NO;
	if( toRemove ) {
		toRemove = NO;
		for( id delegate in handlersToRemove )
			[self forceRemoveDelegate:delegate];
		[handlersToRemove removeAllObjects];
	}
	if( toAdd ) {
		toAdd = NO;
		for( CCTouchHandler *handler in handlersToAdd ) {
			Class targetedClass = [CCTargetedTouchHandler class];
			if( [handler isKindOfClass:targetedClass] )
				[self forceAddHandler:handler array:targetedHandlers];
			else
				[self forceAddHandler:handler array:standardHandlers];
		}
		[handlersToAdd removeAllObjects];
	}
	if( toQuit ) {
		toQuit = NO;
		[self forceRemoveAllDelegates];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if( dispatchEvents )
		[self touches:touches withEvent:event withTouchType:ccTouchBegan];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if( dispatchEvents ) 
		[self touches:touches withEvent:event withTouchType:ccTouchMoved];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if( dispatchEvents )
		[self touches:touches withEvent:event withTouchType:ccTouchEnded];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	if( dispatchEvents )
		[self touches:touches withEvent:event withTouchType:ccTouchCancelled];
}
@end
