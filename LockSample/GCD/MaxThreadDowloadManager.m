//
//  MaxThreadDowloadManager.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "MaxThreadDowloadManager.h"

@implementation MaxThreadDowloadManager

- (instancetype)initWithMaxConcurrentDownloads:(NSInteger)maxCount {
    self = [super init];
    if(self) {
        if(maxCount < 1 || maxCount > 10) {
            maxCount = 6;
        }
        _maxConcurrentDownloads = maxCount;
        _semaphore = dispatch_semaphore_create(maxCount);
    }
    return self;
}

- (void)downloadFileAtURL:(NSURL *)url completion:(void (^)(NSData *data, NSError *error))comoletion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //等待可用下载槽位
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        @try {
            //根据URL下载图片  这里  延迟2秒模拟下载耗时
            [NSThread sleepForTimeInterval:2.0];
            //创建模拟数据
            NSString *content = [NSString stringWithFormat:@"Download from %@", url.absoluteString];
            NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
            if (comoletion) {
                comoletion(data, nil);
            }
        } @catch (NSException *exception) {
            NSLog(@"set object :exception: %@",exception.description);
        } @finally {
            //释放信号量
            dispatch_semaphore_signal(self.semaphore);
            NSLog(@"下载完成并释放信号量 ：%@", url);
        }
    });
    
    
}

- (void)downloadFiles:(NSArray<NSURL *> *)urls {
    dispatch_group_t group = dispatch_group_create();
    
    for(NSURL *url in urls) {
        dispatch_group_enter(group);
        [self downloadFileAtURL:url completion:^(NSData *data, NSError *error) {
            if(error) {
                NSLog(@"下载失败：%@, error: %@", url, error);
            }else {
                //根据实际下载的文件类型 组装数据 如果是image，mp3等音频文件
                //UIImage *image = [UIImage imageWithData:data];
                NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"下载成功 : %@", [content substringToIndex:10]);
            }
            dispatch_group_leave(group);
        }];
    }
    
    //等待所有下载完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"所有文件下载完成");
    });
}
@end


/**
 
 // 使用示例
 DownloadManager *manager = [[DownloadManager alloc] initWithMaxConcurrentDownloads:3];
 [manager downloadFiles:@[
     [NSURL URLWithString:@"https://example.com/file1"],
     [NSURL URLWithString:@"https://example.com/file2"],
     [NSURL URLWithString:@"https://example.com/file3"],
     [NSURL URLWithString:@"https://example.com/file4"],
     [NSURL URLWithString:@"https://example.com/file5"]
 ]];
 */
