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

typedef NS_ENUM(NSUInteger, TMFScrollingDirection) {
    TMFScrollingDirectionUnknown = 0,
    TMFScrollingDirectionUp = 1,
    TMFScrollingDirectionDown = 2,
    TMFScrollingDirectionLeft = 3,
    TMFScrollingDirectionRight = 4
};

static NSString * const kTMFScrollingDirectionKey = @"TMFuny.kTMFScrollingDirectionKey";
static NSString * const kTMFCollectionViewKeyPath = @"TMFuny.kTMFCollectionViewKeyPath";

@interface UICollectionViewCell (TMFSortableCollectionViewFlowLayout)

- (nonnull UIView *)TMF_snapshot;
@end

@implementation UICollectionViewCell (TMFSortableCollectionViewFlowLayout)

- (UIView *)TMF_snapshot {
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        return [self snapshotViewAfterScreenUpdates:YES];
    } else {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return [[UIImageView alloc] initWithImage:image];
    }
}

@end

@interface TMFSortableCollectionViewFlowLayout ()<UIGestureRecognizerDelegate>
@property (nonnull, strong, nonatomic, readwrite) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonnull, strong, nonatomic, readwrite) UIPanGestureRecognizer *panGestureRecognizer;
@property (nullable, strong, nonatomic) NSIndexPath *selectedItemIndexPath;
@property (nullable, strong, nonatomic) UIView *currentView;
@property (assign, nonatomic) CGPoint currentViewCenter;
@property (assign, nonatomic) CGPoint panTranslationInCollectionView;
@property (nullable, strong, nonatomic) CADisplayLink *displayLink;

@property (weak, nonatomic, readonly) id<TMFSortableCollectionViewDataSource> dataSource;
@property (weak, nonatomic, readonly) id<TMFSortableCollectionViewDelegateFlowLayout> delegate;
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
    [self configDefaults];
}

- (void)configDefaults {
    _scrollingSpeed = 300.0f;
    _scrollingTriggerEdgeInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
}
//this is not required to implement a custom layout but is provided as an opportunity to make initial calculations if necessary.
- (void)prepareLayout {
    self.itemSize = CGSizeMake(sItemCell_Width, sItemCell_Height);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 20;
    self.sectionInset = UIEdgeInsetsMake(4, 10, 4, 10);
    self.headerReferenceSize = CGSizeMake(sItemCell_Width, sItemCell_Height);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.decelerationRate = 1;
    self.collectionView.contentSize = CGSizeMake(100, 200);
}


//required
//- (CGSize)collectionViewContentSize {
//    
//}

//required
//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//
//    
//}

//
////If the user scrolls its content, the collection view calls this
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return YES;
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

//- (void)setHeaderReferenceSize:(CGSize)headerReferenceSize {
//    
//}
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
@end
