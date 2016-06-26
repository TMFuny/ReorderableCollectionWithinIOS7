//
//  TMFSortableCollectionViewFlowLayout.h
//  TMFReorderCollectionCellIniOS7
//
//  Created by MrChens on 16/6/23.
//  Copyright © 2016年 TMFuny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMFSortableCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat scrollingSpeed;
@property (nonatomic, assign) UIEdgeInsets scrollingTriggerEdgeInsets;
@property (nonnull, strong, nonatomic, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonnull, strong, nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;

@end

@protocol TMFSortableCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@optional
- (void)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end

@protocol TMFSortableCollectionViewDataSource <UICollectionViewDataSource>

@optional
- (void)collectionView:(nonnull UICollectionView *)collectionView itemAtIndexPath:(nonnull NSIndexPath *)fromIndexPath willMoveToIndexPath:(nonnull NSIndexPath *)toIndexPath;
- (void)collectionView:(nonnull UICollectionView *)collectionView itemAtIndexPath:(nonnull NSIndexPath *)fromIndexPath didMoveToIndexPath:(nonnull NSIndexPath *)toIndexPath;

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView canMoveItemAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (BOOL)collectionView:(nonnull UICollectionView *)collectionView itemAtIndexPath:(nonnull NSIndexPath *)fromIndexPath canMovetoIndexPath:(nonnull NSIndexPath *)toIndexPath;

@end