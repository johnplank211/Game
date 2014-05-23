//
//  RWGameData.m
//  testgame2
//
//  Created by john plank on 5/22/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import "RWGameData.h"

@implementation RWGameData



static NSString* const SSGameDataHighScoreKey = @"highScore";
static NSString* const SSGameDataScoreKey = @"score";
static NSString* const SSGameDataNameKey = @"username";
static NSString* const SSGameDataDateKey = @"date";


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.highScore forKey: SSGameDataHighScoreKey];
    [encoder encodeDouble:self.score2 forKey: SSGameDataScoreKey];
    [encoder encodeDouble:self.username forKey: SSGameDataNameKey];
    [encoder encodeDouble:self.date forKey: SSGameDataDateKey];
   
}




+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

-(void)reset
{
    self.score2 = 0;
}


- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        _highScore = [decoder decodeDoubleForKey: SSGameDataHighScoreKey];
        _score2 = [decoder decodeDoubleForKey: SSGameDataScoreKey];
        _username = [decoder decodeDoubleForKey: SSGameDataNameKey];
        _date = [decoder decodeDoubleForKey: SSGameDataDateKey];
            }
    return self;
}



+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
         stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}

+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [RWGameData filePath]];
    if (decodedData) {
        RWGameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[RWGameData alloc] init];
}

-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[RWGameData filePath] atomically:YES];
    
  
}


@end
