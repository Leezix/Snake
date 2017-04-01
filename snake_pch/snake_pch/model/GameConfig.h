//
//  GameConfig.h
//  snake
//
//  Created by lzx on 17/3/30.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GAME_CONFIG [GameConfig shareInstance]
/**
 游戏的相关配置
 */
@interface GameConfig : NSObject

/**水平方向格子数*/
@property(nonatomic, assign) int horizontalCount;
/**垂直方向格子数*/
@property(nonatomic, assign) int verticalCount;
/**垂直方向格子数*/
@property(nonatomic, assign, readonly) CGFloat unitLength;

+ (instancetype)shareInstance;

- (void)makeReframe:(UIView *)view;

@end
