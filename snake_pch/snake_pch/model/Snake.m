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

- (void)moveWithCompleteHandle:(void (^)(ZXPoint *point, bool hasEatMyself))completeHandle {
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
    //判断是否吃到自己
    if ([self containPoint:headPoint]){
        completeHandle(headPoint, YES);
        return;
    }
    [self addNewHead:headPoint];
    //判断是否吃到水果
    if ([headPoint isEqualToPoint:_fruit]) {
        [self changeFruit];
    } else {
        [self removeLast];
    }
    
    completeHandle(headPoint, NO);
}

+ (instancetype)create{
    Snake *snake = [self new];
    return snake;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _bodys = @[ZXPOINT_MAKE(1, 19), ZXPOINT_MAKE(1, 18), ZXPOINT_MAKE(1, 17), ZXPOINT_MAKE(1, 16), ZXPOINT_MAKE(1, 15), ZXPOINT_MAKE(1, 14), ZXPOINT_MAKE(1, 13), ZXPOINT_MAKE(1, 12), ZXPOINT_MAKE(1, 11), ZXPOINT_MAKE(1, 10), ZXPOINT_MAKE(1, 9), ZXPOINT_MAKE(1, 8), ZXPOINT_MAKE(1, 7), ZXPOINT_MAKE(1, 6), ZXPOINT_MAKE(1, 5), ZXPOINT_MAKE(1, 4), ZXPOINT_MAKE(1, 3), ZXPOINT_MAKE(1, 2), ZXPOINT_MAKE(1, 1)
               ].mutableCopy;
    _fruit = ZXPOINT_MAKE(1, 20);
    _direction = SnakeDirection_Down;
}

- (BOOL)containPoint:(ZXPoint *)point {
    for (ZXPoint *body in self.bodys) {
        if ([body isEqualToPoint:point]){
            return YES;
        }
    }
    return NO;
}

- (void)restart{
    [self initialize];
}

- (void)changeFruit {
    while (1) {
        int x = arc4random_uniform(GAME_CONFIG.horizontalCount);
        int y = arc4random_uniform(GAME_CONFIG.verticalCount);
        ZXPoint *newFruit = ZXPOINT_MAKE(x, y);
         if (![self containPoint:newFruit]) {
             _fruit = newFruit;
            break;
        }
    }
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
