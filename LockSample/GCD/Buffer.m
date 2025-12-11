//
//  Buffer.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "Buffer.h"

@implementation Buffer{
    NSMutableArray *_items;
    dispatch_semaphore_t _itemSemaphore;//控制是否有数据可消费
    dispatch_semaphore_t _accessSemaphore;  //保护_items 数组的访问
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
        _itemSemaphore = dispatch_semaphore_create(0);  //初始无数据
        _accessSemaphore = dispatch_semaphore_create(1);    //互斥访问
    }
    return self;
}

- (void)produce:(id)item {
    if(!item) return;
    //保护 _items的访问
    dispatch_semaphore_wait(_accessSemaphore, DISPATCH_TIME_FOREVER);
    @try {
        [_items addObject:item];
    } @catch (NSException *exception) {
        NSLog(@"Error 生产出错 :exception: %@",exception.description);
    } @finally {
        dispatch_semaphore_signal(_accessSemaphore);
    }
    
    //通知消费者有新数据
    dispatch_semaphore_signal(_itemSemaphore);
}

- (id)consume {
    //等待有数据可消费
    dispatch_semaphore_wait(_itemSemaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_semaphore_wait(_accessSemaphore, DISPATCH_TIME_FOREVER);
    id item = nil;
    @try {
        if(_items.count > 0) {
            item = [_items firstObject];
            [_items removeObjectAtIndex:0];
            NSLog(@"消费: %@, 剩余库存: %lu", item , (unsigned long)_items.count);
        }
    } @catch (NSException *exception) {
        NSLog(@"Error 消费出错 :exception: %@",exception.description);
    } @finally {
        dispatch_semaphore_signal(_accessSemaphore);
    }
    return item;
}

- (BOOL)isEmpty {
    dispatch_semaphore_wait(_accessSemaphore, DISPATCH_TIME_FOREVER);
    BOOL empty = _items.count == 0;
    dispatch_semaphore_signal(_accessSemaphore);
    return empty;
}

- (void)testProducerConsumer {
    Buffer<NSString *> *buffer = [[Buffer alloc] init];
    
    //生产者
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i = 1; i <= 5; i++) {
            NSString *item = [NSString stringWithFormat:@"产品%d", i];
            [buffer produce:item];
            [NSThread sleepForTimeInterval:0.3];    //生产间隔0.3s
        }
    });
    
    //消费者1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 3; i++) {
            id item = [buffer consume];
            if(item) {
                NSLog(@"消费者1消费：%@", item);
            }
            [NSThread sleepForTimeInterval:0.5];
        }
    });
    
    //消费者2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 3; i++) {
            id item = [buffer consume];
            if(item) {
                NSLog(@"消费者2消费：%@", item);
            }
            [NSThread sleepForTimeInterval:0.2];
        }
    });
}

@end
