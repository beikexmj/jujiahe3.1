//
//  FamilyAlbumVC.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyAlbumVC.h"
#import "FamilyAlbumCell.h"

#define ITEM_SIZE CGSizeMake((SCREENWIDTH - 60) / 4, (SCREENWIDTH - 60) / 4)

static NSString *const kFamilyAlbumCollectionViewCell = @"com.copticomm.jjh.album.collectionview.cell";

@interface FamilyAlbumVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *dataSource;

@end

@implementation FamilyAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigation];
    
    [self.contentView addSubview:self.collectionView];
    [self setupConstraints];
}

- (void)setupNavigation
{
    [self setPopLeftItem];
    self.navigationBar.jj_barTintColor = RGBA(0xf6f6f6, 1);
    self.navigationBar.shadowImage = [UIImage new];
    @weakify(self);
    [self setRightItemWithItemHandler:^(UIBarButtonItem *  _Nonnull sender) {
        @strongify(self);
        self.collectionView.allowsSelection = !self.collectionView.allowsSelection;
        if (self.collectionView.allowsSelection) {
            sender.title = @"删除";
        } else {
            sender.title = @"管理";
        }
        [self.collectionView reloadData];
    }
                               titles:@"管理", nil];
}

- (void)setupConstraints
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FamilyAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFamilyAlbumCollectionViewCell
                                                                      forIndexPath:indexPath];
    if (indexPath.item == 0) {
        cell.allowPick = NO;
        cell.imageView.image = [UIImage imageNamed:@"btn_add_photo"];
    } else {
        cell.allowPick = collectionView.allowsSelection;
    }
    return cell;
}

#pragma mark - getter

- (NSString *)title
{
    return @"家人动态";
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 12;
        flowLayout.itemSize = ITEM_SIZE;
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 12, 15, 12);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsSelection = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[FamilyAlbumCell class]
            forCellWithReuseIdentifier:kFamilyAlbumCollectionViewCell];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [@[] mutableCopy];
    }
    return _dataSource;
}

@end
