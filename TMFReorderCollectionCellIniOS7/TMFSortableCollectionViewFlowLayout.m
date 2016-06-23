//
//  TMFSortableCollectionViewFlowLayout.m
//  TMFReorderCollectionCellIniOS7
//
//  Created by MrChens on 16/6/23.
//  Copyright © 2016年 TMFuny. All rights reserved.
//
//https://developer.apple.com/library/ios/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/CreatingCustomLayouts/CreatingCustomLayouts.html#//apple_ref/doc/uid/TP40012334-CH5-SW6
#import "TMFSortableCollectionViewFlowLayout.h"
#import "TMFDateAttributes.h"

#define sItemCell_Width (65)
#define sItemCell_Height (36)

@interface TMFSortableCollectionViewFlowLayout ()

@property (nonatomic, assign) NSInteger maxNumRows;
@property (nullable, nonatomic, strong) NSMutableDictionary *layoutInformation;
@property(nonatomic, assign) UIEdgeInsets insets;
@end

@implementation TMFSortableCollectionViewFlowLayout

#pragma mark - Init
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
}
//this is not required to implement a custom layout but is provided as an opportunity to make initial calculations if necessary.
- (void)prepareLayout {
    NSMutableDictionary *layoutInformation = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numSections; section++) {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < numItems; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            TMFDateAttributes *attributes = [self attributesWithChildrenAtIndexPath:indexPath];
            [cellInformation setObject:attributes forKey:indexPath];
        }
    }
    
    for (NSInteger section = numSections - 1; section >= 0; section--) {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        NSInteger totalHeight = 0;
        for (NSInteger item = 0; item < numItems; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            TMFDateAttributes *attributes = [cellInformation objectForKey:indexPath];
            attributes.frame = [self frameForCellAtIndexPath:indexPath];
            [self adjustFramesOfChildrenAndConnectorsForClassAtIndexPath:indexPath];
            cellInformation[indexPath] = attributes;
//            totalHeight += [self.customDataSource numRowsForClassAndChildrenAtIndexPath:indexPath];
        }
        if (section == 0) {
            self.maxNumRows = totalHeight;
        }
    }
    
    [layoutInformation setObject:cellInformation forKey:@"MyCellKind"];
    self.layoutInformation = layoutInformation;
//    self.itemSize = CGSizeMake(sItemCellWidth, sItemCellHeight);
//    self.minimumInteritemSpacing = 10;
//    self.minimumLineSpacing = 20;
//    self.scrollDirection = UICollectionViewScrollDirectionVertical;
//    self.collectionView.decelerationRate = 1;
//    self.collectionView.contentSize = CGSizeMake(100, 200);
}

//required
- (CGSize)collectionViewContentSize {
    CGFloat width = self.collectionView.numberOfSections * (sItemCell_Width + self.insets.left + self.insets.right);
    CGFloat height = self.maxNumRows * (sItemCell_Height + self.insets.top + self.insets.bottom);
    return CGSizeMake(width, height);
}

//required
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *myAttributes = [NSMutableArray arrayWithCapacity:self.layoutInformation.count];
    for (NSString *key in self.layoutInformation) {
        NSDictionary *attributesDic = [self.layoutInformation objectForKey:key];
        for (NSIndexPath *key in attributesDic) {
            UICollectionViewLayoutAttributes *attributes = [attributesDic objectForKey:key];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [myAttributes addObject:attributes];
            }
        }
    }
    return myAttributes;
    
}
//
////If the user scrolls its content, the collection view calls this
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return YES;
//}
//
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutInformation[@"MyCellKind"][indexPath];
}
#pragma mark - AppleDataSource and Delegate
//1.0
//To support additional supplementary and decoration views, you need to override the following methods at a minimum:
//layoutAttributesForElementsInRect: (required)
//layoutAttributesForItemAtIndexPath: (required)
//layoutAttributesForSupplementaryViewOfKind:atIndexPath: (to support new supplementary views)
//layoutAttributesForDecorationViewOfKind:atIndexPath: (to support new decoration views)

//2.0
//By default, a simple fade animation is created for items being inserted or deleted. To create custom animations, you must override some or all of the following methods:
//initialLayoutAttributesForAppearingItemAtIndexPath:
//initialLayoutAttributesForAppearingSupplementaryElementOfKind:atIndexPath:
//initialLayoutAttributesForAppearingDecorationElementOfKind:atIndexPath:
//finalLayoutAttributesForDisappearingItemAtIndexPath:
//finalLayoutAttributesForDisappearingSupplementaryElementOfKind:atIndexPath:
//finalLayoutAttributesForDisappearingDecorationElementOfKind:atIndexPath:
//prepareForCollectionViewUpdates:
//finalizeCollectionViewUpdates
#pragma mark - ThirdPartyDataSource and Delegate
#pragma mark - CustomDataSource and Delegate
#pragma mark - Target-Action Event
#pragma mark - PublicMethod
#pragma mark - PrivateMethod
- (TMFDateAttributes *)attributesWithChildrenAtIndexPath:(NSIndexPath *)indexPath {
    //TODO
    TMFDateAttributes *attributes = [[TMFDateAttributes alloc] init];
    
    return attributes;
}

- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath {
    //TODO
    CGRect frame = CGRectZero;
    
    return frame;
}

- (void)adjustFramesOfChildrenAndConnectorsForClassAtIndexPath:(NSIndexPath *)indexPath {
    //TODO
}
@end
