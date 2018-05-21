//
//  CommunityDetailVC.m
//  jujiahe
//
//  Created by 夏明江 on 2018/5/21.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CommunityDetailVC.h"
#import <WebKit/WebKit.h>
#import "AllServiceDataModel.h"

@interface CommunityDetailVC ()<WKUIDelegate>
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong)UIButton *signUpBtn;
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong)UILabel *readNum;
@property (nonatomic,strong)UILabel *time;
@property (nonatomic,assign)CGFloat WebViewHeight;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong) NSArray <AllServiceArr*> *myArr;
@end

@implementation CommunityDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    _backButton.hidden = NO;
    self.titleLabel.text = _titleStr;
    [self.view addSubview:self.myScrollView];
    [self.myScrollView addSubview:self.readNum];
    [self.myScrollView addSubview:self.time];
    [self.myScrollView addSubview:self.webView];
    [self.myScrollView addSubview:self.signUpBtn];
    self.readNum.text = @"阅读：2000";
    self.time.text = @"12:20";
    [self.view addSubview:self.bottomView];
    [self dataWithBottomView];
    // Do any additional setup after loading the view.
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
                [self dataWithBottomView];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (UIScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT)];
    }
    return _myScrollView;
}
- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 10, 40, 0)];
        _webView.UIDelegate = self;
    }
    return _webView;
}
- (UILabel *)readNum{
    if (!_readNum) {
        _readNum = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 20)];
        _readNum.textColor = RGBA(0x9c9c9c, 1);
        _readNum.font = [UIFont systemFontOfSize:13.0];
    }
    return _readNum;
}
- (UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 115, 10, 100, 20)];
        _time.textColor = RGBA(0x9c9c9c, 1);
        _time.font = [UIFont systemFontOfSize:13.0];
        _time.textAlignment = NSTextAlignmentRight;
    }
    return _time;
}
- (UIButton *)signUpBtn{
    if (!_signUpBtn) {
        _signUpBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, SCREENHEIGHT - TABBARHEIGHT - 40, SCREENWIDTH - 60, 40)];
        _signUpBtn.backgroundColor = RGBA(0x00a7ff, 1);
        _signUpBtn.layer.cornerRadius = 20;
        _signUpBtn.layer.masksToBounds = YES;
        [_signUpBtn setTitle:@"报名" forState:UIControlStateNormal];
        [_signUpBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [_signUpBtn.titleLabel setTextColor:RGBA(0xffffff, 1)];
    }
    return _signUpBtn;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 40, SCREEN_WIDTH, 0)];
        _bottomView.backgroundColor = RGBA(0xffffff, 1);
    }
    return _bottomView;
}
- (void)dataWithBottomView{
    
    CGFloat sectionY = 0;
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    topLineView.backgroundColor = RGBA(0xeaeef1, 1);
    sectionY +=10;
    [self.bottomView addSubview:topLineView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionY + 10, 5, 15)];
    lineView.backgroundColor  = RGBA(0x00a7ff, 1);
    [self.bottomView addSubview:lineView];
    UILabel *markTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, sectionY + 10, 100, 15)];
    markTitle.textColor = RGBA(0x303030, 1);
    markTitle.font = [UIFont systemFontOfSize:16.0];
    markTitle.text = @"猜你喜欢";
    [self.bottomView  addSubview:markTitle];
    sectionY += 10 + 15 + 10;
    
    for (int i = 0; i<_myArr.count; i++) {
        CGFloat yy = sectionY;
        for (int j = 0; j<_myArr[i].data.count/2 +(_myArr[i].data.count%2 ==0?0:1); j++) {
            for (int k = 0; k<2; k++) {
                if (j*2 + (k+1)>_myArr[i].data.count) {
                    continue;
                }

                UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(10 + k*((SCREENWIDTH - 50)/2.0), yy, (SCREENWIDTH - 50)/2.0, (SCREENWIDTH - 50)/2.0)];

               

                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + k*((SCREENWIDTH - 50)/2.0), yy, (SCREENWIDTH - 50)/2.0, (SCREENWIDTH - 50)/2.0)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:_myArr[i].data[j*2 + k].icon] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
                [myView addSubview:imageView];
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  (SCREENWIDTH - 50)/2.0 - 30,  (SCREENWIDTH - 50)/2.0, 30)];
                nameLabel.text = _myArr[i].data[j*2 +k].name;
                nameLabel.font = [UIFont systemFontOfSize:13.0];
                nameLabel.textColor = RGBA(0xffffff, 1);
                nameLabel.backgroundColor = RGBA(0x000000, 0.5);
                nameLabel.textAlignment =NSTextAlignmentCenter;
                [myView addSubview:nameLabel];
                UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake(10 + k*((SCREENWIDTH - 50)/2.0), yy, (SCREENWIDTH - 50)/2.0, (SCREENWIDTH - 50)/2.0)];
                btn.tag = j*2 + (k+1) + i*100;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [myView addSubview:btn];
                [_bottomView addSubview:myView];
            }
            yy = yy + 130;
        }
        sectionY = sectionY + (_myArr[i].data.count/2 +(_myArr[i].data.count%2 ==0?0:1))*(SCREENWIDTH - 50)/2.0 + 30;
    }
   CGRect rect = _bottomView.frame;
    rect.size.height  = sectionY;
    _bottomView.frame = rect;
    [self.webView loadHTMLString:@"12327483247237943732732483" baseURL:nil];

}
- (void)btnClick:(UIButton *)btn{
//    CircleVC *page = [[CircleVC alloc]init];
//    [self.navigationController pushViewController:page animated:YES];
}
// 页面加载完成之后调用 此方法会调用多次
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    __block CGFloat webViewHeight;
    self.WebViewHeight = webView.frame.size.height;
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以，但如果是和我一样直接加载原站内容使用前者更合适
        //获取页面高度，并重置webview的frame
        webViewHeight = [result doubleValue];
        NSLog(@"%f",webViewHeight);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (webViewHeight != self.WebViewHeight) {
                webView.frame = CGRectMake(0, 40, self.view.frame.size.width, webViewHeight);
                CGRect rect =  _bottomView.frame;
                rect.origin.y = webViewHeight +40;
                _bottomView.frame = rect;
                self.myScrollView.contentSize = CGSizeMake(SCREENWIDTH, webViewHeight + 40 + _bottomView.frame.size.height);
            }
        });
    }];
    
    NSLog(@"结束加载");
    
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
