//
//  TMFDateCollectionViewController.m
//  TMFReorderCollectionCellIniOS7
//
//  Created by MrChens on 16/6/23.
//  Copyright © 2016年 TMFuny. All rights reserved.
//

#import "TMFDateCollectionViewController.h"
#import "TMFDateCollectionViewCell.h"
#import "TMFSortableCollectionViewFlowLayout.h"
#import "NSDate+WSPXUtility.h"



@interface TMFDateCollectionViewController ()<TMFSortableCollectionViewDataSource, TMFSortableCollectionViewDelegateFlowLayout>

@end

@implementation TMFDateCollectionViewController

static NSString * const reuseIdentifier = @"TMFReuseCellIdentifier";

#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[TMFDateCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    self.collectionView.backgroundColor = [UIColor grayColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    TMFSortableCollectionViewFlowLayout *flowLayout = [[TMFSortableCollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = flowLayout;
    self.dates = [[NSMutableArray alloc] init];
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

    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMFDateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.dateLabel.text = [self.dates objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor greenColor];
    } else {
        cell.backgroundColor = [UIColor yellowColor];
    }
    return cell;
}



#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}

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
    for (int i = 0; i < 50; i++) {
        [self.dates addObject:[[[NSDate date] getDateStringByTheFormatString:DATE_FORMAT_HH_MM_SS_24HOUR] stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
    }
}
@end
