//
//  TMFDateCollectionViewController.m
//  TMFReorderCollectionCellIniOS7
//
//  Created by MrChens on 16/6/23.
//  Copyright © 2016年 TMFuny. All rights reserved.
//

#import "TMFDateCollectionViewController.h"
#import "TMFDateCollectionViewCell.h"
#import "TMFCollectionViewSectionHeader.h"
#import "TMFSortableCollectionViewFlowLayout.h"
#import "NSDate+WSPXUtility.h"



@interface TMFDateCollectionViewController ()<TMFSortableCollectionViewDataSource, TMFSortableCollectionViewDelegateFlowLayout>

@end

@implementation TMFDateCollectionViewController

static NSString * const cellReuseIdentifier = @"TMFCellReuseIdentifier";
static NSString * const headerReuseIndentifier = @"TMFHeaderReuseIdentifier";
#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[TMFDateCollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    [self.collectionView registerClass:[TMFCollectionViewSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIndentifier];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    self.collectionView.backgroundColor = [UIColor grayColor];
//    self.collectionView.dataSource = self;
//    self.collectionView.delegate = self;
//    TMFSortableCollectionViewFlowLayout *flowLayout = [[TMFSortableCollectionViewFlowLayout alloc] init];
//    self.collectionView.collectionViewLayout = flowLayout;
    self.firstDates = [[NSMutableArray alloc] init];
    self.secondDates = [[NSMutableArray alloc] init];
    self.thirdDates = [[NSMutableArray alloc] init];
    [self loadDates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIInit
#pragma mark - UIConfig
#pragma mark - UIUpdate
#pragma mark - AppleDataSource and Delegate

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (section == 0) {
        return self.firstDates.count;
    } else if (section == 1) {
        return self.secondDates.count;
    } else {
        return self.thirdDates.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMFDateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.dateLabel.text = [self.firstDates objectAtIndex:indexPath.item];
    } else {
        cell.dateLabel.text = [self.secondDates objectAtIndex:indexPath.item];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    TMFCollectionViewSectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIndentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headerView.titleLabel.text = @"firstSection";
    } else if(indexPath.section == 1){
        headerView.titleLabel.text = @"secondSection";
    } else if (indexPath.section == 2) {
        
    }
    
    return headerView;
}
#pragma mark TMFSortableCollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    NSString *removeStr = @"";
    if (fromIndexPath.section == 0) {
        removeStr = self.firstDates[fromIndexPath.item];
        [self.firstDates removeObjectAtIndex:fromIndexPath.item];
    } else if(fromIndexPath.section == 1){
        removeStr = self.secondDates[fromIndexPath.item];
        [self.secondDates removeObjectAtIndex:fromIndexPath.item];
    } else if (fromIndexPath.section == 2) {
        removeStr = self.thirdDates[fromIndexPath.item];
        [self.thirdDates removeObjectAtIndex:fromIndexPath.item];
    }
    
    if (toIndexPath.section == 0) {
        [self.firstDates insertObject:removeStr atIndex:toIndexPath.item];
    } else if(toIndexPath.section == 1){
        [self.secondDates insertObject:removeStr atIndex:toIndexPath.item];
    } else if (toIndexPath.section == 2) {
        [self.thirdDates insertObject:removeStr atIndex:toIndexPath.item];
    }

}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMovetoIndexPath:(NSIndexPath *)toIndexPath {
    if (toIndexPath.section != 0) {
        return NO;
    }
    return YES;
}

#pragma mark TMFSortableCollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did end drag");
}
#pragma mark <UICollectionViewDelegate>


//// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected indexPath section:%ld item:%ld", indexPath.section, indexPath.item);
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (indexPath.section == 0) {
        if (indexPath.item % 2 == 0) {
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            NSString *removeStr = self.firstDates[indexPath.item];
            [self.firstDates removeObjectAtIndex:indexPath.item];
            if (self.thirdDates && self.thirdDates.count == 0) {
                [self.thirdDates addObject:removeStr];
            } else {
                
                [self.thirdDates insertObject:removeStr atIndex:toIndexPath.item];
            }
            
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
            return;
        }
        
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        NSString *removeStr = self.firstDates[indexPath.item];
        [self.firstDates removeObjectAtIndex:indexPath.item];
        if (self.secondDates && self.secondDates.count == 0) {
            [self.secondDates addObject:removeStr];
        } else {
            
            [self.secondDates insertObject:removeStr atIndex:toIndexPath.item];
        }

        [collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
    } else if (indexPath.section == 1){
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:[collectionView numberOfItemsInSection:0] inSection:0];
        NSString *removeStr = self.secondDates[indexPath.item];
        [self.secondDates removeObjectAtIndex:indexPath.item];
        if (self.firstDates && self.firstDates.count == 0) {
            [self.firstDates addObject:removeStr];
        } else {
            [self.firstDates insertObject:removeStr atIndex:toIndexPath.item];
        }
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
    } else if (indexPath.section == 2) {
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:[collectionView numberOfItemsInSection:0] inSection:0];
        NSString *removeStr = self.thirdDates[indexPath.item];
        [self.thirdDates removeObjectAtIndex:indexPath.item];
        if (self.firstDates && self.firstDates.count == 0) {
            [self.firstDates addObject:removeStr];
        } else {
            
            [self.firstDates insertObject:removeStr atIndex:toIndexPath.item];
        }
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
//
//
//
//// Uncomment this method to specify if the specified item should be selected
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//
//
//// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
//	return NO;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	return NO;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	
//}

//https://developer.apple.com/library/ios/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/UsingtheFlowLayout/UsingtheFlowLayout.html#//apple_ref/doc/uid/TP40012334-CH3-SW4
#pragma mark <UICollectionViewDelegateFlowLayout>
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(40, 20);
//}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(4, 10, 4, 10);
//}
// 设置没一行之间的最小间距(实际的间距可能大于最小间距,这个最小间=上行最底部的item的底和下行最顶部的item的顶 之间的距离)
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 20.0;
//}
// 设置每个item之间的最小间距(实际的间距可能大于最小间距)
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 10.0;
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(200, 20);
//}

#pragma mark - ThirdPartyDataSource and Delegate
#pragma mark - CustomDataSource and Delegate
#pragma mark - Target-Action Event
#pragma mark - PublicMethod
#pragma mark - PrivateMethod
- (void)loadDates {
    for (int i = 0; i < 15; i++) {
        [self.firstDates addObject:[[NSString stringWithFormat:@"1-%d",i] stringByAppendingString:[[NSDate date] getDateStringByTheFormatString:DATE_FORMAT_HH_MM_24HOUR]]];
    }
//    for (int i = 0; i < 2; i++) {
//        [self.secondDates addObject:[[NSString stringWithFormat:@"2-%d",i] stringByAppendingString:[[NSDate date] getDateStringByTheFormatString:DATE_FORMAT_HH_MM_24HOUR]]];
//    }
}
@end
