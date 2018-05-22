//
//  HappenVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/11.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HappenVC.h"
#import "AllServiceDataModel.h"
#import "HappenCell.h"
#import "EstablishCircleVC.h"
#import "CircleVC.h"
#import "happenCell2.h"
#import "HappenDataModel.h"
@interface HappenVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat indexPathPersition1; // indexpath == {0,0}位置
    CGFloat indexPathPersition2;//indexpath == {1,0}位置

}
@property (nonatomic,strong)UIButton *districtAffairsBtn;
@property (nonatomic,strong)UIButton *perimeterBtn;
@property (nonatomic,strong)UIView *lineViewFlag;
@property (nonatomic,strong) NSArray <AllServiceArr*> *myArr;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)HappenData *myData;
@property (nonatomic,strong)NSMutableArray <HappenDataMyCircles *>*myCircleData;
@end

@implementation HappenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    _myCircleData = [NSMutableArray array];
    [self headerSwitchView];
    [self.view addSubview:self.myTableView];
    [self viewConfig];
    [self fetchData];

    // Do any additional setup after loading the view.
}
- (void)findIndexPathPersition{
    happenCell2 *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    indexPathPersition1 = cell.frame.origin.y;
//    happenCell2 *cell2 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    indexPathPersition2 = indexPathPersition1 + 60 *_myData.microdistrictCircles.count + 45*2;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 165, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - TABBARHEIGHT - 165)];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
    
}
- (UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 35, SCREENWIDTH, 120)collectionViewLayout:layout];
        [_myCollectionView registerNib:[UINib nibWithNibName:@"HappenCell" bundle:nil] forCellWithReuseIdentifier:@"HappenCell"];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
    }
    return _myCollectionView;
}
- (void)headerSwitchView{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT - 40, SCREENWIDTH, 40)];
    [self.navView addSubview:myView];
    CGFloat gap = (SCREENWIDTH - 55*2)/3.0;
    CGFloat btnWidth = (SCREENWIDTH - gap*2)/2.0;
    _districtAffairsBtn = [[UIButton alloc]initWithFrame:CGRectMake(gap, 0, btnWidth, 40)];
    [_districtAffairsBtn setTitle:@"小区事" forState:UIControlStateNormal];
    [_districtAffairsBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_districtAffairsBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
    [_districtAffairsBtn addTarget:self action:@selector(btnChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _perimeterBtn = [[UIButton alloc]initWithFrame:CGRectMake(gap + btnWidth, 0, btnWidth, 40)];
    [_perimeterBtn setTitle:@"周边事" forState:UIControlStateNormal];
    [_perimeterBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_perimeterBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
    [_perimeterBtn addTarget:self action:@selector(btnChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:_districtAffairsBtn];
    [myView addSubview:_perimeterBtn];
    
    _lineViewFlag = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 2)];
    _lineViewFlag.backgroundColor = RGBA(0x00a7ff, 1);
    _lineViewFlag.center = CGPointMake(gap + btnWidth/2.0, 40-2);
    [myView addSubview:_lineViewFlag];
    [self.view addSubview:myView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
    lineView.backgroundColor = RGBA(0xdbdbdb, 1);
    [myView addSubview:lineView];
}
- (void)fetchData{
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];

    NSDictionary *dict = @{@"cityId":storage.areaNumber,@"microdistrictId":storage.choseUnitPropertyId};
    [XMJHttpTool postWithUrl:@"circle/llist4App" param:dict success:^(id responseObj) {
        NSString * str = [responseObj mj_JSONObject][@"data"];
        HappenDataModel *data = [HappenDataModel mj_objectWithKeyValues:str];
        if (data.success) {
            _myData = data.data;
            [self findIndexPathPersition];
            [_myCircleData removeAllObjects];
            [_myCircleData addObjectsFromArray:_myData.myCircles];
            [_myCollectionView reloadData];
            [_myTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewConfig{
    
//    UIView *locationView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 40)];
//    locationView.backgroundColor = RGBA(0xeaeef1, 1);
//    UIImageView *locationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 15, 20)];
//    locationImageView.image = [UIImage imageNamed:@"hap_icon_location"];
//    [locationView addSubview:locationImageView];
//
//    UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, SCREENWIDTH - 50, 40)];
//    locationLabel.font = [UIFont systemFontOfSize:14.0];
//    locationLabel.textColor = RGBA(0x303030, 1);
//    locationLabel.text = @"重庆复地新成就";
//    [locationView addSubview:locationLabel];
//
//    [self.view addSubview:locationView];
    
//    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT +40, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - 40)];
//    [self.view addSubview:myScrollView];
    
    CGFloat sectionY = 0;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 0)];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionY + 10, 5, 15)];
    lineView.backgroundColor  = RGBA(0x00a7ff, 1);
    [headerView addSubview:lineView];
    UILabel *markTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, sectionY + 10, 100, 15)];
    markTitle.textColor = RGBA(0x303030, 1);
    markTitle.font = [UIFont systemFontOfSize:16.0];
    markTitle.text = @"我的圈子";
    [headerView  addSubview:markTitle];
    sectionY += 10 + 15 + 10;
    
    [headerView addSubview:self.myCollectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;

    sectionY += 120 +10;
    
    CGRect rect = headerView.frame;
    rect.size.height = sectionY;
    headerView.frame = rect;
    [self.view addSubview:headerView];
}
- (void)btnClick:(UIButton *)btn{
    CircleVC *page = [[CircleVC alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}

- (void)btnChoseClick:(UIButton *)btn{
    CGFloat gap = (SCREENWIDTH - 55*2)/3.0;
    CGFloat btnWidth = (SCREENWIDTH - gap*2)/2.0;
    if (btn == _perimeterBtn) {
        _lineViewFlag.center = CGPointMake(gap + btnWidth/2.0 + btnWidth, 40-2);
        [_perimeterBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        [_districtAffairsBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        if (_myData) {
            [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }
        
    }else{
        _lineViewFlag.center = CGPointMake(gap + btnWidth/2.0, 40-2);
        [_perimeterBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [_districtAffairsBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        if (_myData) {
            [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];

        }

    }
}
#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _myCircleData.count +1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HappenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HappenCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HappenCell" owner:self options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        cell.img.image = [UIImage imageNamed:@"addPic"];
        cell.name.text = @"创建圈子";
    }else{
        [cell.img sd_setImageWithURL:[NSURL URLWithString:_myCircleData[indexPath.row-1].path] placeholderImage:[UIImage imageNamed:@"icon_默认"]];
        cell.name.text = _myCircleData[indexPath.row-1].name;
    }
    return cell;
}
#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){75,110};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 30.0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        EstablishCircleVC *page = [[EstablishCircleVC alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }else{
        CircleVC *page = [[CircleVC alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"happenCell2";
    happenCell2 *myCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!myCell) {
        myCell = [[happenCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cell];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [myCell setData:_myData.microdistrictCircles[indexPath.row]];
    }else if (indexPath.section == 1){
        [myCell setData:_myData.cityCircles[indexPath.row]];
    }
    return myCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return _myData.microdistrictCircles.count;
    }
    return _myData.cityCircles.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat sectionY = 0;

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
    headerView.backgroundColor = RGBA(0xffffff, 1);
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    lineView2.backgroundColor = RGBA(0xeaeef1, 1);
    [headerView addSubview:lineView2];
    sectionY += 10;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionY + 10, 5, 15)];
    lineView.backgroundColor  = RGBA(0x00a7ff, 1);
    [headerView addSubview:lineView];
    UILabel *markTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, sectionY + 10, 100, 15)];
    markTitle.textColor = RGBA(0x303030, 1);
    markTitle.font = [UIFont systemFontOfSize:16.0];
    markTitle.text = @[@"小区事",@"周边事"][section];
    [headerView  addSubview:markTitle];
    sectionY += 10 + 15 + 10;
    
    CGRect rect = headerView.frame;
    rect.size.height = sectionY;
    headerView.frame = rect;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.myTableView) {
//        [self findIndexPathPersition];
        CGFloat gap = (SCREENWIDTH - 55*2)/3.0;
        CGFloat btnWidth = (SCREENWIDTH - gap*2)/2.0;
        if (scrollView.contentOffset.y <=indexPathPersition2) {
            _lineViewFlag.center = CGPointMake(gap + btnWidth/2.0, 40-2);
            [_perimeterBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
            [_districtAffairsBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        }else if (scrollView.contentOffset.y >=indexPathPersition2){
            _lineViewFlag.center = CGPointMake(gap + btnWidth/2.0 + btnWidth, 40-2);
            [_perimeterBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
            [_districtAffairsBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
