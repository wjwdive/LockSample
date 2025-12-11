//
//  TabBarControllerManager.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "TabBarControllerManager.h"
// 导入所有视图控制器头文件
#import "HomeViewController.h"
#import "DiscoveryViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"

@implementation TabBarControllerManager

+ (UITabBarController *)createAndConfigureTabBarController {
    // 创建TabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    // 1. 创建首页导航控制器和视图控制器
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" 
                                                     image:[UIImage systemImageNamed:@"house"] 
                                                           selectedImage:[UIImage systemImageNamed:@"house.fill"]];
    
    // 2. 创建发现导航控制器和视图控制器
    DiscoveryViewController *discoveryVC = [[DiscoveryViewController alloc] init];
    UINavigationController *discoveryNav = [[UINavigationController alloc] initWithRootViewController:discoveryVC];
    discoveryNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" 
                                                           image:[UIImage systemImageNamed:@"magnifyingglass"] 
                                                         selectedImage:[UIImage systemImageNamed:@"magnifyingglass"]];
    
    // 3. 创建消息导航控制器和视图控制器
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageVC];
    messageNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" 
                                                         image:[UIImage systemImageNamed:@"message"] 
                                                       selectedImage:[UIImage systemImageNamed:@"message.fill"]];
    
    // 4. 创建我的导航控制器和视图控制器
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profileVC];
    profileNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" 
                                                         image:[UIImage systemImageNamed:@"person"] 
                                                       selectedImage:[UIImage systemImageNamed:@"person.fill"]];
    
    // 将所有导航控制器添加到TabBarController中
    tabBarController.viewControllers = @[homeNav, discoveryNav, messageNav, profileNav];
    
    // 设置TabBar的外观
    tabBarController.tabBar.tintColor = [UIColor systemBlueColor]; // 选中时的颜色
    tabBarController.tabBar.unselectedItemTintColor = [UIColor grayColor]; // 未选中时的颜色
    
    return tabBarController;
}

@end