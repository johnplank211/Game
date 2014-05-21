//
//  GameHelp.h
//  testgame2
//
//  Created by john plank on 5/20/14.
//  Copyright (c) 2014 john plank. All rights reserved.
//

#import <GameKit/GameKit.h>

@protocol GameHelpProtocol<NSObject>
@end


@interface GameHelp : NSObject

@property (nonatomic, assign)
id<GameHelpProtocol> delegate;


@property (nonatomic, readonly) NSError* lastError;

+ (id) sharedGameKitHelper;

// Player authentication

-(void) authenticateLocalPlayer;

@end
