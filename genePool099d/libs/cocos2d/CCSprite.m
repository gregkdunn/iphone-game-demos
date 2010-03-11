/* cocos2d for iPhone
 *
 * http://www.cocos2d-iphone.org
 *
 * Copyright (C) 2009,2010 Ricardo Quesada
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the 'cocos2d for iPhone' license.
 *
 * You will find a copy of this license within the cocos2d for iPhone
 * distribution inside the "LICENSE" file.
 *
 */

#import "ccConfig.h"
#import "CCSpriteSheet.h"
#import "CCSprite.h"
#import "CCSpriteFrame.h"
#import "CCSpriteFrameCache.h"
#import "CCTextureCache.h"
#import "Support/CGPointExtension.h"
#import "CCDrawingPrimitives.h"

#pragma mark -
#pragma mark CCSprite

#if CC_SPRITESHEET_RENDER_SUBPIXEL
#define RENDER_IN_SUBPIXEL
#else
#define RENDER_IN_SUBPIXEL(__A__) ( (int)(__A__))
#endif

// XXX: Optmization
struct transformValues_ {
	CGPoint pos;		// position x and y
	CGPoint	scale;		// scale x and y
	float	rotation;
	CGPoint ap;			// anchor point in pixels
};

@interface CCSprite (Private)
-(void)updateTextureCoords:(CGRect)rect;
-(void)updateBlendFunc;
-(void) initAnimationDictionary;
-(void) setTextureRect:(CGRect)rect untrimmedSize:(CGSize)size;
-(struct transformValues_) getTransformValues;	// optimization
@end

@implementation CCSprite

@synthesize dirty = dirty_;
@synthesize quad = quad_;
@synthesize atlasIndex = atlasIndex_;
@synthesize textureRect = rect_;
@synthesize opacity=opacity_, color=color_;
@synthesize blendFunc = blendFunc_;
@synthesize usesSpriteSheet = usesSpriteSheet_;
@synthesize textureAtlas = textureAtlas_;
@synthesize spriteSheet = spriteSheet_;
@synthesize honorParentTransform = honorParentTransform_;
@synthesize offsetPosition = offsetPosition_;


+(id)spriteWithTexture:(CCTexture2D*)texture
{
	return [[[self alloc] initWithTexture:texture] autorelease];
}

+(id)spriteWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
	return [[[self alloc] initWithTexture:texture rect:rect] autorelease];
}

+(id)spriteWithTexture:(CCTexture2D*)texture rect:(CGRect)rect offset:(CGPoint)offset
{
	return [[[self alloc] initWithTexture:texture rect:rect offset:offset] autorelease];
}

+(id)spriteWithFile:(NSString*)filename
{
	return [[[self alloc] initWithFile:filename] autorelease];
}

+(id)spriteWithFile:(NSString*)filename rect:(CGRect)rect
{
	return [[[self alloc] initWithFile:filename rect:rect] autorelease];
}

+(id)spriteWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
	return [[[self alloc] initWithSpriteFrame:spriteFrame] autorelease];
}

+(id)spriteWithSpriteFrameName:(NSString*)spriteFrameName
{
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName];
	return [self spriteWithSpriteFrame:frame];
}

// XXX: deprecated
+(id)spriteWithCGImage:(CGImageRef)image
{
	return [[[self alloc] initWithCGImage:image] autorelease];
}

+(id)spriteWithCGImage:(CGImageRef)image key:(NSString*)key
{
	return [[[self alloc] initWithCGImage:image key:key] autorelease];
}

+(id) spriteWithSpriteSheet:(CCSpriteSheet*)spritesheet rect:(CGRect)rect
{
	return [[[self alloc] initWithSpriteSheet:spritesheet rect:rect] autorelease];
}

