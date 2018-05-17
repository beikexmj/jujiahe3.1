//
//  RegestViewController.m
//  copooo
//
//  Created by 夏明江 on 16/9/14.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "RegestViewController.h"
#import "registDataModle.h"
//#import "NewPaymentAccountTwoViewController.h"
//#import "JPUSHService.h"
//#import "NewPropertyRoomNoViewController.h"
#import "AppDelegate.h"
#import "BaseTabbarVC.h"
#import "YYText.h"
#import "MyWebVC.h"
@interface RegestViewController ()
{
    BOOL flag;
}
@end

@implementation RegestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    flag = YES;
    self.navHight.constant = NAVHEIGHT;
    self.submitBtn.layer.cornerRadius = 5;
    self.password.secureTextEntry = !self.password.secureTextEntry;
    
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button1_normal"] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button1_press"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREENWIDTH -20)*1/8.0;
    
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 3; //设置行间距
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSString *ruleStr = @"我已阅读并同意《居家合服务协议与隐私》";
    
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:ruleStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSParagraphStyleAttributeName:paraStyle}];
    WeakSelf
    [attrStr1 yy_setTextHighlightRange:NSMakeRange(7, ruleStr.length-7) color:RGBA(0x00A7FF, 1) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        StrongSelf
        MyWebVC *page = [[MyWebVC alloc]init];
        page.titleStr = @"协议及隐私";
        page.url = [NSString stringWithFormat:@"%@%@", BASE_URL2,@"/jujiaheDocument/jujiaheuser/privacy.html"];
        [strongSelf.navigationController pushViewController:page animated:YES];
    }];
    YYLabel *yyRule = [YYLabel new];
    _rule.hidden = YES;
    CGRect frame = _rule.frame;
    frame.size.height = [StorageUserInfromation getStringSizeWith2:ruleStr withStringFont:12.0 withWidthOrHeight:SCREENWIDTH-64 lineSpacing:3.0].height +8;
    yyRule.frame = frame;
    yyRule.attributedText = attrStr1;
    [self.view addSubview:yyRule];
    
    
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)regestBtnClick:(id)sender {
    if ([JGIsBlankString isBlankString:self.phoneNum.text]) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.password.text]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if ([self.password.text length]<6) {
        [MBProgressHUD showError:@"请输入6位或以上密码"];
        return;
    }
    if ([self.password.text length]>20) {
        [MBProgressHUD showError:@"密码长度超过20位"];
        return;
    }
    if (![StorageUserInfromation judgePassWordLegal:self.password.text]) {
        [MBProgressHUD showError:@"密码只能包含可见字符"];
        return;
    }
    
    for(int i=0; i< [self.password.text length];i++){
        int a = [self.password.text characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            [MBProgressHUD showError:@"密码不能包含中文"];
            return;
        }

    }
    if ([JGIsBlankString isBlankString:self.code.text]) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    if (!flag) {
        [MBProgressHUD showError:@"你需要同意居家合服务协议与隐私条款"];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.phoneNum.text forKey:@"username"];
    [defaults setObject:self.password.text forKey:@"password"];
//
    NSDictionary *dict = @{@"phone":self.phoneNum.text,@"password":self.password.text,@"verifyCode":self.code.text,@"loginStatus":@"0"};
    [XMJHttpTool postWithUrl:@"user/register" param:dict success:^(id responseObj) {
      
        registDataModle *user = [registDataModle yy_modelWithJSON:[responseObj mj_JSONObject]];
        if (user.success) {
            [MBProgressHUD showSuccess:@"注册成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:user.message];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];

    }];
}
- (IBAction)sendCodeBtnClick:(id)sender {
    if ([JGIsBlankString isBlankString:self.phoneNum.text]) {
        [MBProgressHUD showError:@"请输入注册手机号"];
        return;
    }
    if (![StorageUserInfromation valiMobile:self.phoneNum.text]) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    NSDictionary *dict = @{@"phone":self.phoneNum.text};
    [XMJHttpTool postWithUrl:@"user/registerVerifyCode" param:dict success:^(id responseObj) {
        NSDictionary * dictData = [responseObj mj_JSONObject];
        [MBProgressHUD showSuccess:dictData[@"message"]];
        if ([dictData[@"success"] boolValue] == YES) {
            [self startTime];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];

    }];
}
-(void)startTime{
    if ([JGIsBlankString isBlankString:self.phoneNum.text]) {
        return;
    }
    if (![StorageUserInfromation valiMobile:self.phoneNum.text]) {
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
                [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _codeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_codeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _codeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (IBAction)passwordVisualBtnClick:(id)sender {
    self.password.secureTextEntry = !self.password.secureTextEntry;
}
-(void)login{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:@"roomNo"];
    //用于绑定Tag的 根据自己想要的Tag加入，值得注意的是这里Tag需要用到NSSet
//    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
//    [JPUSHService setAlias:storage.userId callbackSelector:nil object:nil];
    NSLog(@"%d %s",__LINE__,__PRETTY_FUNCTION__);

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
}

-(void)nextPage{
    //用于绑定Alias的  使用NSString 即可
//    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
//    [JPUSHService setAlias:storage.userId callbackSelector:nil object:nil];
    NSLog(@"%d %s",__LINE__,__PRETTY_FUNCTION__);

//    NewPropertyRoomNoViewController * page = [[NewPropertyRoomNoViewController alloc]init];
//    page.comFromFlag = 1;
//    [self.navigationController pushViewController:page animated:YES];
    
}
- (IBAction)ruleChoseBtnClick:(id)sender {
    if (flag) {
        [_ruleChoseBtn setImage:[UIImage imageNamed:@"login_unchoice"] forState:UIControlStateNormal];
    }else{
        [_ruleChoseBtn setImage:[UIImage imageNamed:@"login_choice"] forState:UIControlStateNormal];
    }
    flag = !flag;
}
@end
