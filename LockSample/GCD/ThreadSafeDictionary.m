//
//  ThreadSafeDictionary.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "ThreadSafeDictionary.h"

@implementation ThreadSafeDictionary

- (instancetype)init {
    self = [super init];
    if (self) {
        _storage = [NSMutableDictionary dictionary];
        _semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    @try {
        if(object && key) {
            _storage[key] = object;
        }
    }
    @catch (NSException *exception){
        NSLog(@"set object :exception: %@",exception.description);
    }
    @finally {
        dispatch_semaphore_signal(_semaphore);
    }
}

- (id)objectForKey:(NSString *)key {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    @try {
        
    } @catch (NSException *exception) {
        NSLog(@"set object :exception: %@",exception.description);
    } @finally {
        dispatch_semaphore_signal(_semaphore);
    }
    return nil;
}
@end