-(id) init
{
	if( (self=[super init]) ) {
		dirty_ = recursiveDirty_ = NO;
		
		// by default use "Self Render".
		// if the sprite is added to an SpriteSheet, then it will automatically switch to "SpriteSheet Render"
		[self useSelfRender];
		
		// update texture and blend functions
		[self setTexture:nil];
		

		// clean the Quad
		bzero(&quad_, sizeof(quad_));
		
		flipY_ = flipX_ = NO;
		
		// lazy alloc
		animations_ = nil;
		
		// default transform anchor: center
		anchorPoint_ =  ccp(0.5f, 0.5f);
		
		// zwoptex default values
		offsetPosition_ = CGPointZero;
		
		honorParentTransform_ = CC_HONOR_PARENT_TRANSFORM_ALL;
		hasChildren_ = NO;
		
		// Atlas: Color
		opacity_ = 255;
		color_ = ccWHITE;
		ccColor4B tmpColor = {255,255,255,255};
		quad_.bl.colors = tmpColor;
		quad_.br.colors = tmpColor;
		quad_.tl.colors = tmpColor;
		quad_.tr.colors = tmpColor;	
		
		// Atlas: Vertex
		
		// updated in "useSelfRender"
		
		// Atlas: TexCoords
		[self setTextureRect:CGRectZero];
	}
	
	return self;
}

-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
	NSAssert(texture!=nil, @"Invalid texture for sprite");
	// IMPORTANT: [self init] and not [super init];
	if( (self = [self init]) )
	{
		[self setTexture:texture];
		[self setTextureRect:rect];
	}
	return self;
}

-(id) initWithTexture:(CCTexture2D*)texture
{
	NSAssert(texture!=nil, @"Invalid texture for sprite");

	CGRect rect = CGRectZero;
	rect.size = texture.contentSize;
	return [self initWithTexture:texture rect:rect];
}

-(id) initWithFile:(NSString*)filename
{
	NSAssert(filename!=nil, @"Invalid filename for sprite");

	CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: filename];
	if( texture ) {
		CGRect rect = CGRectZero;
		rect.size = texture.contentSize;
		return [self initWithTexture:texture rect:rect];
	}
	return nil;
}

-(id) initWithFile:(NSString*)filename rect:(CGRect)rect
{
	NSAssert(filename!=nil, @"Invalid filename for sprite");

	CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: filename];
	if( texture )
		return [self initWithTexture:texture rect:rect];
	return nil;
}

- (id) initWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
	NSAssert(spriteFrame!=nil, @"Invalid spriteFrame for sprite");

	id ret = [self initWithTexture:spriteFrame.texture rect:spriteFrame.rect];
	[self setDisplayFrame:spriteFrame];
	return ret;
}

-(id)initWithSpriteFrameName:(NSString*)spriteFrameName
{
	NSAssert(spriteFrameName!=nil, @"Invalid spriteFrameName for sprite");

	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName];
	return [self initWithSpriteFrame:frame];
}

// XXX: deprecated
- (id) initWithCGImage: (CGImageRef)image
{
	NSAssert(image!=nil, @"Invalid CGImageRef for sprite");

	// XXX: possible bug. See issue #349. New API should be added
	NSString *key = [NSString stringWithFormat:@"%08X",(unsigned long)image];
	CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addCGImage:image forKey:key];
	
	CGSize size = texture.contentSize;
	CGRect rect = CGRectMake(0, 0, size.width, size.height );
	
	return [self initWithTexture:texture rect:rect];
}

- (id) initWithCGImage:(CGImageRef)image key:(NSString*)key
{
	NSAssert(image!=nil, @"Invalid CGImageRef for sprite");
	
	// XXX: possible bug. See issue #349. New API should be added
	CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addCGImage:image forKey:key];
	
	CGSize size = texture.contentSize;
	CGRect rect = CGRectMake(0, 0, size.width, size.height );
	
	return [self initWithTexture:texture rect:rect];
}

-(id) initWithSpriteSheet:(CCSpriteSheet*)spritesheet rect:(CGRect)rect
{
	id ret = [self initWithTexture:spritesheet.texture rect:rect];
	[self useSpriteSheetRender:spritesheet];
	return ret;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X | Rect = (%.2f,%.2f,%.2f,%.2f) | tag = %i | atlasIndex = %i>", [self class], self,
			rect_.origin.x, rect_.origin.y, rect_.size.width, rect_.size.height,
			tag_,
			atlasIndex_
	];
}

