//
//  RestartView.m
//  ZgChess
//
//  Created by Welkin on 15-2-19.
//  Copyright (c) 2015年 wk. All rights reserved.
//
//  Github: https://github.com/WelkinXie/FiveInARow
//

#import "RestartView.h"
#import "Header.h"

@implementation RestartView

- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size {
    if (self = [super initWithColor:color size:size]) {
        self.userInteractionEnabled = YES;
        SKLabelNode *again = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        again.position = CGPointMake(self.frame.size.width / 3 - 20, self.frame.size.height / 2);
        again.fontSize = 50;
        again.text = RESTART;
        again.name = RESTART;
        [self addChild:again];
        
        SKLabelNode *play = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        play.position = CGPointMake(self.frame.size.width / 3 * 2 + 20, self.frame.size.height / 2);
        play.fontSize = 50;
        play.text = PLAY;
        play.name = PLAY;
        [self addChild:play];
    }
    return self;
}

+ (instancetype)getInstanceWithSize:(CGSize)size {
    RestartView *restart = [RestartView spriteNodeWithColor:rgba(255, 255, 255, 0.3) size:size];
    restart.anchorPoint = CGPointMake(0, 0);
    
    return restart;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKSpriteNode *touchNode = (SKSpriteNode*)[self nodeAtPoint:[touch locationInNode:self]];
    if (touchNode == [self childNodeWithName:RESTART] || touchNode == [self childNodeWithName:PLAY]) {
        [self removeFromParent];
        if ([_delegate respondsToSelector:@selector(myScene:didPressButton:)]) {
            [_delegate myScene:self didPressButton:touchNode];
        }
    }
}

@end
