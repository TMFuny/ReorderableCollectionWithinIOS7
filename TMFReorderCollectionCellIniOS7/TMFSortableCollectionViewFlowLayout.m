//
//  TMFSortableCollectionViewFlowLayout.m
//  TMFReorderCollectionCellIniOS7
//
//  Created by MrChens on 16/6/23.
//  Copyright © 2016年 TMFuny. All rights reserved.
//
//https://realm.io/cn/news/gwendolyn-weston-ios-background-networking/
//http://mobilev5.github.io/2016/03/13/meeting-common-urldownloader/
//https://developer.apple.com/library/ios/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/CreatingCustomLayouts/CreatingCustomLayouts.html#//apple_ref/doc/uid/TP40012334-CH5-SW6
//http://stackoverflow.com/questions/12611292/uicollectionview-assertion-failure
#import "TMFSortableCollectionViewFlowLayout.h"
#import "TMFDateAttributes.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#define sItemCell_Width (65)
#define sItemCell_Height (36)

#ifndef CGGEOMETRY_LXSUPPORT_H_
CG_INLINE CGPoint
TMF_CGPointAdd(CGPoint point1, CGPoint point2){
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}
#endif
typedef NS_ENUM(NSUInteger, TMFScrollingDirection) {
    TMFScrollingDirectionUnknown = 0,
    TMFScrollingDirectionUp = 1,
    TMFScrollingDirectionDown = 2,
    TMFScrollingDirectionLeft = 3,
    TMFScrollingDirectionRight = 4
};

static NSString * const kTMFScrollingDirectionKey = @"kTMFScrollingDirectionKey";
static NSString * const kTMFCollectionViewKeyPath = @"collectionView";

#pragma mark - snapshot
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

#pragma mark - 

@interface CADisplayLink (TMF_userInfo)
@property (nullable, nonatomic, copy) NSDictionary *TMF_userInfo;

@end

@implementation CADisplayLink (TMF_userInfo)
- (void)setTMF_userInfo:(NSDictionary *)TMF_userInfo {
    objc_setAssociatedObject(self, "TMF_userInfo", TMF_userInfo, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)TMF_userInfo {
    return objc_getAssociatedObject(self, "TMF_userInfo");
}

@end

@interface TMFSortableCollectionViewFlowLayout ()<UIGestureRecognizerDelegate>
@property (nonnull, strong, nonatomic, readwrite) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonnull, strong, nonatomic, readwrite) UIPanGestureRecognizer *panGestureRecognizer;
@property (nullable, strong, nonatomic) NSIndexPath *selectedItemIndexPath;
@property (nullable, strong, nonatomic) NSMutableArray *deleteIndexPaths;
@property (nullable, strong, nonatomic) UIView *currentView;
@property (assign, nonatomic) CGPoint currentViewCenter;
@property (assign, nonatomic) CGPoint panTranslationInCollectionView;
@property (nullable, strong, nonatomic) CADisplayLink *displayLink;
@property (nullable, strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

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

- (void)dealloc {
    [self invalidatesScrollTimer];
    [self tearDownCollectionView];
    [self removeObserver:self forKeyPath:kTMFCollectionViewKeyPath];
}

- (void)commonInit {
    [self configDefaults];
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    [self addObserver:self forKeyPath:kTMFCollectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)configDefaults {
    _scrollingSpeed = 300.0f;
    _scrollingTriggerEdgeInsets = UIEdgeInsetsMake(30.0f, 30.0f, 30.0f, 30.0f);
}
//this is not required to implement a custom layout but is provided as an opportunity to make initial calculations if necessary.
- (void)prepareLayout {
    self.itemSize = CGSizeMake(sItemCell_Width, sItemCell_Height);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 20;
    self.sectionInset = UIEdgeInsetsMake(4, 10, 4, 10);
    self.headerReferenceSize = CGSizeMake(sItemCell_Width, sItemCell_Height);
//    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.decelerationRate = 1;
//    self.collectionView.contentSize = CGSizeMake(100, 200);
}

- (void)setupCollectionView {
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    _longPressGestureRecognizer.delegate = self;
    
    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
        }
    }
    
    [self.collectionView addGestureRecognizer:_longPressGestureRecognizer];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _panGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:_panGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)setupScrollTimerInDirection:(TMFScrollingDirection)direction {
    if (!self.displayLink.paused) {
        TMFScrollingDirection oldDirection = [self.displayLink.TMF_userInfo[kTMFScrollingDirectionKey] integerValue];
        
        if (direction == oldDirection) {
            return;
        }
    }
    
    [self invalidatesScrollTimer];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleScroll:)];
    self.displayLink.TMF_userInfo = @{kTMFScrollingDirectionKey: @(direction)};
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    if ([layoutAttributes.indexPath isEqual:self.selectedItemIndexPath]) {
        layoutAttributes.hidden = YES;
    }
}

