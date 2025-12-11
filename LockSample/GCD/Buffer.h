//
//  Buffer.h
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

/**
 生产者+消费者问题
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Buffer<T> : NSObject
- (void)produce:(T)item;
- (T)consume;
- (BOOL)isEmpty;

//测试
- (void)testProducerConsumer;

@end

NS_ASSUME_NONNULL_END
