//
//  GameStartView.h
//  snake_pch
//
//  Created by lzx on 17/4/12.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GAMESTARTVIEW_MARGIN 10

typedef void (^BtnClickHandle)(UIButton *btn);

@class GameStartView;

@protocol GameStartViewDelegate <NSObject>

@required
- (void)startView:(GameStartView *)view ClickHandle:(NSInteger)idx;

@end

@interface GameStartView : UIView

@property(nonatomic, weak) id<GameStartViewDelegate> delegate;

- (instancetype)initWithBtnTitles:(NSArray<NSString *> *)btnTitles;

- (void)show;
- (void)hide;

@end
