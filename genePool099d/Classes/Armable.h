//
//  Armable.h
//  genePool_8.2
//
//  Created by Greg Dunn on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Armable : NSObject {

	Boolean automatic;
	int ammoLeft, clipSize;
	float firingFrequency, recoil;
	NSMutableString *ammoType;
}

@property (nonatomic) Boolean automatic;
@property (nonatomic) int ammoLeft, clipSize;
@property (nonatomic) float firingFrequency, recoil;
@property (nonatomic, assign) NSMutableString *ammoType;

//Methods
- (void) onAdd;
- (void) onRemove;

- (void) arm;
- (void) disarm;

- (void) loadAmmo;
- (void) releaseAmmo;

- (void) fire;



@end