- (void) dealloc
{
	[texture_ release];
	[animations_ release];
	[super dealloc];
}

-(void) useSelfRender
{
	atlasIndex_ = CCSpriteIndexNotInitialized;
	usesSpriteSheet_ = NO;
	textureAtlas_ = nil;
	spriteSheet_ = nil;
	dirty_ = recursiveDirty_ = NO;
	
	float x1 = 0 + offsetPosition_.x;
	float y1 = 0 + offsetPosition_.y;
	float x2 = x1 + rect_.size.width;
	float y2 = y1 + rect_.size.height;
	quad_.bl.vertices = (ccVertex3F) { x1, y1, 0 };
	quad_.br.vertices = (ccVertex3F) { x2, y1, 0 };
	quad_.tl.vertices = (ccVertex3F) { x1, y2, 0 };
	quad_.tr.vertices = (ccVertex3F) { x2, y2, 0 };		
}

-(void) useSpriteSheetRender:(CCSpriteSheet*)spriteSheet
{
	usesSpriteSheet_ = YES;
	textureAtlas_ = [spriteSheet textureAtlas]; // weak ref
	spriteSheet_ = spriteSheet; // weak ref
}


-(void) initAnimationDictionary
{
	animations_ = [[NSMutableDictionary dictionaryWithCapacity:2] retain];
}

-(void)setTextureRect:(CGRect)rect
{
	[self setTextureRect:rect untrimmedSize:rect.size];
}

-(void)setTextureRect:(CGRect)rect untrimmedSize:(CGSize)untrimmedSize
{
	rect_ = rect;

	[self setContentSize:untrimmedSize];
	[self updateTextureCoords:rect];
	
	// rendering using SpriteSheet
	if( usesSpriteSheet_ ) {
		// update dirty_, don't update recursiveDirty_
		dirty_ = YES;
	}

	// self rendering
	else
	{
		// Atlas: Vertex
		float x1 = 0 + offsetPosition_.x;
		float y1 = 0 + offsetPosition_.y;
		float x2 = x1 + rect.size.width;
		float y2 = y1 + rect.size.height;
		
		// Don't update Z.
		quad_.bl.vertices = (ccVertex3F) { x1, y1, 0 };
		quad_.br.vertices = (ccVertex3F) { x2, y1, 0 };
		quad_.tl.vertices = (ccVertex3F) { x1, y2, 0 };
		quad_.tr.vertices = (ccVertex3F) { x2, y2, 0 };			
	}
			
}

-(void)updateTextureCoords:(CGRect)rect
{
	
	float atlasWidth = texture_.pixelsWide;
	float atlasHeight = texture_.pixelsHigh;

	float left = rect.origin.x / atlasWidth;
	float right = (rect.origin.x + rect.size.width) / atlasWidth;
	float top = rect.origin.y / atlasHeight;
	float bottom = (rect.origin.y + rect.size.height) / atlasHeight;

	
	if( flipX_)
		CC_SWAP(left,right);
	if( flipY_)
		CC_SWAP(top,bottom);
	
	quad_.bl.texCoords.u = left;
	quad_.bl.texCoords.v = bottom;
	quad_.br.texCoords.u = right;
	quad_.br.texCoords.v = bottom;
	quad_.tl.texCoords.u = left;
	quad_.tl.texCoords.v = top;
	quad_.tr.texCoords.u = right;
	quad_.tr.texCoords.v = top;
}

