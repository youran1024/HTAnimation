//
//  ViewController.m
//  BubbleAnimation
//
//  Created by Mr.Yang on 15/12/7.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "ViewController.h"
#import "StretchBubble.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    StretchBubble *view = [[StretchBubble alloc] init];
    view.titleLabel.text = @"67";
    [self.view addSubview:view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
