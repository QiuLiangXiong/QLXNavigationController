//
//  QLXNavigationController.m
//
//
//  Created by 邱良雄 on 15/8/26.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXNavigationController.h"

/**
 *  包装一层所需要的类
 */

@interface QLXWrapViewController : UIViewController
/**
 *  被包裹的主控制器
 */
@property (nonatomic , strong) UIViewController * rootViewController;

@end

@implementation QLXWrapViewController

#pragma mark - overriding

- (BOOL)hidesBottomBarWhenPushed {
    return [self rootViewController].hidesBottomBarWhenPushed;
}

- (UITabBarItem *)tabBarItem {
    return [self rootViewController].tabBarItem;
}

- (NSString *)title {
    return [self rootViewController].title;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return [self rootViewController];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return [self rootViewController];
}

#pragma mark - getter

- (UIViewController *)rootViewController {
    QLXNavigationController *wrapperNavController = self.childViewControllers.firstObject;
    return wrapperNavController.childViewControllers.firstObject;
}

@end




//----------------------------我是类分割线----------------------------



/**
 *  QLXNavigationController
 */

@interface QLXNavigationController ()

/**
 * 包装自己的主导航栏控制器
 */
@property (nonatomic , weak) QLXNavigationController * rootNavigationContrller;

@end


@implementation QLXNavigationController

#pragma mark - overriding 重写

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super init];
    if (self) {
        // 包裹一层带有导航栏控制器的QLXWrapViewController控制器
        self.viewControllers = @[ [self wrapNavigationControlerWithViewController:rootViewController] ];
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.rootNavigationContrller) {
        [self.rootNavigationContrller pushViewController:viewController animated:animated];
    }else {
        if (self.childViewControllers.count > 0) {// 配置默认返回按钮
            [self configDefaultLeftBarItemWithViewContrller:viewController];
        }
        [super pushViewController:[self wrapNavigationControlerWithViewController:viewController] animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.rootNavigationContrller) {
        return [self.rootNavigationContrller popViewControllerAnimated:animated];
    }else {
        UIViewController * popedController = [super popViewControllerAnimated:animated];
        return [self debagNavigationControlerWithViewController:popedController];
    }
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.rootNavigationContrller) {
        return [self.rootNavigationContrller popToViewController:viewController animated:animated];
    }else {
        UIViewController * wrapViewContrller = viewController.navigationController.parentViewController;
        if ([wrapViewContrller isMemberOfClass:[QLXWrapViewController class]]) {
            viewController = wrapViewContrller;
        }
        if (![self.childViewControllers containsObject:viewController]) {
            return nil;
        }
        NSArray * contrllers = [super popToViewController:viewController animated:animated];
        return [self debagNavigationControlerWithViewControllers:contrllers];
    }
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    if (self.rootNavigationContrller) {
        return [self.rootNavigationContrller popToRootViewControllerAnimated:animated];
    }else {
        NSArray * contrllers = [super popToRootViewControllerAnimated:animated];
        return [self debagNavigationControlerWithViewControllers:contrllers];
    }
}

- (NSArray<UIViewController *> *)viewControllers{
    if (self.rootNavigationContrller) {
        return self.rootNavigationContrller.viewControllers;
        
    }
    NSArray * viewContrlllers = [super viewControllers];
    return [self debagNavigationControlerWithViewControllers:viewContrlllers];
}

- (UIViewController *)visibleViewController{
    if (self.rootNavigationContrller) {
        return self.rootNavigationContrller.visibleViewController;
    }
    return  [self debagNavigationControlerWithViewController:[super visibleViewController]];
}


