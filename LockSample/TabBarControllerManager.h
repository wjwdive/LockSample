//
//  TabBarControllerManager.h
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabBarControllerManager : NSObject

/**
 * 创建并配置TabBarController
 * @return 配置好的UITabBarController实例
 */
+ (UITabBarController *)createAndConfigureTabBarController;

@end

NS_ASSUME_NONNULL_END