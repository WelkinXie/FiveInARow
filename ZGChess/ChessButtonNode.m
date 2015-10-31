//
//  ChessButtonNode.m
//  ZgChess
//
//  Created by 谢伟健 on 15-2-15.
//  Copyright (c) 2015年 wk. All rights reserved.
//

#import "ChessButtonNode.h"
#import "Header.h"

@implementation ChessButtonNode

- (instancetype)initWithFlag:(NSInteger)flag location:(CGPoint)location {
    if (self = [super init]) {
        if (flag == 1) {
            self = [ChessButtonNode spriteNodeWithImageNamed:BLACKCHESS];
        } else if (flag == 0){
            self = [ChessButtonNode spriteNodeWithImageNamed:WHITECHESS];
        } else {
            NSLog(@"flag error while initializing chessbtnNode");
        }
        self.position = location;
        self.size = CGSizeMake(60, 60);
    }
    return self;
}


@end
