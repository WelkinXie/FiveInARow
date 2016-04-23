//
//  AppDelegate.h
//  ZgChess
//
//  Created by 谢伟健 on 15-2-15.
//  Copyright (c) 2015年 wk. All rights reserved.
//
//  Github: https://github.com/WelkinXie/FiveInARow
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@class MyScene;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyScene *scene;

+ (AppDelegate*)appdelegate;

@end
