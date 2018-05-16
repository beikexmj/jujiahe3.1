//
//  LeftTableViewController.m
//  微博个人主页
//
//  Created by zenglun on 16/5/4.
//  Copyright © 2016年 chengchengxinxi. All rights reserved.
//

#import "LeftTableViewController.h"
#import "TopicCell.h"
#import "CircleDataModel.h"
#import "XLPhotoBrowser.h"
#import "TopicDetailVC.h"
@interface LeftTableViewController ()<XLPhotoBrowserDelegate,XLPhotoBrowserDatasource,UIActionSheetDelegate>
{
    TopicCell *likeCell;
    NSInteger indexPathRow;
    NSInteger page;
    NSInteger totolPicNum;
    NSMutableArray *imageArr;

}
@property (nonatomic, strong) NSMutableArray <CircleDataList *> *circleDataList;
@property (nonatomic,strong)NSMutableDictionary * hightDict;

@end

@implementation LeftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hightDict = [NSMutableDictionary dictionary];
    [self.tableView registerNib:[UINib nibWithNibName:@"TopicCell" bundle:nil] forCellReuseIdentifier:@"TopicCell"];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
//        self.tableView.contentInset =UIEdgeInsetsMake(64,0,49,0);//64和49自己看效果，是否应该改成0
//        self.tableView.scrollIndicatorInsets =self.tableView.contentInset;
//    }
    WeakSelf
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        StrongSelf
        [strongSelf fetchList:page];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        StrongSelf
        [_hightDict removeAllObjects];
        [strongSelf fetchList:page];
    }];
    _circleDataList = [NSMutableArray array];
    page = 1;
    [self fetchList:1];
}
- (void)fetchList:(NSInteger)pageNum{
    page = pageNum;
    NSString *userId = [StorageUserInfromation storageUserInformation].userId;
    
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"device":@"1",@"apiv":@"1.0",@"pagesize":@"10",@"page":[NSString stringWithFormat:@"%ld",pageNum],@"hot":@"n",@"userId":userId?userId:@""};
    if (page == 1) {
        //        [MBProgressHUD showMessage:@""];
    }
    [ZTHttpTool postWithUrl:@"social/v1/public/findNextPostByCreateTime" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        if (page>1) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        CircleDataModel *data = [CircleDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            if (data.form.list.count>0) {
                if (page == 1) {
                    [_hightDict removeAllObjects];
                    [_circleDataList removeAllObjects];
                    [_circleDataList addObjectsFromArray:data.form.list];
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    
                }else{
                    [_circleDataList addObjectsFromArray:data.form.list];
                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                    for (int ind = 0; ind < data.form.list.count; ind++) {
                        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow: _circleDataList.count - data.form.list.count + ind inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    //重新调用UITableView的方法, 来生成行.
                    [UIView performWithoutAnimation:^{
                        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_circleDataList.count - data.form.list.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }];
                }
            }
        }else{
            if (page>1) {
                page--;
            }else{
                [MBProgressHUD hideHUD];
            }
            [MBProgressHUD showError:data.msg];
        }
        
    } failure:^(NSError *error) {
        if (page>1) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD hideHUD];
        }
        XMJLog(@"%@",error)
        if (page>1) {
            page--;
        }
        [MBProgressHUD showError:@"网络异常"];
    }];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_circleDataList) {
        return _circleDataList.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cell = @"TopicCell";
    TopicCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell forIndexPath:indexPath];
    if (!myCell) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:cell owner:self options:nil] lastObject];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    if (_circleDataList) {
        CircleDataList *dict = _circleDataList[indexPath.row];
        NSInteger integer = dict.thumbPicUrls.count;
        if (dict.anon == 1) {
            myCell.headerIcon.image = [UIImage imageNamed:@"匿名头像"];
            myCell.name.text = @"匿名";
        }else{
            [myCell.headerIcon sd_setImageWithURL:[NSURL URLWithString:dict.avatar] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageRefreshCached|SDWebImageAllowInvalidSSLCertificates];
            myCell.name.text = dict.nickname;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapClick:)];
        myCell.headerIcon.tag = indexPath.row;
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
        myCell.likeBtn.tag = indexPath.row;
        myCell.commentBtn.tag = indexPath.row;
        myCell.moreBtn.tag = indexPath.row;
        myCell.tag = indexPath.row;
        myCell.likeBtnBlock = ^(NSInteger integer, TopicCell *onceCell) {
            likeCell = onceCell;
            [self likeBtnClick:integer];
        };
        myCell.commentBtnBlock = ^(NSInteger integer) {
            
        };
        myCell.moreBtnBlock = ^(NSInteger integer) {
            indexPathRow = integer;
            [self showActionSheet];
        };
        WeakSelf
        myCell.imageViewTapBlock = ^(NSInteger integer, UIImageView *imageView) {
            StrongSelf
            CircleDataList *dict2 = _circleDataList[integer/10];
            [strongSelf clickImage:imageView tag:integer totol:dict2.thumbPicUrls.count];
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
    
    return myCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber* cellHeightNumber = [_hightDict objectForKey:@(indexPath.row)];
    CGFloat cellHeight;
    if (cellHeightNumber) {//判断是否缓存了该cell的高度
        cellHeight = [cellHeightNumber floatValue];
        return cellHeight;
    }
    CGFloat f = 75 + 40 + 10 + 4;
    if (_circleDataList) {
        CircleDataList *dict = _circleDataList[indexPath.row];
        NSInteger integer = dict.thumbPicUrls.count;
        if (integer == 0) {
            f -= 10;
        }else if (integer == 1){
            f += SCREENWIDTH*(8/15.0);
        }else if (integer == 2){
            f += (SCREENWIDTH - 80 - 5)/2.0;
        }else if (integer == 3){
            f += (SCREENWIDTH - 80 - 5*2)/3.0;
        }else if (integer == 4 | integer ==5 | integer == 6){
            f += ((SCREENWIDTH - 80 - 5*2)/3.0) *2 +5;
        }else if (integer > 6){
            f += ((SCREENWIDTH - 80 - 5*2)/3.0) *3 +5*2;
        }
        CGFloat contentHeight = [StorageUserInfromation getStringSizeWith2:[NSString stringWithFormat:@"#%@#%@",dict.tag,dict.content] withStringFont:15.0 withWidthOrHeight:SCREENWIDTH-80 lineSpacing:8.0].height + 8;
        if (contentHeight>75) {
            contentHeight = 75;
        }
        f += contentHeight;
    }else {
        f = 0;
    }
    [_hightDict setObject:[NSNumber numberWithFloat:f] forKey:@(indexPath.row)];
    return f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleDataList *dict = _circleDataList[indexPath.row];
    TopicDetailVC *page = [[TopicDetailVC alloc]init];
    page.dict = dict;
    page.headerHeight = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    [self.navigationController pushViewController:page animated:YES];
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
    CircleDataList *onceList = _circleDataList[indexPathRow];
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexPathRow inSection:0];
    TopicCell *myCell = [self.tableView cellForRowAtIndexPath:indexPath];
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
    CircleDataList *onceList = _circleDataList[indexPathRow];
    
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
            if ([_circleDataList[indexPathRow].userId isEqualToString:[StorageUserInfromation storageUserInformation].userId]) {
                
                NSDictionary *dict = @{@"apiv":@"1.0",@"postId":_circleDataList[indexPathRow].postId};
                [ZTHttpTool postWithUrl:@"social/v1/post/deletePost" param:dict success:^(id responseObj) {
                    NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
                    NSDictionary *myDict = [DictToJson dictionaryWithJsonString:str];
                    NSLog(@"%@",myDict);
                    if ([myDict[@"rcode"] integerValue] == 0) {
                        [MBProgressHUD showSuccess:@"删除成功"];
                        [_circleDataList removeObjectAtIndex:indexPathRow];
                        [_hightDict removeAllObjects];
                        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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

- (void)request_data {
    // 如果需要请求网络数据, 再调用tableView的reloadData之后，调用下面resetContentInset方法可以消除底部多余空白
    
    
    
}
- (void)headerTapClick:(UIGestureRecognizer *)tap{
    //    if([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
    //        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"未登录" message:@"确定跳回登录界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //        alert.tag = 10;
    //        [alert show];
    //        return;
    //    }
    
    NSInteger integer = tap.view.tag;
    CircleDataList *dict = _circleDataList[integer];
    if (dict.anon == 1 && (![dict.userId isEqualToString:[StorageUserInfromation storageUserInformation].userId])) {
        [MBProgressHUD showError:@"该用户匿名发帖，无法查看他的发帖信息"];
        return;
    }
}
- (void)likeBtnClick:(NSInteger)index{
    if ([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]) {
        [MBProgressHUD showError:@"未登录用户不能点赞"];
        return;
    }
    CircleDataList *dict = _circleDataList[index];
    [MBProgressHUD showMessage:@""];
    NSDictionary *myDict = @{@"userId":[StorageUserInfromation storageUserInformation].userId,@"postId":dict.postId,@"apiv":@"1.0",@"operation":dict.thumbUp?@"2":@"1"};
    [ZTHttpTool postWithUrl:@"social/v1/post/thumbUp" param:myDict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            if (dict.thumbUp) {
                dict.thumbUpCount = [NSString stringWithFormat:@"%ld",dict.thumbUpCount.integerValue - 1];
            }else{
                dict.thumbUpCount = [NSString stringWithFormat:@"%ld",dict.thumbUpCount.integerValue + 1];
            }
            dict.thumbUp = !dict.thumbUp;
            [_circleDataList replaceObjectAtIndex:index withObject:dict];
            
            likeCell.likeNum.text = dict.thumbUpCount;
            if (dict.thumbUp) {
                [likeCell.likeBtn setImage:[UIImage imageNamed:@"com_icon_praise2"] forState:UIControlStateNormal];
                likeCell.likeNum.textColor = RGBA(0xff4e18, 1);
            }else{
                [likeCell.likeBtn setImage:[UIImage imageNamed:@"com_icon_praise"] forState:UIControlStateNormal];
                likeCell.likeNum.textColor = RGBA(0x606060, 1);
                
            }
        }else if ([onceDict[@"rcode"] integerValue] == -1){
            if ([onceDict[@"msg"] isEqualToString:@"已点过赞"]) {
                dict.thumbUpCount = [NSString stringWithFormat:@"%ld",dict.thumbUpCount.integerValue + 1];
                dict.thumbUp = !dict.thumbUp;
                [_circleDataList replaceObjectAtIndex:index withObject:dict];
                likeCell.likeNum.text = dict.thumbUpCount;
                
                [likeCell.likeBtn setImage:[UIImage imageNamed:@"com_icon_praise2"] forState:UIControlStateNormal];
                likeCell.likeNum.textColor = RGBA(0xff4e18, 1);
            }else if ([onceDict[@"msg"] isEqualToString:@"还没有点过赞"]){
                dict.thumbUpCount = [NSString stringWithFormat:@"%ld",dict.thumbUpCount.integerValue - 1];
                dict.thumbUp = !dict.thumbUp;
                [_circleDataList replaceObjectAtIndex:index withObject:dict];
                likeCell.likeNum.text = dict.thumbUpCount;
                [likeCell.likeBtn setImage:[UIImage imageNamed:@"com_icon_praise"] forState:UIControlStateNormal];
                likeCell.likeNum.textColor = RGBA(0x606060, 1);
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
#pragma mark - Private
- (void)resetContentInset {
    [self.tableView layoutIfNeeded];
    
    if (self.tableView.contentSize.height < kScreenHeight + 136) {  // 136 = 200
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight+88-self.tableView.contentSize.height, 0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
}

@end
