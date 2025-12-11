//
//  DiscoveryViewController.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "DiscoveryViewController.h"
#import "Masonry.h"
#import "LockSample-Swift.h"//使用swift中的类和方法，导入的头文件时“项目名称+Swift.h”
#import "Buffer.h"//生产者，消费者

@interface DiscoveryViewController ()

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置页面标题
    self.title = @"发现";
    [self sayHelloInSwift];
    
    [[[Buffer alloc] init] testProducerConsumer];
    
    // 设置页面背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加一个简单的标签作为页面内容
    UILabel *label = [[UILabel alloc] init];
    label.text = @"发现内容";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    
    // 使用Masonry进行自动布局
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
}

- (void)sayHelloInSwift {
    Greeting *greeting = [[Greeting alloc] initWithName:@"Jarvis"];
    [greeting greet];
}


@end
