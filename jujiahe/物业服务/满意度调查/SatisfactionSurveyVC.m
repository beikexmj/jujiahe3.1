//
//  SatisfactionSurveyVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/10.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "SatisfactionSurveyVC.h"
#import "AXRatingView.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "HJInputView.h"
#import "ServiceMemberVC.h"
@interface SatisfactionSurveyVC ()
@property (nonatomic,strong)NSArray *headerImgArr;
@property (nonatomic,strong)HJInputView *adviceTextView;
@property (nonatomic,strong)UILabel *textNumLabel;
@property (nonatomic,strong)UIButton *submitBtn;
@property (nonatomic,strong)UIImageView *commentImageView;
@property (nonatomic,strong)UILabel *tipLable;
@property (nonatomic,strong)UIView *commentContentView;
@property (nonatomic,strong)UILabel *mesageCallBack;
@property (nonatomic,strong)UIView *adviceView;
@end

@implementation SatisfactionSurveyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _headerImgArr =[NSArray array];
    _headerImgArr = [NSArray arrayWithObjects:@"per_head",@"per_head",@"per_head",@"per_head",@"per_head",@"per_head",@"per_head",@"per_head",@"per_head",@"per_head",@"per_head", nil];
    [self setNav];
    [self viewConfig];
    [self bottomView];
    // Do any additional setup after loading the view.
}
- (void)setNav{
    UIView *headerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 160+ NAVHEIGHT -64)];
    headerBackView.backgroundColor = RGBA(0x00a7ff, 1);
    
    
    //实现背景渐变
    
    //初始化我们需要改变背景色的UIView，并添加在视图上
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREENWIDTH, 160 - 64 + NAVHEIGHT);
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [headerBackView.layer insertSublayer:gradientLayer atIndex:0];
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)RGBA(0x00a7ff, 1).CGColor,
                             (__bridge id)RGBA(0x1396ff, 1).CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
    [self.view addSubview:headerBackView];
    self.isShowNav = YES;
    self.lineView.hidden = YES;
    self.titleLabel.textColor = RGBA(0xffffff, 1);
    self.titleLabel.text = @"满意度调查";
    self.navView.backgroundColor = [UIColor clearColor];
    self.leftImgName = @"icon_back_white";
}
- (void)viewConfig{
    UIView *midleView = [[UIView alloc]initWithFrame:CGRectMake(15, NAVHEIGHT + 10, SCREENWIDTH  - 30, 160)];
    midleView.backgroundColor = RGBA(0xffffff, 1);
    midleView.layer.cornerRadius = 5.0;
    midleView.layer.shadowColor = RGBA(0x000000, 1).CGColor;
    midleView.layer.shadowOpacity = 0.5;
    midleView.layer.shadowOffset = CGSizeMake(0, 0);
    midleView.layer.shadowRadius = 5.0;
    [self.view addSubview:midleView];
    
    UIView *imgContenerView = [[UIView alloc]init];
    NSInteger numMax = 6;
    if (SCREENWIDTH <= 320) {
        numMax = 5;
    }else if (SCREENWIDTH <=375){
        numMax = 6;
    }else if (SCREENWIDTH <= 414){
        numMax = 7;
    }
    NSInteger realNum = _headerImgArr.count;
    if (realNum>numMax) {
        realNum = numMax;
        imgContenerView.frame = CGRectMake(10, 25, (realNum+1)*45 -5, 40);
    }else{
        imgContenerView.frame = CGRectMake(10, 25, realNum*45 -5, 40);
    }
    [midleView addSubview:imgContenerView];
    imgContenerView.center = CGPointMake((SCREENWIDTH - 30)/2.0, 45.0);
    for (int i = 0; i<realNum; i++) {
        UIImageView *headerImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(i*45, 0, 40, 40)];
        headerImageView.image = [UIImage imageNamed:_headerImgArr[i]];
        headerImageView.layer.cornerRadius = 20;
        headerImageView.layer.masksToBounds = YES;
        [imgContenerView addSubview:headerImageView];
    }
    if (realNum<_headerImgArr.count) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(realNum*45, 20, 45, 20)];
        label.text = [NSString stringWithFormat:@"...%ld人",_headerImgArr.count];
        label.textColor = RGBA(0x606060, 1);
        label.font = [UIFont systemFontOfSize:14.0];
        [imgContenerView addSubview:label];
    }
    UILabel *propertyName = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, SCREENWIDTH - 50, 25)];
    propertyName.font = [UIFont systemFontOfSize:15.0];
    propertyName.textColor = RGBA(0x303030, 1);
    propertyName.textAlignment = NSTextAlignmentCenter;
    propertyName.text = @"重庆金科物业";
    [midleView addSubview:propertyName];
    
    UIButton *serviceMemberBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    serviceMemberBtn.center = CGPointMake((SCREENWIDTH - 30)/2.0, 132.5);
    serviceMemberBtn.layer.cornerRadius = 12.5;
    serviceMemberBtn.layer.borderWidth = 1;
    serviceMemberBtn.layer.borderColor = RGBA(0x00a7ff, 1).CGColor;
    [serviceMemberBtn setTitle:@"查看服务团队" forState:UIControlStateNormal];
    [serviceMemberBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
    [serviceMemberBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [serviceMemberBtn addTarget:self action:@selector(serviceMemberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [midleView addSubview:serviceMemberBtn];
}
- (void)bottomView{
    UIScrollView *myscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT +10 + 160, SCREENWIDTH, SCREENHEIGHT - ( NAVHEIGHT +10 + 160) - 90)];
    CGFloat y = 0;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, y + 30.0, SCREENWIDTH, 30)];
    label.textColor = RGBA(0x606060, 1);
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger month= [components month];
    label.text = [[NSString alloc]initWithFormat:@"请您对我们%ld月服务满意度评价",month];
    [myscrollView addSubview:label];
    y += 60;
    CGRect componentBounds = (CGRect){
        (SCREENWIDTH -100)/2.0, y + 15.0,
        100, 32.0
    };
    AXRatingView *ratingView = [[AXRatingView alloc] initWithFrame:componentBounds];
    [ratingView setStepInterval:1.0];
    ratingView.value = 0;
    [ratingView setBaseColor:RGBA(0x606060, 1)];
    ratingView.userInteractionEnabled = YES;
    [ratingView addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
    [ratingView sizeToFit];
    [myscrollView addSubview:ratingView];
    y += 47;
    
    _tipLable = [[UILabel alloc]initWithFrame:CGRectMake(0, y+ 5, SCREENWIDTH, 20)];
    _tipLable.textColor = RGBA(0x9c9c9c, 1);
    _tipLable.textAlignment = NSTextAlignmentCenter;
    _tipLable.font = [UIFont systemFontOfSize:15.0];
    _tipLable.text =@"满意度";
    [myscrollView addSubview:_tipLable];
    y += 25;
    
    _commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 60, y + 20 - 60, 60, 60)];
    _commentImageView.image = [UIImage imageNamed:@"home_sat_evaluation"];
    [myscrollView addSubview:_commentImageView];
    _commentImageView.hidden = YES;
    
    _adviceView = [[UIView alloc]initWithFrame:CGRectMake(0, y + 20, SCREENWIDTH, 150)];
    _adviceView.backgroundColor = RGBA(0xf6f6f6, 1);
    [myscrollView addSubview:_adviceView];
    
    _commentContentView = [[UIView alloc]initWithFrame:CGRectMake(0, y + 20, SCREENWIDTH, 150)];
    [myscrollView addSubview:_commentContentView];
    _commentContentView.hidden = YES;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    lineView.backgroundColor = RGBA(0xeaeef1, 1);
    [_commentContentView addSubview:lineView];
    
    UILabel *mesageCallBackName = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, 80, 20)];
    mesageCallBackName.textColor = RGBA(0x9c9c9c, 1);
    mesageCallBackName.font = [UIFont systemFontOfSize:14.0];
    mesageCallBackName.text = @"留言反馈";
    [_commentContentView addSubview:mesageCallBackName];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 120, 25, 100, 20)];
    time.textColor = RGBA(0x9c9c9c, 1);
    time.font = [UIFont systemFontOfSize:14.0];
    time.textAlignment = NSTextAlignmentRight;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString=[dateFormatter stringFromDate:[NSDate date]];
    time.text = dateString;
    [_commentContentView addSubview:time];
    
    
   _mesageCallBack = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, SCREENWIDTH - 30, 0)];
    _mesageCallBack.textColor = RGBA(0x303030, 1);
    _mesageCallBack.font = [UIFont systemFontOfSize:15.0];
    _mesageCallBack.text = @"留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈留言反馈";
    _mesageCallBack.numberOfLines = 0;
    [_commentContentView addSubview:_mesageCallBack];
    
    y += 170;
    _adviceTextView = [[HJInputView alloc]initWithFrame:CGRectMake(20, 10, SCREENWIDTH - 40, 110)];
    _adviceTextView.textV.frame = CGRectMake(0, 0, SCREENWIDTH - 40, 110);
    _adviceTextView.textV.backgroundColor = [UIColor clearColor];
    _adviceTextView.textV.textColor = RGBA(0x606060, 1);
    _adviceTextView.textV.font = [UIFont systemFontOfSize:15.0];
    _adviceTextView.placeholerLabel.text = @"留下您的宝贵意见让我们改进（选填）";
    [[_adviceTextView.textV.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        if (value.length>=100) {
            _adviceTextView.textV.attributedText = [_adviceTextView.textV.attributedText attributedSubstringFromRange:NSMakeRange(0, 100)];
        }
        return value.length<=100;
    }] subscribeNext:^(NSString * _Nullable x) {
        if (x.length) {
            [_adviceTextView.placeholerLabel removeFromSuperview];
            UITextRange *selectedRange = [_adviceTextView.textV markedTextRange];
            NSString * newText = [_adviceTextView.textV textInRange:selectedRange]; //获取高亮部分
            if(newText.length>0)
                return;
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 3;// 字体的行间距
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle};
            _adviceTextView.textV.attributedText = [[NSAttributedString alloc] initWithString:_adviceTextView.textV.text attributes:attributes];
            
        }else{
            [_adviceTextView.textV addSubview:_adviceTextView.placeholerLabel];
        }
        _textNumLabel.text = [NSString stringWithFormat:@"%ld/100",x.length];
        
    }] ;
    [_adviceView addSubview:_adviceTextView];
    //文字数量
    _textNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 120 + 5, 120, 20)];
    _textNumLabel.textAlignment = NSTextAlignmentLeft;
    _textNumLabel.font = [UIFont systemFontOfSize:12];
    [_textNumLabel setTextColor:RGBCOLOR(192, 192, 192)];
    _textNumLabel.text = @"0/100";
    [_adviceView addSubview:_textNumLabel];
    
    
    myscrollView.contentSize = CGSizeMake(SCREENWIDTH, y);
    [self.view addSubview:myscrollView];
    
    _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, SCREENHEIGHT - 90, SCREENWIDTH  - 60, 40)];
    _submitBtn.backgroundColor = RGBA(0xc0c0c0, 1);
    _submitBtn.layer.cornerRadius = 20;
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
}
- (void)ratingChanged:(AXRatingView *)sender
{
//    [self.slider setValue:[sender value]];
//    [self.label setText:[NSString stringWithFormat:@"set and get: %.2f", sender.value]];
}
- (void)leftButtonClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)submitBtnClick:(UIButton *)btn{
    _commentImageView.hidden = NO;
    _commentContentView.hidden = NO;
    _submitBtn.hidden = YES;
    _adviceView.hidden = YES;
    _mesageCallBack.text = _adviceTextView.textV.text;
   CGRect frame = _mesageCallBack.frame;
    frame.size.height = [_mesageCallBack sizeThatFits:CGSizeMake(SCREENWIDTH - 30, 100)].height;
    _mesageCallBack.frame = frame;
}
- (void)serviceMemberBtnClick:(UIButton *)btn{
    ServiceMemberVC *page = [[ServiceMemberVC alloc]init];
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
