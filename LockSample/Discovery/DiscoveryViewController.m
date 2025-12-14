//
//  DiscoveryViewController.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "DiscoveryViewController.h"
#import "AnimationViewController.h"
#import "CAAnimationViewController.h"
#import "Masonry.h"
#import "LockSample-Swift.h"//使用swift中的类和方法，导入的头文件时“项目名称+Swift.h”
#import "Buffer.h"//生产者，消费者

@interface DiscoveryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置页面标题
    self.title = @"发现";
    
    // 设置页面背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化数据源
    [self setupDataSource];
    
    // 创建并配置UITableView
    [self setupTableView];
}

- (void)setupDataSource {
    // 初始化数据源，包含5条动画数据
    self.dataSource = @[
        @{@"title": @"动画1", @"subtitle": @"动画1描述"},
        @{@"title": @"动画2", @"subtitle": @"动画2描述"},
        @{@"title": @"动画3", @"subtitle": @"动画3描述"},
        @{@"title": @"动画4", @"subtitle": @"动画4描述"},
        @{@"title": @"动画5", @"subtitle": @"动画5描述"}
    ];
}

- (void)setupTableView {
    // 创建UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // 我们不需要注册cell，因为我们将使用自定义的方式创建带有子标题的cell
    
    // 添加到视图
    [self.view addSubview:self.tableView];
    
    // 设置约束
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 使用带有子标题的cell样式
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    // 获取当前行的数据
    NSDictionary *item = self.dataSource[indexPath.row];
    
    // 设置标题和子标题
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"subtitle"];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    // 设置cell的样式为带有子标题的样式
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)sayHelloInSwift {
    Greeting *greeting = [[Greeting alloc] initWithName:@"Jarvis"];
    [greeting greet];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击第一个cell时跳转到AnimationViewController (SpriteKit实现)
    if (indexPath.row == 0) {
        AnimationViewController *animationVC = [[AnimationViewController alloc] init];
        [self.navigationController pushViewController:animationVC animated:YES];
    }
    // 点击第二个cell时跳转到CAAnimationViewController (CAKeyframeAnimation实现)
    else if (indexPath.row == 1) {
        CAAnimationViewController *caAnimationVC = [[CAAnimationViewController alloc] init];
        [self.navigationController pushViewController:caAnimationVC animated:YES];
    }
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
