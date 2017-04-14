//
//  ViewController.m
//  snake
//
//  Created by lzx on 17/3/29.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ViewController.h"
#import "GamaPool.h"
#import "GameStartView.h"

@interface ViewController () <GameStartViewDelegate>
{
    NSMutableArray<NSValue *> *_topTenPoint;
}

@property(nonatomic, strong) GamaPool *gamePool;

@property(nonatomic, strong) GameStartView *startView;

@property(nonatomic, strong) Snake *snake;

@property(nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

#pragma mark --------------Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _topTenPoint = [[NSMutableArray alloc] initWithCapacity:10];
    [self initUI];
    [self addGesture];
}



#pragma mark --------------Initialize

- (void)initUI{
    /*****createSnake******/
    Snake *snake = [Snake create];
    self.snake = snake;
    GamaPool *pool = [[GamaPool alloc] initWithSnake:self.snake];
    pool.backgroundColor = [UIColor whiteColor];
    pool.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20);
    [GAME_CONFIG makeReframe:pool];
    [self.view addSubview:pool];
    self.gamePool = pool;
    
    /*****gameStartView******/
    self.startView = [[GameStartView alloc] initWithBtnTitles:@[@"Start", @"Pause", @"Config"]];
    self.startView.delegate = self;
    [self.view addSubview:self.startView];
    self.startView.frame = self.view.frame;
}

- (void)addGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
    
}

#pragma mark --------------Gesture

- (void)panAction:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateChanged &&
        _topTenPoint.count >= 10) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded){
        if (_topTenPoint.count < 10) [self changeDirection];
        [_topTenPoint removeAllObjects];
        return;
    }
    
    //install
    CGPoint point = [gesture translationInView:self.view];
    _topTenPoint.count < 10 ? [_topTenPoint addObject:[NSValue valueWithCGPoint:point]] : nil;
    if (_topTenPoint.count == 10) {
        [self changeDirection];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)gesture{
    if (self.startView.hidden) {
        [self pauseGame];
        [self.startView showWithComplete:nil];
    } else {
        [self.startView hideWithComplete:^{
            [self startView];
        }];
    }
}

#pragma mark --------------Game Operation

// 开始游戏
- (void)startGame{
    __weak typeof(self) weakself = self;
    //修复快速点击btn的bug, _timer在invalidate未完成时, 便执行新的一轮_timer赋值. 导致内存泄露
    if (!_timer.valid) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:GAME_CONFIG.timeInterval target:weakself selector:@selector(snakeMove) userInfo:nil repeats:YES];
        [_timer fire];
    }
}

// 蛇移动一格
- (void)snakeMove {
    [self.snake moveWithCompleteHandle:^(Snake *snake, ZXPoint *point, bool hasEatMyself) {
        if (hasEatMyself) {
            [self endGameWithComplete:^{
                [self.startView showWithComplete:nil];
            }];
            [self alertMessage:@"吃到自己了=.="];
        }
        if ([self isKnock:point]) {//撞墙
            [self endGameWithComplete:^{
                [self.startView showWithComplete:nil];
            }];
            [self alertMessage:@"撞墙了=.="];
        } else {
            self.gamePool.snake = snake;
        }
    }];
}

// 结束游戏
- (void)endGameWithComplete:(void (^)())completeHandle {
    [self pauseGame];
    [self.snake restart];
    self.gamePool.snake = self.snake;
    completeHandle? completeHandle():nil;
}

// 暂停
- (void)pauseGame{
    [_timer invalidate];
    _timer = nil;
}

// 改变方向
- (void)changeDirection{
    SnakeDirection verticalDirection = SnakeDirection_Up | SnakeDirection_Down;
    SnakeDirection horizontalDirection = SnakeDirection_Left | SnakeDirection_Right;
    SnakeDirection orderDirection = [self evaluateDirecton];
    if (((self.snake.direction & verticalDirection) && (orderDirection & horizontalDirection)) ||
        ((self.snake.direction & horizontalDirection) && (orderDirection & verticalDirection))) {
        self.snake.direction = orderDirection;
    } else {
        NSLog(@"invalid direction");
    }
}

// 根据_topTenPoint估算方向
- (SnakeDirection)evaluateDirecton{
    CGPoint first = _topTenPoint.firstObject.CGPointValue;
    CGPoint last = _topTenPoint.lastObject.CGPointValue;
    //判断方向
    CGFloat horizontalSpace = first.x - last.x;
    CGFloat verticalSpace = first.y - last.y;
    if (fabs(horizontalSpace) > fabs(verticalSpace)) {
        if (horizontalSpace > 0) {
            return SnakeDirection_Left;
        } else {
            return SnakeDirection_Right;
        }
    } else {
        if (verticalSpace > 0) {
            return SnakeDirection_Up;
        } else {
            return SnakeDirection_Down;
        }
    }
}

- (BOOL)isKnock:(ZXPoint *)point{
    return [self.gamePool isKnockPoint:point];
}

#pragma mark --------------StartView
- (void)clickStart {
    [self.startView hideWithComplete:^{
        [self startGame];
    }];
}

#pragma mark --------------Utils

- (void)alertMessage:(NSString *)message{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"🐍" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark GameStartViewDelegate
- (void)startView:(GameStartView *)view ClickHandle:(NSInteger)idx {
    NSLog(@"%ld", (long)idx);
    switch (idx) {
        case 0: {
            [self clickStart];
            break;
        }
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}

#pragma mark --------------TEST

- (void)testGesture:(UIGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"---begin");
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"---change");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"---ended");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"---Failed");
            break;
        case UIGestureRecognizerStatePossible:
            NSLog(@"---Possible");
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"---Cancelled");
            break;
        default:
            break;
    }
    
}

- (void)testDirection:(SnakeDirection)direction{
    switch (direction) {
        case SnakeDirection_Up:
            NSLog(@"--->up");
            break;
        case SnakeDirection_Right:
            NSLog(@"--->right");
            break;
        case SnakeDirection_Left:
            NSLog(@"--->left");
            break;
        case SnakeDirection_Down:
            NSLog(@"--->down");
            break;
            
        default:
            break;
    }
}

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}

@end
