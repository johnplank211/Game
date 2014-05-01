//
//  CreditScene.m
//  testgame2
//
//  Created by john plank on 4/29/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import "CreditScene.h"

@implementation CreditScene

//set up scene with background image
+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    
    CreditScene *layer = [CreditScene node];
    
    // CGSize windowSize = [[CCDirector sharedDirector] ];
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"splash.png"];
    background.anchorPoint = ccp(0, 0);
    [layer addChild:background z:-1];
    
    
    [scene addChild:layer];

    
	return scene;
}

//Adds main menu button

- (id)init
{
    if ((self=[super init])) {
        
        CCButton *backButton = [CCButton buttonWithTitle:@"[ Main Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
        backButton.positionType = CCPositionTypeNormalized;
        backButton.position = ccp(0.5f, 0.15f);
        [backButton setTarget:self selector:@selector(onSpinningClicked:)];
        [self addChild:backButton];
        
        
        
    }
    
    return self;
}

///method that is fired when button is clicked
- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

@end
