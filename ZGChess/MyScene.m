//
//  MyScene.m
//  ZgChess
//
//  Created by 谢伟健 on 15-2-15.
//  Copyright (c) 2015年 wk. All rights reserved.
//
//  Github: https://github.com/WelkinXie/FiveInARow
//

#import "MyScene.h"
#import "ChessButtonNode.h"
#import "Header.h"
#import "RestartView.h"

@implementation MyScene

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        SKSpriteNode *chessBoardNode = [SKSpriteNode spriteNodeWithImageNamed:CHESSBOARD];
        chessBoardNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [chessBoardNode setSize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        [self addChild:chessBoardNode];
        
        [self initializeLabel];
        [self initializePointArray];
    }
    return self;
}

- (void)initializeLabel {
    SKSpriteNode *flagNodeWhite = [SKSpriteNode spriteNodeWithImageNamed:WHITECHESS];
    flagNodeWhite.position = CGPointMake(CGRectGetWidth(self.frame) - 70, 70);
    flagNodeWhite.name = WHITECHESS;
    [self addChild:flagNodeWhite];
    
    SKSpriteNode *flagNodeBlack = [SKSpriteNode spriteNodeWithImageNamed:BLACKCHESS];
    flagNodeBlack.position = CGPointMake(70, CGRectGetHeight(self.frame) - 70);
    flagNodeBlack.name = BLACKCHESS;
    [self addChild:flagNodeBlack];
    
    SKLabelNode *pauseNode = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    pauseNode.name = PAUSE;
    pauseNode.text = PAUSE;
    pauseNode.fontSize = 32;
    pauseNode.position = CGPointMake(80, MARGIN_LR);
    [self addChild:pauseNode];
    
    SKLabelNode *whiteRetract = [[SKLabelNode alloc] initWithFontNamed:@"Courier"];
    SKLabelNode *blackRetract = [[SKLabelNode alloc] initWithFontNamed:@"Courier"];
    whiteRetract.fontSize = 32;
    blackRetract.fontSize = 32;
    whiteRetract.position = CGPointMake(70, MARGIN_LR);
    blackRetract.position = CGPointMake(self.frame.size.width - 70, self.frame.size.height - MARGIN_LR);
    blackRetract.zRotation = M_PI;
//    whiteRetract.text = RETRACT;
//    blackRetract.text = RETRACT;
    whiteRetract.name = WHITERETRACT;
    blackRetract.name = BLACKRETRACT;
    [self addChild:whiteRetract];
    [self addChild:blackRetract];
    [_chessArray addObject:whiteRetract];
    [_chessArray addObject:blackRetract];
}

- (void)initializePointArray {
    _flag = 0;
    _finished = NO;
    _showed = NO;
    _whiteReady = NO;
    _blackReady = NO;
    _canRegret = NO;
    
    if (!_pointArray || !_pointFlagArray) {
        _pointArray = [[NSMutableArray alloc] init];
        _pointFlagArray = [[NSMutableArray alloc] init];
        
        CGFloat x = 35;
        CGFloat y = 165;
        
        for (int i=0; i<15; ++i) {
            for (int j=0; j<15; ++j) {
                CGPoint point = CGPointMake(x + 50*i, y + 50*j);
                [_pointArray addObject:[NSValue valueWithCGPoint:point]];
                [_pointFlagArray addObject:@3];
            }
        }
    }
    if (_pointFlagArray.count == 0) {
        for (int i=0; i<15; ++i) {
            for (int j=0; j<15; ++j) {
                [_pointFlagArray addObject:@3];
            }
        }
    }
    if (!_chessArray) {
        _chessArray = [[NSMutableArray alloc] init];
    }
    if (!_lastChessArray) {
        _lastChessArray = [[NSMutableArray alloc] init];
    }
}

