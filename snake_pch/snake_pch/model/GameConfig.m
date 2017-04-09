//
//  GameConfig.m
//  snake
//
//  Created by lzx on 17/3/30.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "GameConfig.h"

@interface GameConfig()

@end

static GameConfig *config = nil;

@implementation GameConfig

+ (instancetype)shareInstance{
    if (!config) {
        config = [[GameConfig alloc] init];
        [config initSelf];
        
    }
    return config;
}

- (void)initSelf{
    self.horizontalCount = 50;
    self.timeInterval = .1;
    _unitLength = SCREEN_WIDTH / self.horizontalCount;
}

- (void)makeReframe:(UIView *)view{
    CGFloat height = view.hm_height;
    self.verticalCount = height / _unitLength;
    view.hm_height = self.verticalCount * _unitLength;
}

@end
