//
//  ViewController.m
//  snake
//
//  Created by lzx on 17/3/29.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ViewController.h"
#import "GamaPool.h"

@interface ViewController ()<UIGestureRecognizerDelegate> {
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
    } else {
        [self cancel];
        [self.btn setTitle:@"begin" forState:UIControlStateNormal];
    }
}

- (void)begin{
    [self startGame];
}

- (void)cancel{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark --------------Initialize

- (void)initUI{
    Snake *snake = [Snake create];
    self.snake = snake;
    GamaPool *pool = [[GamaPool alloc] initWithSnake:self.snake];
    pool.backgroundColor = [UIColor whiteColor];
    pool.center = self.view.center;
    [self.view addSubview:pool];
    self.gamePool = pool;
}

- (void)startGame{
    __weak typeof(self) wealself = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [wealself.snake move];
        [wealself.gamePool setNeedsDisplay];
    }];
}

- (void)addGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
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