- (id<TMFSortableCollectionViewDataSource>)dataSource {
    return (id<TMFSortableCollectionViewDataSource>)self.collectionView.dataSource;
}

-(id<TMFSortableCollectionViewDelegateFlowLayout>)delegate {
    return (id<TMFSortableCollectionViewDelegateFlowLayout>)self.collectionView.delegate;
}

//required
//- (CGSize)collectionViewContentSize {
//    
//}

//required
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray *layoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesForElementsInRect) {
        switch (layoutAttributes.representedElementCategory) {
            case UICollectionElementCategoryCell:
            {
                [self applyLayoutAttributes:layoutAttributes];
            }
                break;
                
            default:
                break;
        }
    }
                 return layoutAttributesForElementsInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    switch (layoutAttributes.representedElementCategory) {
        case UICollectionElementCategoryCell:
        {
            [self applyLayoutAttributes:layoutAttributes];
        }
            break;
            
        default:
            break;
    }
    return layoutAttributes;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kTMFCollectionViewKeyPath]) {
        if (self.collectionView != nil) {
            [self setupCollectionView];
        } else {
            [self invalidatesScrollTimer];
            [self tearDownCollectionView];
        }
    }
}
//
////If the user scrolls its content, the collection view calls this
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return YES;
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

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    self.deleteIndexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *item in updateItems) {
        if (item.updateAction == UICollectionUpdateActionDelete) {
            [self.deleteIndexPaths addObject:item.indexPathBeforeUpdate];
        }
    }
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    self.deleteIndexPaths = nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    
        return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if ([self.deleteIndexPaths containsObject:itemIndexPath]) {
        if (attributes) {
            
            attributes.center = self.collectionView.center;
            attributes.transform3D = CATransform3DConcat(CATransform3DMakeRotation((2 * M_PI ), 0, 0, 1), CATransform3DMakeScale(0.1, 0.1, 1.0));
        }
    }
        return attributes;
}
#pragma mark UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
        return (self.selectedItemIndexPath != nil);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.longPressGestureRecognizer isEqual:gestureRecognizer]) {
        return [self.panGestureRecognizer isEqual:otherGestureRecognizer];
    }
    
    if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
        return [self.longPressGestureRecognizer isEqual:otherGestureRecognizer];
    }
    
    return NO;
}
#pragma mark - ThirdPartyDataSource and Delegate
#pragma mark - CustomDataSource and Delegate
#pragma mark - Target-Action Event
#pragma mark - PublicMethod
#pragma mark - PrivateMethod

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    switch(gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];
            
            if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)] &&
                ![self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:currentIndexPath]) {
                return;
            }
            
            self.selectedItemIndexPath = currentIndexPath;
            
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:self.selectedItemIndexPath];
            }
            
            UICollectionViewCell *collectionViewCell = [self.collectionView cellForItemAtIndexPath:self.selectedItemIndexPath];
            
            self.currentView = [[UIView alloc] initWithFrame:collectionViewCell.frame];
            
            collectionViewCell.highlighted = YES;
            UIView *highlightedImageView = [collectionViewCell TMF_snapshot];
            highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            highlightedImageView.alpha = 1.0f;
            
            collectionViewCell.highlighted = NO;
            UIView *imageView = [collectionViewCell TMF_snapshot];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            imageView.alpha = 0.0f;
            
            [self.currentView addSubview:imageView];
            [self.currentView addSubview:highlightedImageView];
            [self.collectionView addSubview:self.currentView];
            
            self.currentViewCenter = self.currentView.center;
            
            __weak typeof(self) weakSelf = self;
            [UIView
             animateWithDuration:0.3
             delay:0.0
             options:UIViewAnimationOptionBeginFromCurrentState
             animations:^{
                 __strong typeof(self) strongSelf = weakSelf;
                 if (strongSelf) {
                     strongSelf.currentView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                     highlightedImageView.alpha = 0.0f;
                     imageView.alpha = 1.0f;
                 }
             }
             completion:^(BOOL finished) {
                 __strong typeof(self) strongSelf = weakSelf;
                 if (strongSelf) {
                     [highlightedImageView removeFromSuperview];
                     
                     if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                         [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didBeginDraggingItemAtIndexPath:strongSelf.selectedItemIndexPath];
                     }
                 }
             }];
            
            [self invalidateLayout];
        } break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            NSIndexPath *currentIndexPath = self.selectedItemIndexPath;
            
            if (currentIndexPath) {
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:currentIndexPath];
                }
                
                self.selectedItemIndexPath = nil;
                self.currentViewCenter = CGPointZero;
                
                UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:currentIndexPath];
                
                self.longPressGestureRecognizer.enabled = NO;
                
                __weak typeof(self) weakSelf = self;
                [UIView
                 animateWithDuration:0.3
                 delay:0.0
                 options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                     __strong typeof(self) strongSelf = weakSelf;
                     if (strongSelf) {
                         strongSelf.currentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         strongSelf.currentView.center = layoutAttributes.center;
                     }
                 }
                 completion:^(BOOL finished) {
                     
                     self.longPressGestureRecognizer.enabled = YES;
                     
                     __strong typeof(self) strongSelf = weakSelf;
                     if (strongSelf) {
                         [strongSelf.currentView removeFromSuperview];
                         strongSelf.currentView = nil;
                         [strongSelf invalidateLayout];
                         
                         if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
                             [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didEndDraggingItemAtIndexPath:currentIndexPath];
                         }
                     }
                 }];
            }
        } break;
            
        default: break;
    }
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            self.panTranslationInCollectionView = [gestureRecognizer translationInView:self.collectionView];
            CGPoint viewCenter = self.currentView.center = TMF_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
            
            [self invalidateLayoutIfNecessary];
            
            switch (self.scrollDirection) {
                case UICollectionViewScrollDirectionVertical: {
                    if (viewCenter.y < (CGRectGetMinY(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.top)) {
                        [self setupScrollTimerInDirection:TMFScrollingDirectionUp];
                    } else {
                        if (viewCenter.y > (CGRectGetMaxY(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.bottom)) {
                            [self setupScrollTimerInDirection:TMFScrollingDirectionDown];
                        } else {
                            [self invalidatesScrollTimer];
                        }
                    }
                } break;
                case UICollectionViewScrollDirectionHorizontal: {
                    if (viewCenter.x < (CGRectGetMinX(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.left)) {
                        [self setupScrollTimerInDirection:TMFScrollingDirectionLeft];
                    } else {
                        if (viewCenter.x > (CGRectGetMaxX(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.right)) {
                            [self setupScrollTimerInDirection:TMFScrollingDirectionRight];
                        } else {
                            [self invalidatesScrollTimer];
                        }
                    }
                } break;
            }
        } break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self invalidatesScrollTimer];
        } break;
        default: {
            // Do nothing...
        } break;
    }

}

