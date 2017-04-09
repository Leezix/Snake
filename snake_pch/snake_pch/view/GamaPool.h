//
//  GamaPool.h
//  snake
//
//  Created by lzx on 17/3/30.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Snake.h"
@interface GamaPool : UIView

@property(nonatomic, copy) Snake *snake;

- (BOOL)isKnockPoint:(ZXPoint *)point;

- (instancetype)initWithSnake:(Snake *)snake;

@end
