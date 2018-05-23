//
//  FamilyDynamicVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyDynamicVC.h"
#import "FamilyWarningVC.h"
#import "peopleIMView.h"
#import "XXTextField.h"
#import "YYText.h"
#import "DynamicVC.h"

@interface FamilyDynamicVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIGestureRecognizerDelegate>{
    BMKMapView* _mapView;//
    BMKLocationService *_locService;//定位类
    BMKPointAnnotation *_pointAnnotation;
    BMKGeoCodeSearch* _geocodesearch;
    NSArray *imageArr;
    NSArray *locationArr;
    
    CLLocationCoordinate2D userLocationCoordinate;
    
    XXInputView *inputView;
    UIView *maskView;
    NSMutableArray *buildArr;
    UIButton *chooseBtn;
    
    UIView *attrStrView;
    YYLabel *yyRule;
    UILabel *label;
    
    CGFloat attrStrViewWidth;
}


@end

@implementation FamilyDynamicVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geocodesearch.delegate=self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate=nil;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;
    //禁止页面左侧滑动返回，注意，如果仅仅需要禁止此单个页面返回，还需要在viewWillDisapper下开放侧滑权限
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_mapView];
    _locService = [[BMKLocationService alloc]init];
    [self position];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    maskView.backgroundColor = RGBA(0x000000, 0.3);
    
    buildArr=[[NSMutableArray alloc]initWithArray:@[@"重庆南坪万达",@"重庆财富中心",@"重庆高科",@"重庆解放碑",@"观音桥"]];
    
    [self setBtnUI];
    
    [self setAttrStr];
    
}

-(void)setBtnUI{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(-10, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"icon_back_gray"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    chooseBtn.backgroundColor=[UIColor redColor];
    [chooseBtn setTitle:@"重庆财富中心" forState:UIControlStateNormal];
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chooseBtn setImage:[UIImage imageNamed:@"icon_drop"] forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(chooseClick) forControlEvents:UIControlEventTouchUpInside];
    [self setBtn:chooseBtn];
    [self.view addSubview:chooseBtn];
    [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage imageNamed:@"home_family_btn_update"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
    
    UIButton *IMBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [IMBtn setImage:[UIImage imageNamed:@"home_family_btn_talk"] forState:UIControlStateNormal];
    [IMBtn addTarget:self action:@selector(IMBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:IMBtn];
    
    UIButton *currentPositionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [currentPositionBtn setImage:[UIImage imageNamed:@"home_family_btn_position"] forState:UIControlStateNormal];
    [currentPositionBtn addTarget:self action:@selector(currentPositionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currentPositionBtn];
    
    UIButton *familyWarningBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [familyWarningBtn setImage:[UIImage imageNamed:@"home_family_btn_family"] forState:UIControlStateNormal];
    [familyWarningBtn addTarget:self action:@selector(familyWarningBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:familyWarningBtn];
    
    [currentPositionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-30);
        make.width.height.mas_equalTo(44);
    }];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentPositionBtn);
        make.bottom.equalTo(currentPositionBtn.mas_top).with.offset(-20);
        make.width.height.mas_equalTo(44);
    }];
    
    [familyWarningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-10);
        make.bottom.equalTo(self.view).with.offset(-30);
        make.width.height.mas_equalTo(44);
    }];
    
    [IMBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(familyWarningBtn);
        make.bottom.equalTo(currentPositionBtn.mas_top).with.offset(-20);
        make.width.height.mas_equalTo(44);
    }];
    
    
}

-(void)setBtn:(UIButton*)chooseBtn1{
//    CGFloat    space = 5;// 图片和文字的间距
    NSString    * titleString = [NSString stringWithFormat:@"%@", chooseBtn1.titleLabel.text];
    CGFloat    titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    UIImage    * btnImage = [UIImage imageNamed:@"icon_drop"];// 11*6
    CGFloat    imageWidth = btnImage.size.width;
//    CGFloat    imageHeight = chooseBtn1.imageView.image.size.height;
    CGFloat    titleHeight = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].height;
    
    [chooseBtn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageWidth*0.5, 0, imageWidth*0.5)];
    [chooseBtn1 setImageEdgeInsets:UIEdgeInsetsMake(titleHeight, titleWidth*0.5, -titleHeight, -titleWidth*0.5)];
}

