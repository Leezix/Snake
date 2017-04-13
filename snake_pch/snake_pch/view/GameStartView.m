//
//  GameStartView.m
//  snake_pch
//
//  Created by lzx on 17/4/12.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "GameStartView.h"
#import <ZXUIKit/ZXUIKit.h>

@interface GameStartView () {
    NSArray <ZXButton *> *_buttons;
}

@end

@implementation GameStartView

+ (instancetype)shareInstance {
    static GameStartView *startView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        startView = [GameStartView new];
    });
    return startView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //init sub view
        ZXButton *startBtn = [[ZXButton alloc] initWithTitle:@"Start"
                                          attribute:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}
                                              color:[UIColor lightGrayColor]
                                               type:ZXButtonType_Normal];
        ZXButton *configBtn = [[ZXButton alloc] initWithTitle:@"Config"
                                           attribute:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}
                                               color:[UIColor lightGrayColor]
                                                type:ZXButtonType_Normal];
        ZXButton *pauseBtn = [[ZXButton alloc] initWithTitle:@"Pause"
                                          attribute:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}
                                              color:[UIColor lightGrayColor]
                                               type:ZXButtonType_Normal];
        [self addSubview: startBtn];
        [self addSubview: pauseBtn];
        [self addSubview: configBtn];
        _buttons = @[startBtn, pauseBtn, configBtn];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    NSLog(@"%s", __FUNCTION__);
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    CGFloat width = self.zx_width - 2 * GAMESTARTVIEW_MARGIN;
//    CGFloat height = self.zx_height - (_buttons.count + 1) * GAMESTARTVIEW_MARGIN / _buttons.count;
    [_buttons enumerateObjectsUsingBlock:^(ZXButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZXButton *nextBtn = nil;
        ZXButton *lastBtn = nil;
        BOOL islast = idx == _buttons.count - 1;
        BOOL isFirst = idx == 0;
        !islast ? nextBtn = _buttons[idx + 1] : nil;
        !isFirst ? lastBtn = _buttons[idx - 1] : nil;
       [obj mas_makeConstraints:^(MASConstraintMaker *make) {
           isFirst ? make.topMargin.mas_equalTo(GAMESTARTVIEW_MARGIN)
                   : make.top.equalTo(lastBtn.mas_bottom).offset(GAMESTARTVIEW_MARGIN);
           make.leftMargin.mas_equalTo(GAMESTARTVIEW_MARGIN);
           make.rightMargin.mas_equalTo(-GAMESTARTVIEW_MARGIN);
           !islast ? make.height.equalTo(nextBtn.mas_height) : make.bottomMargin.mas_equalTo(-GAMESTARTVIEW_MARGIN);
       }];
    }];
    
}

@end
