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

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone{
    ZXPoint *point = [[self class] allocWithZone:zone];
    point.x = _x;
    point.y = _y;
    return point;
}

@end