- (id<UINavigationControllerDelegate>)delegate{
    if (self.rootNavigationContrller) {
        return self.rootNavigationContrller.delegate;
    }else {
        return [super delegate];
    }
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate{
    if (self.rootNavigationContrller) {
        [self.rootNavigationContrller setDelegate:delegate];
    }else {
        [super setDelegate:delegate];
    }
}



- (UIGestureRecognizer *)interactivePopGestureRecognizer{
    if (self.rootNavigationContrller) {
        return self.rootNavigationContrller.interactivePopGestureRecognizer;
    }
    return [super interactivePopGestureRecognizer];
}

- (BOOL)isToolbarHidden{
    if (self.rootNavigationContrller) {
        return [self.rootNavigationContrller isToolbarHidden];
    }
    return [super isToolbarHidden];
}

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated{
    if (self.rootNavigationContrller) {
        return [self.rootNavigationContrller setToolbarHidden:hidden animated:animated];
    }
    [super setToolbarHidden:hidden animated:animated];
}

- (UIToolbar *)toolbar{
    if (self.rootNavigationContrller) {
        return self.rootNavigationContrller.toolbar;
    }
    return [super toolbar];
}


- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    if (self.rootNavigationContrller) {
        if ([super viewControllers].count) {
            NSMutableArray * contrllers = [[NSMutableArray alloc] initWithCapacity:viewControllers.count];
            for (UIViewController * contrller in viewControllers) {
                UIViewController * warpContrller = [self wrapNavigationControlerWithViewController:contrller];
                if (warpContrller) {
                    [contrllers addObject:warpContrller];
                }
            }
            [self.rootNavigationContrller setViewControllers:contrllers animated:animated];
        }
    }
    [super setViewControllers:viewControllers animated:animated];
}

/**
 *  预布局时 把主导航栏本身的导航栏隐藏
 */
- (void)viewWillLayoutSubviews{
    if (!self.rootNavigationContrller) {
        if (self.navigationBar.hidden == false) {
            self.navigationBar.hidden = true;
        }
    }
    [super viewWillLayoutSubviews];
}

#pragma mark - private (私用)

/**
 *  配置默认返回按钮
 */
- (void) configDefaultLeftBarItemWithViewContrller:(UIViewController *)viewContrlller{
    UIViewController * rootViewController = viewContrlller;
    if ([viewContrlller isKindOfClass:[UINavigationController class]]) {
        rootViewController = [(UINavigationController *)viewContrlller childViewControllers].firstObject;
        if ([rootViewController isMemberOfClass:[QLXWrapViewController class]]) {
            rootViewController = rootViewController.childViewControllers.firstObject;
            rootViewController = rootViewController.childViewControllers.firstObject;
        }
    }
    if (!rootViewController.navigationItem.leftBarButtonItem) {
        UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(onLeftBarItemClick:)];
        rootViewController.navigationItem.leftBarButtonItem = leftItem;
    }
}

/**
 *  点击返回按钮回调
 */
- (void) onLeftBarItemClick:(id)sender{
    [self popViewControllerAnimated:true];
}

/**
 * 包裹一层带有导航栏控制器的 QLXWrapViewController控制器
 */
- (UIViewController *)wrapNavigationControlerWithViewController:(UIViewController *)viewControlller{
    if ([viewControlller isMemberOfClass:[QLXWrapViewController class]]) {// 已经包过了
        return viewControlller;
    }
    UIViewController * wrapViewController = [QLXWrapViewController new];
    Class navigationControllerClass = [self class];
    if ([viewControlller isKindOfClass:[UINavigationController class]]) {
        assert([viewControlller isKindOfClass:[QLXNavigationController class]]);
        QLXNavigationController * navigationController = ((QLXNavigationController *)viewControlller);
        viewControlller =  [self debagNavigationControlerWithViewController:navigationController.childViewControllers.firstObject];
        navigationControllerClass = [navigationController class];
    }
    
    QLXNavigationController * navigationController = [navigationControllerClass new];
    navigationController.rootNavigationContrller = self;
    navigationController.viewControllers = @[viewControlller];
    
    [wrapViewController.view addSubview:navigationController.view];
    [wrapViewController addChildViewController:navigationController];
    return wrapViewController;
}

/**
 *  解包一个被包裹的控制器
 */
- (UIViewController *)debagNavigationControlerWithViewController:(UIViewController *)viewControlller{
    if ([viewControlller isMemberOfClass:[QLXWrapViewController class]]) {
        QLXWrapViewController * wrapViewContrller = (QLXWrapViewController *)viewControlller;
        return wrapViewContrller.rootViewController;
    }else {
        return viewControlller;
    }
    return nil;
}

/**
 *  解包多个被包裹的控制器
 */
- (NSArray<UIViewController *> *)debagNavigationControlerWithViewControllers:(NSArray<UIViewController *> *)viewControlllers{
    if (viewControlllers.count <= 0) {
        return viewControlllers;
    }
    NSMutableArray * contrllers = [[NSMutableArray alloc] initWithCapacity:viewControlllers.count];
    for (UIViewController * contrller  in viewControlllers) {
        [contrllers addObject:[self debagNavigationControlerWithViewController:contrller]];
    }
    return contrllers;
}


@end