-(void)updateTransform
{
	NSAssert( usesSpriteSheet_, @"updateTransform is only valid when CCSprite is being renderd using an CCSpriteSheet");

	CGAffineTransform matrix;
	
	
	// Optimization: if it is not visible, then do nothing
	if( ! visible_ ) {		
		quad_.br.vertices = quad_.tl.vertices = quad_.tr.vertices = quad_.bl.vertices = (ccVertex3F){0,0,0};
		[textureAtlas_ updateQuad:&quad_ atIndex:atlasIndex_];
		dirty_ = recursiveDirty_ = NO;
		return ;
	}
	

	// Optimization: If parent is spritesheet, or parent is nil
	// build Affine transform manually
	if( ! parent_ || parent_ == spriteSheet_ ) {
		
		float radians = -CC_DEGREES_TO_RADIANS(rotation_);
		float c = cosf(radians);
		float s = sinf(radians);
		
		matrix = CGAffineTransformMake( c * scaleX_,  s * scaleX_,
									   -s * scaleY_, c * scaleY_,
									   position_.x, position_.y);
		matrix = CGAffineTransformTranslate(matrix, -anchorPointInPixels_.x, -anchorPointInPixels_.y);		
	} 
	
	// else do affine transformation according to the HonorParentTransform
	else if( parent_ != spriteSheet_ ) {

		matrix = CGAffineTransformIdentity;
		ccHonorParentTransform prevHonor = CC_HONOR_PARENT_TRANSFORM_ALL;
		
		for (CCNode *p = self ; p && p != spriteSheet_; p = p.parent) {
			
			struct transformValues_ tv = [(CCSprite*)p getTransformValues];
			
			CGAffineTransform newMatrix = CGAffineTransformIdentity;
			
			// 2nd: Translate, Rotate, Scale
			if( prevHonor & CC_HONOR_PARENT_TRANSFORM_TRANSLATE )
				newMatrix = CGAffineTransformTranslate(newMatrix, tv.pos.x, tv.pos.y);
			if( prevHonor & CC_HONOR_PARENT_TRANSFORM_ROTATE )
				newMatrix = CGAffineTransformRotate(newMatrix, -CC_DEGREES_TO_RADIANS(tv.rotation));
			if( prevHonor & CC_HONOR_PARENT_TRANSFORM_SCALE ) {
				newMatrix = CGAffineTransformScale(newMatrix, tv.scale.x, tv.scale.y);
			}
			
			// 3rd: Translate anchor point
			newMatrix = CGAffineTransformTranslate(newMatrix, -tv.ap.x, -tv.ap.y);

			// 4th: Matrix multiplication
			matrix = CGAffineTransformConcat( matrix, newMatrix);
			
			prevHonor = [(CCSprite*)p honorParentTransform];
		}		
	}
	
	//
	// calculate the Quad based on the Affine Matrix
	//
	
	CGSize size = rect_.size;

	float x1 = offsetPosition_.x;
	float y1 = offsetPosition_.y;
	
	float x2 = x1 + size.width;
	float y2 = y1 + size.height;
	float x = matrix.tx;
	float y = matrix.ty;
	
	float cr = matrix.a;
	float sr = matrix.b;
	float cr2 = matrix.d;
	float sr2 = -matrix.c;
	float ax = x1 * cr - y1 * sr2 + x;
	float ay = x1 * sr + y1 * cr2 + y;
	
	float bx = x2 * cr - y1 * sr2 + x;
	float by = x2 * sr + y1 * cr2 + y;
	
	float cx = x2 * cr - y2 * sr2 + x;
	float cy = x2 * sr + y2 * cr2 + y;
	
	float dx = x1 * cr - y2 * sr2 + x;
	float dy = x1 * sr + y2 * cr2 + y;
	
	quad_.bl.vertices = (ccVertex3F) { RENDER_IN_SUBPIXEL(ax), RENDER_IN_SUBPIXEL(ay), vertexZ_ };
	quad_.br.vertices = (ccVertex3F) { RENDER_IN_SUBPIXEL(bx), RENDER_IN_SUBPIXEL(by), vertexZ_ };
	quad_.tl.vertices = (ccVertex3F) { RENDER_IN_SUBPIXEL(dx), RENDER_IN_SUBPIXEL(dy), vertexZ_ };
	quad_.tr.vertices = (ccVertex3F) { RENDER_IN_SUBPIXEL(cx), RENDER_IN_SUBPIXEL(cy), vertexZ_ };
		
	[textureAtlas_ updateQuad:&quad_ atIndex:atlasIndex_];
	dirty_ = recursiveDirty_ = NO;
}

