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

typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;

double _gameOverTime;
bool _gameOver;


@interface HelloWorldScene : CCScene <CCPhysicsCollisionDelegate>

{
    CCSprite *plane;
    CCSprite *ufo1;
    CCSprite *ufo2;
    NSMutableArray * _ufo2;
    NSMutableArray * _ufo1;
    NSMutableArray * _planeHero;
    NSMutableArray * _plane;
    float _shipPointsPerSecY;
    int _lives;
    double _gameOverTime;
    bool _gameOver;
    int _score;
    CCLabelTTF * _label;
    CCLabelTTF * _label2;
    BOOL bearMoving;
    BOOL paused;
    //double curTime;
    
}


@property (nonatomic, retain) CCSprite *plane;
@property (nonatomic, retain) CCSprite *ufo1;
@property (nonatomic, retain) CCSprite *ufo2;

@property (nonatomic, strong) CCAction *walkAction;
@property (nonatomic, strong) CCAction *moveAction;



// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene;
- (id)init;

-(void)pauseGamePlayScene;
-(void)resumeGamePlayScene;
-(void) animation_monsterCollision:(CCNode *)monster;




// -----------------------------------------------------------------------
@end