//
//  FirstStepVerificationOfIdentityVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FirstStepVerificationOfIdentityVC.h"
#import "SecondStepVerificationOfIdentityVC.h"
#import "NewRoomDataModel.h"
#import "XXTextField.h"
@interface FirstStepVerificationOfIdentityVC ()
{
    NSString *buildingId;
    NSString *unitIds;
    NSString *roomId;
    NSString *flourId;
    XXInputView *inputView;
}
@property (nonatomic,strong)NSMutableArray <NewRoomDataList *>*buildingArr;
@property (nonatomic,strong)NSMutableArray <NewRoomDataList *>*unitArr;
@property (nonatomic,strong)NSMutableArray <NewRoomDataList *>*roomArr;
@property (nonatomic,strong)NSMutableArray <NewRoomDataList *>*flourArr;
@end

@implementation FirstStepVerificationOfIdentityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextStep.layer.cornerRadius = 20;
    self.nextStep.layer.masksToBounds = YES;
    self.navHight.constant = NAVHEIGHT;
    self.backViewHight.constant = 200 - 64 + NAVHEIGHT;
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    _city.text = storage.currentCity;
    _village.text = storage.choseUnitName;
    [self backViewColor];

    _buildingArr = [NSMutableArray array];
    _unitArr = [NSMutableArray array];
    _roomArr = [NSMutableArray array];
    _flourArr = [NSMutableArray array];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)backViewColor{
    //实现背景渐变
    
    //初始化我们需要改变背景色的UIView，并添加在视图上
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREENWIDTH, 200 - 64 + NAVHEIGHT);
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.backView.layer insertSublayer:gradientLayer atIndex:0];
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)RGBA(0x00a7ff, 1).CGColor,
                             (__bridge id)RGBA(0x1392f4, 1).CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
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

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextStepBtnClick:(id)sender {
    if (roomId) {
        SecondStepVerificationOfIdentityVC *page = [[SecondStepVerificationOfIdentityVC alloc]init];
        page.identity = _identity;
        page.roomId = roomId;
        page.tips = self.tips.text;
        [self.navigationController pushViewController:page animated:YES];
    }else{
        [MBProgressHUD showError:@"请完善选择"];
    }
   
}

