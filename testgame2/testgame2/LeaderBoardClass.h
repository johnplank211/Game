//
//  LeaderBoardClass.h
//  testgame2
//
//  Created by Brandon Danner on 5/22/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeaderBoardScore.h"

@interface LeaderBoardClass : NSObject

- (void) reportScore:(int64_t)score userName: (NSString *)userName scoreDate: (NSDate *)scoreDate;
- (NSMutableArray *)getTopScores: (NSString *)scope;


@property (strong) NSMutableArray *topScores;

@end