-(void)setAttrStr{
    attrStrView=[[UIView alloc]init];
    [attrStrView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    attrStrView.layer.cornerRadius=15;
    attrStrView.layer.masksToBounds=YES;
    [self.view addSubview:attrStrView];
    [attrStrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(-275);
        make.top.equalTo(self.view).with.offset(120);
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [delBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [attrStrView addSubview:delBtn];
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(attrStrView);
        make.centerY.equalTo(attrStrView);
        make.height.width.mas_equalTo(30);
    }];
    
    yyRule = [YYLabel new];
    [attrStrView addSubview:yyRule];
    [self setYYLabelValue:@"张三"];
    
    attrStrView.hidden=YES;
}

-(void)setYYLabelValue:(NSString*)name{
    
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineSpacing = 3; //设置行间距
//    paraStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;//ab...cd

    NSString *ruleStr =[NSString stringWithFormat:@"家人%@离开安全围栏查看详情",name];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize   sizeC = CGSizeMake(MAXFLOAT ,30);
    CGSize   sizeFileName = [ruleStr boundingRectWithSize:sizeC
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:dic
                                                     context:nil].size;
    
    attrStrViewWidth=sizeFileName.width+25+34;
    attrStrViewWidth=attrStrViewWidth>SCREEN_WIDTH?SCREEN_WIDTH:attrStrViewWidth;
    [attrStrView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(attrStrViewWidth);
        if (attrStrView.hidden) {
            make.left.equalTo(self.view).with.offset(-attrStrViewWidth);
        }
        
    }];
    
    
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:ruleStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    @weakify(self);
    [attrStr1 yy_setTextHighlightRange:NSMakeRange(ruleStr.length-4, 4) color:RGBA(0x07D7F6, 1) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        [self.navigationController pushViewController:[FamilyWarningVC new] animated:YES];
    }];
    yyRule.attributedText = attrStr1;
    [yyRule setLineBreakMode:NSLineBreakByTruncatingMiddle];
//    yyRule.backgroundColor=[UIColor redColor];
    [yyRule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(attrStrView).with.offset(25);
        make.centerY.equalTo(attrStrView);
        make.right.equalTo(attrStrView).with.offset(-30);
        make.height.mas_equalTo(30);
    }];
    
}

//- (void)mapViewFitAnnotations:(NSArray<CLLocation *> *)locations
-(void)mapViewFitAnnotations:(NSArray*)locations
{
    if (locations.count < 2) return;
    
//    CLLocationCoordinate2D coor = [locations[0] coordinate];
    CLLocationCoordinate2D coor = (CLLocationCoordinate2D){[locations[0][0] floatValue],[locations[0][1] floatValue]};
   
    BMKMapPoint pt = BMKMapPointForCoordinate(coor);
    
    CGFloat ltX, ltY, rbX, rbY;
    
    ltX = pt.x; ltY = pt.y;
    rbX = pt.x; rbY = pt.y;
    
    for (int i = 1; i < locations.count; i++) {
        
//        CLLocationCoordinate2D coor = [locations[i] coordinate];
         CLLocationCoordinate2D coor = (CLLocationCoordinate2D){[locations[i][0] floatValue],[locations[i][1] floatValue]};
        
        
        BMKMapPoint pt = BMKMapPointForCoordinate(coor);
        
        if (pt.x < ltX) ltX = pt.x;
        if (pt.x > rbX) rbX = pt.x;
        if (pt.y > ltY) ltY = pt.y;
        if (pt.y < rbY) rbY = pt.y;
    }
    
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel -1;
    NSLog(@"-------%f--------",_mapView.zoomLevel);
}


