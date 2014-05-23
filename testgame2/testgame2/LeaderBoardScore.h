//
//  LeaderBoardScore.h
//  testgame2
//
//  Created by Brandon Danner on 5/22/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeaderBoardScore : NSObject
@property (strong, nonatomic) NSDate *scoreDate;
@property (strong, nonatomic) NSString *userName;
@property (nonatomic) int64_t score;
@end
