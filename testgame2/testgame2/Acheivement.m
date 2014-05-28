//
//  Acheivement.m
//  testgame2
//
//  Created by Brandon Danner on 5/27/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import "Acheivement.h"

NSMutableDictionary *_PassFirstWave = nil;
NSMutableDictionary *_KillCount = nil;

@implementation Acheivement


-(id) init{
    self = [super init];
    NSString *firstWaveFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"PassFirstWave"];
    NSString *killCountFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"KillCount"];
    _PassFirstWave = [[NSMutableDictionary alloc] initWithContentsOfFile:firstWaveFilePath];
    _KillCount = [[NSMutableDictionary alloc] initWithContentsOfFile:killCountFilePath];
    if (!_PassFirstWave)
    {
        _PassFirstWave = [[NSMutableDictionary alloc] init];
    }
    if (!_KillCount)
    {
        _KillCount = [[NSMutableDictionary alloc] init];
    }
    
    
    return self;
}

-(Boolean)checkCompletionAcheivement: (NSString *)userName
{
    Boolean returnVal = [_PassFirstWave valueForKey:userName];
    return returnVal;
}

-(void)writeCompletionAcheivement: (NSString *)userName
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"PassFirstWave"];
    if (![_PassFirstWave valueForKey:userName])
    {
        [_PassFirstWave setObject:@"true" forKey:userName];
    }
    [_PassFirstWave writeToFile:filePath atomically:YES];
}

-(void)writeKillCount:(NSString *)userName currentKills:(int)curKills;
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"KillCount"];
    
    int savedKills = [self getKillCount:userName];
    int totalKills = savedKills + curKills;

    [_KillCount setObject:[NSNumber numberWithInt:totalKills] forKey:userName];
    [_KillCount writeToFile:filePath atomically:YES];
}

-(int)getKillCount:(NSString *)userName
{
    int *savedKills = [[_KillCount valueForKey:(userName)] intValue];
    return savedKills;
}



@end
