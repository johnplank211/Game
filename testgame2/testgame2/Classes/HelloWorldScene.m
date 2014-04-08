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
#import "chipmunk.h"


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
    background.anchorPoint = ccp(0, 0);
    [layer addChild:background z:-1];
    
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


- (void) addMonster {
    
    self.ufo2 = [CCSprite spriteWithImageNamed:@"ufoIII.png"];
    // Determine where to spawn the monster along the Y axis
    CGSize s = [[CCDirector sharedDirector] viewSize];
    int minY = self.ufo2.contentSize.height / 2;
    int maxY = s.height - self.ufo2.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    self.ufo2.position = ccp(s.width + self.ufo2.contentSize.width/2, actualY);
    [self addChild:self.ufo2];
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCActionMoveTo * actionMove = [CCActionMoveTo actionWithDuration:actualDuration
                                                            position:ccp(-self.ufo2.contentSize.width/2, actualY)];
    CCActionCallBlock * actionMoveDone = [CCActionCallBlock actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    [self.ufo2 runAction:[CCActionSequence actions:actionMove, actionMoveDone, nil]];
    
}






- (id)init
{
    
     if ((self=[super init])) {

        
      CGSize winSize = [CCDirector sharedDirector].viewSize;
        

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

        self.ufo1 = [CCSprite spriteWithImageNamed:@"ufo.png"];
        ufo1.position = ccp(800,200);
        
//        self.ufo2 = [CCSprite spriteWithImageNamed:@"ufoIII.png"];
//        ufo2.position = ccp(800,500);
        
        self.plane = [CCSprite spriteWithImageNamed:@"plane.png"];
        plane.position = ccp(plane.contentSize.width/2, winSize.height/2);
//   
//        int x = arc4random() %768;
//        int y = arc4random() % 1024;
//        
//        id moveToAction = [CCActionMoveTo actionWithDuration:2.0 position:ccp(x,y)];
//        id callBack = [CCActionCallFunc actionWithTarget:self selector:@selector(animation_finsihed)];
//        
//        [self.plane runAction:[CCActionSequence actions:moveToAction, callBack, nil]];
        
        [[OALSimpleAudio sharedInstance] preloadEffect:@"laser.wav"];
        [[OALSimpleAudio sharedInstance] preloadEffect:@"enemymachinegun.wav"];
        
        [self addChild:self.plane z:100];
        [self addChild:self.ufo1];
        //[self addChild:self.ufo2];
        self.userInteractionEnabled = TRUE;
        
    }
    //[self schedule:@selector(gameLogic:) interval:0.05];
    return self;
}


-(void)gameLogic:(CCTime)dt
{
    [self addMonster];
}



-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // Choose one of the touches to work with
    //UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    self.ufo1 = [CCSprite spriteWithImageNamed:@"ufo.png"];
    self.ufo1.position = ccp(plane.contentSize.width/2, winSize.height/2);
    
    // Determine offset of location to projectile
    CGPoint offset = ccpSub(location, self.ufo1.position);
    
    // Bail out if you are shooting down or backwards
    if (offset.x <= 0) return;
    
    // Ok to add now - we've double checked position
    [self addChild:self.ufo1];
    
    int realX = winSize.width + (self.ufo1.contentSize.width/2);
    float ratio = (float) offset.y / (float) offset.x;
    int realY = (realX * ratio) + self.ufo1.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // Determine the length of how far you're shooting
    int offRealX = realX - self.ufo1.position.x;
    int offRealY = realY - self.ufo1.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    [[OALSimpleAudio sharedInstance] playBg:@"enemymachinegun.wav" loop:NO];
    // Move projectile to actual endpoint
    [ufo1 runAction:
     [CCActionSequence actions:
      [CCActionMoveTo actionWithDuration:realMoveDuration position:realDest],
      [CCActionCallBlock actionWithBlock:^(CCNode *node) {
         [node removeFromParentAndCleanup:YES];
     }],
      nil]];
    
}





//-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    CGPoint touchLoc = [touch locationInNode:self];    
//    //CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(location));
//    
//    
//    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
//    float distance = powf(self.plane.position.x - touchLoc.x, 2) + powf(self.plane.position.y - touchLoc.y, 2);
//    
//    distance = sqrtf(distance);
//    
//    if (distance <= 55)
//    {
//        [self.plane runAction:[CCActionRotateBy actionWithDuration:2.0 angle:360]];
//        [[OALSimpleAudio sharedInstance] playBg:@"enemymachinegun.wav" loop:NO];
//    }
//    
//    float distance1 = powf(self.ufo2.position.x - touchLoc.x, 2) + powf(self.ufo2.position.y - touchLoc.y, 2);
//    
//    distance1 = sqrtf(distance1);
//    
//    if (distance1 <= 55)
//    {
//        //[self.ufo2 runAction:[CCActionRotateBy actionWithDuration:2.0 angle:360]];
//        [[OALSimpleAudio sharedInstance] playBg:@"laser.wav" loop:NO];
//    }
//
//    //added this to see if I set up git
//    
//}





//- (void)dealloc
//{
    
    
    //[_ufo1 release];
    //_ufo1 = nil;
    //[_ufo2 release];
    //_ufo2 = nil;
    // clean up code goes here
//}

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
