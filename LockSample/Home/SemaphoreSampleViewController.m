//
//  SemaphoreSampleViewController.m
//  LockSample
//
//  Created by on 2024/7/20.
//

#import "SemaphoreSampleViewController.h"
#import "Masonry.h"

@interface SemaphoreSampleViewController ()
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@end

@implementation SemaphoreSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置控制器标题
    self.title = @"信号量示例";
    
    // 设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建按钮
    [self createButtons];
    
    // 布局按钮
    [self layoutButtons];
}

- (void)createButtons {
    // 按钮1
    self.button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button1 setTitle:@"信号量基础" forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button1.backgroundColor = [UIColor systemBlueColor];
    [self.button1.layer setCornerRadius:8.0];
    self.button1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button1 addTarget:self action:@selector(semaphoreBasicButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button1];
    
    // 按钮2
    self.button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button2 setTitle:@"信号量控制" forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button2.backgroundColor = [UIColor systemGreenColor];
    [self.button2.layer setCornerRadius:8.0];
    self.button2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button2 addTarget:self action:@selector(semaphoreControlButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button2];
    
    // 按钮3
    self.button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button3 setTitle:@"信号量同步" forState:UIControlStateNormal];
    [self.button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button3.backgroundColor = [UIColor systemYellowColor];
    [self.button3.layer setCornerRadius:8.0];
    self.button3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button3 addTarget:self action:@selector(semaphoreSyncButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button3];
    
    // 按钮4
    self.button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button4 setTitle:@"信号量并发" forState:UIControlStateNormal];
    [self.button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button4.backgroundColor = [UIColor systemPurpleColor];
    [self.button4.layer setCornerRadius:8.0];
    self.button4.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button4 addTarget:self action:@selector(semaphoreConcurrentButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button4];
}

- (void)layoutButtons {
    // 使用Masonry进行竖排布局
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(50);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(50);
    }];
    
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.button1.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(50);
    }];
    
    [self.button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.button2.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(50);
    }];
    
    [self.button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.button3.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - Helper Methods

- (CGFloat)getSafeAreaTopInset {
    CGFloat topInset = 0;
    if (@available(iOS 11.0, *)) {
        topInset = self.view.safeAreaInsets.top;
    }
    return topInset;
}

#pragma mark - Button Actions

- (void)semaphoreBasicButtonTapped {
    // 信号量基础示例
    
    
    
    
}

- (void)semaphoreControlButtonTapped {
    // 信号量控制示例
}

- (void)semaphoreSyncButtonTapped {
    // 信号量同步示例
}

- (void)semaphoreConcurrentButtonTapped {
    // 信号量并发示例
}

@end
