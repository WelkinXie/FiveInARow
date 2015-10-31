//
//  MyScene.h
//  ZgChess
//

//  Copyright (c) 2015年 wk. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RestartView.h"

@interface MyScene : SKScene <RestartViewDelegate>
@property (assign, nonatomic) NSInteger flag;  //0:白, 1:黑
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) BOOL showed;
@property (assign, nonatomic) BOOL finished;
@property (assign, nonatomic) BOOL canRegret;
@property (assign, nonatomic) BOOL whiteReady;
@property (assign, nonatomic) BOOL blackReady;
@property (nonatomic, strong) NSMutableArray *pointArray;
@property (nonatomic, strong) NSMutableArray *pointFlagArray;   //0:白, 1:黑, 2:无
@property (nonatomic, strong) NSMutableArray *chessArray;
@property (nonatomic, strong) NSMutableArray *lastChessArray;

- (void)showRestartView;

@end
