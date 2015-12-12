//
//  ViewController.m
//  gooeyView
//
//  Created by Mr.Yang on 15/12/11.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "ViewController.h"
#import "GooeyView.h"

@interface ViewController ()

@property (nonatomic, strong)   GooeyView *gooeyView1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(300, 100, 60, 60);
    [button setTitle:@"Triger" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    GooeyView *view = [[GooeyView alloc] init];
    [self.view addSubview:view];
    
    _gooeyView1 = view;
    
}

- (void)buttonClicked:(UIButton *)button
{

    [_gooeyView1 trigger];
}


@end
