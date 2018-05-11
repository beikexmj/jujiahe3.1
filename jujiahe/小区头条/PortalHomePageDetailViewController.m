//
//  PortalHomePageDetailViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/27.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "PortalHomePageDetailViewController.h"
#import <WebKit/WebKit.h>
@interface PortalHomePageDetailViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *myWebView;
@end

@implementation PortalHomePageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+22;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    [self addUIData];
    // Do any additional setup after loading the view from its nib.
}
- (void)addUIData{
    UIView * myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, MAXFLOAT)];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 3; //设置行间距
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:RGBCOLOR(48, 48, 48)};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:_onceList.titlePrimary attributes:dic];
    titleLabel.attributedText = attributeStr;
    
    CGFloat height = [StorageUserInfromation getStringSizeWith:_onceList.titlePrimary withStringFont:17.0 withWidthOrHeight:SCREEN_WIDTH-30].height;
    titleLabel.frame = CGRectMake(15, 15, SCREEN_WIDTH-30, height + 15);
    [myView addSubview:titleLabel];
    
    UILabel *segTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, height +30, 80, 21)];
    segTitle.font = [UIFont systemFontOfSize:15.0];
    segTitle.textColor = RGBCOLOR(192, 192, 192);
    
    switch ([_onceList.newsType integerValue]) {
        case 0:
            {
            segTitle.text = @"桂东电力";
            }
            break;
        case 1:
        {
            segTitle.text = @"电价法规";

        }
            break;
        case 2:
        {
            segTitle.text = @"公共信息";

        }
            break;
        case 3:
        {
            segTitle.text = @"帮助";

        }
            break;
        default:
            break;
    }
    [myView addSubview:segTitle];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(115, height +30, 120, 21)];
    time.textColor = RGBCOLOR(192, 192, 192);
    time.font  = [UIFont systemFontOfSize:15.0];
    time.text = [StorageUserInfromation timeStrFromDateString:_onceList.updateTime];
    
    [myView addSubview:time];
    [self.myScrollView addSubview:myView];
    myView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+30+21+15);
    
    _myWebView  = [[WKWebView alloc]initWithFrame:CGRectMake(0, myView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _myWebView.navigationDelegate = self;
    [self.myScrollView addSubview:_myWebView];
    [_myWebView loadHTMLString:_onceList.content baseURL:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [webView evaluateJavaScript:@"Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)"
              completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                  if (!error) {
                      NSNumber *height = result;
                      // do with the height
                      _myWebView.frame = CGRectMake(0, _myWebView.frame.origin.y, SCREEN_WIDTH, [height floatValue]);
                      self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _myWebView.frame.origin.y + [height floatValue]);
                      
                  }
              }];
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
@end
