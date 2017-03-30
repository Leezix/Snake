//
//  ZXPoint.m
//  snake
//
//  Created by lzx on 17/3/30.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ZXPoint.h"

@implementation ZXPoint

+ (instancetype)pointWithCGPoint:(CGPoint)point{
    ZXPoint *zx_point = [self new];
    zx_point.x = (int)point.x;
    zx_point.y = (int)point.y;
    return zx_point;
}

@end
