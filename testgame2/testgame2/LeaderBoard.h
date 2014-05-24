//
//  LeaderBoard.h
//  testgame2
//
//  Created by john plank on 5/21/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import "CCScene.h"
#import "IntroScene.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface LeaderBoard : CCScene
{
    CCLabelTTF * label1;
    CCLabelTTF * label2;
    CCLabelTTF * label3;
    NSString *name;
    int64_t _score2;
}

@property (nonatomic, assign) int64_t _score2;

+ (LeaderBoard *)scene;
- (id)init;

@end