- (void)showRestartView {
    if (_showed) {
        return;
    }
    _showed = !_showed;
    RestartView *restart = [RestartView getInstanceWithSize:self.size];
    restart.delegate = self;
    [self addChild:restart];
    //[self runAction:[SKAction fadeInWithDuration:1.0f]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

    if (_finished) {
        for (UITouch *touch in touches) {
            CGPoint point = [touch locationInNode:self];
            NSLog(@"(%f, %f)", point.x, point.y);
            if (point.x < 145 && point.y < 125) {
                SKLabelNode *node = (SKLabelNode*)[self childNodeWithName:WHITEREADY];
                node.text = ALREADY;
                node = (SKLabelNode*)[self childNodeWithName:BLACKREADY];
                node.text = START;
                _whiteReady = YES;
            } else if (point.x > self.view.frame.size.width - 145 && point.y > self.view.frame.size.height - 125) {
                SKLabelNode *node = (SKLabelNode*)[self childNodeWithName:BLACKREADY];
                node.text = ALREADY;
                node = (SKLabelNode*)[self childNodeWithName:WHITEREADY];
                node.text = START;
                _blackReady = YES;
            }
            
        }
        return;
    }
    if (touches.count > 1) {
        if (touches.count == 2) {
            [self showRestartView];
        }
        return;
    }
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInNode:self];
        if (point.x < 145 && point.y < 125) {
            [self showRestartView];
            return;
        }
    }
    
    //悔棋
    UITouch *touch = [touches anyObject];
    SKSpriteNode *touchNode = (SKSpriteNode*)[self nodeAtPoint:[touch locationInNode:self]];
    if (touchNode == [self childNodeWithName:WHITERETRACT] || touchNode == [self childNodeWithName:BLACKRETRACT]) {
        _flag = (_flag + 1) % 2;
        [self removeChildrenInArray:_lastChessArray];
        [_pointFlagArray removeObjectAtIndex:_currentIndex];
        _canRegret = NO;
        return;
    }
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        location = [self checkPoint:location];
        if (location.x == 0 && location.y == 0) {
            return;
        }
        ChessButtonNode *sprite = [[ChessButtonNode alloc] initWithFlag:_flag location:location];
        [self addChild:sprite];
        [_chessArray addObject:sprite];
        [_lastChessArray removeAllObjects];
        [_lastChessArray addObject:sprite];
        
        [self checkOver];
        
        _flag = (_flag + 1) % 2;
        _canRegret = YES;
    }
}

- (void)checkOver {
    if ([self checkStateHoriz:15 vert:0]) {
        return;
    }
    if ([self checkStateHoriz:15 vert:1]) {
        return;
    }
    if ([self checkStateHoriz:1 vert:0]) {
        return;
    }
    [self checkStateHoriz:15 vert:-1];
}

- (BOOL)checkStateHoriz:(NSInteger)horiz vert:(NSInteger)vert {
    NSInteger score = 1;
    for (int i=1; i<5; ++i) {
        if (_currentIndex - horiz*i + i*vert < 0) {
            break;
        }
        if ([_pointFlagArray[_currentIndex - horiz*i + i*vert] integerValue] == _flag) {
            ++score;
        } else {
            break;
        }
    }
    for (int i=1; i<5; ++i) {
        if (_currentIndex + horiz*i - i*vert >= _pointArray.count) {
            break;
        }
        if ([_pointFlagArray[_currentIndex + horiz*i - i*vert] integerValue] == _flag) {
            ++score;
        } else {
            break;
        }
    }
    if (score > 4) {
        [self endGame];
        return YES;
    }
    return NO;
}

- (CGPoint)checkPoint:(CGPoint)location {
    NSMutableDictionary *pointDict = [[NSMutableDictionary alloc] init];
    pointDict[LOCATION] = @0;
    pointDict[DISTANCE] = @10000;
    
    for (NSInteger i=0; i<15*15; ++i) {
        CGPoint arrayPoint = [_pointArray[i] CGPointValue];
        CGFloat distance = [self getDistanceBetweenArrPoint:arrayPoint andTouchedPoint:location];
        
        if (distance < [[pointDict objectForKey:DISTANCE] doubleValue]) {
            [pointDict removeAllObjects];
            pointDict[LOCATION] = @(i);
            pointDict[DISTANCE] = @(distance);
        }
    }

    NSInteger index = [pointDict[LOCATION] integerValue];
    if ([_pointFlagArray[index] integerValue] == 3 && [pointDict[DISTANCE] doubleValue] < 30) {
        location = [_pointArray[index] CGPointValue];
        [_pointFlagArray replaceObjectAtIndex:index withObject:@(_flag)];
        _currentIndex = index;
    } else {
        location = CGPointMake(0, 0);
    }
    
    return location;
}

