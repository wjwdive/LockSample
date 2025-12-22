//
//  GCDViewController.m
//  LockSample
//
//  Created by jarvis on 2025/12/21.
//

#import "StackViewNestViewController.h"
#import "Masonry/Masonry.h"

@interface StackViewNestViewController ()
@property (nonatomic, strong) UIStackView *buttonsStackViewVertical;

@property (nonatomic, strong) UIStackView *buttonsStackViewHorizontal;

@property (nonatomic, strong) NSMutableArray *buttonsArray;
@property (nonatomic, strong) NSMutableArray *buttonsTitlesArray;
@property (nonatomic, strong) NSMutableArray *buttonsColorArray;



@end

@implementation StackViewNestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"GCD";
    self.buttonsArray = [NSMutableArray array];
    self.buttonsTitlesArray = [@[@"新房",@"二手房",@"租房", @"合租", @"库房09098",
                                 @"新房",@"二手房", @"租房", @"合租", @"库房09098"] mutableCopy];
    self.buttonsColorArray = [@[
        [UIColor systemRedColor],
        [UIColor systemBlueColor],
        [UIColor systemGrayColor],
        [UIColor systemMintColor],
        [UIColor systemTealColor],
        
        [UIColor systemRedColor],
        [UIColor systemBlueColor],
        [UIColor systemGrayColor],
        [UIColor systemMintColor],
        [UIColor systemTealColor]

    ] mutableCopy];
    
    [self configUI];
    
}

- (void)configUI {
    UIStackView *buttonsStackViewVertical = [[UIStackView alloc] init];
    buttonsStackViewVertical.axis = UILayoutConstraintAxisVertical;
    buttonsStackViewVertical.distribution = UIStackViewDistributionFillProportionally;
    buttonsStackViewVertical.alignment = UIStackViewAlignmentFill;
    buttonsStackViewVertical.spacing = 8;
    buttonsStackViewVertical.translatesAutoresizingMaskIntoConstraints = NO;
    self.buttonsStackViewVertical = buttonsStackViewVertical;
    [self.view addSubview:buttonsStackViewVertical];


    // 2. 设置父StackView的约束（贴紧屏幕边缘，留边距）
    // [self.buttonsStackViewVertical mas_makeConstraints:^(MASConstraintMaker *make) {
    //     make.top.equalTo(self.view.mas_top).offset(20);
    //     make.leading.equalTo(self.view.mas_leading).offset(20);
    //     make.trailing.equalTo(self.view.mas_trailing).offset(-20);
    //     make.height.mas_greaterThanOrEqualTo(40);
    //     make.height.mas_lessThanOrEqualTo(120);
    // }];

    NSInteger maxButtonsPerRow = 3;

    UIStackView *currentButtonsStackViewHorizontal = nil;

    for (int i = 0; i < _buttonsTitlesArray.count; i++) {
        //1. 每maxButtonsPerRow个按钮，创建一个水平StackView
        if (i % maxButtonsPerRow == 0) {
            currentButtonsStackViewHorizontal = [[UIStackView alloc] init];
            currentButtonsStackViewHorizontal.axis = UILayoutConstraintAxisHorizontal;
            currentButtonsStackViewHorizontal.spacing = 8; // 按钮间距
            currentButtonsStackViewHorizontal.distribution = UIStackViewDistributionFillEqually; // 关键：按钮宽度自适应内容
            currentButtonsStackViewHorizontal.alignment = UIStackViewAlignmentCenter; // 垂直居中对齐
            currentButtonsStackViewHorizontal.translatesAutoresizingMaskIntoConstraints = NO;
            [self.buttonsStackViewVertical addArrangedSubview:currentButtonsStackViewHorizontal];
        }

        //  2. 创建按钮 并配置
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:_buttonsTitlesArray[i] forState:UIControlStateNormal];
        button.backgroundColor = _buttonsColorArray[i];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [button sizeToFit];
        button.layer.cornerRadius = 8;
        button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        button.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 16);

        //3. 关键：调整优先级 , 保证按钮根据文字缩放
        [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        
        //添加阴影效果
        button.layer.shadowColor = [UIColor grayColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(0, 2);
        button.layer.shadowOpacity = 0.3;
        button.layer.shadowRadius = 3;
        
        //4.设置id，绑定事件
        button.tag = i;
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //5.添加 按钮到行stackView
        [_buttonsArray addObject:button];
        [currentButtonsStackViewHorizontal addArrangedSubview:button];
    }
    
    
    [self.buttonsStackViewVertical mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.width.equalTo(self.view).multipliedBy(0.9);
        make.centerX.equalTo(self.view);
        make.height.mas_lessThanOrEqualTo(120);
    }];
   
    
    
}

#pragma makr -- event --
- (void)buttonTapped:(UIButton *)sender {
    NSLog(@"点击： %@ ", [sender titleForState:UIControlStateNormal]);
    //动画
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            sender.transform = CGAffineTransformIdentity;
        }];
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
