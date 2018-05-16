//
//  TopicDetailVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/16.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "TopicDetailVC.h"
#import "TopicCell.h"
#import "CommentTableViewController.h"
#import "PraiseTableViewController.h"
#import "XLPhotoBrowser.h"
#import "CommentViewController.h"
@interface TopicDetailVC ()<TableViewScrollingProtocol,XLPhotoBrowserDelegate,XLPhotoBrowserDatasource,UIActionSheetDelegate>
{
    CGFloat contentViewHeight;
    BOOL Flexflag;
    BOOL _stausBarColorIsBlack;
    UIButton *chossBtn;
    TopicCell *myCell;
    NSInteger indexPathRow;
    NSInteger totolPicNum;
    NSMutableArray *imageArr;
}
@property (nonatomic,strong)UIButton *followBtn;
@property (nonatomic,strong)UIView *headContentView;
@property (nonatomic,strong)UIButton *commentNumBtn;
@property (nonatomic,strong)UIButton *praiseNumBtn;
@property (nonatomic,strong)UIButton *commentBtn;
@property (nonatomic,strong)UIButton *praiseBtn;
@property (nonatomic,strong)UIView *lineViewFlag;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个tableview在Y轴上的偏移量
@property (nonatomic, weak) UITableViewController *showingVC;


@end