- (void)addBuilding{
    [XMJHttpTool postWithUrl:@"building/getDropdown" param:[StorageUserInfromation storageUserInformation].choseUnitPropertyId success:^(id responseObj) {
        [_buildingArr removeAllObjects];
        NSString * str = [responseObj mj_JSONObject];
       
        NewRoomDataModel *newRoomData = [NewRoomDataModel mj_objectWithKeyValues:str];
        if (newRoomData.code == 0) {
            [_buildingArr addObjectsFromArray:newRoomData.data];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)addUint:(NSString *)str{
    [XMJHttpTool postWithUrl:@"unit/getDropdown" param:str success:^(id responseObj) {
        [_unitArr removeAllObjects];
        NSString * str = [responseObj mj_JSONObject];
        NewRoomDataModel *newRoomData = [NewRoomDataModel mj_objectWithKeyValues:str];
        if (newRoomData.code == 0) {
            [_unitArr addObjectsFromArray:newRoomData.data];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)addRoom:(NSString *)str{
    [XMJHttpTool postWithUrl:@"house/getDropdown" param:str success:^(id responseObj) {
        [_roomArr removeAllObjects];
        NSString * str = [responseObj mj_JSONObject];
        NewRoomDataModel *newRoomData = [NewRoomDataModel mj_objectWithKeyValues:str];
        if (newRoomData.code == 0) {
            [_roomArr addObjectsFromArray:newRoomData.data];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)addFlour:(NSString *)str{
    [XMJHttpTool postWithUrl:@"floor/getDropdown" param:str success:^(id responseObj) {
        [_flourArr removeAllObjects];
        NSString * str = [responseObj mj_JSONObject];
        NewRoomDataModel *newRoomData = [NewRoomDataModel mj_objectWithKeyValues:str];
        if (newRoomData.code == 0) {
            [_flourArr addObjectsFromArray:newRoomData.data];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)choseBtnClick:(id)sender {
    if (inputView) {
        [inputView hide];
    }
    UIButton *btn = sender;
    switch (btn.tag) {
        case 10:
        {
            [MBProgressHUD showMessage:@""];
            
            [ZTHttpTool sendGroupPostRequest:^{
                [self addBuilding];
            } success:^{
                if (_buildingArr.count == 0) {
                    [MBProgressHUD hideHUD];
                    
                    [MBProgressHUD showError:@"暂无楼栋"];
                    return ;
                }
                inputView = [[XXInputView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) mode:XXPickerViewModeDataSourceForColumn dataSource:_buildingArr];
                inputView.hideSeparator = YES;
                __weak typeof(buildingId) weakBuildingId = buildingId;
                WeakSelf
                inputView.completeBlock = ^(NSString *dateString,NSString *ids){
                    NSLog(@"selected data : %@", dateString);
                    StrongSelf
                    if (weakBuildingId) {
                        if (![ids isEqualToString:weakBuildingId]) {
                            strongSelf.buildingName.text = dateString;
                            buildingId = ids;
                            strongSelf.unitName.text = @"请选择";
                            unitIds = nil;
                            strongSelf.roomNum.text = @"请选择";
                            roomId = nil;
                            strongSelf.flourName.text = @"请选择";
                            flourId = nil;
                            strongSelf.buildingName.textColor = RGBA(0x606060, 1);
                            strongSelf.unitName.textColor = RGBA(0xc0c0c0, 1);
                            strongSelf.roomNum.textColor = RGBA(0xc0c0c0, 1);
                            strongSelf.flourName.textColor = RGBA(0xc0c0c0, 1);
                            strongSelf.buildingName.font = [UIFont systemFontOfSize:16.0];
                            strongSelf.unitName.font = [UIFont systemFontOfSize:14.0];
                            strongSelf.roomNum.font = [UIFont systemFontOfSize:14.0];
                            strongSelf.flourName.font = [UIFont systemFontOfSize:14.0];


                        }
                    }else{
                        strongSelf.buildingName.text = dateString;
                        buildingId = ids;
                         strongSelf.buildingName.textColor = RGBA(0x606060, 1);
                        strongSelf.buildingName.font = [UIFont systemFontOfSize:16.0];

                    }
                    
                    
                };
                
                [self.view addSubview:inputView];
                [inputView show];
                [MBProgressHUD hideHUD];
                
            } failure:^(NSArray *errorArray) {
                [MBProgressHUD hideHUD];
            }];
            
        }
            break;
        case 20:
        {
            if (!buildingId) {
                [MBProgressHUD showError:@"请选择楼栋"];
                break;
            }
            [MBProgressHUD showMessage:@""];
            
            [ZTHttpTool sendGroupPostRequest:^{
                [self addUint:buildingId];
            } success:^{
                if (_unitArr.count == 0) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"暂无单元"];
                    return ;
                }
                inputView = [[XXInputView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) mode:XXPickerViewModeDataSourceForColumn dataSource:_unitArr];
                inputView.hideSeparator = YES;
                __weak typeof(unitIds) weakUnitIds = unitIds;
                WeakSelf
                inputView.completeBlock = ^(NSString *dateString,NSString *ids){
                    NSLog(@"selected data : %@", dateString);
                    StrongSelf
                    if (weakUnitIds) {
                        if (![ids isEqualToString:weakUnitIds]) {
                            strongSelf.unitName.text = dateString;
                            unitIds = ids;
                            strongSelf.roomNum.text = @"请选择";
                            roomId = nil;
                            strongSelf.flourName.text = @"请选择";
                            flourId = nil;
                            strongSelf.unitName.textColor = RGBA(0x606060, 1);
                            strongSelf.roomNum.textColor = RGBA(0xc0c0c0, 1);
                            strongSelf.flourName.textColor = RGBA(0xc0c0c0, 1);
                            strongSelf.unitName.font = [UIFont systemFontOfSize:16.0];
                            strongSelf.roomNum.font = [UIFont systemFontOfSize:14.0];
                            strongSelf.flourName.font = [UIFont systemFontOfSize:14.0];
                        }
                    }else{
                        strongSelf.unitName.text = dateString;
                        unitIds = ids;
                        strongSelf.unitName.textColor = RGBA(0x606060, 1);
                        strongSelf.unitName.font = [UIFont systemFontOfSize:16.0];

                    }
                };
                
                [self.view addSubview:inputView];
                [inputView show];
                [MBProgressHUD hideHUD];
                
            } failure:^(NSArray *errorArray) {
                [MBProgressHUD hideHUD];
            }];
            
        }
            break;
        case 30:
        {
            if (!unitIds) {
                [MBProgressHUD showError:@"请选择单元"];
                break;
            }
            [MBProgressHUD showMessage:@""];
            
            [ZTHttpTool sendGroupPostRequest:^{
                [self addFlour:unitIds];
            } success:^{
                if (_flourArr.count == 0) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"暂无楼层"];
                    return ;
                }
                inputView = [[XXInputView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) mode:XXPickerViewModeDataSourceForColumn dataSource:_flourArr];
                inputView.hideSeparator = YES;
                __weak typeof(flourId) weakFlourId = flourId;
                WeakSelf
                inputView.completeBlock = ^(NSString *dateString,NSString *ids){
                    NSLog(@"selected data : %@", dateString);
                    StrongSelf
                    if (weakFlourId) {
                        if (![ids isEqualToString:weakFlourId]) {
                            strongSelf.flourName.text = dateString;
                            flourId = ids;
                            strongSelf.roomNum.text = @"请选择";
                            roomId = nil;
                            strongSelf.flourName.textColor = RGBA(0x606060, 1);
                            strongSelf.roomNum.textColor = RGBA(0xc0c0c0, 1);
                            strongSelf.flourName.font = [UIFont systemFontOfSize:16.0];
                            strongSelf.unitName.font = [UIFont systemFontOfSize:14.0];

                        }
                    }else{
                        strongSelf.flourName.text = dateString;
                        flourId = ids;
                        strongSelf.flourName.textColor = RGBA(0x606060, 1);
                        strongSelf.flourName.font = [UIFont systemFontOfSize:16.0];
                    }
                };
                
                [self.view addSubview:inputView];
                [inputView show];
                [MBProgressHUD hideHUD];
                
            } failure:^(NSArray *errorArray) {
                [MBProgressHUD hideHUD];
            }];
        }
            
            break;
        case 40:
        {
            if (!flourId) {
                [MBProgressHUD showError:@"请选择楼层"];
                break;
            }
            [MBProgressHUD showMessage:@""];
            
            [ZTHttpTool sendGroupPostRequest:^{
                [self addRoom:flourId];
            } success:^{
                if (_roomArr.count == 0) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"暂无户号"];
                    return ;
                }
                inputView = [[XXInputView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) mode:XXPickerViewModeDataSourceForColumn dataSource:_roomArr];
                inputView.hideSeparator = YES;
                WeakSelf
                inputView.completeBlock = ^(NSString *dateString,NSString *ids){
                    StrongSelf
                    NSLog(@"selected data : %@", dateString);
                    strongSelf.roomNum.text = dateString;
                    roomId = ids;
                    strongSelf.roomNum.textColor = RGBA(0x606060, 1);
                    strongSelf.roomNum.font = [UIFont systemFontOfSize:16.0];
                };
                
                [self.view addSubview:inputView];
                [inputView show];
                [MBProgressHUD hideHUD];
                
            } failure:^(NSArray *errorArray) {
                [MBProgressHUD hideHUD];
            }];
        }
            break;
        default:
            break;
    }
}

- (IBAction)addRoomNoBtnClick:(id)sender {
    
}
@end
