//
//  Snake.m
//  snake
//
//  Created by lzx on 17/3/30.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "Snake.h"

@implementation Snake

- (NSUInteger)length{
    return self.bodys.count;
}

- (void)move{
    ZXPoint *headPoint = [self.bodys.firstObject copy];
    switch (_direction) {
        case SnakeDirection_Up:
            headPoint.y--;
            break;
        case SnakeDirection_Left:
            headPoint.x--;
            break;
        case SnakeDirection_Right:
            headPoint.x++;
            break;
        case SnakeDirection_Down:
            headPoint.y++;
            break;
        default:
            NSAssert(false, @"----->ZX_CRASH: 方向错误");
            break;
    }
    [self removeLast];
    [self addNewHead:headPoint];
}

+ (instancetype)create{
    Snake *snake = [self new];
    snake.bodys = @[ZXPOINT_MAKE(1, 3), ZXPOINT_MAKE(1, 2), ZXPOINT_MAKE(1, 1)
                    ].mutableCopy;
    snake.direction = SnakeDirection_Down;
    return snake;
}

- (NSString *)description{
    NSArray *keys = @[@"body", @"direction"];
    return [self dictionaryWithValuesForKeys:keys].description;
}

#pragma mark private method
- (void)removeLast{
    [self.bodys removeLastObject];
}

- (void)addNewHead:(ZXPoint *)newHead{
    [self.bodys insertObject:newHead atIndex:0];
}

@end
