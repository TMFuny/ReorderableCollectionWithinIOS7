//
//  TMFCollectionViewSectionHeader.m
//  TMFReorderCollectionCellIniOS7
//
//  Created by MrChens on 16/6/27.
//  Copyright © 2016年 TMFuny. All rights reserved.
//

#import "TMFCollectionViewSectionHeader.h"
#import "UIColor+TMFUtilityColor.h"

@implementation TMFCollectionViewSectionHeader

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.backgroundColor = UIColorFromHex(0xeeeeee);
    _titleLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.titleLabel];
    [self addConstraintToTitleLabel];
}
#pragma mark - ViewLifeCycle
#pragma mark - UIInit
#pragma mark - UIConfig
#pragma mark - UIUpdate
#pragma mark - AppleDataSource and Delegate
#pragma mark - ThirdPartyDataSource and Delegate
#pragma mark - CustomDataSource and Delegate
#pragma mark - Target-Action Event
#pragma mark - PublicMethod
#pragma mark - PrivateMethod
- (void)addConstraintToTitleLabel {
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1
                                                                           constant:0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    
    [self addConstraints:@[leadingConstraint, trailingConstraint, topConstraint, bottomConstraint]];
}

@end