-(void)position{
    [_locService startUserLocationService];
    _mapView.zoomLevel = 18; //地图等级，数字越大越清晰
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode =BMKUserTrackingModeFollow; //设置定位的跟随状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    
    [self performSelector:@selector(refreshMap) withObject:self afterDelay:0.5];
    
    
}

-(void)refreshMap{
    
    [_mapView removeAnnotations: _mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    
    imageArr=@[@"pro_btn_invitation",@"pro_btn_news",@"my_icon_pro3",@"my_icon_pro3"];
 locationArr=@[@[@"29.611000",@"106.510000"],@[@"29.616000",@"106.513000"],@[@"29.618000",@"106.515000"],@[@"29.628000",@"106.565000"]];
//    [self mapViewFitAnnotations:locationArr];
    
    for (int i=0; i<imageArr.count; i++) {
        _pointAnnotation = [[BMKPointAnnotation alloc] init];
        _pointAnnotation.coordinate = (CLLocationCoordinate2D){[locationArr[i][0] floatValue],[locationArr[i][1] floatValue]};
        
//        _pointAnnotation.title = @"我在这个地方";
//        _pointAnnotation.subtitle = @"你在哪呢";
        [_mapView addAnnotation:_pointAnnotation];
//        [_mapView selectAnnotation:_pointAnnotation animated:YES];
    }
    
    
}

/**
 *在地图View将要启动定位时，会调用此函数
 * mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    //    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    _mapView.centerCoordinate = userLocation.location.coordinate;
    //    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    //   NSLog(@"用户坐标----%f,---%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    userLocationCoordinate = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 * _mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 * _mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]){
        
        BMKPinAnnotationView * newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.canShowCallout=NO;//不显示气泡 设置这个是为了在不设置title的情况下，标注也能接收到点击事件
        
        //此处加for循环 去找annotation对应的序号标题
        for (int i=0; i<imageArr.count; i++) {
            
            CGFloat lat = [locationArr[i][0] floatValue];
            CGFloat lng =  [locationArr[i][1] floatValue];

            //通过判断给相对应的标注添加序号标题
            if(annotation.coordinate.latitude == lat && annotation.coordinate.longitude ==  lng )
            {
//                newAnnotationView.image = [UIImage imageNamed:imageArr[i]];
                newAnnotationView.clipsToBounds=NO;
                newAnnotationView.frame=CGRectMake(0, 0, 50, 50);
                newAnnotationView.layer.cornerRadius=25;
                newAnnotationView.layer.shadowOffset = CGSizeMake(0, 0);
                newAnnotationView.layer.shadowOpacity = 1;
                newAnnotationView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                newAnnotationView.layer.shadowRadius = 3;
                newAnnotationView.image = nil;
  
                
                UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
                bgImageView.image = [UIImage imageNamed:imageArr[i]];
                                [newAnnotationView addSubview:bgImageView];
                bgImageView.layer.cornerRadius = 25; //设置imageView的圆角
                bgImageView.layer.masksToBounds = YES;

                [newAnnotationView addSubview:bgImageView];
            
                break;
            }
        }
        
        
        return newAnnotationView;
    }
   return nil;
}

//当选中一个annotation views时，调用此接口
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{

    NSLog(@"选中一个annotation:-------%f,--------%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
    
    peopleIMView *aaView = [[[NSBundle mainBundle] loadNibNamed:@"peopleIMView" owner:self options:nil] lastObject];
    aaView.frame=self.view.bounds;
    aaView.peopleName.text = @"小明";
    aaView.address.text = @"当前位置:重庆市渝北区黄山大道68号木星";
    aaView.phonenumber=@"15683931812";
    aaView.coordinate=view.annotation.coordinate;
    
    [self.view addSubview:aaView];
    
    [view setSelected:NO];
    

//    if ([view.annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        //取出piAnnoarray中的每个标注
//        for (int i = 0; i<[piAnnoarray count]; i++) {
//
//            BMKPinAnnotationView *pinAnnotation = [[BMKPinAnnotationView alloc]init];
//            pinAnnotation = [piAnnoarray objectAtIndex:i];
//            //判断他的selected状态
//            if(pinAnnotation.selected )
//            {
//
//                pinAnnotation.image = view.image = [UIImage imageNamed:@"mapannotation_up"];
//                //重新计算Frame，如果你用的图片大小一样，则不需要重新计算 设置图片一定要放到计算<span style="font-family: Arial, Helvetica, sans-serif;">Frame的前面</span>
//
//                [self SetAonnotionLaFrame:pinAnnotation labelTag:i];
//
//                /// 设置当前地图的中心点 把选中的标注作为地图中心点
//                [_mapView setCenterCoordinate:pinAnnotation.annotation.coordinate animated:YES] ;
//            }
//            else{
//
//                pinAnnotation.image = [UIImage imageNamed:@"mapannotation_down"];
//
//                //重新计算Frame
//                [self SetAonnotionLaFrame:pinAnnotation labelTag:i];
//            }
//
//        }
//
//
//    }
    
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {
        NSLog(@"%@ - %@ - %@ - %@ - %@", result.addressDetail.province, result.addressDetail.city, result.addressDetail.streetName, result.address, result.businessCircle);
    } else {
        NSLog(@"找不到");
    }
    
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//家人动态 跳转
-(void)familyWarningBtnClick{
#if 0
    [self.navigationController pushViewController:[FamilyWarningVC new] animated:YES];
#else
    [self.navigationController pushViewController:[DynamicVC new] animated:YES];
#endif
}

//-(void)IMBtnClick{
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){29.611000,106.510000};
//
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeocodeSearchOption.reverseGeoPoint = pt;
//    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }
//}

-(void)IMBtnClick{
    if (attrStrView.hidden) {
        attrStrView.hidden=NO;
        [self setYYLabelValue:@"李四王"];
        [self animationView];
    }else{
        [self setYYLabelValue:@"王五哈哈哈王五哈哈哈王五哈哈哈王五哈哈哈"];
        
    }
    
    
}

-(void)currentPositionBtnClick{
    _mapView.centerCoordinate = userLocationCoordinate;

}

-(void)refreshBtnClick{
    [self refreshMap];
}

-(void)chooseClick{
//    if (_flourArr.count == 0) {
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"暂无楼层"];
//        return ;
//    }
    inputView = [[XXInputView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) mode:XXPickerViewModeProvinceCityAreasColumn dataSource:buildArr];
    inputView.hideSeparator = YES;
    __weak typeof (maskView) weakMaskView = maskView;
    __weak typeof (chooseBtn) chooseBtn1 = chooseBtn;

    @weakify(self);
    inputView.completeBlock = ^(NSString *dateString,NSString *ids){
        NSLog(@"selected data : %@", dateString);
        @strongify(self);
        [chooseBtn1 setTitle:dateString forState:UIControlStateNormal];
        [self setBtn:chooseBtn1];
        [weakMaskView removeFromSuperview];
    };
    inputView.cancleBlock = ^{
        [weakMaskView removeFromSuperview];
    };
    [self.view addSubview:maskView];
    [self.view addSubview:inputView];
    [inputView show];
//    [MBProgressHUD hideHUD];ƒ
}

-(void)delBtnClick{
    [UIView animateWithDuration:0.5f animations:^{
        [attrStrView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(-attrStrViewWidth);
        }];
        [self.view layoutIfNeeded];//这里是关键

    } completion:^(BOOL finished) {
        attrStrView.hidden=YES;
    }];
    
}

-(void)animationView{
//    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5f animations:^{
        [attrStrView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(-15);
        }];
        [self.view layoutIfNeeded];//这里是关键
        //        self.backView.alpha = 0.35;//透明度的变化依然和老方法一样
    } completion:^(BOOL finished) {

    }];
}

@end
