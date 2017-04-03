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
    SnakeDirection_Up = 1 << 0,
    SnakeDirection_Left = 1 << 1,
    SnakeDirection_Right = 1 << 2,
    SnakeDirection_Down = 1 << 3,
}SnakeDirection;

@interface Snake : NSObject

@property(nonatomic, strong) NSMutableArray<ZXPoint *> *bodys;

@property(nonatomic, assign) SnakeDirection direction;

@property(nonatomic, assign, readonly) NSUInteger length;

@property(nonatomic, weak) id delegate;

@property(nonatomic, strong, readonly) ZXPoint *fruit;

+ (instancetype)create;

- (void)restart;

- (void)moveWithCompleteHandle:(void (^)(ZXPoint *point, bool hasEatMyself))completeHandle;

- (BOOL)containPoint:(ZXPoint *)point;

- (void)changeFruit;

@end
