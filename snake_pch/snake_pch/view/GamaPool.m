//
//  GamaPool.m
//  snake
//
//  Created by lzx on 17/3/30.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "GamaPool.h"
#import "HMObjcSugar.h"
@interface GamaPool ()

@end

@implementation GamaPool

- (instancetype)initWithSnake:(Snake *)snake{
    self = [super init];
    if (self) {
        self.snake = snake;
    }
    return self;
}

- (BOOL)isKnockPoint:(ZXPoint *)point {
    return point.x >= GAME_CONFIG.horizontalCount || point.x < 0 || point.y >= GAME_CONFIG.verticalCount || point.y < 0;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    //画边框
    [[UIColor blackColor] set];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    path.lineWidth = 1;
    path.lineJoinStyle = kCGLineJoinBevel;
    [path stroke];
    
    //画🐍
    [self drawSnake];
    //画🍎
    [self drawFruit];
}

- (void)drawSnake{
    for (ZXPoint *point in self.snake.bodys) {
        CGFloat x = point.x * GAME_CONFIG.unitLength;
        CGFloat y = point.y * GAME_CONFIG.unitLength;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, GAME_CONFIG.unitLength, GAME_CONFIG.unitLength)];
        [path fill];
        
    }
}

- (void)drawFruit{
    CGFloat x = _snake.fruit.x * GAME_CONFIG.unitLength;
    CGFloat y = _snake.fruit.y * GAME_CONFIG.unitLength;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, GAME_CONFIG.unitLength, GAME_CONFIG.unitLength)];
    [path fill];
}

- (void)setSnake:(Snake *)snake{
    _snake = snake.mutableCopy;
    [self setNeedsDisplay];
}

@end