// XXX: Optimization: instead of calling 5 times the parent sprite to obtain: position, scale.x, scale.y, anchorpoint and rotation,
// this fuction return the 5 values in 1 single call
-(struct transformValues_) getTransformValues
{
	struct transformValues_ tv;
	tv.pos = position_;
	tv.scale.x = scaleX_;
	tv.scale.y = scaleY_;
	tv.rotation = rotation_;
	tv.ap = anchorPointInPixels_;
	
	return tv;
}

#pragma mark CCSprite - draw

-(void) draw
{	
	NSAssert(!usesSpriteSheet_, @"If CCSprite is being rendered by CCSpriteSheet, CCSprite#draw SHOULD NOT be called");

	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Unneeded states: -

	BOOL newBlend = NO;
	if( blendFunc_.src != CC_BLEND_SRC || blendFunc_.dst != CC_BLEND_DST ) {
		newBlend = YES;
		glBlendFunc( blendFunc_.src, blendFunc_.dst );
	}

#define kQuadSize sizeof(quad_.bl)
	glBindTexture(GL_TEXTURE_2D, [texture_ name]);
	
	int offset = (int)&quad_;
	
	// vertex
	int diff = offsetof( ccV3F_C4B_T2F, vertices);
	glVertexPointer(3, GL_FLOAT, kQuadSize, (void*) (offset + diff) );
	
	// color
	diff = offsetof( ccV3F_C4B_T2F, colors);
	glColorPointer(4, GL_UNSIGNED_BYTE, kQuadSize, (void*)(offset + diff));
	
	// tex coords
	diff = offsetof( ccV3F_C4B_T2F, texCoords);
	glTexCoordPointer(2, GL_FLOAT, kQuadSize, (void*)(offset + diff));
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	if( newBlend )
		glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
	
#if CC_SPRITE_DEBUG_DRAW
	CGSize s = [self contentSize];
	CGPoint vertices[4]={
		ccp(0,0),ccp(s.width,0),
		ccp(s.width,s.height),ccp(0,s.height),
	};
	ccDrawPoly(vertices, 4, YES);
#endif // CC_TEXTURENODE_DEBUG_DRAW
	
}

#pragma mark CCSprite - CCNode overrides

-(id) addChild:(CCSprite*)child z:(int)z tag:(int) aTag
{
	NSAssert( child != nil, @"Argument must be non-nil");
	
	id ret = [super addChild:child z:z tag:aTag];
	
	if( usesSpriteSheet_ ) {
		NSAssert( [child isKindOfClass:[CCSprite class]], @"CCSprite only supports CCSprites as children when using SpriteSheet");
		NSAssert( child.texture.name == textureAtlas_.texture.name, @"CCSprite is not using the same texture id");
		
		NSUInteger index = [spriteSheet_ atlasIndexForChild:child atZ:z];
		[spriteSheet_ insertChild:child inAtlasAtIndex:index];
	}
	
	hasChildren_ = YES;

	return ret;
}

-(void) reorderChild:(CCSprite*)child z:(int)z
{
	if( usesSpriteSheet_ ) {
		NSAssert(NO,@"reorderChild not implemented while using Spritesheet. Please open a bug, and if possible attach the patch. Thanks");
	}

	[super reorderChild:child z:z];
}

-(void)removeChild: (CCSprite *)sprite cleanup:(BOOL)doCleanup
{
	if( usesSpriteSheet_ )
		[spriteSheet_ removeSpriteFromAtlas:sprite];

	[super removeChild:sprite cleanup:doCleanup];
	
	hasChildren_ = ( [children_ count] > 0 );
}

