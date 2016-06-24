//
//  UIColor+TMFUtilityColor.m
//  TMFReorderCollectionCellIniOS7
//
//  Created by MrChens on 16/6/24.
//  Copyright © 2016年 TMFuny. All rights reserved.
//

#import "UIColor+TMFUtilityColor.h"

@implementation UIColor (TMFUtilityColor)
+ (UIColor *)randomColor {
        CGFloat redValue = (arc4random() % 255) / 255.0f;
        CGFloat blueValue = (arc4random() % 255) / 255.0f;
        CGFloat greenValue = (arc4random() % 255) / 255.0f;
    
    return [self colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0f];
}

+ (NSArray *)randomColorsWithCount:(NSInteger)counts {
    const NSInteger numberOfColors = 100;
    
    NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:numberOfColors];
    
    for (NSInteger i = 0; i < numberOfColors; i++)
    {
        CGFloat redValue = (arc4random() % 255) / 255.0f;
        CGFloat blueValue = (arc4random() % 255) / 255.0f;
        CGFloat greenValue = (arc4random() % 255) / 255.0f;
        
        [colorArray addObject:[UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0f]];
    }
    return colorArray;
}
@end
