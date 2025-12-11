//
//  ThreadSafeDictionary.h
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

/**
 实现一个线程安全的字典
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThreadSafeDictionary : NSObject
@property (nonatomic, strong) NSMutableDictionary *storage;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
