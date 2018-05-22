//
//  DnamicVC.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "DynamicVC.h"
#import "DynamicCell.h"
#import "FamilyManageVC.h"
#import "FamilyAlbumVC.h"
#import "AnniversaryVC.h"

#define ITEM_SIZE CGSizeMake((SCREENWIDTH - 50) / 2, 55)

static NSString *const kDynamicCollectionViewCell = @"com.copticomm.jjh.dynamic.collectionview.cell";

@interface DynamicVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel          *dialogLabel;
@property (nonatomic, strong) UIImageView      *coverImageView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<DynamicCellData *> *dataSource;

@end

@implementation DynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigation];
    
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.dialogLabel];
    [self setupConstraints];
}

- (void)setupNavigation
{
    [self setPopLeftItem];
    UIImage *cameraImage = [UIImage imageNamed:@"home_family_icon_camera"];
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, cameraImage.size}];
    [cameraButton setBackgroundImage:cameraImage forState:UIControlStateNormal];
    [[cameraButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
    self.navigationItem.rightBarButtonItems = @[cameraItem];
}

- (void)setupConstraints
{
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.height.mas_equalTo(225);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.top.equalTo(self.coverImageView.mas_bottom);
    }];
    [self.dialogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.centerY.equalTo(self.coverImageView);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDynamicCollectionViewCell forIndexPath:indexPath];
    cell.data = self.dataSource[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item) {
        case 0:
            [self.navigationController pushViewController:[FamilyManageVC new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[FamilyAlbumVC new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[AnniversaryVC new] animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - getter

- (NSString *)title
{
    return @"家人动态";
}

- (UILabel *)dialogLabel
{
    if (!_dialogLabel) {
        _dialogLabel = [[UILabel alloc] init];
        _dialogLabel.font = [UIFont systemFontOfSize:16];
        _dialogLabel.numberOfLines = 0;
        _dialogLabel.textAlignment = NSTextAlignmentCenter;
        _dialogLabel.text = @"点击右上角，上传属于您的第一张家庭合照";
        _dialogLabel.textColor = [UIColor whiteColor];
    }
    return _dialogLabel;
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.backgroundColor = [UIColor grayColor];
    }
    return _coverImageView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = ITEM_SIZE;
        flowLayout.minimumLineSpacing = 40;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(25, 22.5, 0, 22.5);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DynamicCell class]
            forCellWithReuseIdentifier:kDynamicCollectionViewCell];
    }
    return _collectionView;
}

- (NSMutableArray<DynamicCellData *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [@[[DynamicCellData dataWithTitle:@"家人管理" imageName:@"home_family_icon_person"],
                         [DynamicCellData dataWithTitle:@"家庭相册" imageName:@"home_family_icon_pic"],
                         [DynamicCellData dataWithTitle:@"纪念日" imageName:@"home_family_icon_date"],
                         [DynamicCellData dataWithTitle:@"家人街" imageName:@"home_family_icon_shopping"]] mutableCopy];
    }
    return _dataSource;
}

@end
