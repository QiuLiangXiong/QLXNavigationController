//
//  BViewController.m
//  QLXNavigationControllerDemo
//
//  Created by QLX on 16/8/31.
//  Copyright © 2016年 QLX. All rights reserved.
//

#import "BViewController.h"
#import "CViewController.h"

@interface BViewController ()

@property(nonatomic , strong)  UIButton * pushBtn;

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"B";
    [self pushBtn];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
    
}

-(void) onPushBtnClick:(UIButton *)sender{
    [self.navigationController pushViewController:[CViewController new] animated:true];
}

#pragma mark - getter
-(UIButton *)pushBtn{
    if (!_pushBtn) {
        _pushBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_pushBtn setTitle:@"pushCContrller" forState:(UIControlStateNormal)];
        [_pushBtn sizeToFit];
        _pushBtn.center = self.view.center;
        [_pushBtn addTarget:self action:@selector(onPushBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:_pushBtn];
    }
    return _pushBtn;
}


@end
