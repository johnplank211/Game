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
    CCPhysicsNode *_physicsWorld;
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
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"bgii.png"];
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




- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)monster projectileCollision:(CCNode *)projectile {
    [monster removeFromParent];
    [projectile removeFromParent];
    [[OALSimpleAudio sharedInstance] playEffect:@"boom.wav"];
    
    return YES;
}






- (void) addMonster {
    
    self.ufo2 = [CCSprite spriteWithImageNamed:@"ufoIII.png"];
    
    int minY = self.ufo2.contentSize.height / 2;
    int maxY = self.contentSize.height - self.ufo2.contentSize.height / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    self.ufo2.position = CGPointMake(self.contentSize.width + self.ufo2.contentSize.width/2, randomY);
    //[self addChild:self.ufo2];
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    
    
    
    self.ufo2.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.ufo2.contentSize} cornerRadius:1];
    self.ufo2.physicsBody.collisionGroup = @"monsterGroup";
    self.ufo2.physicsBody.collisionType  = @"monsterCollision";
    [_physicsWorld addChild:self.ufo2];


    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-self.ufo2.contentSize.width/2, randomY)];
    CCAction *actionRemove = [CCActionRemove action];
    [self.ufo2 runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
}






- (id)init
{
    
     if ((self=[super init])) {

        
      CGSize winSize = [CCDirector sharedDirector].viewSize;
                
//        self.ufo2 = [CCSprite spriteWithImageNamed:@"ufoIII.png"];
//        ufo2.position = ccp(800,500);
        
        self.plane = [CCSprite spriteWithImageNamed:@"planeii.png"];
        plane.position = ccp(plane.contentSize.width/2, winSize.height/2);

         _physicsWorld = [CCPhysicsNode node];
         _physicsWorld.gravity = ccp(0,0);
         //_physicsWorld.debugDraw = YES;
         _physicsWorld.collisionDelegate = self;
         [self addChild:_physicsWorld];
         
        [[OALSimpleAudio sharedInstance] preloadEffect:@"boom.wav"];
        [[OALSimpleAudio sharedInstance] preloadEffect:@"gunfire.wav"];
        
        //[self addChild:self.plane z:100];
         
         
         self.plane.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.plane.contentSize} cornerRadius:0]; // 1
         self.plane.physicsBody.collisionGroup = @"playerGroup"; // 2
         [_physicsWorld addChild:self.plane z:100];
         
         
       // [self addChild:self.ufo2];
        self.userInteractionEnabled = TRUE;
        
    }
    [self schedule:@selector(gameLogic:) interval:2];
    return self;
}


-(void)gameLogic:(CCTime)dt
{
    [self addMonster];
}



-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode:self];
    
 
    int     targetX   = 1000 + 0;
    int     targetY   = 0 + self.plane.position.y;
    CGPoint targetPosition = ccp(targetX,targetY);
    
 
    CCSprite *projectile = [CCSprite spriteWithImageNamed:@"bullet.png"];
    projectile.position = self.plane.position;
   
    
    projectile.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:projectile.contentSize.width/2.0f andCenter:projectile.anchorPointInPoints];
   
    
    projectile.physicsBody.collisionGroup = @"playerGroup";
    projectile.physicsBody.collisionType  = @"projectileCollision";
    
    
    //_physicsWorld.debugDraw = YES;
    [_physicsWorld addChild:projectile];
    
    //[[OALSimpleAudio sharedInstance] playEffect:@"enemymachinegun.wav"];
    
    
    float distance = powf(self.plane.position.x - touchLocation.x, 2) + powf(self.plane.position.y - touchLocation.y, 2);
    
        distance = sqrtf(distance);
    
        if (distance <= 55)
        {
            //[self.plane runAction:[CCActionRotateBy actionWithDuration:2.0 angle:360]];
            [[OALSimpleAudio sharedInstance] playBg:@"gunfire.wav" loop:NO];
            
            
            CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
            CCActionRemove *actionRemove = [CCActionRemove action];
            [projectile runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
        }

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
