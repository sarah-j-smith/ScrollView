//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

#define MARGIN 20.0f
#define SPEED 40.0f

@implementation MainScene
{
    CCNodeColor *_stencil;
    CCLabelTTF *_title;
    CCLabelTTF *_xLabel;
    CCClippingNode *_clippingNode;
    float _increment;
    
    CCNode *_starfield;
    CCNode *_words;
    
    CGSize _viewSize;
    CGPoint _clipOrigin;
}

- (void)didLoadFromCCB
{
    NSAssert(_stencil != nil, @"_stencil was nil");
    NSAssert(_title != nil, @"_title was nil");
    
    NSLog(@"stencil - pos: %@,  size: %@", NSStringFromCGPoint([_stencil positionInPoints]), NSStringFromCGSize([_stencil contentSizeInPoints]));
    
    CCNode *parentNode = [_stencil parent];
    _clipOrigin = [parentNode convertToWorldSpace:[_stencil positionInPoints]];
    
    _clippingNode = [CCClippingNode clippingNodeWithStencil:_stencil];
    [_clippingNode setAlphaThreshold:0.0f];
    
    [self addChild:_clippingNode];
    
    NSLog(@"clippingNode - pos: %@,  size: %@", NSStringFromCGPoint([_clippingNode positionInPoints]), NSStringFromCGSize([_clippingNode contentSizeInPoints]));
    NSLog(@"label - pos: %@ - size: %@", NSStringFromCGPoint([_title positionInPoints]), NSStringFromCGSize([_title contentSizeInPoints]));
    
    _starfield = [CCBReader load:@"Starfield"];
    _words = [CCBReader load:@"TextLayer"];
}

- (void)onEnter
{
    [super onEnter];
    
    _viewSize = [[CCDirector sharedDirector] viewSize];
    _increment = SPEED;
    
    [self loadContent:_title];
}

- (void)loadContent:(CCNode *)content
{
    if ([content parent] != nil)
    {
        [content removeFromParent];
    }
    CCNode *clippedContent = [[_clippingNode children] objectAtIndex:0];
    [clippedContent removeFromParent];
    
    [_clippingNode addChild:content];
    [content setPositionType:CCPositionTypePoints];
    [content setPosition:_clipOrigin];
}

- (void)update:(CCTime)delta
{
    float d = delta * _increment;
    CCNode *clippedContent = [[_clippingNode children] objectAtIndex:0];
    CGPoint pos = [clippedContent position];
    pos.y += d;
    if (pos.y > (_viewSize.height - MARGIN))
    {
        pos.y = (_viewSize.height - MARGIN);
        _increment = -_increment;
    }
    else if (pos.y < MARGIN)
    {
        pos.y = MARGIN;
        _increment = -_increment;
    }
    [clippedContent setPosition:pos];
    [_xLabel setString:[NSString stringWithFormat:@"%d, %d", (int)pos.x, (int)pos.y]];
}

- (void)switch:(id)sender
{
    CCNode *clippedContent = [[_clippingNode children] objectAtIndex:0];
    if (clippedContent == _title)
    {
        [self loadContent:_starfield];
    }
    else if (clippedContent == _starfield)
    {
        [self loadContent:_words];
    }
    else
    {
        [self loadContent:_title];
    }
}

@end
