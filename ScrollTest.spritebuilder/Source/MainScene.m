//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene
{
    CCNodeColor *_stencil;
    CCLabelTTF *_title;
    CCLabelTTF *_xLabel;
    CCLabelTTF *_yLabel;
    CCClippingNode *_clippingNode;
    float _increment;
    
    CCNode *_starfield;
    CCNode *_words;
    
    CGSize _viewSize;
}

- (void)didLoadFromCCB
{
    NSAssert(_stencil != nil, @"_stencil was nil");
    NSAssert(_title != nil, @"_title was nil");
    
    NSLog(@"stencil - pos: %@,  size: %@", NSStringFromCGPoint([_stencil positionInPoints]), NSStringFromCGSize([_stencil contentSizeInPoints]));
    
    CCNode *parentNode = [_stencil parent];
    
    _clippingNode = [CCClippingNode clippingNodeWithStencil:_stencil];
    [_clippingNode setContentSize:[_stencil contentSize]];
    [_clippingNode setPosition:CGPointZero];
    [_clippingNode setAlphaThreshold:0.0f];
    [parentNode addChild:_clippingNode];
    
    NSArray *childrenToMove = [[_stencil children] copy];
    for (CCNode *k in childrenToMove)
    {
        [k removeFromParent];
        [_clippingNode addChild:k];
    }
    
    NSLog(@"clippingNode - pos: %@,  size: %@", NSStringFromCGPoint([_clippingNode positionInPoints]), NSStringFromCGSize([_clippingNode contentSizeInPoints]));
    NSLog(@"label - pos: %@ - size: %@", NSStringFromCGPoint([_title positionInPoints]), NSStringFromCGSize([_title contentSizeInPoints]));
}

- (void)onEnter
{
    [super onEnter];
    
    _viewSize = [[CCDirector sharedDirector] viewSize];
}

- (void)sliderChanged:(id)sender
{
    NSLog(@"sender: %@", sender);
    CCSlider *slider = sender;
    CCNode *clippedContent = [[_clippingNode children] objectAtIndex:0];
    CGPoint pos = [clippedContent position];
    if ([[slider name] isEqualToString:@"topSlider"])
    {
        NSLog(@"x: %0.2f", [slider sliderValue]);
        float range = _viewSize.width * 2.0f;
        float offset = _viewSize.width * 0.5f;
        float xpos = (range * [slider sliderValue]) - offset;
        pos.x = xpos;
    }
    else
    {
        NSLog(@"y: %0.2f", [slider sliderValue]);
        float range = _viewSize.height * 2.0f;
        float offset = _viewSize.height * 0.5f;
        float ypos = (range * [slider sliderValue]) - offset;
        pos.y = ypos;
    }
    [clippedContent setPosition:pos];
    [_xLabel setString:[NSString stringWithFormat:@"%d", (int)pos.x]];
    [_yLabel setString:[NSString stringWithFormat:@"%d", (int)pos.y]];
}

- (void)switch:(id)sender
{
    CCNode *clippedContent = [[_clippingNode children] objectAtIndex:0];
    [clippedContent removeFromParent];
    CCNode *switchToContent;
    if (clippedContent == _title)
    {
        if (_starfield == nil)
        {
            _starfield = [CCBReader load:@"Starfield"];
        }
        switchToContent = _starfield;
    }
    else if (clippedContent == _starfield)
    {
        if (_words == nil)
        {
            _words = [CCBReader load:@"TextLayer"];
        }
        switchToContent = _words;
    }
    else
    {
        switchToContent = _title;
    }
    if ([switchToContent parent] != nil)
    {
        [switchToContent removeFromParent];
    }
    [_clippingNode addChild:switchToContent];
}

@end
