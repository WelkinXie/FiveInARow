//
//  ViewController.m
//  ZgChess
//
//  Created by 谢伟健 on 15-2-15.
//  Copyright (c) 2015年 wk. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "AppDelegate.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SKView *skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    AppDelegate *appDelegate = [AppDelegate appdelegate];
    appDelegate.scene = [MyScene sceneWithSize:skView.bounds.size];
    appDelegate.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:appDelegate.scene];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
