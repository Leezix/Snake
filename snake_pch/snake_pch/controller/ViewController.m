//
//  ViewController.m
//  snake
//
//  Created by lzx on 17/3/29.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ViewController.h"
#import "GamaPool.h"

@interface ViewController ()

@property(nonatomic, weak) GamaPool *gamePool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GamaPool *pool = [[GamaPool alloc] initWithSnake:[Snake create]];
    pool.backgroundColor = [UIColor whiteColor];
    pool.center = self.view.center;
    [self.view addSubview:pool];
    self.gamePool = pool;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
