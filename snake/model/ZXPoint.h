//
//  ZXPoint.h
//  snake
//
//  Created by lzx on 17/3/30.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXPoint : NSObject

@property(nonatomic, assign) int x;
@property(nonatomic, assign) int y;

+ (instancetype)pointWithCGPoint:(CGPoint)point;

@end