@implementation TopicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    Flexflag = YES;
    [self setNav];
    [self contentViewConfig];
    [self addController];
    [self addBottomBtn];
    [self btnChoseClick:_commentNumBtn];
    // Do any additional setup after loading the view.
}
- (void)setNav{
    self.isShowNav = YES;
    self.navView.backgroundColor = RGBA(0xf6f6f6, 1);
    self.lineView.hidden = YES;
    _backButton.hidden = NO;
    self.titleLabel.text = @"话题详情";
    
}
- (void)addBottomBtn{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - TABBARHEIGHT, SCREENWIDTH, TABBARHEIGHT)];
    bottomView.backgroundColor = RGBA(0xf6f6f6, 1);
    [self.view addSubview:bottomView];
    
    _commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/2.0, TABBARHEIGHT)];
    [_commentBtn setImage:[UIImage imageNamed:@"icon_评论"] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
    [_commentBtn setTitle:@" 评论" forState:UIControlStateNormal];
    [_commentBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [bottomView addSubview:_commentBtn];
    [_commentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _praiseBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH/2.0, 0, SCREENWIDTH/2.0, TABBARHEIGHT)];
    [_praiseBtn setImage:[UIImage imageNamed:@"icon_点赞1"] forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
    [_praiseBtn setTitle:@" 点赞" forState:UIControlStateNormal];
    [_praiseBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [bottomView addSubview:_praiseBtn];
    [_praiseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    lineView1.backgroundColor = RGBA(0xdbdbdb, 1);
    [bottomView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2.0, (TABBARHEIGHT - 40)/2.0, 1, 40)];
    lineView2.backgroundColor = RGBA(0xdbdbdb, 1);
    [bottomView addSubview:lineView2];
}
-(void)contentViewConfig{
    if (self.headContentView) {
        [self.headContentView removeFromSuperview];
    }
    self.headContentView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, _headerHeight + 10)];
    
    myCell = [[[NSBundle mainBundle] loadNibNamed:@"TopicCell" owner:self options:nil] lastObject];
    myCell.frame  =CGRectMake(0, 0, SCREENWIDTH, _headerHeight);
    [self.headContentView addSubview:myCell];
    [self initHeaderData];
    [self headerSwitchView:_headerHeight - 40];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, _headerHeight, SCREENWIDTH, 10)];
    lineView2.backgroundColor = RGBA(0xeaeef1, 1);
    [_headContentView addSubview:lineView2];
    
    
    contentViewHeight = _headerHeight + 10;
}
- (void)initHeaderData{
    myCell.bottomView.hidden = YES;
    myCell.imageFatherView.hidden = YES;
    myCell.oneImageView.hidden = YES;
    myCell.twoImageView.hidden = YES;
    myCell.threeOrMoreImageView.hidden = YES;
    myCell.firstRowInThreeImageView.hidden = YES;
    myCell.secondRowInThreeImageView.hidden = YES;
    myCell.thirdRowInThreeImageView.hidden = YES;
    myCell.firstRowHight.constant = 0;
    myCell.secondRowHight.constant = 0;
    myCell.thirdRowHight.constant = 0;
    myCell.picOneInOneImageViewToRight.constant = 0;
    myCell.picOneInOneImageView.contentMode = UIViewContentModeLeft;
    if (_dict) {
        CircleDataList *dict = _dict;
        NSInteger integer = dict.thumbPicUrls.count;
        if (dict.anon == 1) {
            myCell.headerIcon.image = [UIImage imageNamed:@"匿名头像"];
            myCell.name.text = @"匿名";
        }else{
            [myCell.headerIcon sd_setImageWithURL:[NSURL URLWithString:dict.avatar] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageRefreshCached|SDWebImageAllowInvalidSSLCertificates];
            myCell.name.text = dict.nickname;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapClick:)];
        myCell.headerIcon.userInteractionEnabled = YES;
        [myCell.headerIcon addGestureRecognizer:tap];
        
        
        myCell.time.text = [StorageUserInfromation timeStrFromDateString:dict.createTime];
        myCell.likeNum.text = dict.thumbUpCount;
        myCell.commentNum.text = dict.commentCount;
        if (dict.thumbUp) {
            [myCell.likeBtn setImage:[UIImage imageNamed:@"com_icon_praise2"] forState:UIControlStateNormal];
            myCell.likeNum.textColor = RGBA(0xff4e18, 1);
        }else{
            [myCell.likeBtn setImage:[UIImage imageNamed:@"com_icon_praise"] forState:UIControlStateNormal];
            myCell.likeNum.textColor = RGBA(0x606060, 1);
            
        }
        myCell.tag = 0;

        WeakSelf
        myCell.imageViewTapBlock = ^(NSInteger integer, UIImageView *imageView) {
            StrongSelf
            [strongSelf clickImage:imageView tag:integer totol:dict.thumbPicUrls.count];
        };
        myCell.content.text = [NSString stringWithFormat:@"#%@#%@",dict.tag,dict.content];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 3; //设置行间距
        paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:myCell.content.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1),NSParagraphStyleAttributeName:paraStyle}];
        
        CGFloat contentHeight = [StorageUserInfromation getStringSizeWith2:[NSString stringWithFormat:@"#%@#%@",dict.tag,dict.content] withStringFont:15.0 withWidthOrHeight:SCREENWIDTH-80 lineSpacing:8.0].height +8;
        if (contentHeight>75) {
            contentHeight = 75;
        }
        CGRect frame3 = myCell.content2.frame;
        frame3.size.height = contentHeight;
        myCell.content.frame = frame3;
        myCell.content.attributedText = attrStr;
        myCell.contentHight.constant = contentHeight;
        
        if (integer == 0) {
            
        }else if (integer == 1){
            myCell.imageFatherView.hidden = NO;
            myCell.oneImageView.hidden = NO;
            [myCell.picOneInOneImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[0]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                if (image.size.width>SCREENWIDTH -80) {
                    myCell.picOneInOneImageView.contentMode = UIViewContentModeScaleAspectFit;
                    if (SCREENWIDTH*(8/15.0) *(image.size.width/image.size.height)<SCREENWIDTH -80) {
                        myCell.picOneInOneImageViewToRight.constant = SCREENWIDTH -80 - SCREENWIDTH*(8/15.0) *(image.size.width/image.size.height);
                    }
                    
                }
            } ];
            myCell.picOneInOneImageView.layer.masksToBounds = YES;
        }else if (integer == 2){
            myCell.imageFatherView.hidden = NO;
            myCell.twoImageView.hidden = NO;
            [myCell.picOneInTwoImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[0]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
            [myCell.picTwoInTwoImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[1]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
        }else if (integer == 3){
            myCell.imageFatherView.hidden = NO;
            myCell.threeOrMoreImageView.hidden = NO;
            myCell.firstRowInThreeImageView.hidden = NO;
            myCell.firstRowHight.constant = (SCREENWIDTH - 80 - 5*2)/3.0;
            myCell.secondRowHight.constant = 0;
            myCell.thirdRowHight.constant = 0;
            [myCell.picOneInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[0]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
            [myCell.picTwoInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[1]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
            [myCell.picThreeInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[2]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
            
        }else if (integer == 4){
            myCell.imageFatherView.hidden = NO;
            myCell.threeOrMoreImageView.hidden = NO;
            myCell.firstRowInThreeImageView.hidden = NO;
            myCell.secondRowInThreeImageView.hidden = NO;
            myCell.firstRowHight.constant = (SCREENWIDTH - 80 - 5*2)/3.0;
            myCell.secondRowHight.constant = (SCREENWIDTH - 80 - 5*2)/3.0 + 5;
            myCell.thirdRowHight.constant = 0;
            myCell.picThreeInThreeOrMoreImageView.image = [UIImage imageNamed:@""];
            myCell.picSixInThreeOrMoreImageView.image = [UIImage imageNamed:@""];
            [myCell.picOneInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[0]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
            [myCell.picTwoInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[1]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
            [myCell.picFourInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[2]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
            [myCell.picFiveInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[3]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
        }else{
            myCell.imageFatherView.hidden = NO;
            myCell.threeOrMoreImageView.hidden = NO;
            myCell.firstRowInThreeImageView.hidden = NO;
            myCell.secondRowInThreeImageView.hidden = NO;
            if (integer >6) {
                myCell.thirdRowInThreeImageView.hidden = NO;
            }else{
                myCell.thirdRowInThreeImageView.hidden = YES;
            }
            myCell.firstRowHight.constant = (SCREENWIDTH - 80 - 5*2)/3.0;
            myCell.secondRowHight.constant = (SCREENWIDTH - 80 - 5*2)/3.0 + 5;
            if (integer>6) {
                myCell.thirdRowHight.constant = (SCREENWIDTH - 80 - 5*2)/3.0 + 5;
            }else{
                myCell.thirdRowHight.constant = 0;
            }
            
            
            [myCell.picOneInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[0] ] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
            [myCell.picTwoInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[1]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
            [myCell.picThreeInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[2]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
            [myCell.picFourInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[3]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
            
            myCell.picNightInThreeOrMoreImageView.image = [UIImage imageNamed:@""];
            myCell.picEightInThreeOrMoreImageView.image = [UIImage imageNamed:@""];
            myCell.picSevenInThreeOrMoreImageView.image = [UIImage imageNamed:@""];
            myCell.picSixInThreeOrMoreImageView.image = [UIImage imageNamed:@""];
            myCell.picFiveInThreeOrMoreImageView.image = [UIImage imageNamed:@""];
            
            switch (integer) {
                case 9:
                {
                    [myCell.picNightInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[8]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
                    
                }
                case 8:
                {
                    [myCell.picEightInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[7]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
                    
                }
                case 7:
                {
                    [myCell.picSevenInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[6]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
                    
                }
                case 6:
                {
                    [myCell.picSixInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[5]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
                    
                }
                case 5:
                {
                    [myCell.picFiveInThreeOrMoreImageView sd_setImageWithURL:[NSURL URLWithString:dict.thumbPicUrls[4]] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
                    
                }
                    break;
                default:
                    break;
            }
        }
    }
    
}
- (void)headerSwitchView:(CGFloat)y{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, y, SCREENWIDTH, 40)];
    myView.backgroundColor = RGBA(0xffffff, 1);
    [_headContentView addSubview:myView];
    CGFloat gap = (SCREENWIDTH - 55*2)/3.0;
    CGFloat btnWidth = (SCREENWIDTH - gap*2)/2.0;
    _commentNumBtn = [[UIButton alloc]initWithFrame:CGRectMake(gap - 20, 0, btnWidth, 40)];
    [_commentNumBtn setTitle:@"评论9999+" forState:UIControlStateNormal];
    [_commentNumBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_commentNumBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
    [_commentNumBtn addTarget:self action:@selector(btnChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _praiseNumBtn = [[UIButton alloc]initWithFrame:CGRectMake(gap -20 + btnWidth, 0, btnWidth, 40)];
    [_praiseNumBtn setTitle:@"点赞200" forState:UIControlStateNormal];
    [_praiseNumBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_praiseNumBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
    [_praiseNumBtn addTarget:self action:@selector(btnChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:_commentNumBtn];
    [myView addSubview:_praiseNumBtn];
    
    _lineViewFlag = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 2)];
    _lineViewFlag.backgroundColor = RGBA(0x00a7ff, 1);
    _lineViewFlag.center = CGPointMake(gap - 20 + btnWidth/2.0 + btnWidth, 40-2);
    [myView addSubview:_lineViewFlag];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
    lineView.backgroundColor = RGBA(0xdbdbdb, 1);
    [myView addSubview:lineView];
    
    
   UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 15 - 60, 0, 60, 40)];
    [moreBtn setImage:[UIImage imageNamed:@"com_icon_more"] forState:UIControlStateNormal];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:moreBtn];
    
}
/**
 *  浏览图片
 *
 */
- (void)clickImage:(UIImageView *)image tag:(NSInteger)integer totol:(NSInteger)sum
{
    NSInteger tag = integer%10 -1;
    indexPathRow = integer/10;
    totolPicNum = sum;
    if (totolPicNum == 4) {
        if (tag>=2) {
            tag -= 1;
        }
    }
    CircleDataList *onceList = _dict;
    imageArr = [NSMutableArray arrayWithArray:onceList.picUrls];
    // 快速创建并进入浏览模式
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:tag imageCount:imageArr.count datasource:self];
    
    //    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
    //    [browser setActionSheetWithTitle:@"这是一个类似微信/微博的图片浏览器组件" delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"发送给朋友",@"保存图片",@"投诉",nil];
    
    // 自定义pageControl的一些属性
    browser.pageDotColor = [UIColor lightGrayColor]; ///< 此属性针对动画样式的pagecontrol无效
    browser.currentPageDotColor = [UIColor whiteColor];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;///< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
}
#pragma mark    -   XLPhotoBrowserDatasource

- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    //    if (totolPicNum == 4) {
    //        if (index>=2) {
    //            index -= 1;
    //        }
    //        return  [NSURL URLWithString:imageArr[index]];
    //    }
    return  [NSURL URLWithString:imageArr[index]];
}
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return browser.sourceImageView.image;
}
- (UIImageView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
{
    if (totolPicNum == 1) {
        return myCell.picOneInOneImageView;
    }else if (totolPicNum == 2){
        return [myCell.twoImageView viewWithTag:index + indexPathRow*10 + 1];
    }else if (totolPicNum <= 3){
        
        return [myCell.firstRowInThreeImageView viewWithTag:index + indexPathRow*10 + 1];
        
    }else if (totolPicNum == 4){
        if (index<=1) {
            return [myCell.firstRowInThreeImageView viewWithTag:index + indexPathRow*10     +1];
        }else{
            return [myCell.secondRowInThreeImageView viewWithTag:index + 1 + indexPathRow*10+1];
        }
        
    }else if (totolPicNum > 4 && totolPicNum<=6){
        if (index<=2) {
            return [myCell.firstRowInThreeImageView viewWithTag:index + indexPathRow*10+1];
        }else{
            return [myCell.secondRowInThreeImageView viewWithTag:index + indexPathRow*10+1];
        }
        
        
    }else if (totolPicNum >= 7){
        if (index<=2) {
            return [myCell.firstRowInThreeImageView viewWithTag:index + indexPathRow*10+1];
        }else if (index>2 && index<=5){
            return [myCell.secondRowInThreeImageView viewWithTag:index + indexPathRow*10+1];
        }
        return [myCell.thirdRowInThreeImageView viewWithTag:index + indexPathRow*10+1];
        
    }
    return nil;
}
- (void)showActionSheet{
    CircleDataList *onceList = _dict;
    
    UIActionSheet *actionSheet;
    if ([onceList.userId isEqualToString:[StorageUserInfromation storageUserInformation].userId]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
    }else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
    }
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://举报//取消
        {
            if ([_dict.userId isEqualToString:[StorageUserInfromation storageUserInformation].userId]) {
                
                NSDictionary *dict = @{@"apiv":@"1.0",@"postId":_dict.postId};
                [ZTHttpTool postWithUrl:@"social/v1/post/deletePost" param:dict success:^(id responseObj) {
                    NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
                    NSDictionary *myDict = [DictToJson dictionaryWithJsonString:str];
                    NSLog(@"%@",myDict);
                    if ([myDict[@"rcode"] integerValue] == 0) {
                        [MBProgressHUD showSuccess:@"删除成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } failure:^(NSError *error) {
                    XMJLog(@"%@",error);
                    [MBProgressHUD showError:@"删除失败"];
                    
                }];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"举报成功" message:@"感谢您的反馈，我们将尽快处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)addController {
    CommentTableViewController *vc1 = [[CommentTableViewController alloc] init];
    vc1.delegate = self;
    vc1.postId = _dict.postId;
    PraiseTableViewController *vc2 = [[PraiseTableViewController alloc] init];
    vc2.delegate = self;
    vc2.postId = _dict.postId;
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
}
- (void)flexBtnClick{
    Flexflag = !Flexflag;
    [self contentViewConfig];
    
    if (chossBtn) {
        [self btnChoseClick:chossBtn];
    }else{
        [self btnChoseClick:_commentNumBtn];
    }
    
    
}
-(void)followBtnClick{
    
}
- (void)btnChoseClick:(UIButton *)btn{
    CGFloat gap = (SCREENWIDTH - 55*2)/3.0;
    CGFloat btnWidth = (SCREENWIDTH - gap*2)/2.0;
    if (btn == _praiseNumBtn) {
        _lineViewFlag.center = CGPointMake(gap - 20 + btnWidth/2.0 + btnWidth, 40-2);
        [_praiseNumBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        [_commentNumBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [self segmentedControlChangedValue:1];
    }else{
        _lineViewFlag.center = CGPointMake(gap - 20 + btnWidth/2.0, 40-2);
        [_praiseNumBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [_commentNumBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        [self segmentedControlChangedValue:0];
        
    }
    chossBtn = btn;
}
- (void)segmentedControlChangedValue:(NSInteger)tag {
    [_showingVC.view removeFromSuperview];
    
    BaseTableViewController *newVC = self.childViewControllers[tag];
    if (!newVC.view.superview) {
        //        [self.view addSubview:newVC.view];
        newVC.view.frame = CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT- TABBARHEIGHT);
    }
    
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    XMJLog(@"offsetY11111 ==== %.0f",offsetY);
    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentViewHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    newVC.tableView.tableHeaderView = headerView;
    newVC.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    [self.view insertSubview:newVC.view belowSubview:self.navView];
    if (offsetY <= contentViewHeight - 50) {
        [newVC.view addSubview:_headContentView];
        
        CGRect rect = _headContentView.frame;
        rect.origin.y = 0;
        _headContentView.frame = rect;
    }  else {
        [self.view insertSubview:_headContentView belowSubview:self.navView];
        CGRect rect = _headContentView.frame;
        rect.origin.y = NAVHEIGHT -contentViewHeight +50;
        _headContentView.frame = rect;
    }
    XMJLog(@"offsetY22222 ==== %.0f",_headContentView.frame.origin.y);
    
    _showingVC = newVC;
}

#pragma mark - Getter/Setter
- (NSMutableDictionary *)offsetYDict {
    if (!_offsetYDict) {
        _offsetYDict = [NSMutableDictionary dictionary];
        for (BaseTableViewController *vc in self.childViewControllers) {
            NSString *addressStr = [NSString stringWithFormat:@"%p", vc];
            _offsetYDict[addressStr] = @(CGFLOAT_MIN);
        }
    }
    return _offsetYDict;
}

#pragma mark - BaseTabelView Delegate
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY{
    if (offsetY > contentViewHeight - 50) {
        if (![_headContentView.superview isEqual:self.view]) {
            [self.view insertSubview:_headContentView belowSubview:self.navView];
        }
        CGRect rect = self.headContentView.frame;
        rect.origin.y = NAVHEIGHT -contentViewHeight +50;
        self.headContentView.frame = rect;
    } else {
        if (![_headContentView.superview isEqual:tableView]) {
            for (UIView *view in tableView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [tableView insertSubview:_headContentView aboveSubview:view];
                    break;
                }
            }
        }
        CGRect rect = self.headContentView.frame;
        rect.origin.y = 0;
        self.headContentView.frame = rect;
    }
    
}

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO;  这四行被屏蔽内容，每行下面一行的效果一样
    _headContentView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > contentViewHeight - 50) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= contentViewHeight - 50) {
                _offsetYDict[key] = @(contentViewHeight - 50);
            }
        }];
    } else {
        if (offsetY <= contentViewHeight - 50) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO; 这四行被屏蔽内容，每行下面一行的效果一样
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > contentViewHeight - 50) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            }
            //            else if ([_offsetYDict[key] floatValue] <= contentViewHeight - 50) {
            //                _offsetYDict[key] = @(contentViewHeight - 50);
            //            }
        }];
    } else {
        if (offsetY <= contentViewHeight - 50) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewWillBeginDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = YES; 这四行被屏蔽内容，每行下面一行的效果一样
}

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = YES; 这四行被屏蔽内容，每行下面一行的效果一样
}
- (void)headerTapClick:(UIGestureRecognizer *)tap{
    //    if([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
    //        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"未登录" message:@"确定跳回登录界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //        alert.tag = 10;
    //        [alert show];
    //        return;
    //    }
    CircleDataList *dict =_dict;
    if (dict.anon == 1 && (![dict.userId isEqualToString:[StorageUserInfromation storageUserInformation].userId])) {
        [MBProgressHUD showError:@"该用户匿名发帖，无法查看他的发帖信息"];
        return;
    }
}
- (void)moreBtnClick:(UIButton *)btn{
    
}
- (void)btnClick:(UIButton *)btn{
    if (btn == _commentBtn) {
        CommentViewController *page = [[CommentViewController alloc]init];
        page.targetUserId = @"";
        page.postId = _dict.postId;
        page.commentBlock = ^{
//            self.commentNum.text = [NSString stringWithFormat:@"评论 %@",_onceList.commentCount];
        };
        [self.navigationController pushViewController:page animated:YES];
    }else if (btn == _praiseBtn) {
        [self thumbUp];
    }
}
- (void)thumbUp{
    _praiseBtn.userInteractionEnabled = NO;
    [ZTHttpTool postWithUrl:@"social/post/thumbUp" param:@{@"postId":_dict.postId,@"userId":[StorageUserInfromation storageUserInformation].userId} success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        if ([dict[@"rcode"] integerValue] == 0) {
//            _onceList.thumbUp = !_onceList.thumbUp;
//            self.likeBlock(_onceList.thumbUp);
//            if (_onceList.thumbUp) {
//                [self.likeBtn setImage:[UIImage imageNamed:@"icon_点赞2"] forState:UIControlStateNormal];
//            }else{
//                [self.likeBtn setImage:[UIImage imageNamed:@"icon_点赞1"] forState:UIControlStateNormal];
//
//            }
//            self.likeNum.text = [NSString stringWithFormat:@"点赞 %@",_onceList.thumbUpCount];
        }
        _praiseBtn.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        _praiseBtn.userInteractionEnabled = YES;
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

@end

