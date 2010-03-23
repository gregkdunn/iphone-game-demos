//
//  Armable.m
//  genePool_8.2
//
//  Created by Greg Dunn on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Armable.h"

@implementation Armable


@synthesize  ammoLeft, ammoType, automatic, clipSize, firingFrequency, recoil;

//Methods
- (void) onAdd{
	
};
- (void) onRemove{
	
};

- (void) arm{
	
};

- (void) disarm{
	
};


- (void) loadAmmo{
	if(self.ammoLeft < self.clipSize)
	{
		//load the weapon
	}
};

- (void) releaseAmmo{
	//release to world
	self.ammoLeft = 0;
};


- (void) fire{
	if (self.ammoLeft > 0)
	{
		//fire the weapon
		[self setAmmoLeft:self.ammoLeft-1];
	}
};


@end