-(void)removeAllChildrenWithCleanup:(BOOL)doCleanup
{
	if( usesSpriteSheet_ ) {
		for( CCSprite *child in children_ )
			[spriteSheet_ removeSpriteFromAtlas:child];
	}
	
	[super removeAllChildrenWithCleanup:doCleanup];
	
	hasChildren_ = NO;
}

//
// CCNode property overloads
// used only when parent is CCSpriteSheet
//
#pragma mark CCSprite - property overloads


-(void) setDirtyRecursively:(BOOL)b
{
	dirty_ = recursiveDirty_ = b;
	// recursively set dirty
	if( hasChildren_ ) {
		for( CCSprite *child in children_)
			[child setDirtyRecursively:YES];
	}
}

// XXX HACK: optimization
#define SET_DIRTY_RECURSIVELY() {									\
					if( usesSpriteSheet_ && ! recursiveDirty_ ) {	\
						dirty_ = recursiveDirty_ = YES;				\
						if( hasChildren_)							\
							[self setDirtyRecursively:YES];			\
						}											\
					}

-(void)setPosition:(CGPoint)pos
{
	[super setPosition:pos];
	SET_DIRTY_RECURSIVELY();
}

-(void)setRotation:(float)rot
{
	[super setRotation:rot];
	SET_DIRTY_RECURSIVELY();
}

-(void)setScaleX:(float) sx
{
	[super setScaleX:sx];
	SET_DIRTY_RECURSIVELY();
}

-(void)setScaleY:(float) sy
{
	[super setScaleY:sy];
	SET_DIRTY_RECURSIVELY();
}

-(void)setScale:(float) s
{
	[super setScale:s];
	SET_DIRTY_RECURSIVELY();
}

-(void) setVertexZ:(float)z
{
	[super setVertexZ:z];
	SET_DIRTY_RECURSIVELY();
}

-(void)setAnchorPoint:(CGPoint)anchor
{
	[super setAnchorPoint:anchor];
	SET_DIRTY_RECURSIVELY();
}

-(void)setRelativeAnchorPoint:(BOOL)relative
{
	NSAssert( ! usesSpriteSheet_, @"relativeTransformAnchor is invalid in CCSprite");
	[super setIsRelativeAnchorPoint:relative];
}

-(void)setVisible:(BOOL)v
{
	if( v != visible_ ) {
		[super setVisible:v];
		if( usesSpriteSheet_ && ! recursiveDirty_ ) {
			dirty_ = recursiveDirty_ = YES;
			for( id child in children_)
				[child setVisible:v];
		}
	}
}

-(void)setFlipX:(BOOL)b
{
	if( flipX_ != b ) {
		flipX_ = b;
		[self setTextureRect:rect_];	
	}
}
-(BOOL) flipX
{
	return flipX_;
}

-(void) setFlipY:(BOOL)b
{
	if( flipY_ != b ) {
		flipY_ = b;	
		[self setTextureRect:rect_];	
	}	
}
-(BOOL) flipY
{
	return flipY_;
}

//
// RGBA protocol
//
#pragma mark CCSprite - RGBA protocol
-(void) updateColor
{
	// renders using Sprite Manager
	if( usesSpriteSheet_ ) {
		if( atlasIndex_ != CCSpriteIndexNotInitialized)
			[textureAtlas_ updateQuad:&quad_ atIndex:atlasIndex_];
		else
			// no need to set it recursively
			// update dirty_, don't update recursiveDirty_
			dirty_ = YES;
	}
	// self render
	// do nothing
}

-(void) setOpacity:(GLubyte) anOpacity
{
	opacity_ = anOpacity;
	
	// special opacity for premultiplied textures
	if( opacityModifyRGB_ )
		color_.r = color_.g = color_.b = opacity_;

	ccColor4B color4 = {color_.r, color_.g, color_.b, opacity_ };

	quad_.bl.colors = color4;
	quad_.br.colors = color4;
	quad_.tl.colors = color4;
	quad_.tr.colors = color4;

	[self updateColor];
}

