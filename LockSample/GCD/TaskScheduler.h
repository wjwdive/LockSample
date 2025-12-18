//
//  TaskScheduler.h
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

/**
 使用信号量 控制任务的依赖/同步
 任务A先执行，任务B依赖任务A执行完成，任务C依赖任务B执行完成。
 用一个信号量初始化为0，
 开始执行任务A,任务A执行完成发送signal信号；
 异步提交任务B,开始执行任务B之前，先对信号量wait操作。然后执行B的具体任务代码。B任务执行完成之后，对信号量signal操作。
 同样，异步提交任务C，开始执行任务C之前，先对信号量wait操作。然后执行任务C的具体代码。任务C执行完成之后，对信号量signal操作。
  
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskScheduler : NSObject
- (void)executeTasksWithDependencies;
- (void)executeTasksWithDependenciesSync;
@end

NS_ASSUME_NONNULL_END
