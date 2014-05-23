//
//  IntroScene.h
//  testgame2
//
//  Created by john plank on 4/2/14.
//  Copyright john plank 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using cocos2d-v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameCenterFiles.h"


// -----------------------------------------------------------------------

/**
 *  The intro scene
 *  Note, that scenes should now be based on CCScene, and not CCLayer, as previous versions
 *  Main usage for CCLayer now, is to make colored backgrounds (rectangles)
 *
 */
@interface IntroScene : CCScene <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate>

{
   
    CCTextField *enterName;
    CCLabelTTF * label1;
    NSString *name;
    
}

    //@property (nonatomic,retain) GameCenterFiles *gameCenterManager;

// -----------------------------------------------------------------------

+ (IntroScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end