//
//  GamaPool.m
//  snake
//
//  Created by lzx on 17/3/30.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "GamaPool.h"
#import "HMObjcSugar.h"
@interface GamaPool (){
    /**一个单位的长度*/
    CGFloat _unitLength;
}

@end

@implementation GamaPool

- (instancetype)initWithSnake:(Snake *)snake{
    self = [super init];
    if (self) {
        self.snake = snake;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.hm_width = [UIScreen mainScreen].bounds.size.width;
    self.hm_height = self.hm_width;
    _unitLength = self.hm_width / GAME_CONFIG.horizontalCount;
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
}

- (void)drawSnake{
    for (ZXPoint *point in self.snake.bodys) {
        CGFloat x = point.x * _unitLength;
        CGFloat y = point.y * _unitLength;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, _unitLength, _unitLength)];
        [path fill];
        
    }
}


@end
