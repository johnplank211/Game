//
//  RWGameData.h
//  testgame2
//
//  Created by john plank on 5/22/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWGameData : NSObject <NSCoding>
{
    int highScore;
}

@property (assign, nonatomic) long score2;
@property (assign, nonatomic) long highScore;
@property (assign, nonatomic) long username;
@property (assign, nonatomic) long date;


+(instancetype)sharedGameData;
-(void)reset;
-(void)save;

@end
