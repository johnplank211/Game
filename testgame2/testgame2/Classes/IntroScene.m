//
//  IntroScene.m
//  testgame2
//
//  Created by john plank on 4/2/14.
//  Copyright john plank 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "CreditScene.h"
#import "Instructions.h"
#import "GameCenterFiles.h"
#import "LeaderBoard.h"




// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------




+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);

    [[GameCenterFiles sharedInstance] authenticateLocalUser];
     
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Planes Shooting Ufo's" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    // Helloworld scene button
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[ Start ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.35f);
    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:helloWorldButton];
    
    // Credits scene button
    CCButton *creditButton = [CCButton buttonWithTitle:@"[ Credits ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    creditButton.positionType = CCPositionTypeNormalized;
    creditButton.position = ccp(0.5f, 0.30f);
    [creditButton setTarget:self selector:@selector(onCreditClicked:)];
    [self addChild:creditButton];

    // instructions scene button
    CCButton *instructionButton = [CCButton buttonWithTitle:@"[ Instructions ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    instructionButton.positionType = CCPositionTypeNormalized;
    instructionButton.position = ccp(0.5f, 0.25f);
    [instructionButton setTarget:self selector:@selector(onInstructionsClicked:)];
    [self addChild:instructionButton];
    
    // instructions scene button
    CCButton *LocalLeaderBoardButton = [CCButton buttonWithTitle:@"[ LeaderBoards ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    LocalLeaderBoardButton.positionType = CCPositionTypeNormalized;
    LocalLeaderBoardButton.position = ccp(0.5f, 0.20f);
    [LocalLeaderBoardButton setTarget:self selector:@selector(onLeaderBoardClicked:)];
    [self addChild:LocalLeaderBoardButton];
    
    
    //static NSString *const name = @"";
    //name = @"";
    
    
    CCSprite *textSprite = [CCSprite spriteWithImageNamed:@"blanky.png"];
    enterName = [CCTextField textFieldWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"blanky.png"]];
    enterName.fontSize = 16.0f;
    enterName.positionType = CCPositionTypeNormalized;
    enterName.contentSize = CGSizeMake(100.0f, 50.0f);
    enterName.preferredSize = textSprite.contentSize;
    enterName.position = ccp(0.56f, 0.37f);
    //enterName.string = name;
    enterName.scale = 1.0f;
    enterName.color = [CCColor blackColor];
    [self addChild:enterName z:101];
    
    name = @"John is Awesome";
    
    
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    label1              = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Enter name"]
                                             fontName:@"Super Mario Bros Alphabet"
                                             fontSize:30.0f];
    
    
    label1.positionType = CCPositionTypeNormalized;
    label1.color        = [CCColor whiteColor];
    label1.position     = ccp(0.45f, 0.40f);
    
    [self addChild:label1];
    
    
    // done
	return self;
}












// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------


//Starts game
- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}


//Starts credit scene
- (void)onCreditClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[CreditScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}


//Starts Instructions scene
- (void)onInstructionsClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[Instructions scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onLeaderBoardClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[LeaderBoard scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
