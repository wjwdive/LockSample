//
//  AnimationViewController.m
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

#import "AnimationViewController.h"
#import <SpriteKit/SpriteKit.h>

@interface AnimationViewController ()

@property (nonatomic, strong) SKView *skView;
@property (nonatomic, strong) SKScene *currentScene;
@property (nonatomic, strong) SKSpriteNode *animationNode;
@property (nonatomic, strong) NSDictionary *animationData;
@property (nonatomic, strong) UIImage *spriteSheetImage;
@property (nonatomic, strong) NSDictionary *framesData;
@property (nonatomic, strong) NSDictionary *animationGroups;
@property (nonatomic, strong) NSArray *actionTypes;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面标题
    self.title = @"动画示例";
    
    // 设置页面背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建SpriteKit视图
    [self setupSKView];
    
    // 加载动画数据
    if ([self loadAnimationData]) {
        // 按动作类型分组
        [self groupAnimations];
        
        // 创建动画选择UI
        [self createAnimationSelector];
        
        // 默认播放default动画
        [self playAnimationForAction:@"default"];
    }
}

- (void)setupSKView {
    // 创建SKView
    self.skView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 200)];
    self.skView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.skView];
    
    // 启用显示FPS和节点计数
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    
    // 创建场景
    self.currentScene = [[SKScene alloc] initWithSize:self.skView.bounds.size];
    self.currentScene.backgroundColor = [UIColor clearColor];
    [self.skView presentScene:self.currentScene];
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
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"System"];
        label.text = @"Animation files not found";
        label.fontSize = 20;
        label.position = CGPointMake(self.currentScene.size.width / 2, self.currentScene.size.height / 2);
        label.fontColor = [UIColor redColor];
        [self.currentScene addChild:label];
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
    CGFloat buttonWidth = (self.view.bounds.size.width - 80) / 3;
    CGFloat buttonHeight = 40;
    CGFloat startY = self.skView.frame.origin.y + self.skView.frame.size.height + 20;
    
    for (NSInteger i = 0; i < self.actionTypes.count; i++) {
        CGFloat x = 20 + (buttonWidth + 20) * (i % 3);
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
    
    // 停止当前动画
    if (self.animationNode) {
        [self.animationNode removeAllActions];
        [self.animationNode removeFromParent];
        self.animationNode = nil;
    }
    
    // 获取该动作类型的所有帧名称
    NSArray *frameNames = self.animationGroups[actionType];
    if (!frameNames || frameNames.count == 0) {
        NSLog(@"No frames found for action type: %@", actionType);
        
        // 显示错误信息
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"System"];
        label.text = [NSString stringWithFormat:@"No frames for %@", actionType];
        label.fontSize = 20;
        label.position = CGPointMake(self.currentScene.size.width / 2, self.currentScene.size.height / 2);
        label.fontColor = [UIColor redColor];
        [self.currentScene addChild:label];
        return;
    }
    
    // 加载动画帧
    NSMutableArray<SKTexture *> *animationFrames = [NSMutableArray array];
    
    // 解析每一帧
    for (NSString *frameName in frameNames) {
        NSDictionary *frameInfo = self.framesData[frameName];
        if (!frameInfo) continue;
        
        // 从plist中获取帧的位置和大小信息
        NSInteger x = [frameInfo[@"x"] integerValue];
        NSInteger y = [frameInfo[@"y"] integerValue];
        NSInteger width = [frameInfo[@"width"] integerValue];
        NSInteger height = [frameInfo[@"height"] integerValue];
        
        CGRect frameRect = CGRectMake(x, y, width, height);
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.spriteSheetImage.CGImage, frameRect);
        if (imageRef) {
            UIImage *frameImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            SKTexture *texture = [SKTexture textureWithImage:frameImage];
            [animationFrames addObject:texture];
        }
    }
    
    NSLog(@"Found %ld frames for action: %@", (long)animationFrames.count, actionType);
    
    if (animationFrames.count == 0) {
        NSLog(@"Failed to create textures for action: %@", actionType);
        return;
    }
    
    // 创建精灵节点
    self.animationNode = [SKSpriteNode spriteNodeWithTexture:animationFrames.firstObject];
    
    // 设置精灵位置
    self.animationNode.position = CGPointMake(self.currentScene.size.width / 2, self.currentScene.size.height / 2);
    
    // 调整精灵大小
    self.animationNode.scale = 1.0;
    
    // 添加精灵到场景
    [self.currentScene addChild:self.animationNode];
    
    // 创建动画动作
    SKAction *animationAction = [SKAction animateWithTextures:animationFrames timePerFrame:0.15 resize:YES restore:NO];
    SKAction *repeatAction = [SKAction repeatActionForever:animationAction];
    
    // 播放动画
    [self.animationNode runAction:repeatAction];
}

@end
