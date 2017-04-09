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

- (void)moveWithCompleteHandle:(void (^)(Snake *snake,ZXPoint *point, bool hasEatMyself))completeHandle {
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
        completeHandle(self, headPoint, YES);
        return;
    }
    [self addNewHead:headPoint];
    //判断是否吃到水果
    if ([headPoint isEqualToPoint:_fruit]) {
        [self changeFruit];
    } else {
        [self removeLast];
    }
    
    completeHandle(self, headPoint, NO);
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
    _bodys = @[ZXPOINT_MAKE(1, 3), ZXPOINT_MAKE(1, 2), ZXPOINT_MAKE(1, 1)
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
    static int count = 0;
    while (1) {
        count++;
        int x = arc4random_uniform(GAME_CONFIG.horizontalCount);
        int y = arc4random_uniform(GAME_CONFIG.verticalCount);
        ZXPoint *newFruit = ZXPOINT_MAKE(x, y);
         if (![self containPoint:newFruit]) {
             _fruit = newFruit;
            break;
        }
    }
    NSLog(@"---------count: %d", count);
}

- (NSString *)description{
    NSArray *keys = @[@"bodys", @"direction"];
    return [NSString stringWithFormat:@"%@\n------%@", [self dictionaryWithValuesForKeys:keys].description, [super description]];
}

#pragma mark Copying
- (id)copyWithZone:(NSZone *)zone{
    Snake *snake = [[Snake allocWithZone:zone] init];
    snake.bodys = self.bodys.copy;
    [snake.bodys enumerateObjectsUsingBlock:^(ZXPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        snake.bodys[idx] = obj.copy;
    }];
    snake.direction = self.direction;
    snake.fruit = self.fruit.copy;
    return snake;
    
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    Snake *snake = [[[self class] allocWithZone:zone] init];
    snake.bodys = self.bodys.mutableCopy;
    [snake.bodys enumerateObjectsUsingBlock:^(ZXPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        snake.bodys[idx] = obj.mutableCopy;
    }];
    snake.direction = self.direction;
    snake.fruit = self.fruit.mutableCopy;
    return snake;
}

#pragma mark private method
- (void)removeLast{
    [self.bodys removeLastObject];
}

- (void)addNewHead:(ZXPoint *)newHead{
    [self.bodys insertObject:newHead atIndex:0];
}

@end
