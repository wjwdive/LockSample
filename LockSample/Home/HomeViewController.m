//
//  HomeViewController.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "HomeViewController.h"
#import "LockSampleViewController.h"
#import "SemaphoreSampleViewController.h"
#import "Masonry.h"

@interface HomeViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面标题
    self.title = @"首页";
    
    // 设置页面背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化数据源
    self.dataSource = @[@{@"title": @"un_fire_lock锁", @"subtitle": @"线程同步锁"},
                        @{@"title": @"信号量", @"subtitle": @"信号量的机制"}
    ];
    
    // 创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    // 设置数据源和代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 设置cell样式为带副标题
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
    
    // 设置分隔线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    // 添加到视图
    [self.view addSubview:self.tableView];
    
    // 使用Masonry进行自动布局
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LockCell";
    
    // 尝试从复用队列获取cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // 如果没有复用的cell，则创建新的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // 设置cell内容
    NSDictionary *item = self.dataSource[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"subtitle"];
    
    // 设置cell选中状态效果
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // 在主线程中更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (indexPath.row) {
            case 0:
            {// 创建锁使用示例界面
                    LockSampleViewController *lockSampleVC = [[LockSampleViewController alloc] init];
                    lockSampleVC.title = @"un_fire_lock使用示例";
                    
                    // 导航到锁使用示例界面
                    [self.navigationController pushViewController:lockSampleVC animated:YES];
            }
                break;
            case 1:
            {// 创建信号量示例界面
                    SemaphoreSampleViewController *semaphoreVC = [[SemaphoreSampleViewController alloc] init];
                    semaphoreVC.title = @"信号量使用示例";
                    
                    // 导航到信号量示例界面
                    [self.navigationController pushViewController:semaphoreVC animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    });
}

@end
