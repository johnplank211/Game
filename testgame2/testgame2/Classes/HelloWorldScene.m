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
#import "CCAnimation.h"



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


-(void) animation_finsihed
{
    
    
    int x = arc4random() %320;
    int y = arc4random() % 480;
    
    id moveToAction = [CCActionMoveTo actionWithDuration:2.0 position:ccp(x,y)];
    id callBack = [CCActionCallFunc actionWithTarget:self selector:@selector(animation_finsihed)];
    
    
    [self.plane runAction:[CCActionSequence actions:moveToAction, callBack, nil]];
    
}





// -----------------------------------------------------------------------

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)triple monsterCollision:(CCNode *)monster projectileCollision:(CCNode *)projectile 
{
    [monster removeFromParent];
    [projectile removeFromParent];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"boom.wav"];

    if (_score >= 0)
    {
        
        [self endScene:kEndReasonWin];
    }
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"boom.plist"];
    
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"boom.png"];
    [self addChild:spriteSheet];
    
    
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for (int i=1; i<=3; i++) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"boom%d.png",i]]];
    }
    
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:walkAnimFrames delay:0.1f];
    
    
    self.ufo2 = [CCSprite spriteWithImageNamed:@"boom1.png"];
    self.ufo2.position = monster.position;
    CCAction *animateAction = [CCActionAnimate actionWithAnimation:walkAnim];
    [self.ufo2 runAction:animateAction];
    
    [spriteSheet addChild:self.ufo2];
    
    _score++;
    [_label setString:[NSString stringWithFormat:@"score: %d",_score]];
    
    return YES;
}



- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)triple monsterCollision:(CCNode *)ufoo planeCollision:(CCNode *)planeHero
{
    [ufoo removeFromParent];
    [[OALSimpleAudio sharedInstance] playEffect:@"boom.wav"];
    
   // _lives = 1;
    
    
    if (_lives <= 0) {
        [planeHero removeFromParent];
        [planeHero stopAllActions];
        planeHero.visible = FALSE;
        [self endScene:kEndReasonLose];
    }
    
    
    if (CGRectIntersectsRect(planeHero.boundingBox, ufoo.boundingBox)) {
            ufoo.visible = NO;
            [planeHero runAction:[CCActionBlink actionWithDuration:1.0 blinks:9]];
            _lives--;
            
            
    
        }
    
//    if (_lives <= 0) {
//        [planeHero removeFromParent];
//        [planeHero stopAllActions];
//        planeHero.visible = FALSE;
//        [self endScene:kEndReasonLose];
//    }


    
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
        
         
         
         
        self.plane = [CCSprite spriteWithImageNamed:@"planeii.png"];
        plane.position = ccp(plane.contentSize.width/2, winSize.height/2);
         

         _physicsWorld = [CCPhysicsNode node];
         _physicsWorld.gravity = ccp(0,0);
         _physicsWorld.collisionDelegate = self;
         //_physicsWorld.debugDraw = YES;
         [self addChild:_physicsWorld];
         
        [[OALSimpleAudio sharedInstance] preloadEffect:@"boom.wav"];
        [[OALSimpleAudio sharedInstance] preloadEffect:@"gunfire.wav"];
        
         self.plane.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.plane.contentSize} cornerRadius:0];
         self.plane.physicsBody.collisionGroup = @"playerGroup";
         plane.physicsBody.collisionType  = @"planeCollision";
         [_physicsWorld addChild:self.plane z:100];
         
         
         
        self.userInteractionEnabled = TRUE;
                 
         [self schedule:@selector(gameLogic:) interval:1];
         
         _lives = 2;
         _score              = 0;
         _label              = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", _score]
                                                  fontName:@"Super Mario Bros Alphabet"
                                                  fontSize:30.0f];
         _label.positionType = CCPositionTypeNormalized;
         _label.color        = [CCColor whiteColor];
         _label.position     = ccp(0.5f, 0.9f);
         
         [self addChild:_label];
         
         
         CCButton *pause = [CCButton buttonWithTitle:@"pause"];
         [pause setTarget:self selector:@selector(pauseGamePlayScene)];
         pause.positionType = CCPositionTypeNormalized;
         pause.position = ccp(0.5f, 0.10f);
         //[[CCDirector sharedDirector] pause];
         
         [self addChild:pause z:100];
         
         CCButton *resume = [CCButton buttonWithTitle:@"resume"];
         [resume setTarget:self selector:@selector(resumeGamePlayScene)];
         resume.positionType = CCPositionTypeNormalized;
         resume.position = ccp(0.5f, 0.05f);

         
         [self addChild:resume z:100];

         //_lives = 2;
                 
    }
    
    
    return self;
        
    
}


