//
//  CAAnimationViewController.m
//  LockSample
//
//  Created by wjw on 2025/12/13.
//

#import "CAAnimationViewController.h"
#import "LockSample-Prefix.pch"

// 创建日志对象
static os_log_t animationLog = NULL;

@interface CAAnimationViewController ()

@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) NSDictionary *animationData;
@property (nonatomic, strong) UIImage *spriteSheetImage;
@property (nonatomic, strong) NSDictionary *framesData;
@property (nonatomic, strong) NSDictionary *animationGroups;
@property (nonatomic, strong) NSArray *actionTypes;

@end

@implementation CAAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化日志对象
    if (!animationLog) {
        animationLog = os_log_create("com.wjw.LockSample.animation", "performance");
    }
    
    // 设置页面标题
    self.title = @"CAKeyframeAnimation 动画";
    
    // 设置页面背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建动画视图
    [self setupAnimationView];
    
    // 加载动画数据
    if ([self loadAnimationData]) {
        // 按动作类型分组
        [self groupAnimations];
        
        // 创建动画选择UI
        [self createAnimationSelector];
        
        // 默认播放第一个动画组
        if (self.actionTypes.count > 0) {
            [self playAnimationForAction:self.actionTypes.firstObject];
        }
    }
}

- (void)setupAnimationView {
    // 创建UIImageView用于显示动画
    // 增大默认尺寸，确保有足够空间显示所有动画帧
    CGFloat defaultWidth = self.view.bounds.size.width * 0.7; // 使用屏幕宽度的70%
    CGFloat defaultHeight = self.view.bounds.size.height * 0.5; // 使用屏幕高度的50%
    self.animationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, defaultWidth, defaultHeight)];
    self.animationView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 3);
    
    // 使用UIViewContentModeScaleAspectFit以保持图像比例
    self.animationView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.animationView];
}

- (BOOL)loadAnimationData {
    // 直接查找资源文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"munvshen/munvshen0" ofType:@"plist"];
    NSString *pngPath = [[NSBundle mainBundle] pathForResource:@"munvshen/munvshen0" ofType:@"png"];
    
    // 如果找不到，尝试直接在根目录查找
    if (!plistPath) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"munvshen0" ofType:@"plist"];
    }
    if (!pngPath) {
        pngPath = [[NSBundle mainBundle] pathForResource:@"munvshen0" ofType:@"png"];
    }
    
    NSLog(@"Plist path: %@", plistPath ? plistPath : @"Not found");
    NSLog(@"PNG path: %@", pngPath ? pngPath : @"Not found");
    
    // 检查文件是否存在
    if (!plistPath || !pngPath) {
        // 显示错误信息
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        label.center = self.animationView.center;
        label.text = @"Animation files not found";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
        [self.view addSubview:label];
        return NO;
    }
    
    // 加载plist文件
    self.animationData = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if (!self.animationData) {
        NSLog(@"Failed to load plist file");
        return NO;
    }
    
    // 获取frames信息
    self.framesData = self.animationData[@"frames"];
    if (!self.framesData) {
        NSLog(@"No frames found in plist");
        return NO;
    }
    
    // 加载精灵表图片
    self.spriteSheetImage = [UIImage imageWithContentsOfFile:pngPath];
    if (!self.spriteSheetImage) {
        NSLog(@"Failed to load sprite sheet image");
        return NO;
    }
    
    return YES;
}

