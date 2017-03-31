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
    
    switch (_direction) {
        case SnakeDirection_Up:
            break;
        case SnakeDirection_Left:
            break;
        case SnakeDirection_Right:
            break;
        case SnakeDirection_Down:
            break;
        default:
            break;
    }
}

+ (instancetype)create{
    Snake *snake = [self new];
    snake.bodys = @[ZXPOINT_MAKE(1, 2), ZXPOINT_MAKE(1, 1)
                    ].mutableCopy;
    snake.direction = SnakeDirection_Right;
    return snake;
}

- (NSString *)description{
    NSArray *keys = @[@"body", @"direction"];
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
