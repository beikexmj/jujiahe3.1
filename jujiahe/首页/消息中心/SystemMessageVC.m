//
//  SystemMessageVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/17.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "SystemMessageVC.h"
#import "MyMessageDataModel.h"
#import "UITableView+WFEmpty.h"
#import "SystemMessageCell.h"
#import "SystemMessageDataModel.h"
#import "SystemMessageDetailVC.h"
@interface SystemMessageVC ()
{
    NSInteger messagePage;
}
@property (nonatomic,strong)NSMutableArray <SystemMessageFrom *> *systemMessageArr;

@end

@implementation SystemMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    messagePage = 1;
    _systemMessageArr = [NSMutableArray array];
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
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/systemNotice/myNotice" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        SystemMessageDataModel *data = [SystemMessageDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            if (data.form.count>0) {
                if (messagePage == 1) {
                    [_systemMessageArr removeAllObjects];
                    [_systemMessageArr addObjectsFromArray:data.form];
                    [self.tableView reloadData];
                }else{
                    [_systemMessageArr addObjectsFromArray:data.form];
                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                    for (int ind = 0; ind < data.form.count; ind++) {
                        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow: _systemMessageArr.count - data.form.count + ind inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    //重新调用UITableView的方法, 来生成行.
                    [UIView performWithoutAnimation:^{
                        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_systemMessageArr.count - data.form.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }];
                }
            }else{
                if (page>1) {
                    messagePage--;
                }
            }
            if (_systemMessageArr.count ==0) {
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
    static NSString *systemMessageCell = @"SystemMessageCell";
    SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:systemMessageCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:systemMessageCell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mark.backgroundColor = RGBA(0xffffff, 1);
    cell.mark.textColor = RGBA(0xc0c0c0, 1);
    if (_systemMessageArr.count) {
        SystemMessageFrom *onceDict = _systemMessageArr[indexPath.row];
        if ([onceDict.userId isEqualToString:@"<null>"]|(!onceDict.userId)) {
            cell.mark.text = onceDict.noticeType;
            cell.mark.backgroundColor = RGBA(0x00a7ff, 1);
            cell.mark.textColor = RGBA(0xffffff, 1);
        }else{
            cell.mark.text = @"已读";
        }
        CGFloat width =  [cell.mark sizeThatFits:CGSizeMake(MAXFLOAT, 17)].width + 5;
        cell.markWidth.constant = width;
        cell.time.text = [StorageUserInfromation timeStrFromDateString:onceDict.createTime];
        cell.content.text = onceDict.content;
    }
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _systemMessageArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemMessageDetailVC *page = [[SystemMessageDetailVC alloc]init];
    SystemMessageFrom *dict = _systemMessageArr[indexPath.row];
    [self hasReadOrDeleteSystemMessage:dict.ids operation:@"1" index:indexPath];
    page.dict = dict;
    [self.navigationController pushViewController:page animated:YES];
    
    
}
- (void)hasReadOrDeleteSystemMessage:(NSString *)noticeId operation:(NSString *)operation index:(NSIndexPath *)index {
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"noticeId":noticeId,@"operation":operation};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/systemNotice/operation" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
//            [self fetchUnreadMessageCount];
            if ([operation isEqualToString:@"1"]) {
                SystemMessageFrom *dict = _systemMessageArr[index.row];
                dict.userId = [StorageUserInfromation storageUserInformation].userId;
                [_systemMessageArr replaceObjectAtIndex:index.row withObject:dict];
                [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                //删除数据，和删除动画
                [self.systemMessageArr removeObjectAtIndex:index.row];
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
    SystemMessageFrom *dict = _systemMessageArr[indexPath.row];
    [self hasReadOrDeleteSystemMessage:dict.ids operation:@"2" index:indexPath];
    
    
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
