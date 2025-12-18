//
//  AppDelegate.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "AppDelegate.h"
#import "TaskScheduler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 * 检测当前运行环境并打印信息
 */
- (void)printCurrentEnvironment {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    // 从Info.plist中读取环境信息（这些信息来自xcconfig文件）
    NSString *environment = infoDict[@"EnvironmentName"];
    NSString *apiBaseURL = infoDict[@"API_BASE_URL"];
    
    // 如果环境名称为空，则使用默认值
    if (!environment) {
        environment = @"未知环境";
    }
    
    // 打印环境信息
    NSLog(@"==========================");
    NSLog(@"当前运行环境: %@", environment);
    NSLog(@"应用名称: %@", [[NSBundle mainBundle] infoDictionary][@"CFBundleName"]);
    NSLog(@"应用版本: %@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]);
    NSLog(@"Bundle ID: %@", bundleID);
    NSLog(@"API基础地址: %@", apiBaseURL);
    NSLog(@"==========================");
    

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 打印当前环境信息
    [self printCurrentEnvironment];
    
    //[[[TaskScheduler alloc] init] executeTasksWithDependencies];
    [[[TaskScheduler alloc] init] executeTasksWithDependenciesSync];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
