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
#import <CoreMotion/CoreMotion.h>
#import "GameCenterFiles.h"
#import "RWGameData.h"
#import "Acheivement.h"




// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *_sprite;
    CCPhysicsNode *_physicsWorld;
    CMMotionManager *_motionManager;
    Acheivement *_achieve;
    NSString *_userName;
    

    
}



@synthesize plane, ufo1, ufo2;

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

//Sets up background
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
//This is what detects collisions betweeen ufo and bullets
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)triple monsterCollision:(CCNode *)monster projectileCollision:(CCNode *)projectile 
{
    [monster removeFromParentAndCleanup:YES];
    [projectile removeFromParentAndCleanup:YES];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"boom.wav"];

    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"boom.plist"];
    
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"boom.png"];
    [self addChild:spriteSheet];
    
    //this goes through array of images for animation
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
    
    
    //Adds kill score everytime ufo is hit
    _score++;
    
    //[scorelabel setString:[NSString stringWithFormat:@"score: %d",_score]];
    [[NSUserDefaults standardUserDefaults] setInteger:_score forKey:@"score_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    //[RWGameData sharedGameData].score2 += 5;
   
        
    
    [_label setString:[NSString stringWithFormat:@"score: %d",_score]];
    
    return YES;
}


// detects collisions between ufo and plane
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)triple monsterCollision:(CCNode *)ufoo planeCollision:(CCNode *)planeHero
{
    [ufoo removeFromParent];
    [[OALSimpleAudio sharedInstance] playEffect:@"boom.wav"];
    
   // _lives = 1;
    
    //checks to see if there is lives left, if not fire game over
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
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)triple smartBombCollision:(CCNode *)smartBomb projectileCollision:(CCNode *)projectile
{
    [smartBomb removeFromParent];
    [[OALSimpleAudio sharedInstance] playEffect:@"boom.wav"];
    
    [smartBomb removeFromParent];
    [projectile removeFromParent];
    
    
    [self destroyAllMonster];
    
    
    return YES;
}

-(void)destroyAllMonster
{
    
    [ufo2 removeFromParentAndCleanup:YES];
    
}

// Adds ufos to the scene
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
//Bonus smart bomb
- (void) addBonus {
    
    self.ufo2 = [CCSprite spriteWithImageNamed:@"bomb.png"];
    
    int minY = self.ufo2.contentSize.width / 2;
    int maxY = self.contentSize.height - self.ufo2.contentSize.height / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    self.ufo2.position = CGPointMake(randomY, self.contentSize.width + self.ufo2.contentSize.width/2);
    //[self addChild:self.ufo2];
    
    int minDuration = 1.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    
    
    
    self.ufo2.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.ufo2.contentSize} cornerRadius:1];
    self.ufo2.physicsBody.collisionGroup = @"monsterGroup";
    self.ufo2.physicsBody.collisionType  = @"smartBombCollision";
    [_physicsWorld addChild:self.ufo2];
    
    
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(randomY, -self.ufo2.contentSize.width/2)];
    CCAction *actionRemove = [CCActionRemove action];
    [self.ufo2 runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
}




// Adds our hero plane to the scene and the physics world
- (id)init
{
    
     if ((self=[super init])) {
         
         _achieve = [[Acheivement alloc] init];
         
         _userName = @"playerOne";
         
         _motionManager = [[CMMotionManager alloc] init];
               
        self.plane = [CCSprite spriteWithImageNamed:@"planeii.png"];
      
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
                 
         //[self schedule:@selector(gameLogic:) interval:1];
         
         
         
         [self schedule:@selector(gameLogic:) interval:2 repeat:30 delay:5];
         [self schedule:@selector(gameLogic2:) interval:1.5 repeat:45 delay:35];
         [self schedule:@selector(gameLogic3:) interval:1 repeat:60 delay:65];
         [self schedule:@selector(gameLogic4:) interval:.03 repeat:3150 delay:95];
         
                 
         [self schedule:@selector(bonusLogic:) interval:8];
         
         
         //Sets up live and score for the game to start with
         
         int savedScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"score_key"];
         
         
         _lives = 0;
         
         
         
         _score              = 0;
         
       
         
         _label              = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", _score]
                                                  fontName:@"Super Mario Bros Alphabet"
                                                  fontSize:30.0f];
         
         
         _label.positionType = CCPositionTypeNormalized;
         _label.color        = [CCColor whiteColor];
         _label.position     = ccp(0.5f, 0.9f);
         
         [self addChild:_label];
         
         //pause button
         CCButton *pause = [CCButton buttonWithTitle:@"pause"];
         [pause setTarget:self selector:@selector(pauseGamePlayScene)];
         pause.positionType = CCPositionTypeNormalized;
         pause.position = ccp(0.5f, 0.10f);
         //[[CCDirector sharedDirector] pause];
         
         [self addChild:pause z:100];
         
         //resume button
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


- (void)update:(CCTime)delta {
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    CGFloat newXPosition = plane.position.x + acceleration.y * 1000 * delta;
    
    newXPosition = clampf(newXPosition, 0, self.contentSize.width);
    plane.position = CGPointMake(newXPosition, plane.position.x);
    
    
    
  }


//restart game method
- (void)restartTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]];
}


