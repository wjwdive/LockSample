//
//  TaskScheduler.h
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

/**
 使用信号量 控制任务的依赖/同步
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskScheduler : NSObject
- (void)executeTasksWithDependencies;
@end

NS_ASSUME_NONNULL_END
