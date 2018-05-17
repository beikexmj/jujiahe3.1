//
//  SecondStepVerificationOfIdentityVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "SecondStepVerificationOfIdentityVC.h"
#import "TZImagePickerController.h"
#import "HJEditImageViewController.h"
#import "HJPhotoPickerView.h"
#import "HJTableViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import "BaseTabbarVC.h"
#import "HomePageVC.h"
#define IMAGE_SIZE (SCREEN_WIDTH - 60)/4

@interface SecondStepVerificationOfIdentityVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
{
    NSMutableArray *imageArr;//上传的图片数组；
    BOOL deleteBtnIndecate;//删除按钮显示与否 YES == 显示 NO== 不显示；

}
/** UITableView*/
@property(nonatomic, strong)UITableView *tabelV;
@property(nonatomic, strong)UITextField *relationship;//关系
@property(nonatomic, strong)UITextField *name;//姓名
@property(nonatomic, strong)UITextField *telphone;//手机号
@property(nonatomic, strong)UITextField *identityCard;//身份证
@property(nonatomic, strong)UITextField *verificationCode;//验证码
@property(nonatomic, strong)UIButton *verificationCodeBtn;//验证码按钮
@property(nonatomic,strong)UIView *fatherView;
/** 选择图片*/
@property(nonatomic, strong)    HJPhotoPickerView *photoPickerV;
/** 图片编辑起*/
@property(nonatomic, strong)    HJEditImageViewController *editVC;
/** 当前选择的图片*/
@property(nonatomic, strong)    NSMutableArray *imageDataSource;
@end

@implementation SecondStepVerificationOfIdentityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navHight.constant = NAVHEIGHT;
    self.backViewHight.constant = 200 - 64 + NAVHEIGHT;
    self.nextStepBtn.layer.cornerRadius = 20;
    self.nextStepBtn.layer.masksToBounds = YES;
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    _city.text = storage.currentCity;
    _village.text = storage.choseUnitName;
    deleteBtnIndecate = NO;
    [self backViewColor];
    [self viewConfig];
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
-(UITextField *)name{
    if (!_name) {
        _name = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREENWIDTH - 98, 40)];
        if (_identity == Owner) {
            _name.placeholder = @"请正确填写业主姓名";
        }else if(_identity == Tenant){
            _name.placeholder = @"请正确填写租客姓名";
        }else if (_identity == FamilyMembers){
            _name.placeholder = @"请正确填写您的姓名";
        }
        _name.textColor = RGBA(0x303030, 1);
        _name.font = [UIFont systemFontOfSize:16.0];
    }
    return _name;
}
-(UITextField *)telphone{
    if (!_telphone) {
        _telphone = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREENWIDTH - 98, 40)];
        if (_identity == Owner) {
            _telphone.placeholder = @"请输入在物管处预留手机号";
        }else if(_identity == Tenant){
            _telphone.placeholder = @"请输入租客手机号";
        }else if (_identity == FamilyMembers){
            _telphone.placeholder = @"请输入您的手机号";
        }
        _telphone.textColor = RGBA(0x303030, 1);
        _telphone.font = [UIFont systemFontOfSize:16.0];
    }
    return _telphone;
}
-(UITextField *)identityCard{
    if (!_identityCard) {
        _identityCard = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREENWIDTH - 98, 40)];
        if (_identity == Owner) {
            _identityCard.placeholder = @"请输入业主身份证（选填）";
        }else if(_identity == Tenant){
            _identityCard.placeholder = @"请输入租客身份证（选填）";
        }else if (_identity == FamilyMembers){
            _identityCard.placeholder = @"请输入您的身份证（选填）";
        }
        _identityCard.textColor = RGBA(0x303030, 1);
        _identityCard.font = [UIFont systemFontOfSize:16.0];
    }
    return _identityCard;
}
-(UITextField *)relationship{
    if (!_relationship) {
        _relationship = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREENWIDTH - 98, 40)];
        _relationship.placeholder = @"请输入您与业主的关系";
        _relationship.textColor = RGBA(0x303030, 1);
        _relationship.font = [UIFont systemFontOfSize:16.0];
    }
    return _relationship;
}
-(UITextField *)verificationCode{
    if (!_verificationCode) {
        _verificationCode = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, SCREENWIDTH - 98 - 85, 40)];
        _verificationCode.placeholder = @"请输入验证信息";
        _verificationCode.textColor = RGBA(0x303030, 1);
        _verificationCode.font = [UIFont systemFontOfSize:16.0];
    }
    return _verificationCode;
}
- (UIButton *)verificationCodeBtn{
    if (!_verificationCodeBtn) {
        _verificationCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 85, 0, 85, 40)];
        _verificationCodeBtn.backgroundColor = RGBA(0x00a7ff, 1);
        [_verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verificationCodeBtn.titleLabel setTextColor:RGBA(0xffffff, 1)];
        [_verificationCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_verificationCodeBtn addTarget:self action:@selector(verificationCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verificationCodeBtn;
}
- (void)viewConfig{
    _fatherView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
    _fatherView.backgroundColor =RGBA(0xeaeef1, 1);
    NSInteger height = 0;
    for (int i = 0; i<2; i++) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 10 + 50*i, SCREENWIDTH, 40)];
        myView.backgroundColor = RGBA(0xffffff, 1);
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 60, 21)];
        nameLable.textColor = RGBA(0x606060, 1);
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.text = @[@"姓  名",@"手机号"][i];
        [myView addSubview:nameLable];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 39, SCREENWIDTH - 10, 1)];
        lineView.backgroundColor = RGBA(0xeaeef1, 1);
        [myView addSubview:lineView];
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(70, 5, 1, 30)];
        lineView2.backgroundColor = RGBA(0xeaeef1, 1);
        [myView addSubview:lineView2];
        if (i == 0) {
            [myView addSubview:self.name];
        }else if (i == 1){
            [myView addSubview:self.telphone];
        }
        [_fatherView addSubview:myView];
        height += 50;
    }
    NSString *identityNameStr;
    if (_identity == Owner) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, height, SCREENWIDTH, 40)];
        myView.backgroundColor = RGBA(0xffffff, 1);
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 60, 21)];
        nameLable.textColor = RGBA(0x606060, 1);
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.font = [UIFont systemFontOfSize:15.0];
        nameLable.text = @"验证码";
        [myView addSubview:nameLable];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 39, SCREENWIDTH - 10, 1)];
        lineView.backgroundColor = RGBA(0xeaeef1, 1);
        [myView addSubview:lineView];
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(70, 5, 1, 30)];
        lineView2.backgroundColor = RGBA(0xeaeef1, 1);
        [myView addSubview:lineView2];
        [myView addSubview:self.verificationCode];
        [myView addSubview:self.verificationCodeBtn];
        [_fatherView addSubview:myView];
        height += 40;
        identityNameStr = @"业主";
    }else if(_identity == Tenant){
        identityNameStr = @"租客";
    }else if (_identity == FamilyMembers){
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, height + 10, SCREENWIDTH, 40)];
        myView.backgroundColor = RGBA(0xffffff, 1);
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 60, 21)];
        nameLable.textColor = RGBA(0x606060, 1);
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.font = [UIFont systemFontOfSize:15.0];
        nameLable.text = @"关  系";
        [myView addSubview:nameLable];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 39, SCREENWIDTH - 10, 1)];
        lineView.backgroundColor = RGBA(0xeaeef1, 1);
        [myView addSubview:lineView];
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(70, 5, 1, 30)];
        lineView2.backgroundColor = RGBA(0xeaeef1, 1);
        [myView addSubview:lineView2];
        [myView addSubview:self.relationship];
        [_fatherView addSubview:myView];
        height += 50;
        identityNameStr = @"家属";
    }
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, height + 10, SCREENWIDTH, 40)];
    myView.backgroundColor = RGBA(0xffffff, 1);
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 60, 21)];
    nameLable.textColor = RGBA(0x606060, 1);
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = [UIFont systemFontOfSize:15.0];
    nameLable.text = @"身份证";
    [myView addSubview:nameLable];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 39, SCREENWIDTH - 10, 1)];
    lineView.backgroundColor = RGBA(0xeaeef1, 1);
    [myView addSubview:lineView];
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(70, 5, 1, 30)];
    lineView2.backgroundColor = RGBA(0xeaeef1, 1);
    [myView addSubview:lineView2];
    [myView addSubview:self.identityCard];
    [_fatherView addSubview:myView];
    height += 50;
    
    UIView *tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, height + 10, SCREENWIDTH, 80)];
    tipsView.backgroundColor = RGBA(0xffffff, 1);
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 15, SCREENWIDTH - 32, 50)];
    tipsLabel.textColor = RGBA(0x606060, 1);
    tipsLabel.font = [UIFont systemFontOfSize:14.0];
    tipsLabel.numberOfLines = 0;
    ;
    tipsLabel.text = [NSString stringWithFormat:@"请上传能证明您是%@的一些文件照片，如购房合同、贷款合同等（最多9张，%@必填）",identityNameStr,[identityNameStr isEqualToString:@"业主"]?@"非":@""];
    [tipsView addSubview:tipsLabel];
    [_fatherView addSubview:tipsView];
    height +=90;
    _fatherView.frame = CGRectMake(0, 0, SCREENWIDTH, height);
    
    __weak typeof(self) weakSelf = self;

    // 图片选择视图
    _photoPickerV = [[HJPhotoPickerView alloc]init];
    _photoPickerV.frame = CGRectMake(0,  height, SCREENWIDTH, IMAGE_SIZE +10);
    _photoPickerV.deleteButton.hidden = YES;
    _photoPickerV.videoImageView.hidden = YES;
    _photoPickerV.reloadTableViewBlock = ^{
        [weakSelf.tabelV reloadData];
    };
    _photoPickerV.ACMediaClickDeleteButton = ^(NSInteger index) {
        [weakSelf.imageDataSource removeObjectAtIndex:index-1];
//        [weakSelf.imageDataSource addObject:weakSelf.photoPickerV.addImage];
        [weakSelf.photoPickerV setSelectedImages:weakSelf.imageDataSource];
        [weakSelf addTargetForImage];
        [weakSelf.tabelV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    };
    [self addTargetForImage];
    
    // 初始化图片数组
    _imageDataSource = [NSMutableArray array];
    [_imageDataSource addObject:_photoPickerV.addImage];
    
    // 初始化图片编辑控制器
    self.editVC = [[HJEditImageViewController alloc]init];
    
    _tabelV = [[UITableView alloc]initWithFrame:CGRectMake(0, 200 - 64 + NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - (200 - 64 + NAVHEIGHT) - 95) style:UITableViewStylePlain];
    _tabelV.backgroundColor = RGBA(0xffffff, 1);
    _tabelV.delegate = self;
    _tabelV.dataSource = self;
    _tabelV.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tabelV registerClass:[HJTableViewCell class] forCellReuseIdentifier:@"HJTableViewCell"];
    [self.view addSubview:_tabelV];
}
// 为图片添加点击事件
- (void)addTargetForImage{
    for (UIButton * button in _photoPickerV.imageViews) {
        [button addTarget:self action:@selector(addPhotos:) forControlEvents:UIControlEventTouchUpInside];
        if (![button isEqual:_photoPickerV.addImage]) {
            UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(picLongPress:)];
            [button addGestureRecognizer:gesture];
        }
    }
}
- (void)picLongPress:(UIGestureRecognizer*)gesture{
    if (deleteBtnIndecate == NO) {
        deleteBtnIndecate = YES;
        [_tabelV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
 
}
- (void)addPhotos:(UIButton *)button{
    
    
    if ([button.currentBackgroundImage isEqual:_photoPickerV.addImage]) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册选择", nil];
        [actionSheet showInView:self.view];
    }else{
            __weak typeof(self) weakSelf = self;
            _editVC = [[HJEditImageViewController alloc]init];
            _editVC.currentOffset = (int)button.tag;
            _editVC.reloadBlock = ^(NSMutableArray * images){
                weakSelf.photoPickerV.photoNum = 10;
                [weakSelf.photoPickerV setSelectedImages:images];
                [weakSelf addTargetForImage];
                [weakSelf.tabelV reloadData];
            };
            _editVC.images = _imageDataSource;
            [self.navigationController pushViewController:_editVC animated:YES];
        
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self openCamera];
    }else if (buttonIndex == 1){
        [self openPhotos];
    }
}
/** 打开相机 */
- (void)openCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //不支持拍照或模拟器系列
    }
}

