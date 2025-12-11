//
//  MaxThreadDowloadManager.h
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaxThreadDowloadManager : NSObject
@property (nonatomic, assign) NSInteger maxConcurrentDownloads;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

- (void)downloadFiles:(NSArray<NSURL *> *)urls;

@end

NS_ASSUME_NONNULL_END