-(void)pauseGamePlayScene
{
     [[CCDirector sharedDirector] pause];
}

-(void)resumeGamePlayScene
{
    [[CCDirector sharedDirector] resume];
}





//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
//    
//#define kFilteringFactor 0.1
//#define kRestAccelX -0.6
//#define kShipMaxPointsPerSec (winSize.height*0.5)
//#define kMaxDiffX 0.2
//    
//    UIAccelerationValue rollingX, rollingY, rollingZ;
//    
//    rollingX = (acceleration.x * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor));
//    rollingY = (acceleration.y * kFilteringFactor) + (rollingY * (1.0 - kFilteringFactor));
//    rollingZ = (acceleration.z * kFilteringFactor) + (rollingZ * (1.0 - kFilteringFactor));
//    
//    float accelX = acceleration.x - rollingX;
//    float accelY = acceleration.y - rollingY;
//    float accelZ = acceleration.z - rollingZ;
//    
//    CGSize winSize = [CCDirector sharedDirector].viewSize;
//    
//    float accelDiff = accelX - kRestAccelX;
//    float accelFraction = accelDiff / kMaxDiffX;
//    float pointsPerSec = kShipMaxPointsPerSec * accelFraction;
//    
//    _shipPointsPerSecY = pointsPerSec;
//    
//}



- (void)restartTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]];
}

- (void)endScene:(EndReason)endReason {
    
    if (_gameOver) return;
    _gameOver = true;
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    
    
    NSString *message;
    if (endReason == kEndReasonWin) {
        message = @"Winner!!!";
    } else if (endReason == kEndReasonLose) {
        message = @"You lose!";
    }
    
 
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _label2 = [CCLabelBMFont labelWithString:message fntFile:@"Arial-hd.fnt"];
    } else {
        _label2 = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
    }
    _label2.positionType = CCPositionTypeNormalized;
    _label2.color        = [CCColor whiteColor];
    _label2.position     = ccp(0.5f, 0.8f);
    [self addChild:_label2];
  
    CCButton *restartItem = [CCButton buttonWithTitle:@"Restart"];
    [restartItem setTarget:self selector:@selector(restartTapped:)];
    restartItem.scale = 0.1;
    restartItem.position = ccp(winSize.width/2, winSize.height * 0.2);
    
    [self addChild:restartItem];
    
    [restartItem runAction:[CCActionScaleTo actionWithDuration:0.5 scale:1.0]];
    
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
    
 
    float distance = powf(self.plane.position.x - touchLocation.x, 2) + powf(self.plane.position.y - touchLocation.y, 2);
    
        distance = sqrtf(distance);
    
        if (distance <= 55)
        {
            CCSprite *projectile = [CCSprite spriteWithImageNamed:@"bullet.png"];
            projectile.position = self.plane.position;
            
            [_physicsWorld addChild:projectile];
            
            projectile.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:projectile.contentSize.width/2.0f andCenter:projectile.anchorPointInPoints];
            
            
            projectile.physicsBody.collisionGroup = @"playerGroup";
            projectile.physicsBody.collisionType  = @"projectileCollision";
            
            
            //[self.plane runAction:[CCActionRotateBy actionWithDuration:2.0 angle:360]];
            [[OALSimpleAudio sharedInstance] playBg:@"gunfire.wav" loop:NO];
            
            CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
            CCActionRemove *actionRemove = [CCActionRemove action];
            [projectile runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
            
            
            if (_lives <= 0) {
                [projectile removeFromParent];
                [projectile stopAllActions];
                [[OALSimpleAudio sharedInstance] playBg:@"" loop:NO];
            }

        }

//    if (_lives <= 0) {
//        [projectile removeFromParent];
//        [projectile stopAllActions];
//        [[OALSimpleAudio sharedInstance] playBg:@"" loop:NO];
//    }
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
