//
//  LeaderBoard.m
//  testgame2
//
//  Created by john plank on 5/21/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import "LeaderBoard.h"
#import "HelloWorldScene.h"
#import "IntroScene.h"

#import "CreditScene.h"
#import "Instructions.h"
#import "GameCenterFiles.h"
#import "RWGameData.h"

@implementation LeaderBoard

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    
    LeaderBoard *layer = [LeaderBoard node];
    
    // CGSize windowSize = [[CCDirector sharedDirector] ];
    
   CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];    
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
        
               
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        name = [defaults objectForKey:@"name_key"];
        

        
        label1              = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", name]
                                                fontName:@"Super Mario Bros Alphabet"
                                                fontSize:30.0f];
        
        
        label1.positionType = CCPositionTypeNormalized;
        label1.color        = [CCColor whiteColor];
        label1.position     = ccp(0.5f, 0.35f);
        
        [self addChild:label1];
        
        
        ////////////////////////////
        int savedScoreN = [[NSUserDefaults standardUserDefaults] integerForKey:@"score_key"];
        
        label2              = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", savedScoreN]
                                                 fontName:@"Super Mario Bros Alphabet"
                                                 fontSize:30.0f];
        
        label2.positionType = CCPositionTypeNormalized;
        label2.color        = [CCColor whiteColor];
        label2.position     = ccp(0.5f, 0.30f);
        
        [self addChild:label2];
        
//        label3              = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Your High Score"]
//                                                 fontName:@"Super Mario Bros Alphabet"
//                                                 fontSize:30.0f];
//        
//        label3.positionType = CCPositionTypeNormalized;
//        label3.color        = [CCColor whiteColor];
//        label3.position     = ccp(0.5f, 0.50f);
        
 //       [self addChild:label3];
        /////////////////////////////////
        
        ////////////////////////////
        
        
        
        [[NSUserDefaults standardUserDefaults] setInteger:savedScoreN forKey:@"high_score_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //////////////////////////////
        
        int savedScoreA = [[NSUserDefaults standardUserDefaults] integerForKey:@"high_score_key"];
        
//        label3              = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", savedScoreA]
//                                                 fontName:@"Super Mario Bros Alphabet"
//                                                 fontSize:30.0f];
//        
//        label3.positionType = CCPositionTypeNormalized;
//        label3.color        = [CCColor whiteColor];
//        label3.position     = ccp(0.5f, 0.25f);
//        
//        [self addChild:label3];
        
        label3              = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Your High Score"]
                                                 fontName:@"Super Mario Bros Alphabet"
                                                 fontSize:30.0f];
        
        label3.positionType = CCPositionTypeNormalized;
        label3.color        = [CCColor whiteColor];
        label3.position     = ccp(0.5f, 0.50f);
        
        
        
        if (savedScoreA > savedScoreN)
        {
            [self addChild:label3];

        } else if (savedScoreA < savedScoreN)
        {
            [self addChild:label2];
        }
        
        
        
        [self addChild:label3];
        /////////////////////////////////

        
        [[GameCenterFiles sharedInstance] showGameCenter];
        
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
