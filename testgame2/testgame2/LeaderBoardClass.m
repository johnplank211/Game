//
//  LeaderBoardClass.m
//  testgame2
//
//  Created by Brandon Danner on 5/22/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import "LeaderBoardClass.h"

@implementation LeaderBoardClass

- (id) init {
    self = [super init];
    LeaderBoardScore *lbScore = [[LeaderBoardScore alloc]init];
    lbScore.score = 0;
    lbScore.userName = @"Not yet filled";
    lbScore.scoreDate = [NSDate date];
    
    _topScores = [NSMutableArray arrayWithObjects:lbScore, lbScore, lbScore, lbScore, nil];
    return self;
}

- (void) reportScore:(int64_t)score userName: (NSString *)userName scoreDate: (NSDate *)scoreDate
{
    LeaderBoardScore *lbScore = [[LeaderBoardScore alloc]init];
    lbScore.score = score;
    lbScore.scoreDate = scoreDate;
    lbScore.userName = userName;
    
    [_topScores addObject:lbScore];
    
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
         stringByAppendingPathComponent:@"topscores"];
    }
    
    [_topScores writeToFile:filePath atomically:false];
    
    NSMutableArray *dailyScores = [self getTopScores:@"day"];
    NSMutableArray *weeklyScores = [self getTopScores:@"week"];
    NSMutableArray *monthScores = [self getTopScores:@"month"];
}

- (void)sortScores
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [_topScores sortedArrayUsingDescriptors:sortDescriptors];
    _topScores = [NSMutableArray arrayWithArray:sortedArray];
}

- (NSMutableArray *)getTopScores: (NSString *)scope
{
    NSMutableArray *scopedTopScores = [[NSMutableArray alloc] init];
    [self sortScores];
    NSDate *cutoffDate = [NSDate date];
    NSDate *today = [NSDate date];

    
    if ([scope isEqualToString:@"week"])
    {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:-7];
        cutoffDate = [gregorian dateByAddingComponents:components toDate:today options:0];
    }
    
    if ([scope isEqualToString:@"day"])
    {
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
        NSDate *todayMidnight = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:today]];
        cutoffDate = todayMidnight;
    }
    
    if ([scope isEqualToString:@"month"])
    {
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit);
        NSDate *thisMonth = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:today]];
        cutoffDate = thisMonth;
    }
    
    int scoreCount = 0;
    for (int i = 0; i< [_topScores count]; i++)
    {
        LeaderBoardScore *currentScore = _topScores[i];
        if (scoreCount < 5 && currentScore.scoreDate >= cutoffDate)
        {
            [scopedTopScores addObject:currentScore];
            scoreCount ++;
        }
    }
    NSString *happy = @"Fart";
    return scopedTopScores;

}



@end
