//
//  LockSampleViewController.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "LockSampleViewController.h"
#import "Masonry.h"
#import <os/lock.h> // 引入os_unfair_lock头文件
#import <stdlib.h>// 引入rand函数头文件
/**
 iOS10 之后已经弃用了 OSSpinLock自旋锁，自旋锁，性能高，但是会一直让即将要获得锁的现场一直轮训，消耗CPU资源，如果一个长时间执行的任务获取的锁，其他线程就会出现忙等。
 */

@interface LockSampleViewController ()
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *lockButton;
@property (nonatomic, strong) UIButton *unlockButton;

// os_unfair_lock相关属性
@property (nonatomic, assign) os_unfair_lock unfairLock;
@property (nonatomic, strong) UILabel *unfairLockStatusLabel;
@property (nonatomic, strong) UIButton *unfairLockButton;
@property (nonatomic, strong) UIButton *unfairUnlockButton;

@property (nonatomic, assign) NSUInteger ticketCount;

// 余票显示和卖票按钮
@property (nonatomic, strong) UILabel *ticketCountLabel;
@property (nonatomic, strong) UIButton *simulateSaleButton;
@property (nonatomic, strong) UIButton *simulateSaleSafeButton;

@end

@implementation LockSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面标题
    self.title = @"NSLock使用示例";
    self.ticketCount = 20;
 
    // 初始化os_unfair_lock
    self.unfairLock = OS_UNFAIR_LOCK_INIT;
    
    // 设置页面背景色
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化锁
    self.lock = [[NSLock alloc] init];
    
    
    // 创建余票显示label
    self.ticketCountLabel = [[UILabel alloc] init];
    self.ticketCountLabel.text = [NSString stringWithFormat:@"余票：%ld", (unsigned long)self.ticketCount];
    self.ticketCountLabel.textAlignment = NSTextAlignmentCenter;
    self.ticketCountLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    self.ticketCountLabel.textColor = [UIColor systemBlueColor];
    self.ticketCountLabel.backgroundColor = [UIColor whiteColor]; // 设置白色背景，避免数字覆盖产生视觉残留
    self.ticketCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.ticketCountLabel];
    
    // 创建模拟卖票按钮
    self.simulateSaleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.simulateSaleButton setTitle:@"模拟卖票（未加锁）" forState:UIControlStateNormal];
    [self.simulateSaleButton addTarget:self action:@selector(simulateSaleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.simulateSaleButton.backgroundColor = [UIColor systemGreenColor];
    [self.simulateSaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.simulateSaleButton.layer.cornerRadius = 8.0;
    self.simulateSaleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.simulateSaleButton];
    
    // 创建模拟卖票按钮
    self.simulateSaleSafeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.simulateSaleSafeButton setTitle:@"模拟卖票（加锁）" forState:UIControlStateNormal];
    [self.simulateSaleSafeButton addTarget:self action:@selector(simulateSaleSafeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.simulateSaleSafeButton.backgroundColor = [UIColor systemGreenColor];
    [self.simulateSaleSafeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.simulateSaleSafeButton.layer.cornerRadius = 8.0;
    self.simulateSaleSafeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.simulateSaleSafeButton];
    
    // 余票显示和卖票按钮布局
    [self.ticketCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40); // 添加高度约束，确保文本完整显示
    }];
    
    [self.simulateSaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-110);
        make.top.equalTo(self.ticketCountLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(50);
    }];
    
    [self.simulateSaleSafeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(110);
        make.top.equalTo(self.ticketCountLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(50);
    }];
}

//useLock = NO  未加锁 售票
//useLock = YES 加锁 售票
- (void)saleTicketWithLock:(BOOL)useLock {
    if (useLock) {
        os_unfair_lock_lock(&_unfairLock);
    }
//    NSLog(@"current thred:,%@", [NSThread currentThread]);
    if(self.ticketCount > 0) {
        self.ticketCount--;
        NSLog(@"当前窗口:余票 %ld", (unsigned long) self.ticketCount);
        
        // 更新余票显示UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.ticketCountLabel.text = [NSString stringWithFormat:@"余票：%ld", (unsigned long)self.ticketCount];
        });
    }else {
        NSLog(@"当前窗口:当前车票已售罄！");
    }
    
    if (useLock) {
        os_unfair_lock_unlock(&_unfairLock);
    }
}

// 模拟卖票按钮点击事件（未加锁）
- (void)simulateSaleButtonTapped {
    // 重置余票数量
    self.ticketCount = 20;
    self.ticketCountLabel.text = [NSString stringWithFormat:@"余票：%ld", (unsigned long)self.ticketCount];
    
    dispatch_queue_t queue = dispatch_queue_create("com.wjw.ticketConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0 ; i < 11; i++) {
        // 生成0~1秒的随机延迟时间
        NSTimeInterval randomDelay = drand48();
        dispatch_after(randomDelay, queue, ^{
            dispatch_async(queue, ^{
                [self saleTicketWithLock:NO];
            });
        });
    }
    
    dispatch_queue_t queue2 = dispatch_queue_create("com.wjw.ticketConcurrentQueue2", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0 ; i < 11; i++) {
        // 生成0~1秒的随机延迟时间
        NSTimeInterval randomDelay = drand48();
        dispatch_after(randomDelay, queue2, ^{
            dispatch_async(queue2, ^{
                [self saleTicketWithLock:NO];
            });
        });
    }
}


// 模拟卖票按钮点击事件（加锁）
- (void)simulateSaleSafeButtonTapped {
    // 重置余票数量
    self.ticketCount = 20;
    self.ticketCountLabel.text = [NSString stringWithFormat:@"余票：%ld", (unsigned long)self.ticketCount];
    
    dispatch_queue_t queue = dispatch_queue_create("com.wjw.ticketConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0 ; i < 11; i++) {
        // 生成0~1秒的随机延迟时间
        NSTimeInterval randomDelay = drand48();
        dispatch_after(randomDelay, queue, ^{
            dispatch_async(queue, ^{
                [self saleTicketWithLock:YES];
            });
        });
    }
    
    dispatch_queue_t queue2 = dispatch_queue_create("com.wjw.ticketConcurrentQueue2", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0 ; i < 11; i++) {
        // 生成0~1秒的随机延迟时间
        NSTimeInterval randomDelay = drand48();
        dispatch_after(randomDelay, queue2, ^{
            dispatch_async(queue2, ^{
                [self saleTicketWithLock:YES];
            });
        });
    }
}



@end
