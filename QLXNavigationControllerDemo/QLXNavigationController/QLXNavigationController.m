//
//  QLXNavigationController.m
//
//
//  Created by 邱良雄 on 15/8/26.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXNavigationController.h"
@interface QLXNavigationController ()

@property(nonatomic , weak) QLXNavigationController * rootNavigationContrller;

@end


@implementation QLXNavigationController


#pragma mark - private



-(instancetype)initWithOriginRootViewController:(UIViewController *)rootViewController rootNavigationContrller:(QLXNavigationController *)navigationController{
    self.rootNavigationContrller = navigationController;
    return [super initWithRootViewController:rootViewController];
}

#pragma mark - overriding

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.rootNavigationContrller) {
        if (!self.viewControllers.count) {
            [super pushViewController:viewController animated:animated];
        }else {
            [self.rootNavigationContrller pushViewController:viewController animated:animated];
        }
    }else {
        if (self.viewControllers.count > 0) {// 配置默认返回按钮
            [self configDefaultLeftBarItemWithViewContrller:viewController];
        }
        [super pushViewController:[self wrapNavigationControlerWithViewController:viewController] animated:animated];
    }
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.rootNavigationContrller) {
        return [self.rootNavigationContrller popViewControllerAnimated:animated];
    }else {
        return [super popViewControllerAnimated:animated];
    }
}

-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.rootNavigationContrller) {
        return [self.rootNavigationContrller popToViewController:viewController animated:animated];
    }else {
        UIViewController * wrapViewContrller = viewController.navigationController.parentViewController;
        if ([wrapViewContrller.navigationController.parentViewController isMemberOfClass:[UIViewController class]]) {
            wrapViewContrller = wrapViewContrller.navigationController.parentViewController;
        }
        if (![self.viewControllers containsObject:wrapViewContrller]) {
            return nil;
        }
        if ([wrapViewContrller isMemberOfClass:[UIViewController class]]) {
            return [super popToViewController:wrapViewContrller animated:animated];
        }else {
            return [super popToViewController:viewController animated:animated];
        }
        
    }
}

-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    if (self.rootNavigationContrller) {
        return [self.rootNavigationContrller popToRootViewControllerAnimated:animated];
    }else {
        return [super popToRootViewControllerAnimated:animated];
    }
}

-(NSArray<UIViewController *> *)viewControllers{
    if (self.rootNavigationContrller) {
        if ([super viewControllers].count) {
            NSArray * controllers = self.rootNavigationContrller.viewControllers;
            NSMutableArray * viewControllers = [[NSMutableArray alloc] initWithCapacity:controllers.count];
            for (UIViewController * contrller in controllers) {
                UIViewController * originContrller = [self debagNavigationControlerWithViewController:contrller];
                if (originContrller) {
                    [viewControllers addObject:originContrller];
                }
            }
            return viewControllers;
        }
        
    }
    return [super viewControllers];
}

-(id<UINavigationControllerDelegate>)delegate{
    if (self.rootNavigationContrller) {
        return self.rootNavigationContrller.delegate;
    }else {
        return [super delegate];
    }
}

-(void)setDelegate:(id<UINavigationControllerDelegate>)delegate{
    if (self.rootNavigationContrller) {
        [self.rootNavigationContrller setDelegate:delegate];
    }else {
        [super setDelegate:delegate];
    }
}

-(UIViewController *)visibleViewController{
    if (self.rootNavigationContrller) {
        if ([super viewControllers].count){
            UIViewController * visibleViewController = self.rootNavigationContrller.visibleViewController;
            return [self debagNavigationControlerWithViewController:visibleViewController];
        }
        
    }
    return  [super visibleViewController];
}
//
-(UIViewController *)topViewController{
    if (self.rootNavigationContrller) {
        if ([super viewControllers].count) {
            UIViewController * topViewController = self.rootNavigationContrller.topViewController;
            return [self debagNavigationControlerWithViewController:topViewController];
        }
        
    }
    return  [super topViewController];
}

-(UIGestureRecognizer *)interactivePopGestureRecognizer{
    if (self.rootNavigationContrller) {
        return self.rootNavigationContrller.interactivePopGestureRecognizer;
    }
    return [super interactivePopGestureRecognizer];
}

-(BOOL)isToolbarHidden{
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

-(UIToolbar *)toolbar{
    if (self.rootNavigationContrller) {
        return self.rootNavigationContrller.toolbar;
    }
    return [super toolbar];
}


-(void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
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


-(void)viewWillLayoutSubviews{
    if (!self.rootNavigationContrller) {
        if (self.navigationBar.hidden == false) {
            self.navigationBar.hidden = true;
        }
    }
    [super viewWillLayoutSubviews];
}

/**
 *  配置默认返回按钮
 */
-(void) configDefaultLeftBarItemWithViewContrller:(UIViewController *)viewContrlller{
    UIViewController * rootViewController = viewContrlller;
    if ([viewContrlller isKindOfClass:[UINavigationController class]]) {
        rootViewController = [(UINavigationController *)viewContrlller viewControllers].firstObject;
        if ([rootViewController isMemberOfClass:[UIViewController class]]) {
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
-(void) onLeftBarItemClick:(id)sender{
    [self popViewControllerAnimated:true];
}

/**
 * 包裹一个导航栏控制器
 */

-(UIViewController *)wrapNavigationControlerWithViewController:(UIViewController *)viewControlller{
    if ([viewControlller isMemberOfClass:[UIViewController class]]) {// 已经嵌套过了
        return viewControlller;
    }
    UIViewController * wrapViewController = [UIViewController new];
    QLXNavigationController * navigationController ;
    if ([viewControlller isKindOfClass:[QLXNavigationController class]]) {
        UIViewController * wrapViewController = ((QLXNavigationController *)viewControlller).topViewController;
        [wrapViewController removeFromParentViewController];
        [wrapViewController.view removeFromSuperview];
        QLXNavigationController * wrapNavigationCotroller = (QLXNavigationController *)wrapViewController.childViewControllers.firstObject;
        if ([wrapNavigationCotroller isKindOfClass:[QLXNavigationController class]] ) {
            wrapNavigationCotroller.rootNavigationContrller = self;
        }
        return wrapViewController;
    }else {
        navigationController = [[[self class] alloc] initWithOriginRootViewController:viewControlller rootNavigationContrller:self];
    }
    [wrapViewController.view addSubview:navigationController.view];
    [wrapViewController addChildViewController:navigationController];
    return wrapViewController;
}

/**
 *  解包一个被包裹的控制器
 */
-(UIViewController *)debagNavigationControlerWithViewController:(UIViewController *)viewControlller{
    if ([viewControlller isMemberOfClass:[UIViewController class]]) {
        UINavigationController * navigationContrller = (UINavigationController *)[viewControlller childViewControllers].firstObject;
        if ([navigationContrller isKindOfClass:[UINavigationController class]]) {
            UIViewController * originController = navigationContrller.childViewControllers.firstObject;
            if ([originController isMemberOfClass:[UIViewController class]]) {
                originController = [self debagNavigationControlerWithViewController:originController];
            }
            return originController;
        }
    }else {
        return viewControlller;
    }
    return nil;
}



@end