#pragma mark - UIImagePickerController Delegate

///拍照、选视频图片、录像 后的回调（这种方式选择视频时，会自动压缩，但是很耗时间）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image = info[UIImagePickerControllerEditedImage];
        //压缩图片
        NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
        image = [UIImage imageWithData:fileData];
        //        //保存图片至相册
        //        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        [_imageDataSource removeLastObject];
        [_imageDataSource addObjectsFromArray:@[image]];
        [_imageDataSource addObject:_photoPickerV.addImage];
        self.photoPickerV.photoNum = 10;
        [self.photoPickerV setSelectedImages:_imageDataSource];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_imageDataSource];
        BOOL flag = [arr.lastObject isEqual:self.photoPickerV.addImage];
        if (flag) {
            [arr removeLastObject];
        }
        
        [self addTargetForImage];
        [self.tabelV reloadData];
        
    }else{
    }
    
    //todo: 后面有具体处理方法
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}




- (void)openPhotos {
    
    NSInteger num;
    BOOL flag = YES;
    num = 10;
    flag = NO;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:num - _imageDataSource.count delegate:self allowPickingVideo:flag];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
            [_imageDataSource removeLastObject];
            [_imageDataSource addObjectsFromArray:photos];
            [_imageDataSource addObject:_photoPickerV.addImage];
            self.photoPickerV.photoNum = 10;
            [self.photoPickerV setSelectedImages:_imageDataSource];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:_imageDataSource];
            BOOL flag = [arr.lastObject isEqual:self.photoPickerV.addImage];
            if (flag) {
                [arr removeLastObject];
            }
            [self addTargetForImage];
            [self.tabelV reloadData];
            
            
        }];
    
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
    
    
}
-(void)leftButtonClick:(UIButton *)button{
    if (_imageDataSource.count>1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"你有未发布的内容" message:@"确认离开？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 发布图片
- (void)publishImage{
    NSMutableArray *myArr = [NSMutableArray array];
    [myArr addObject:imageArr];
    NSMutableArray *subArr =[NSMutableArray array];
    for (int i = 1; i<=imageArr.count; i++) {
        [subArr addObject:@"file"];
    }
    [myArr addObject:subArr];
    [MBProgressHUD showMessage:@"图片上传中..."];
    [ZTHttpTool postWithImageUrl:@"file/upload" param:@{@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"sourceApp":@"property"} postImageArr:myArr mimeType:@"image/png" success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSString * str = [responseObj mj_JSONObject];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        if ([onceDict[@"success"] integerValue] == 1) {
            NSDictionary *comeBackDict = onceDict[@"data"];
            [self publishText:comeBackDict];
        }else{
            _nextStepBtn.enabled = YES;
            [MBProgressHUD showError:onceDict[@"message"]];
        }
    } failure:^(NSError *error) {
        _nextStepBtn.enabled = YES;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
        
    }];
}
#pragma mark 发布文字（适用于图片发布）
- (void)publishText:(NSDictionary *)onceDict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_roomId forKey:@"houseId"];
    [dict setValue:[StorageUserInfromation storageUserInformation].ids forKey:@"userId"];
    [dict setValue:[NSString stringWithFormat:@"%ld",_identity]  forKey:@"cardType"];

    [dict setValue:@"0"  forKey:@"ownerRelationShip"];
    [dict setValue:_tips  forKey:@"remark"];
    [dict setValue:_name.text  forKey:@"name"];
    [dict setValue:_telphone.text  forKey:@"tel"];
    [dict setValue:_identityCard.text  forKey:@"identityCard"];
    [dict setValue:@"0"  forKey:@"attachment"];
    [dict setValue:_verificationCode.text  forKey:@"smscode"];

    
    
    [XMJHttpTool postWithUrl:@"propertyCard/addBind" param:dict success:^(id responseObj) {
        _nextStepBtn.enabled = YES;
        NSString * str = [responseObj mj_JSONObject];
        NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        if ([dict[@"rcode"] integerValue] == 0) {
           
            [self homePage];
            
        }else{
            [MBProgressHUD showError:dict[@"rocde"]];
        }
    } failure:^(NSError *error) {
        _nextStepBtn.enabled = YES;
        [MBProgressHUD showError:@"网络异常"];
        
    }];
}
- (void)homePage{
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    if (!storage.userId) {
        storage.userId = @"";
        storage.token = @"";
        storage.access_token = @"";
        storage.nickname = @"";
        storage.sex = @"-1";
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BaseTabbarVC *tabBarController = [BaseTabbarVC Shareinstance];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tabBarController];
    nav.fd_fullscreenPopGestureRecognizer.enabled = true;
    nav.fd_prefersNavigationBarHidden = true;
    nav.fd_interactivePopDisabled = true;
    nav.fd_viewControllerBasedNavigationBarAppearanceEnabled = false;
    [nav setNavigationBarHidden:YES animated:YES];
    tabBarController.selectedIndex = 0;
    delegate.window.rootViewController = nav;
    HomePageVC *page = (HomePageVC *)tabBarController.viewControllers[0];
    if (page) {
        [page fetchData2];
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
- (void)verificationCodeBtnClick{
    if ([JGIsBlankString isBlankString:self.telphone.text]) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (![StorageUserInfromation valiMobile:self.telphone.text]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    NSDictionary *dict = @{@"phone":self.telphone.text};
    [ZTHttpTool postWithUrl:@"propertyCard/requestSmscode" param:dict success:^(id responseObj) {
        NSString * str = [responseObj mj_JSONObject];
        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] ==0) {
            [self startTime];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];
        
    }];
}
-(void)startTime{
    if ([JGIsBlankString isBlankString:self.telphone.text]) {
        return;
    }
    if (![StorageUserInfromation valiMobile:self.telphone.text]) {
        return;
    }
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_verificationCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _verificationCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_verificationCodeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _verificationCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextSetpBtnClick:(id)sender {
    if ([JGIsBlankString isBlankString:_name.text]) {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    if ([JGIsBlankString isBlankString:_telphone.text]) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (![StorageUserInfromation valiMobile:self.telphone.text]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    if (_identity == Owner) {
        
        if ([JGIsBlankString isBlankString:_verificationCode.text]) {
            [MBProgressHUD showError:@"请获取验证码"];
            return;
        }
    }
    if (_identity == FamilyMembers) {
        if ([JGIsBlankString isBlankString:_relationship.text]) {
            [MBProgressHUD showError:@"请输入您与业主的关系"];
            return;
        }
    }
    _nextStepBtn.enabled = NO;
    imageArr = [NSMutableArray arrayWithArray:_imageDataSource];
    BOOL flag = [imageArr.lastObject isEqual:self.photoPickerV.addImage];
    if (flag) {
        [imageArr removeLastObject];
    }
    if (imageArr.count == 0) {
        if (_identity == Tenant || _identity == FamilyMembers) {
            [MBProgressHUD showError:@"请选择图片"];
            return;
        }
    }
    if (imageArr.count>0) {
        [self publishImage];
    }else{
        [self publishText:nil];
    }
}

#pragma mark --------------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseID = @"HJTableViewCell";
    HJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    if (!cell ) {
        cell = [[HJTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell addSubview:_fatherView];
    [cell addSubview:_photoPickerV];

    for (UIButton *btn in _photoPickerV.subviews) {
        for (UIButton *subBtn in btn.subviews) {
            if (deleteBtnIndecate) {
                subBtn.hidden = NO;
            }else{
                subBtn.hidden = YES;
            }
        }
        [[btn viewWithTag:20] setHidden:YES];
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = _photoPickerV.frame.size.height + _photoPickerV.frame.origin.y + 10;
    if (!indexPath.section) return rowHeight;
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, CGFLOAT_MIN)];
    myView.backgroundColor = RGBA(0xeeeeee, 1);
    return myView;
}
#pragma mark --------------UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tabelV deselectRowAtIndexPath:indexPath animated:NO];
}
@end
