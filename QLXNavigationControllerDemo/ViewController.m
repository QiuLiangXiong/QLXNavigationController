//
//  ViewController.m
//  QLXNavigationControllerDemo
//
//  Created by QLX on 16/8/31.
//  Copyright © 2016年 QLX. All rights reserved.
//

#import "ViewController.h"
#import "QLXNavigationController.h"
#import "AViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)onStart:(id)sender {
    QLXNavigationController * navigationContrller = [[QLXNavigationController alloc] initWithRootViewController:[AViewController new]];
    [self presentViewController:navigationContrller animated:true completion:nil];
}


@end