-(void) setColor:(ccColor3B)color3
{
	color_ = color3;
	
	ccColor4B color4 = {color_.r, color_.g, color_.b, opacity_ };
	quad_.bl.colors = color4;
	quad_.br.colors = color4;
	quad_.tl.colors = color4;
	quad_.tr.colors = color4;
	
	[self updateColor];
}

-(void) setOpacityModifyRGB:(BOOL)modify
{
	opacityModifyRGB_ = modify;
}

-(BOOL) doesOpacityModifyRGB
{
	return opacityModifyRGB_;
}

//
// CCFrameProtocol protocol
//
#pragma mark CCSprite - CCFrameProtocol protocol

-(void) setDisplayFrame:(CCSpriteFrame*)frame
{
	offsetPosition_ = frame.offset;
	
	CGRect rect = frame.rect;
	CGSize origSize = frame.originalSize;
	offsetPosition_.x += (origSize.width - rect.size.width) / 2;
	offsetPosition_.y += (origSize.height - rect.size.height) / 2;

	// update texture before updating texture rect
	if ( frame.texture.name != self.texture.name )
		[self setTexture: frame.texture];
	
	// update rect
	[self setTextureRect:frame.rect untrimmedSize:frame.originalSize];
	
}

-(void) setDisplayFrame: (NSString*) animationName index:(int) frameIndex
{
	if( ! animations_ )
		[self initAnimationDictionary];
	
	CCAnimation *a = [animations_ objectForKey: animationName];
	CCSpriteFrame *frame = [[a frames] objectAtIndex:frameIndex];
	
	NSAssert( frame, @"CCSprite#setDisplayFrame. Invalid frame");
	
	[self setDisplayFrame:frame];
}

-(BOOL) isFrameDisplayed:(CCSpriteFrame*)frame 
{
	CGRect r = [frame rect];
	CGPoint p = [frame offset];
	return ( CGRectEqualToRect(r, rect_) &&
			frame.texture.name == self.texture.name &&
			CGPointEqualToPoint(p, offsetPosition_));
}

-(CCSpriteFrame*) displayedFrame
{
	return [CCSpriteFrame frameWithTexture:self.texture rect:rect_ offset:CGPointZero];
}

-(void) addAnimation: (id<CCAnimationProtocol>) anim
{
	// lazy alloc
	if( ! animations_ )
		[self initAnimationDictionary];
	
	[animations_ setObject:anim forKey:[anim name]];
}

-(id<CCAnimationProtocol>)animationByName: (NSString*) animationName
{
	NSAssert( animationName != nil, @"animationName parameter must be non nil");
    return [animations_ objectForKey:animationName];
}

#pragma mark CCSprite - CocosNodeTexture protocol

-(void) updateBlendFunc
{
	NSAssert( ! usesSpriteSheet_, @"CCSprite: updateBlendFunc doesn't work when the sprite is rendered using a CCSpriteSheet");

	// it's possible to have an untextured sprite
	if( !texture_ || ! [texture_ hasPremultipliedAlpha] ) {
		blendFunc_.src = GL_SRC_ALPHA;
		blendFunc_.dst = GL_ONE_MINUS_SRC_ALPHA;
		opacityModifyRGB_ = NO;
	} else {
		blendFunc_.src = CC_BLEND_SRC;
		blendFunc_.dst = CC_BLEND_DST;
		opacityModifyRGB_ = YES;
	}
}

-(void) setTexture:(CCTexture2D*)texture
{
	NSAssert( ! usesSpriteSheet_, @"CCSprite: setTexture doesn't work when the sprite is rendered using a CCSpriteSheet");
	
	// accept texture==nil as argument
	NSAssert( !texture || [texture isKindOfClass:[CCTexture2D class]], @"setTexture expects a CCTexture2D. Invalid argument");

	[texture_ release];
	texture_ = [texture retain];
	
	[self updateBlendFunc];
}

-(CCTexture2D*) texture
{
	return texture_;
}

@end
