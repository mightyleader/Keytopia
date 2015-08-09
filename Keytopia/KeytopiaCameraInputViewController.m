//
//  CameraInputViewController.m
//  Keytopia
//
//  Created by Rob Stearn on 31/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

#import "KeytopiaCameraInputViewController.h"
#import "KeytopiaPhotoLibraryCollection.h"

@interface KeytopiaCameraInputViewController ()

@property (nonatomic) KeytopiaPhotoLibraryCollection *photoLibrary;
@property (nonatomic) UICollectionViewFlowLayout *flow;

@end

@implementation KeytopiaCameraInputViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _flow = [[UICollectionViewFlowLayout alloc] init];
  _photoLibrary = [[KeytopiaPhotoLibraryCollection alloc] initWithCollectionViewLayout:_flow];
  [_flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  [_flow setEstimatedItemSize:CGSizeMake(100, 100)];
  _photoLibrary.collectionView.frame = self.inputView.frame;
  [self.inputView addSubview:_photoLibrary.collectionView];
}




@end
