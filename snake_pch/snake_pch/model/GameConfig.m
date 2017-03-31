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
    self.verticalCount = 10;
    self.horizontalCount = 10;
}

@end