- (void)handleScroll:(CADisplayLink *)dispalyLink {
    TMFScrollingDirection direction = (TMFScrollingDirection)[dispalyLink.TMF_userInfo[kTMFScrollingDirectionKey] integerValue];
    if (direction == TMFScrollingDirectionUnknown) {
        return;
    }
    
    CGSize frameSize = self.collectionView.bounds.size;
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    
    CGFloat distance = rint(self.scrollingSpeed * dispalyLink.duration);
    CGPoint translation = CGPointZero;
    
    switch (direction) {
        case TMFScrollingDirectionUp:
        {
            distance = -distance;
            CGFloat minY = 0.0f - contentInset.top;
            
            if ((contentOffset.y + distance) <= minY) {
                distance = -contentOffset.y - contentInset.top;
            }
            
            translation = CGPointMake(0.0f, distance);
        }
            break;
        case TMFScrollingDirectionDown:
        {
            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height + contentInset.bottom;
            
            if ((contentOffset.y + distance) >= maxY) {
                distance = maxY - contentOffset.y;
            }
            
            translation = CGPointMake(0.0f, distance);
        }
            break;
        case TMFScrollingDirectionLeft:
        {
            distance = -distance;
            CGFloat minX = 0.0f - contentInset.left;
            
            if ((contentOffset.x + distance) <= minX) {
                distance = -contentOffset.x - contentInset.left;
            }
            
            translation = CGPointMake(distance, 0.0f);
        }
            break;
        case TMFScrollingDirectionRight:
        {
            CGFloat maxX = MAX(contentSize.width, frameSize.width) - frameSize.width + contentInset.right;
            
            if ((contentOffset.x + distance) >= maxX) {
                distance = maxX - contentOffset.x;
            }
            translation = CGPointMake(distance, 0.0f);
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
    self.currentViewCenter = TMF_CGPointAdd(self.currentViewCenter, translation);
    self.currentView.center = TMF_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
    self.collectionView.contentOffset = TMF_CGPointAdd(contentOffset, translation);
}

- (void)tearDownCollectionView {
    //long Press gesture
    if (_longPressGestureRecognizer) {
        UIView *view = _longPressGestureRecognizer.view;
        if (view) {
            [view removeGestureRecognizer:_longPressGestureRecognizer];
        }
        _longPressGestureRecognizer.delegate = nil;
        _longPressGestureRecognizer = nil;
    }
    
    //pan gesture
    if (_panGestureRecognizer) {
        UIView *view = _panGestureRecognizer.view;
        if (view) {
            [view removeGestureRecognizer:_panGestureRecognizer];
        }
        _panGestureRecognizer.delegate = nil;
        _panGestureRecognizer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)invalidatesScrollTimer {
    if (!self.displayLink.paused) {
        [self.displayLink invalidate];
    }
    self.displayLink = nil;
}

- (void)invalidateLayoutIfNecessary {
    NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:self.currentView.center];
    NSIndexPath *previousIndexPath = self.selectedItemIndexPath;
    
    if ((newIndexPath == nil) || ([newIndexPath isEqual:previousIndexPath])) {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:canMovetoIndexPath:)] && ![self.dataSource collectionView:self.collectionView itemAtIndexPath:previousIndexPath canMovetoIndexPath:newIndexPath]) {
        return;
    }
    
    self.selectedItemIndexPath = newIndexPath;
    
    if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
        [self.dataSource collectionView:self.collectionView itemAtIndexPath:previousIndexPath willMoveToIndexPath:newIndexPath];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf.collectionView deleteItemsAtIndexPaths:@[previousIndexPath]];
            [strongSelf.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
        }
    } completion:^(BOOL finished) {
        __strong typeof(self) strongSelf = weakSelf;
        if ([strongSelf.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
            [strongSelf.dataSource collectionView:strongSelf.collectionView itemAtIndexPath:previousIndexPath didMoveToIndexPath:newIndexPath];
        }
    }];
}

- (void)handleApplicationWillResignActive:(NSNotification *)notification {
    self.panGestureRecognizer.enabled = NO;
    self.panGestureRecognizer.enabled = YES;
}







@end
