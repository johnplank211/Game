//
//  HelloWorldScene.m
//  testgame2
//
//  Created by john plank on 4/2/14.
//  Copyright john plank 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *_sprite;
}



@synthesize plane, ufo1, ufo2;

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (CCScene *)scene
{
    
    CCScene *scene = [CCScene node];
    
    HelloWorldScene *layer = [HelloWorldScene node];
    
   // CGSize windowSize = [[CCDirector sharedDirector] ];
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
    //background.position = ccp(515, 385);
    background.anchorPoint = ccp(0, 0);
    [layer addChild:background z:-1];
    
    
//    CCSprite *background = [CCSprite spriteWithImageNamed:@"castlePlank.png"];
//    background.anchorPoint = ccp(0, 0);
//    [layer addChild:background];
    
    [scene addChild:layer];
    
    return scene;
}

// -----------------------------------------------------------------------

-(void) animation_finsihed
{
    
    
    int x = arc4random() %320;
    int y = arc4random() % 480;
    
    id moveToAction = [CCActionMoveTo actionWithDuration:2.0 position:ccp(x,y)];
    id callBack = [CCActionCallFunc actionWithTarget:self selector:@selector(animation_finsihed)];
    
    
    [self.plane runAction:[CCActionSequence actions:moveToAction, callBack, nil]];
    
}


- (id)init
{
    
    
    
    
    
//    // Apple recommend assigning self with supers return value
    
    if ((self=[super init])) {


   //self.userInteractionEnabled = YES;
        
    
//    CCSprite *plane = [CCSprite spriteWithImageNamed:@"plane.png"];
//    plane.position = ccp(200,200);
//    [self addChild:plane];
//
//        CCSprite *ufo1 = [CCSprite spriteWithImageNamed:@"ufo.png"];
//        ufo1.position = ccp(800,500);
//        [self addChild:ufo1];
//        
//        CCSprite *ufo2 = [CCSprite spriteWithImageNamed:@"ufoIII.png"];
//        ufo2.position = ccp(800,200);
//        [self addChild:ufo2];

        self.ufo2 = [CCSprite spriteWithImageNamed:@"ufoIII.png"];
        ufo2.position = ccp(800,500);
        
        self.plane = [CCSprite spriteWithImageNamed:@"plane.png"];
        plane.position = ccp(200,200);
//   
//        int x = arc4random() %768;
//        int y = arc4random() % 1024;
//        
//        id moveToAction = [CCActionMoveTo actionWithDuration:2.0 position:ccp(x,y)];
//        id callBack = [CCActionCallFunc actionWithTarget:self selector:@selector(animation_finsihed)];
//        
//        [self.plane runAction:[CCActionSequence actions:moveToAction, callBack, nil]];
        
        [self addChild:self.plane];
        [self addChild:self.ufo2];
        self.userInteractionEnabled = TRUE;
        
    }
    
    return self;
}



-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLoc = [touch locationInNode:self];    
    //CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(location));
    
    
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    float distance = powf(self.plane.position.x - touchLoc.x, 2) + powf(self.plane.position.y - touchLoc.y, 2);
    
    distance = sqrtf(distance);
    
    if (distance <= 55)
    {
        [self.plane runAction:[CCActionRotateBy actionWithDuration:2.0 angle:360]];
        [[OALSimpleAudio sharedInstance] playBg:@"enemymachinegun.wav" loop:NO];
    }
    
    float distance1 = powf(self.ufo2.position.x - touchLoc.x, 2) + powf(self.ufo2.position.y - touchLoc.y, 2);
    
    distance1 = sqrtf(distance1);
    
    if (distance1 <= 55)
    {
        //[self.ufo2 runAction:[CCActionRotateBy actionWithDuration:2.0 angle:360]];
        [[OALSimpleAudio sharedInstance] playBg:@"laser.wav" loop:NO];
    }

    
    
}







- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

//-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    CGPoint touchLoc = [touch locationInNode:self];
//    
//    // Log touch location
//    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
//    
//    // Move our sprite to touch location
//    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
//    [_sprite runAction:actionMove];
//    
//    
//    
//    
//}




// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