- (CGFloat)getDistanceBetweenArrPoint:(CGPoint)arrayPoint andTouchedPoint:(CGPoint)touchedPoint {
    return sqrt(pow(arrayPoint.x - touchedPoint.x, 2) + pow(arrayPoint.y- touchedPoint.y, 2));
}

- (void)endGame {
    _finished = !_finished;
    SKLabelNode *whiteLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    SKLabelNode *blackLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    SKLabelNode *whiteReady = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    SKLabelNode *blackReady = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    
    whiteLabel.fontSize = 50;
    blackLabel.fontSize = 50;
    whiteReady.fontSize = 32;
    blackReady.fontSize = 32;
    whiteLabel.position = CGPointMake(self.frame.size.width/2, MARGIN_LR);
    blackLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height-MARGIN_LR);
    whiteReady.position = CGPointMake(80, MARGIN_LR);
    blackReady.position = CGPointMake(self.frame.size.width-80, self.frame.size.height-MARGIN_LR);
    blackLabel.zRotation = M_PI;
    blackReady.zRotation = M_PI;
    
    whiteReady.text = READY;
    blackReady.text = READY;
    
    whiteReady.name = WHITEREADY;
    blackReady.name = BLACKREADY;
    
    if (_flag == 0) {
        whiteLabel.text = WIN;
        blackLabel.text = LOSE;
        whiteLabel.fontColor = [SKColor redColor];
        blackLabel.fontColor = [SKColor greenColor];
    } else if (_flag == 1){
        whiteLabel.text = LOSE;
        blackLabel.text = WIN;
        whiteLabel.fontColor = [SKColor greenColor];
        blackLabel.fontColor = [SKColor redColor];
    } else {
        NSLog(@"_flag error in endGame");
    }
    [self addChild:whiteLabel];
    [self addChild:blackLabel];
    [self addChild:whiteReady];
    [self addChild:blackReady];
    [_chessArray addObject:whiteLabel];
    [_chessArray addObject:blackLabel];
    [_chessArray addObject:whiteReady];
    [_chessArray addObject:blackReady];
}

- (void)changeTurn {
    if (_finished) {
        [self childNodeWithName:PAUSE].hidden = YES;
        return;
    }
    
    [self childNodeWithName:BLACKRETRACT].hidden = YES;
    [self childNodeWithName:WHITERETRACT].hidden = YES;
    [self childNodeWithName:PAUSE].hidden = NO;
    
    if (_flag == 1) {
        [self childNodeWithName:WHITECHESS].hidden = YES;
        [self childNodeWithName:BLACKCHESS].hidden = NO;
        if (_canRegret) {
            [self childNodeWithName:WHITERETRACT].hidden = NO;
        }
    } else if (_flag == 0){
        [self childNodeWithName:WHITECHESS].hidden = NO;
        [self childNodeWithName:BLACKCHESS].hidden = YES;
        if (_canRegret) {
            [self childNodeWithName:BLACKRETRACT].hidden = NO;
        }
    } else {
        NSLog(@"_flag error in changeTurn");
    }
}

- (void)cleanAndRestart {
    [self removeChildrenInArray:_chessArray];
    [_pointFlagArray removeAllObjects];
    [_chessArray removeAllObjects];
    [self initializePointArray];
    _flag = (_flag + 1) % 2;
}

- (void)update:(CFTimeInterval)currentTime {
    if (_whiteReady && _blackReady) {
        [self cleanAndRestart];
        return;
    }
    [self changeTurn];
}

#pragma mark - RestartViewDelegate
- (void)myScene:(MyScene *)myScene didPressButton:(SKSpriteNode *)button {
    if ([button.name isEqualToString:RESTART]) {
        _showed = !_showed;
        [self cleanAndRestart];
    } else if ([button.name isEqualToString:PLAY]) {
        _showed = !_showed;
    }
}

@end
