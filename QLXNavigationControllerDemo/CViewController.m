//
//  CViewController.m
//  QLXNavigationControllerDemo
//
//  Created by QLX on 16/8/31.
//  Copyright © 2016年 QLX. All rights reserved.
//

#import "CViewController.h"
#import "CViewController.h"
#import "DViewController.h"
#import "QLXNavigationController.h"

@interface CViewController ()

@property(nonatomic , strong)  UIButton * pushBtn;

@end

@implementation CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.title = @"C";
    [self pushBtn];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blueColor]];
    
}

-(void) onPushBtnClick:(UIButton *)sender{
    QLXNavigationController * naVC = [[QLXNavigationController alloc] initWithRootViewController:[DViewController new]];
    [self.navigationController pushViewController:naVC animated:true];
}

#pragma mark - getter
-(UIButton *)pushBtn{
    if (!_pushBtn) {
        _pushBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_pushBtn setTitle:@"push另外一个导航控制器" forState:(UIControlStateNormal)];
        [_pushBtn sizeToFit];
        _pushBtn.center = self.view.center;
        [_pushBtn addTarget:self action:@selector(onPushBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:_pushBtn];
    }
    return _pushBtn;
}



@end