//is called when game is over
- (void)endScene:(EndReason)endReason {
    
    if (_gameOver) return;
    _gameOver = true;
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    
    
    int *achievementscore = [_achieve getKillCount:_userName];
    if (achievementscore < 5 && achievementscore + _score >= 5)
    {
        // Display the acheievement logic
        NSString *test = @"poo00000";
    }
    
    if (achievementscore >= 20)
    {
        ///////This is the achievement that increments. In an actual game I would make this like a 1,000, but for testing purposes I made ///it 21
        GameCenterFiles *GCF;
        GCF = [[GameCenterFiles alloc] init];
        [GCF submitAchievement:@"com.johnplank211.testgame2.RB" percentComplete:100];
        NSLog(@"pooooop");
    }
    
    
    [_achieve writeKillCount:_userName currentKills:_score];
    
    NSString *booze;
    
    NSString *message;
    if (endReason == kEndReasonWin) {
        message = @"Winner!!!";
    } else if (endReason == kEndReasonLose) {
        message = @"You lose!";
        
        [[GameCenterFiles sharedInstance]
        reportScore:_score  forCategory:@"com.johnplank211.testgame2.HighScore"];
    }
    
//    LeaderBoardClass *lbClass = [[LeaderBoardClass alloc] init];
//    [lbClass reportScore:_score userName:@"wanker" scoreDate:[NSDate date]];
//
//
//    NSMutableArray *monthScores = [lbClass getTopScores:(@"month")];
//    NSMutableArray *weekScores = [lbClass getTopScores:(@"week")];
//    NSMutableArray *dayScores = [lbClass getTopScores:(@"day")];
    
 
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

    
    //////This is the negative achievement. Basically if u die without killing anyone. This could also be gotten with
    ///////The measurment achievement Pacifist where u make it 2 levels without killing anyone.
    if ((_lives == 0) && (_score == 0))
    {
        GameCenterFiles *GCF;
        GCF = [[GameCenterFiles alloc] init];
        [GCF submitAchievement:@"com.johnplank211.testgame2.SGATS" percentComplete:100];
        NSLog(@"I'm a loser");
    }
    
    }





-(void)gameLogic:(CCTime)dt
{
       [self addMonster];
}

-(void)gameLogic2:(CCTime)dt
{
    if (_lives == 0)
    {
        ////This is the achievement for completion. Making it pass the first wave. 
        GameCenterFiles *GCF;
        GCF = [[GameCenterFiles alloc] init];
        [GCF submitAchievement:@"com.johnplank211.testgame2.PassFirstWave" percentComplete:100];
        [self addMonster];
        
    }
    
    
    if (![_achieve checkCompletionAcheivement:_userName])
    {
        [_achieve writeCompletionAcheivement:_userName];
        // Add logic to alert user that they acheived
    }
}

-(void)gameLogic3:(CCTime)dt
{
    if (_lives == 0)
    {
        [self addMonster];
    }
    
    if (_score == 0)
    {
        /////achievement is gotten if player makes it without die or killing anyone
        GameCenterFiles *GCF;
        GCF = [[GameCenterFiles alloc] init];
        [GCF submitAchievement:@"com.johnplank211.testgame2.pacifist" percentComplete:100];
        [self addMonster];
    }


}

-(void)gameLogic4:(CCTime)dt
{
    if (_lives == 0)
    {
        [self addMonster];
    }

}

-(void)bonusLogic:(CCTime)dt
{
    if (_lives == 0)
    {
        [self addBonus];
    }

}

//checks for touches on the plane and fire projectiles
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //CGPoint touchLocation = [touch locationInNode:self];
 
    int     targetX   = 1000 + 0;
    int     targetY   = 0 + self.plane.position.y;
    CGPoint targetPosition = ccp(targetX,targetY);
    
 
    //float distance = powf(self.plane.position.x - touchLocation.x, 2) + powf(self.plane.position.y - touchLocation.y, 2);
    
//        distance = sqrtf(distance);
//    
//        if (distance <= 55) && (_lives = 0)
//        {
            CCSprite *projectile = [CCSprite spriteWithImageNamed:@"bullet.png"];
            projectile.position = self.plane.position;
    
            if (_lives <= 0)
            {
    
            [_physicsWorld addChild:projectile];
                
            } else {
                
            }
            
            projectile.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:projectile.contentSize.width/2.0f andCenter:projectile.anchorPointInPoints];
            
            
            projectile.physicsBody.collisionGroup = @"playerGroup";
            projectile.physicsBody.collisionType  = @"projectileCollision";
            
            
            //[self.plane runAction:[CCActionRotateBy actionWithDuration:2.0 angle:360]];
            [[OALSimpleAudio sharedInstance] playBg:@"gunfire.wav" loop:NO];
            
            CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
            CCActionRemove *actionRemove = [CCActionRemove action];
            [projectile runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
            
            
            if (_lives <= -1) {
                [projectile removeFromParent];
                [projectile stopAllActions];
                [[OALSimpleAudio sharedInstance] playBg:@"" loop:NO];
            }

        //}

}


// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------




- (void)onEnter
{
    [super onEnter];
    plane.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [_motionManager startAccelerometerUpdates];
}

- (void)onExit
{
    [super onExit];
    [_motionManager stopAccelerometerUpdates];
}







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