- (void)groupAnimations {
    NSMutableDictionary *groups = [NSMutableDictionary dictionary];
    
    // 获取所有帧名称
    NSArray *frameNames = [self.framesData allKeys];
    
    // 遍历所有帧名称，按动作类型分组
    for (NSString *frameName in frameNames) {
        // 帧名称格式: yagumo_action_1.png
        NSArray *components = [frameName componentsSeparatedByString:@"_"];
        if (components.count >= 3) {
            // 获取动作类型
            NSString *actionType = components[1];
            
            // 添加到对应分组
            NSMutableArray *actionFrames = groups[actionType];
            if (!actionFrames) {
                actionFrames = [NSMutableArray array];
                groups[actionType] = actionFrames;
            }
            [actionFrames addObject:frameName];
        }
    }
    
    // 对每个分组的帧进行排序
    // 创建键的副本，避免在枚举时修改字典
    NSArray *groupKeys = [groups allKeys];
    for (NSString *actionType in groupKeys) {
        NSArray *sortedFrames = [groups[actionType] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        groups[actionType] = sortedFrames;
    }
    
    self.animationGroups = groups;
    self.actionTypes = [[groups allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    NSLog(@"Animation groups: %@", groups);
    NSLog(@"Available action types: %@", self.actionTypes);
}

- (void)createAnimationSelector {
    CGFloat buttonWidth = (self.view.bounds.size.width - 40) / 3;
    CGFloat buttonHeight = 40;
    // 将按钮位置固定在屏幕底部上方，避免与动态调整大小的动画视图重合
    CGFloat startY = self.view.bounds.size.height - 200;
    
    for (NSInteger i = 0; i < self.actionTypes.count; i++) {
        CGFloat x = 20 + (buttonWidth + 10) * (i % 3);
        CGFloat y = startY + (buttonHeight + 10) * (i / 3);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:self.actionTypes[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor lightGrayColor]];
        button.layer.cornerRadius = 5;
        
        [button addTarget:self action:@selector(animationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        [self.view addSubview:button];
    }
}

- (void)animationButtonTapped:(UIButton *)sender {
    if (sender.tag < self.actionTypes.count) {
        NSString *actionType = self.actionTypes[sender.tag];
        [self playAnimationForAction:actionType];
    }
}

- (void)playAnimationForAction:(NSString *)actionType {
    if (!self.animationGroups || !self.spriteSheetImage) {
        NSLog(@"Animation data not loaded");
        return;
    }
    
    // 停止当前动画并清除所有内容，确保没有残影
    [self.animationView stopAnimating];
    self.animationView.image = nil;
    self.animationView.animationImages = nil;
    
    // 清除所有子视图
    [self.animationView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 获取该动作类型的所有帧名称
    NSArray *frameNames = self.animationGroups[actionType];
    if (!frameNames || frameNames.count == 0) {
        NSLog(@"No frames found for action type: %@", actionType);
        
        // 显示错误信息
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
        label.center = CGPointMake(self.animationView.bounds.size.width / 2, self.animationView.bounds.size.height / 2);
        label.text = [NSString stringWithFormat:@"No frames for %@", actionType];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
        [self.animationView addSubview:label];
        return;
    }
    os_signpost_id_t spid = SIGNPOST_BEGIN(animationLog, "主线程绘制", "开始绘制动画，帧数量: %lu", (unsigned long)frameNames.count);
    // 调用旧的主线程绘制方法
    [self playAnimationWithMainThreadDrawing:frameNames];
    SIGNPOST_END(animationLog, spid, "主线程绘制");
    // 如果要使用子线程绘制方法，取消上面的注释并注释掉上面的主线程方法调用
//     [self playAnimationWithBackgroundThreadDrawing:frameNames];
}

// 旧的主线程绘制方法
- (void)playAnimationWithMainThreadDrawing:(NSArray *)frameNames {
    NSLog(@"使用主线程绘制方法");
    
    // 加载动画帧的UIImage对象
    NSMutableArray *keyFrames = [NSMutableArray array];
    
    // 解析每一帧
    for (NSString *frameName in frameNames) {
        NSDictionary *frameInfo = self.framesData[frameName];
        if (!frameInfo) continue;
        
        // 从plist中获取帧的位置和大小信息
        NSInteger x = [frameInfo[@"x"] integerValue];
        NSInteger y = [frameInfo[@"y"] integerValue];
        NSInteger width = [frameInfo[@"width"] integerValue];
        NSInteger height = [frameInfo[@"height"] integerValue];
        
        // 从精灵表中提取帧图片
        CGRect frameRect = CGRectMake(x, y, width, height);
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.spriteSheetImage.CGImage, frameRect);
        if (imageRef) {
            UIImage *frameImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            [keyFrames addObject:frameImage];
        }
    }
    
    NSLog(@"Found %ld frames (主线程)", (long)keyFrames.count);
    
    if (keyFrames.count == 0) {
        NSLog(@"Failed to create textures (主线程)");
        return;
    }
    
    // 保持动画视图的原始大尺寸
    // 设置contentMode为Center，确保所有帧保持原始大小居中显示
    // 这样可以确保不同动画的大小统一，避免缩放不一致的问题
    self.animationView.contentMode = UIViewContentModeCenter;
    
    // 使用更简单的UIImageView动画方式，确保contentMode生效
    self.animationView.animationImages = keyFrames;
    self.animationView.animationDuration = keyFrames.count * 0.15; // 每帧0.15秒
    self.animationView.animationRepeatCount = 0; // 0表示无限循环
    
    // 开始动画
    [self.animationView startAnimating];
}

// 新的子线程绘制方法
- (void)playAnimationWithBackgroundThreadDrawing:(NSArray *)frameNames {
    NSLog(@"使用子线程绘制方法");
    
    // 将帧处理逻辑移到后台线程，避免阻塞主线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{        
        // 加载动画帧的UIImage对象
        NSMutableArray *keyFrames = [NSMutableArray array];
        
        // 解析每一帧
        for (NSString *frameName in frameNames) {
            NSDictionary *frameInfo = self.framesData[frameName];
            if (!frameInfo) continue;
            
            // 从plist中获取帧的位置和大小信息
            NSInteger x = [frameInfo[@"x"] integerValue];
            NSInteger y = [frameInfo[@"y"] integerValue];
            NSInteger width = [frameInfo[@"width"] integerValue];
            NSInteger height = [frameInfo[@"height"] integerValue];
            
            // 从精灵表中提取帧图片
            CGRect frameRect = CGRectMake(x, y, width, height);
            CGImageRef imageRef = CGImageCreateWithImageInRect(self.spriteSheetImage.CGImage, frameRect);
            if (imageRef) {
                UIImage *frameImage = [UIImage imageWithCGImage:imageRef];
                CGImageRelease(imageRef);
                [keyFrames addObject:frameImage];
            }
        }
        
        NSLog(@"Found %ld frames (子线程)", (long)keyFrames.count);
        
        if (keyFrames.count == 0) {
            NSLog(@"Failed to create textures (子线程)");
            return;
        }
        
        // 回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{            
            // 保持动画视图的原始大尺寸
            // 设置contentMode为Center，确保所有帧保持原始大小居中显示
            // 这样可以确保不同动画的大小统一，避免缩放不一致的问题
            self.animationView.contentMode = UIViewContentModeCenter;
            
            // 使用更简单的UIImageView动画方式，确保contentMode生效
            self.animationView.animationImages = keyFrames;
            self.animationView.animationDuration = keyFrames.count * 0.15; // 每帧0.15秒
            self.animationView.animationRepeatCount = 0; // 0表示无限循环
            
            // 开始动画
            [self.animationView startAnimating];
        });
    });
}

@end
