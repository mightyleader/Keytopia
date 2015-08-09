//
//  PhotoLibraryCollection.m
//  Keytopia
//
//  Created by Rob Stearn on 10/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "KeytopiaPhotoLibraryCollection.h"
@import Photos;

@interface KeytopiaPhotoLibraryCollection () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> //PHPhotoLibraryChangeObserver later...

@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) PHCachingImageManager *imageManager;

@property CGRect previousPreheatRect;

@end

static NSString * const CellReuseIdentifier = @"Cell";
static CGSize AssetGridThumbnailSize;

@implementation KeytopiaPhotoLibraryCollection


- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
  self = [super initWithCollectionViewLayout:layout];
  if (self) {
    [self setupBackingData];
    [self setupCollectionView];
  }
  return self;
}


- (void)dealloc
{
//  [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}


- (void)setupBackingData
{
  PHFetchOptions *options = [[PHFetchOptions alloc] init];
  options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
  _assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
}


- (void)setupCollectionView
{
  [self.collectionView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
  [self.collectionView setDataSource:self];
  [self.collectionView setDelegate:self];
  [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
  self.imageManager = [[PHCachingImageManager alloc] init];
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  CGFloat scale = [UIScreen mainScreen].scale;
  CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
  AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
}

#pragma mark - Collection view obligations

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
  return _assetsFetchResults.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
  
  // Increment the cell's tag
  NSInteger currentTag = cell.tag + 1;
  cell.tag = currentTag;
  cell.contentView.backgroundColor = [UIColor blueColor];
  PHAsset *asset = self.assetsFetchResults[indexPath.item];
  if (cell.tag == currentTag) {
    [cell setSelected:YES];
    
  }
  [self.imageManager requestImageForAsset:asset
                               targetSize:AssetGridThumbnailSize
                              contentMode:PHImageContentModeAspectFill
                                  options:nil
                            resultHandler:^(UIImage *result, NSDictionary *info) {
                              
                              // Only update the thumbnail if the cell tag hasn't changed. Otherwise, the cell has been re-used.

                              
                            }];
  
  return cell;
}


#pragma mark - PhotoLibrary change callbacks

@end
