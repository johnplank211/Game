//
//  Acheivement.h
//  testgame2
//
//  Created by Brandon Danner on 5/27/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Acheivement : NSObject
-(void)writeCompletionAcheivement: (NSString *)userName;
-(Boolean)checkCompletionAcheivement: (NSString *)userName;
-(int)getKillCount:(NSString *)userName;
-(void)writeKillCount:(NSString *)userName currentKills:(int)curKills;
@end
