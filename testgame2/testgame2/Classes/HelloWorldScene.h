//
//  HelloWorldScene.h
//  testgame2
//
//  Created by john plank on 4/2/14.
//  Copyright john plank 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"


// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface HelloWorldScene : CCScene

{
    CCSprite *plane;
    CCSprite *ufo1;
    CCSprite *ufo2;
}


@property (nonatomic, retain) CCSprite *plane;
@property (nonatomic, retain) CCSprite *ufo1;
@property (nonatomic, retain) CCSprite *ufo2;


// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end