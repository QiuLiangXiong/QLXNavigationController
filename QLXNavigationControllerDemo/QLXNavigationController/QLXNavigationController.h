//
//  QLXNavigationController.h
//  用法和 UINavigationController 完全一致 可以当做UINavigationController
//  QLXNavigationController 解决了不同导航栏背景不一致带来的过度效果不佳问题。
//  并且可以push一个导航栏控制器。
//  Created by 邱良雄 on 15/8/26.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLXNavigationController : UINavigationController

/**
 *  qlx_topViewContrller代替 UINavigationController 的 topViewContrller
 */
@property(nonatomic , strong) UIViewController * qlx_topViewContrller;

@end


