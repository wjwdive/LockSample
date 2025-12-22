//
//  SearchHistoryCell.m
//  LockSample
//
//  Created by jarvis on 2025/12/22.
//

#import "SearchHistoryCell.h"

@interface SearchHistoryCell ()

@property (nonatomic, strong) UIButton *historyButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation SearchHistoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 创建历史记录按钮
    _historyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _historyButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    _historyButton.layer.cornerRadius = 8;
    _historyButton.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 16);
    
    // 设置文本显示模式，避免截断
    _historyButton.titleLabel.numberOfLines = 1;
    _historyButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _historyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_historyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.contentView addSubview:_historyButton];
    
    // 创建删除按钮
    _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteButton.backgroundColor = [UIColor redColor];
    _deleteButton.tintColor = [UIColor whiteColor];
    [_deleteButton setTitle:@"×" forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    _deleteButton.layer.cornerRadius = 12;
    _deleteButton.clipsToBounds = YES;
    
    // 设置可访问性属性
    _deleteButton.accessibilityLabel = @"删除";
    _deleteButton.accessibilityHint = @"删除此搜索历史";
    _deleteButton.isAccessibilityElement = YES;
    
    // 添加删除按钮点击事件
    [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_deleteButton];
    
    // 布局约束
    _historyButton.translatesAutoresizingMaskIntoConstraints = NO;
    _deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // 历史记录按钮约束
        [_historyButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [_historyButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [_historyButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [_historyButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        
        // 删除按钮约束
        [_deleteButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:-8],
        [_deleteButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:8],
        [_deleteButton.widthAnchor constraintEqualToConstant:24],
        [_deleteButton.heightAnchor constraintEqualToConstant:24]
    ]];
}

- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    [_historyButton setTitle:keyword forState:UIControlStateNormal];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    // 更新选中的视觉效果
    if (isSelected) {
        _historyButton.backgroundColor = [UIColor colorWithRed:0.7 green:0.9 blue:1.0 alpha:1.0];
        _historyButton.layer.borderColor = [UIColor blueColor].CGColor;
        _historyButton.layer.borderWidth = 1;
    } else {
        _historyButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        _historyButton.layer.borderColor = [UIColor clearColor].CGColor;
        _historyButton.layer.borderWidth = 0;
    }
    
    // 显示/隐藏删除按钮
    [UIView animateWithDuration:0.2 animations:^{        
        _deleteButton.alpha = isSelected ? 1.0 : 0.0;
    }];
}

// 删除按钮点击事件
- (void)deleteButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(searchHistoryCellDidTapDeleteButton:)]) {
        [self.delegate searchHistoryCellDidTapDeleteButton:self];
    }
}

@end
