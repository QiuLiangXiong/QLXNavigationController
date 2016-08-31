//
//  AViewController.m
//  QLXNavigationControllerDemo
//
//  Created by QLX on 16/8/31.
//  Copyright © 2016年 QLX. All rights reserved.
//

#import "AViewController.h"
#import "BViewController.h"

@interface AViewController ()

@property(nonatomic , strong)  UIButton * pushBtn;

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"A";
    [self pushBtn];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
}

-(void) onPushBtnClick:(UIButton *)sender{
    [self.navigationController pushViewController:[BViewController new] animated:true];
}

#pragma mark - getter

-(UIButton *)pushBtn{
    if (!_pushBtn) {
        _pushBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_pushBtn setTitle:@"pushBContrller" forState:(UIControlStateNormal)];
        [_pushBtn sizeToFit];
        _pushBtn.center = self.view.center;
        [_pushBtn addTarget:self action:@selector(onPushBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:_pushBtn];
    }
    return _pushBtn;
}

@end
