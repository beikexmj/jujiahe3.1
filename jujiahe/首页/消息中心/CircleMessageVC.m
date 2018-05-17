//
//  CircleMessageVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/17.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CircleMessageVC.h"
#import "MyMessageDataModel.h"
#import "UITableView+WFEmpty.h"
#import "MyMessageCell.h"
@interface CircleMessageVC ()
{
    NSInteger messagePage;
}
@property (nonatomic,strong)NSMutableArray <MyMessageFrom *> *myMessageArr;

@end

@implementation CircleMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    messagePage = 1;
    _myMessageArr = [NSMutableArray array];
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf
        messagePage = 1;
        [strongSelf fetchMyMessageData:1];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        StrongSelf
        messagePage++;
        [strongSelf fetchMyMessageData:messagePage];
    }];
    messagePage = 1;
    [self fetchMyMessageData:1];
    // Do any additional setup after loading the view.
}
- (void)fetchMyMessageData:(NSInteger)page{
    messagePage = page;
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"pagesize":@"10",@"page":[NSString stringWithFormat:@"%ld",page]};
    [ZTHttpTool postWithUrl:@"social/v1/personal/userMessage" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        MyMessageDataModel *data = [MyMessageDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            if (data.form.count>0) {
                if (messagePage == 1) {
                    [_myMessageArr removeAllObjects];
                    [_myMessageArr addObjectsFromArray:data.form];
                    [self.tableView reloadData];
                }else{
                    [_myMessageArr addObjectsFromArray:data.form];
                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                    for (int ind = 0; ind < data.form.count; ind++) {
                        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow: _myMessageArr.count - data.form.count + ind inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    //重新调用UITableView的方法, 来生成行.
                    [UIView performWithoutAnimation:^{
                        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_myMessageArr.count - data.form.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }];
                }
            }else{
                if (page>1) {
                    messagePage--;
                }
            }
            if (_myMessageArr.count ==0) {
                [self.tableView addEmptyViewWithImageName:@"暂无消息" title:@"暂无消息"];
                [self.tableView.emptyView setHidden:NO];
            }else{
                [self.tableView.emptyView setHidden:YES];
            }
        }else{
            if (messagePage >1) {
                messagePage--;
            }
        }
        
    } failure:^(NSError *error) {
        if (messagePage >1) {
            messagePage--;
        }
        [self.tableView addEmptyViewWithImageName:@"暂无网络连接" title:@"暂无网络连接"];
        [self.tableView.emptyView setHidden:NO];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myMessageCell = @"MyMessageCell";
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:myMessageCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myMessageCell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headerOne.hidden = YES;
    cell.headerTwo.hidden = YES;
    cell.headerThree.hidden = YES;
    cell.headerFour.hidden = YES;
    cell.more.hidden = YES;
    cell.pic.hidden = YES;
    cell.content.hidden = YES;
    
    //        // 创建 NSMutableAttributedString
    //        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:cell.content.text attributes:@{NSForegroundColorAttributeName:RGBA(0x303030, 1)}];
    //        // 添加文字颜色
    //        [attrStr addAttribute:NSForegroundColorAttributeName
    //                        value:RGBA(0x00a7ff, 1)
    //                        range:NSMakeRange(0, 6)];
    //        cell.content.attributedText = attrStr;
    cell.markLabel.backgroundColor = RGBA(0xffffff, 1);
    cell.markLabel.textColor = RGBA(0xc0c0c0, 1);
    
    if (_myMessageArr.count) {
        MyMessageFrom *onceDict = _myMessageArr[indexPath.row];
        cell.time.text = [StorageUserInfromation timeStrFromDateString:onceDict.timestamp];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *str in onceDict.avatar) {
            if ([str isKindOfClass:[NSNull class]]) {
                [arr addObject:@""];
            }else{
                [arr addObject:str];
            }
        }
        onceDict.avatar = arr;
        if (onceDict.comment == 1) {
            cell.markLabel.text = @"1条消息";
            cell.markLabel.backgroundColor = RGBA(0xfe4b20, 1);
            cell.markLabel.textColor = RGBA(0xffffff, 1);
            cell.headerOne.hidden = NO;
            [cell.headerOne sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[0]?onceDict.avatar[0]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
        }else if (onceDict.comment == 2){
            cell.markLabel.text = @"2条消息";
            cell.markLabel.backgroundColor = RGBA(0xfe4b20, 1);
            cell.markLabel.textColor = RGBA(0xffffff, 1);
            cell.headerOne.hidden = NO;
            cell.headerTwo.hidden = NO;
            [cell.headerOne sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[0]?onceDict.avatar[0]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            [cell.headerTwo sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[1]?onceDict.avatar[1]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            
        }else if (onceDict.comment == 3){
            cell.markLabel.text = @"3条消息";
            cell.markLabel.backgroundColor = RGBA(0xfe4b20, 1);
            cell.markLabel.textColor = RGBA(0xffffff, 1);
            cell.headerOne.hidden = NO;
            cell.headerTwo.hidden = NO;
            cell.headerThree.hidden = NO;
            [cell.headerOne sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[0]?onceDict.avatar[0]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            [cell.headerTwo sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[1]?onceDict.avatar[1]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            [cell.headerThree sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[2]?onceDict.avatar[2]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            
        }else if (onceDict.comment  == 4){
            cell.markLabel.text = @"4条消息";
            cell.markLabel.backgroundColor = RGBA(0xfe4b20, 1);
            cell.markLabel.textColor = RGBA(0xffffff, 1);
            cell.headerOne.hidden = NO;
            cell.headerTwo.hidden = NO;
            cell.headerThree.hidden = NO;
            cell.headerFour.hidden = NO;
            [cell.headerOne sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[0]?onceDict.avatar[0]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            [cell.headerTwo sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[1]?onceDict.avatar[1]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            [cell.headerThree sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[2]?onceDict.avatar[2]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            [cell.headerFour sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[3]?onceDict.avatar[3]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            
        }else{
            cell.markLabel.text = [NSString stringWithFormat:@"%ld条消息",onceDict.comment];
            cell.markLabel.backgroundColor = RGBA(0xfe4b20, 1);
            cell.markLabel.textColor = RGBA(0xffffff, 1);
            cell.headerOne.hidden = NO;
            cell.headerTwo.hidden = NO;
            cell.headerThree.hidden = NO;
            cell.headerFour.hidden = NO;
            cell.more.hidden = NO;
            [cell.headerOne sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[0]?onceDict.avatar[0]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            [cell.headerTwo sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[1]?onceDict.avatar[1]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            [cell.headerThree sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[2]?onceDict.avatar[2]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            [cell.headerFour sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[3]?onceDict.avatar[3]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            
        }
        if (!onceDict.hasUnread) {
            cell.markLabel.text = @"已读";
            cell.markLabel.backgroundColor = RGBA(0xffffff, 1);
            cell.markLabel.textColor = RGBA(0xc0c0c0, 1);
        }else{
            CGFloat width =  [cell.markLabel sizeThatFits:CGSizeMake(MAXFLOAT, 17)].width + 5;
            cell.markWidth.constant = width;
        }
        if (onceDict.type == 2) {
            cell.pic.hidden = NO;
            [cell.pic sd_setImageWithURL:[NSURL URLWithString:onceDict.thumb] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
        }else if (onceDict.type == 1){
            cell.content.hidden = NO;
            cell.content.text = [NSString stringWithFormat:@"#%@#%@",onceDict.tag,onceDict.content];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:cell.content.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1)}];
            [attrStr addAttribute:NSForegroundColorAttributeName value:RGBA(0x00a7ff, 1) range:NSMakeRange(0, onceDict.tag.length+2)];
            cell.content.attributedText = attrStr;
        }
    }
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _myMessageArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMessageFrom *dict = _myMessageArr[indexPath.row];
    
    [self hasReadOrDeleteMyMessage:dict.postId operation:@"1" index:indexPath];
    
    
}
- (void)hasReadOrDeleteMyMessage:(NSString *)postId operation:(NSString *)operation index:(NSIndexPath *)index{
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"postId":postId,@"operation":operation};
    [ZTHttpTool postWithUrl:@"social/v1/personal/operation" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            //            [self fetchUnreadMessageCount];
            if ([operation isEqualToString:@"1"]) {
                MyMessageFrom *dict = _myMessageArr[index.row];
                dict.hasUnread = 0;
                [_myMessageArr replaceObjectAtIndex:index.row withObject:dict];
                [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                //删除数据，和删除动画
                [self.myMessageArr removeObjectAtIndex:index.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    MyMessageFrom *dict = _myMessageArr[indexPath.row];
    [self hasReadOrDeleteMyMessage:dict.postId operation:@"2" index:indexPath];
    
    
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

@end;
