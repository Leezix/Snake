//
//  GameStartView.m
//  snake_pch
//
//  Created by lzx on 17/4/12.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "GameStartView.h"
#import <ZXUIKit/ZXUIKit.h>

#define BTN_ORIGIN_TAG 1000

@interface GameStartView () {
    NSArray <ZXButton *> *_zxbuttons;
    NSArray <NSValue *> *_showLoca;
    UIColor *_themeColor;
    UIFont *_themeFont;
}

@property(nonatomic, strong)NSArray<NSString *> *btnTitles;

@end

@implementation GameStartView

#pragma mark initial

- (instancetype)initWithBtnTitles:(NSArray<NSString *> *)btnTitles {
    self = [super init];
    if (self) {
        _themeColor = [UIColor lightGrayColor];
        _themeFont = [UIFont systemFontOfSize:12];
        self.btnTitles = btnTitles;
    }
    return self;
}

- (void)setBtnTitles:(NSArray<NSString *> *)btnTitles {
    _btnTitles = btnTitles;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *mtArr = [[NSMutableArray alloc] initWithCapacity:btnTitles.count];
    __weak typeof(self) weakself = self;
    [btnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZXButton *btn = [[ZXButton alloc] initWithTitle:obj
                                              attribute:@{NSFontAttributeName: _themeFont}
                                                  color:_themeColor
                                                   type:ZXButtonType_Normal];
        CGFloat width = SCREEN_WIDTH / 2.0;
        CGFloat height = 35;
        btn.zx_height = height;
        btn.zx_width = width;
        [btn addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mtArr addObject:btn];
        [weakself addSubview:btn];
    }];
    _zxbuttons = mtArr.copy;
}

- (void)handleBtnClick:(ZXButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startView:ClickHandle:)]) {
        NSAssert([_zxbuttons containsObject:btn], @"lzx.log----->返回的btn, 不存在?");
        [self.delegate startView:self ClickHandle:[_zxbuttons indexOfObject:btn]];
    }
}

#pragma mark Animate

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.hidden) {
        [self makeSubviewDisappearWithAnimation:NO];
    } else {
        [self makeSubviewAppearWithAnimation:NO];
    }
}

- (void)makeSubviewAppearWithAnimation:(BOOL)animate {
    self.hidden = NO;
    CGPoint center = self.center;
    CGFloat x, y;
    x = center.x - _zxbuttons[0].zx_width / 2.0;
    if (_zxbuttons.count & 1) {
        //单数
        CGFloat count = _zxbuttons.count / 2.0;
        y = center.y - (count * _zxbuttons[0].zx_height + (int)count * GAMESTARTVIEW_MARGIN);
    } else {
        //偶数
        CGFloat count = _zxbuttons.count / 2.0;
        y = center.y - (GAMESTARTVIEW_MARGIN * (0.5 + (int)count - 1) + (int)count * _zxbuttons[0].zx_height);
    }
    __block CGPoint originPoint = CGPointMake(x, y);
    [_zxbuttons enumerateObjectsUsingBlock:^(ZXButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isFirst = idx == 0;
        if (isFirst) {
        } else {
            originPoint.y += (obj.zx_height + GAMESTARTVIEW_MARGIN);
        }
        if (animate) {
            [UIView animateWithDuration:1. animations:^{
                obj.zx_origin = originPoint;
            }];
        } else {
            obj.zx_origin = originPoint;
        }
    }];
}

- (void)makeSubviewDisappearWithAnimation:(BOOL)animate {
    CGPoint center = self.center;
    CGFloat x;
    x = center.x - _zxbuttons[0].zx_width / 2.0;
    __block CGPoint originPoint = CGPointMake(x, SCREEN_HEIGHT);
    [_zxbuttons enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(ZXButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (animate) {
            [UIView animateKeyframesWithDuration:1. delay:(_zxbuttons.count - idx - 1) * .2 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
                obj.zx_origin = originPoint;
            } completion:^(BOOL finish){
                if (idx == 0) {
                    //isFirst
                    self.hidden = YES;
                }
            }];
        } else {
            obj.zx_origin = originPoint;
            if (idx == 0) {
                self.hidden = YES;
            }
        }
        
    }];
    
}


- (void)show {
    [self makeSubviewAppearWithAnimation:YES];
}
- (void)hide {
    [self makeSubviewDisappearWithAnimation:YES];
}

@end
