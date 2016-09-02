//
//  DViewController.m
//  QLXNavigationControllerDemo
//
//  Created by QLX on 16/8/31.
//  Copyright © 2016年 QLX. All rights reserved.
//

#import "DViewController.h"

@interface DViewController ()

@property(nonatomic , strong)  UIButton * backBtn;

@end

@implementation DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"D";
    self.view.backgroundColor = [UIColor redColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    [self backBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%s",__FUNCTION__);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%s",__FUNCTION__);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%s",__FUNCTION__);
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%s",__FUNCTION__);
}

-(void)onBackBtnClick:(UIButton *)sender{
   NSArray * popedContrllers  = [self.navigationController popToViewController:[self.navigationController.viewControllers firstObject] animated:true];
    NSLog(@"%@",popedContrllers);
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_backBtn setTitle:@"返回到根视图" forState:(UIControlStateNormal)];
        [_backBtn sizeToFit];
        _backBtn.center = self.view.center;
        [_backBtn addTarget:self action:@selector(onBackBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:_backBtn];
    }
    return _backBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
