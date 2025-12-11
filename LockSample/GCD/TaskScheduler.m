//
//  TaskScheduler.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "TaskScheduler.h"

@implementation TaskScheduler
- (void)executeTasksWithDependencies {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    //任务链开始
    NSLog(@"开始执行任务链");
    //任务A （后台执行）
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"任务A开始执行");
        [NSThread sleepForTimeInterval:1.0];//模拟耗时操作
        NSLog(@"任务A执行完成");
        //通知任务A执行完成
        dispatch_semaphore_signal(semaphore);
    });
    
    // 任务B（等待任务A完成执行）
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //等待任务A完成
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务B开始执行(依赖任务A)");
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"任务B执行完成");
        
        //可以继续通知其他任务
        dispatch_semaphore_signal(semaphore);
    });
    
    // 任务C（同样等待任务A完成执行）
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //需要重新等待，因为信号量 已经被任务B使用
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务C开始执行(也依赖任务A)");
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"任务C执行完成");
    });
}
@end
