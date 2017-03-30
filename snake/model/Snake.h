//
//  Snake.h
//  snake
//
//  Created by lzx on 17/3/30.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXPoint.h"

typedef enum {
    SnakeDirection_Up,
    SnakeDirection_Left,
    SnakeDirection_Right,
    SnakeDirection_Down,
}SnakeDirection;

@interface Snake : NSObject

@property(nonatomic, strong) NSArray<ZXPoint *> *bodys;

@property(nonatomic, assign) SnakeDirection direction;

@property(nonatomic, assign, readonly) NSUInteger length;

- (void)move;

@end
