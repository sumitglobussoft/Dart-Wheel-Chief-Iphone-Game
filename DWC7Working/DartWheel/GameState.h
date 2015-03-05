//
//  GameState.h
//  DartWheel
//
//  Created by Sumit Ghosh on 31/05/14.
//
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (nonatomic, assign) int levelNumber;
//@property (nonatomic, assign) int latestScore;
@property (nonatomic, assign) int remLife;
@property (nonatomic, assign) BOOL checkLevelClear;
@property (nonatomic, assign) BOOL checkLife;
@property (nonatomic, strong) NSArray *friendsScoreInfoArray;
@property(nonatomic,assign)int victimId;
+(GameState*)sharedState;
@end
