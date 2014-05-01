//
//  Instructions.m
//  testgame2
//
//  Created by john plank on 5/1/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import "Instructions.h"

@implementation Instructions

//sets up the scene 
+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    
    Instructions *layer = [Instructions node];
    
    // CGSize windowSize = [[CCDirector sharedDirector] ];
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"instructions.png"];
    background.anchorPoint = ccp(0, 0);
    [layer addChild:background z:-1];
    
    
    [scene addChild:layer];
    
    
	return scene;
}


//adds the main menu button
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

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

@end
