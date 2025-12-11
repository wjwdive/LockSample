//
//  MessageViewController.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "MessageViewController.h"
#import "Masonry.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置页面标题
    self.title = @"消息";
    // 设置页面背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加一个简单的标签作为页面内容
    UILabel *label = [[UILabel alloc] init];
    label.text = @"消息内容";
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

@end
