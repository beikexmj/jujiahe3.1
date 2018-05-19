//
//  ImageFlowView.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ImageFlowView.h"

static NSString *const kImageFlowViewCollectionViewCell = @"com.copticomm.jjh.image.flow.collection.cell";

@implementation ImageFlowConfiguration

@end

@interface ImageFlowView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView            *singleImageView;
@property (nonatomic, strong) UICollectionView       *multiImageView;
@property (nonatomic, strong) ImageFlowConfiguration *configuration;

@end

@implementation ImageFlowView

- (instancetype)initWithConfiguration:(ImageFlowConfiguration *)configuration
{
    self = [super init];
    if (self) {
        self.configuration = configuration;
    }
    return self;
}

- (void)setImageCount:(NSUInteger)imageCount
{
    _imageCount = imageCount;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (imageCount == 1) {
        [self addSubview:self.singleImageView];
        [self.singleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.height.mas_equalTo(self.configuration.singleImageSize.height);
        }];
        self.configuration.displayImage ? self.configuration.displayImage(self.singleImageView, 0) : nil;
    } else {
        [self addSubview:self.multiImageView];
        [self.multiImageView reloadData];
        [self.multiImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.right.equalTo(self);
            make.height.mas_equalTo(self.multiImageView.collectionViewLayout.collectionViewContentSize.height);
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageFlowViewCollectionViewCell
                                                                           forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *) cell.backgroundView;
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointZero, self.configuration.multiImageSize}];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.backgroundView = imageView;
    }
    self.configuration.displayImage ? self.configuration.displayImage(imageView, indexPath.item) : nil;
    return cell;
}

#pragma mark - getter

- (UIImageView *)singleImageView
{
    if (!_singleImageView) {
        _singleImageView = [[UIImageView alloc] init];
        _singleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _singleImageView.clipsToBounds = YES;
    }
    return _singleImageView;
}

- (UICollectionView *)multiImageView
{
    if (!_multiImageView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = self.configuration.verticalSpacing;
        flowLayout.minimumInteritemSpacing = self.configuration.horizontalSpacing;
        flowLayout.itemSize = self.configuration.multiImageSize;
        
        _multiImageView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.configuration.preferredLayoutWidth, 0)
                                             collectionViewLayout:flowLayout];
        _multiImageView.delegate = self;
        _multiImageView.dataSource = self;
        _multiImageView.backgroundColor = [UIColor clearColor];
        _multiImageView.bounces = NO;
        [_multiImageView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:kImageFlowViewCollectionViewCell];
    }
    return _multiImageView;
}

@end
