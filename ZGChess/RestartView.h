//
//  RestartView.h
//  ZgChess
//
//  Created by Welkin on 15-2-19.
//  Copyright (c) 2015年 wk. All rights reserved.
//
//  Github: https://github.com/WelkinXie/FiveInARow
//

#import <SpriteKit/SpriteKit.h>
@class MyScene;
@class RestartView;

@protocol RestartViewDelegate <NSObject>

- (void)myScene:(RestartView *)myScene didPressButton:(SKSpriteNode *)button;

@end

@interface RestartView : SKSpriteNode

@property (weak, nonatomic) id <RestartViewDelegate> delegate;

+ (instancetype)getInstanceWithSize:(CGSize)size;

@end
