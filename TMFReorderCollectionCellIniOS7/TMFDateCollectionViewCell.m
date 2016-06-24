//
//  TMFDateCollectionViewCell.m
//  TMFReorderCollectionCellIniOS7
//
//  Created by MrChens on 16/6/23.
//  Copyright © 2016年 TMFuny. All rights reserved.
//

#import "TMFDateCollectionViewCell.h"
#import "UIColor+TMFUtilityColor.h"

@implementation TMFDateCollectionViewCell
#pragma mark - ViewLifeCycle
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

#pragma mark - UIInit
- (void)commonInit {
    self.dateLabel = [[UILabel alloc] init];
    _dateLabel.layer.cornerRadius = 3;
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.backgroundColor = UIColorFromHex(0xeeeeee);
    _dateLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.dateLabel];
    [self addConstraintToDateLabel];
}
#pragma mark - UIConfig
#pragma mark - UIUpdate

#pragma mark - AppleDataSource and Delegate
#pragma mark - ThirdPartyDataSource and Delegate
#pragma mark - CustomDataSource and Delegate
#pragma mark - Target-Action Event
#pragma mark - PublicMethod
#pragma mark - PrivateMethod
- (void)addConstraintToDateLabel {
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.dateLabel
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.dateLabel
                                                                  attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1
                                                                           constant:0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.dateLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.dateLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    
    [self addConstraints:@[leadingConstraint, trailingConstraint, topConstraint, bottomConstraint]];
}
@end
