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
@interface HappenVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UIButton *districtAffairsBtn;
@property (nonatomic,strong)UIButton *perimeterBtn;
@property (nonatomic,strong)UIView *lineViewFlag;
@property (nonatomic,strong) NSArray <AllServiceArr*> *myArr;

@end

@implementation HappenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    [self headerSwitchView];
    [self fetchData];
    
    // Do any additional setup after loading the view.
}
- (void)headerSwitchView{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT - 40, SCREENWIDTH, 40)];
    [self.navView addSubview:myView];
    CGFloat gap = (SCREENWIDTH - 55*2)/3.0;
    CGFloat btnWidth = (SCREENWIDTH - gap*2)/2.0;
    _districtAffairsBtn = [[UIButton alloc]initWithFrame:CGRectMake(gap, 0, btnWidth, 40)];
    [_districtAffairsBtn setTitle:@"小区事" forState:UIControlStateNormal];
    [_districtAffairsBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_districtAffairsBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
    [_districtAffairsBtn addTarget:self action:@selector(btnChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _perimeterBtn = [[UIButton alloc]initWithFrame:CGRectMake(gap + btnWidth, 0, btnWidth, 40)];
    [_perimeterBtn setTitle:@"周边事" forState:UIControlStateNormal];
    [_perimeterBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_perimeterBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
    [_perimeterBtn addTarget:self action:@selector(btnChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:_districtAffairsBtn];
    [myView addSubview:_perimeterBtn];
    
    _lineViewFlag = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 2)];
    _lineViewFlag.backgroundColor = RGBA(0x00a7ff, 1);
    _lineViewFlag.center = CGPointMake(gap + btnWidth/2.0 + btnWidth, 40-2);
    [myView addSubview:_lineViewFlag];
    [self.view addSubview:myView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
    lineView.backgroundColor = RGBA(0xdbdbdb, 1);
    [myView addSubview:lineView];
}
- (void)fetchData{
    NSDictionary *dict = @{@"apiv":@"1.0",@"propertyAreaId":@"1c265c5b5a3741cca88ace5dac48a6ef"};
    [ZTHttpTool postWithUrl:@"jujiahe/v1/serviceMenu/infos" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        AllServiceDataModel *data = [AllServiceDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            _myArr = data.form;
            if (_myArr.count>0) {
                [self viewConfig];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewConfig{
    
    UIView *locationView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 40)];
    locationView.backgroundColor = RGBA(0xeaeef1, 1);
    UIImageView *locationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 15, 20)];
    locationImageView.image = [UIImage imageNamed:@"my_icon_list"];
    [locationView addSubview:locationImageView];
    
    UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, SCREENWIDTH - 50, 40)];
    locationLabel.font = [UIFont systemFontOfSize:14.0];
    locationLabel.textColor = RGBA(0x303030, 1);
    locationLabel.text = @"重庆复地新成就";
    [locationView addSubview:locationLabel];
    
    [self.view addSubview:locationView];
    
    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT +40, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - 40)];
    [self.view addSubview:myScrollView];
    
    CGFloat sectionY = 0;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionY + 10, 5, 15)];
    lineView.backgroundColor  = RGBA(0x00a7ff, 1);
    [myScrollView addSubview:lineView];
    UILabel *markTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, sectionY + 10, 100, 15)];
    markTitle.textColor = RGBA(0x303030, 1);
    markTitle.font = [UIFont systemFontOfSize:16.0];
    markTitle.text = @"我的圈子";
    [myScrollView  addSubview:markTitle];
    sectionY += 10 + 15 + 10;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    UICollectionView *myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, sectionY, SCREENWIDTH, 120)collectionViewLayout:layout];
    [myCollectionView registerNib:[UINib nibWithNibName:@"HappenCell" bundle:nil] forCellWithReuseIdentifier:@"HappenCell"];
    myCollectionView.backgroundColor = [UIColor whiteColor];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [myScrollView addSubview:myCollectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;

    sectionY += 120 +10;
    
    for (int i = 0; i<_myArr.count; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionY + 5, 5, 15)];
        lineView.backgroundColor = RGBA(0x00a7ff, 1);
        [myScrollView addSubview:lineView];
        
        UILabel *typeName = [[UILabel alloc]initWithFrame:CGRectMake(20, sectionY, 150, 25)];
        typeName.font = [UIFont systemFontOfSize:16.0];
        typeName.textColor = RGBA(0x303030, 1);
        typeName.text = _myArr[i].name;
        [myScrollView addSubview:typeName];
        CGFloat yy = sectionY + 45;
        for (int j = 0; j<_myArr[i].data.count/3 +(_myArr[i].data.count%3 ==0?0:1); j++) {
            for (int k = 0; k<3; k++) {
                if (j*3 + (k+1)>_myArr[i].data.count) {
                    continue;
                }
                
                UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(10 + k*((SCREENWIDTH - 10*2)/3.0), yy, (SCREENWIDTH - 10*2)/3.0, 130)];
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, (SCREENWIDTH - 10*2)/3.0, 20)];
                nameLabel.text = _myArr[i].data[j*3 +k].name;
                nameLabel.font = [UIFont systemFontOfSize:13.0];
                nameLabel.textColor = RGBA(0x606060, 1);
                nameLabel.textAlignment =NSTextAlignmentCenter;
                [myView addSubview:nameLabel];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(((SCREENWIDTH - 10*2)/3.0 - 80)/2.0, 0, 80, 80)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:_myArr[i].data[j*3 + k].icon] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
                [myView addSubview:imageView];
                
                UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake( 0 , 0 , (SCREENWIDTH - 10*2)/3.0, 110)];
                btn.tag = j*3 + (k+1) + i*100;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [myView addSubview:btn];
                [myScrollView addSubview:myView];
            }
            yy = yy + 130;
        }
        sectionY = sectionY + (_myArr[i].data.count/3 +(_myArr[i].data.count%3 ==0?0:1))*130 + 90;
    }
    myScrollView.contentSize = CGSizeMake(SCREENWIDTH, sectionY);
}
- (void)btnClick:(UIButton *)btn{
    
}

- (void)btnChoseClick:(UIButton *)btn{
    CGFloat gap = (SCREENWIDTH - 55*2)/3.0;
    CGFloat btnWidth = (SCREENWIDTH - gap*2)/2.0;
    if (btn == _perimeterBtn) {
        _lineViewFlag.center = CGPointMake(gap + btnWidth/2.0 + btnWidth, 40-2);
        [_perimeterBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        [_districtAffairsBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
    }else{
        _lineViewFlag.center = CGPointMake(gap + btnWidth/2.0, 40-2);
        [_perimeterBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [_districtAffairsBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
    }
}
#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HappenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HappenCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HappenCell" owner:self options:nil] lastObject];
    }
    cell.img.image = [UIImage imageNamed:@"home_btn_menjin"];
    cell.name.text = @"小区麻友";
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
    EstablishCircleVC *page = [[EstablishCircleVC alloc]init];
    [self.navigationController pushViewController:page animated:YES];
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
