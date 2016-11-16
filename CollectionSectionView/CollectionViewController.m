//
//  CollectionViewController.m
//  CollectionSectionView
//
//  Created by Atif on 9/21/14.
//  Copyright (c) 2014 Atif. All rights reserved.
//

#import "CollectionViewController.h"
#import "SectionBackgroundLayout.h"

@interface CollectionViewController ()

@property (strong, nonatomic) NSMutableArray<NSNumber*> *numberOfCellsInSections;
@property (strong, nonatomic) NSMutableArray<NSValue*> *cellSizes;

@end

@implementation CollectionViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SectionBackgroundLayout *layout = (id)self.collectionViewLayout;
    layout.decorationViewOfKinds = @[@"SectionBackgroundView1", @"SectionBackgroundView2", [NSNull null]];
    layout.alternateBackgrounds = YES;
    layout.scrollDirection = (self.view.bounds.size.width < self.view.bounds.size.height ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal);
    
    self.numberOfCellsInSections = [@[@(5)] mutableCopy];
    [self reloadCellSizes];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    SectionBackgroundLayout *layout = (id)self.collectionViewLayout;
    layout.scrollDirection = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal);
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}


#pragma mark - Helper Methods

- (void)reloadCellSizes {
    NSMutableArray *sizes = [NSMutableArray array];
    for (NSInteger i=0; i<self.numberOfCellsInSections.count; i++) {
        [sizes addObject:[NSValue valueWithCGSize:CGSizeMake(50+rand()%50, 50+rand()%50)]];
    }
    
    self.cellSizes = sizes;
}


#pragma mark - UICollectionView DataSource & Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.numberOfCellsInSections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.numberOfCellsInSections[section] integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:(rand()%255)/255.0 alpha:1.0];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat inset = 40;
    if (section%3 == 0)
        inset = 20;
    
    return UIEdgeInsetsMake(inset, inset, inset, inset);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellSizes[indexPath.section] CGSizeValue];
}


#pragma mark - Action Handlers

- (IBAction)onRefresh:(id)sender {
    //    [self reloadCellSizes];
    NSInteger sectionIndex = 0;
    
    NSInteger numberOfCellsInSection = [self.numberOfCellsInSections[sectionIndex] integerValue];
    [self.numberOfCellsInSections replaceObjectAtIndex:sectionIndex withObject:@(random()%10+numberOfCellsInSection)];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (IBAction)onAdd:(id)sender {
    NSInteger sectionIndex = 0;
    NSInteger numberOfCellsInSection = [self.numberOfCellsInSections[sectionIndex] integerValue];
    [self.numberOfCellsInSections replaceObjectAtIndex:sectionIndex withObject:@(numberOfCellsInSection+1)];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfCellsInSection inSection:sectionIndex];
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (IBAction)onRemove:(id)sender {
    NSInteger sectionIndex = 0;
    NSInteger numberOfCellsInSection = [self.numberOfCellsInSections[sectionIndex] integerValue];
    
    //    if (numberOfCellsInSection > 1) {
    [self.numberOfCellsInSections replaceObjectAtIndex:sectionIndex withObject:@(numberOfCellsInSection-1)];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfCellsInSection-1 inSection:sectionIndex];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    //    }
}

@end
