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
    _topScores = [[NSMutableArray alloc] init];
    [self loadTopScores];
    return self;
}

- (void) reportScore:(int64_t)score userName: (NSString *)userName scoreDate: (NSDate *)scoreDate
{
    LeaderBoardScore *lbScore = [[LeaderBoardScore alloc]init];
    lbScore.score = score;
    lbScore.scoreDate = scoreDate;
    lbScore.userName = userName;
    
    [_topScores addObject:lbScore];
    
    [self saveToFile];
    
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

- (void)saveToFile
{
    static NSString* filePath = nil;
    static NSString* userNamePath = nil;
    static NSString* scorePath = nil;
    static NSString* scoreDatePath = nil;

    if (!filePath) {
        userNamePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
         stringByAppendingPathComponent:@"username"];
        scorePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
         stringByAppendingPathComponent:@"score"];
        scoreDatePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
         stringByAppendingPathComponent:@"scoredate"];
    }
    
    NSMutableArray *userNames = [[NSMutableArray alloc]init];
    NSMutableArray *scores = [[NSMutableArray alloc]init];
    NSMutableArray *scoreDates = [[NSMutableArray alloc]init];
    
    for (int i  =0; i< [_topScores count]; i++)
    {
        LeaderBoardScore *currentScore = _topScores[i];
        
        NSNumber *tempNumberScore = [NSNumber numberWithUnsignedLongLong:currentScore.score];
        NSString *scoreString = [tempNumberScore stringValue];
        
        [userNames addObject:currentScore.userName];
        [scores addObject:scoreString];
        [scoreDates addObject:currentScore.scoreDate];
    }
    
    [userNames writeToFile:userNamePath atomically:false];
    [scores writeToFile:scorePath atomically:false];
    [scoreDatePath writeToFile:scoreDatePath atomically:false];
}

-(void)loadTopScores
{
    static NSString* filePath = nil;
    static NSString* userNamePath = nil;
    static NSString* scorePath = nil;
    static NSString* scoreDatePath = nil;
    
    if (!filePath) {
        userNamePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
         stringByAppendingPathComponent:@"username"];
        scorePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
         stringByAppendingPathComponent:@"score"];
        scoreDatePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
         stringByAppendingPathComponent:@"scoredate"];
    }
    
    NSMutableArray *scores = [[NSMutableArray alloc]init];
    NSMutableArray *scoreDates = [[NSMutableArray alloc]init];
    
   
    NSMutableArray *userNames = [[NSMutableArray alloc] initWithContentsOfFile:userNamePath];
    for (int i = 0; i<[userNames count]; i++)
    {
        LeaderBoardScore *lbScore = [[LeaderBoardScore alloc] init];
        lbScore.UserName = userNames[i];
        [_topScores addObject:lbScore];
    }
    
    NSString *test = @"fart";
}



@end
