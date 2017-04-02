//
//  ViewController.m
//  snake
//
//  Created by lzx on 17/3/29.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ViewController.h"
#import "GamaPool.h"

@interface ViewController () {
    NSMutableArray<NSValue *> *_topTenPoint;
}

@property(nonatomic, weak) GamaPool *gamePool;

@property(nonatomic, weak) Snake *snake;

@property(nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIButton *btn;
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

#pragma mark --------------Button

- (IBAction)cancelClick {
    if ([self.btn.titleLabel.text isEqualToString:@"begin"]) {
        [self begin];
        [self.btn setTitle:@"cancel" forState:UIControlStateNormal];
        self.btn.hidden = YES;
    } else {
        [self cancel];
        [self.btn setTitle:@"begin" forState:UIControlStateNormal];
        self.btn.hidden = NO;
    }
}

- (void)begin{
    __weak typeof(self) weakself = self;
    //修复快速点击btn的bug, _timer在invalidate未完成时, 便执行新的一轮_timer赋值. 导致内存泄露
    if (!_timer.valid) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:GAME_CONFIG.timeInterval target:weakself selector:@selector(startGame) userInfo:nil repeats:YES];
        [_timer fire];
    }
}

- (void)cancel{
    [_timer invalidate];
    _timer = nil;
    [self.snake restart];
    [self.gamePool setNeedsDisplay];
}

#pragma mark --------------Initialize

- (void)initUI{
    Snake *snake = [Snake create];
    self.snake = snake;
    GamaPool *pool = [[GamaPool alloc] initWithSnake:self.snake];
    pool.backgroundColor = [UIColor whiteColor];
    pool.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20);
    [GAME_CONFIG makeReframe:pool];
    [self.view addSubview:pool];
    self.gamePool = pool;
    [self.view bringSubviewToFront:self.btn];
}

- (void)startGame{
    [self.snake moveWithCompleteHandle:^(ZXPoint *headPoint) {
        if ([self isKnock:headPoint]) {//撞墙
            [self cancelClick];
            [self alertMessage:@"撞墙了=.="];
        } else {
            [self.gamePool setNeedsDisplay];
        }
    }];
}

- (void)addGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:pan];
}

#pragma mark --------------operation

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

- (void)changeDirection{
    self.snake.direction = [self evaluateDirecton];
//    [self testDirection:[self evaluateDirecton]];
}

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

- (void)alertMessage:(NSString *)message{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"🐍" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
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
