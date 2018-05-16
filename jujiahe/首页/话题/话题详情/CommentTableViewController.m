//
//  CommentTableViewController.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/16.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CommentTableViewController.h"
#import "CircleCommentTableViewCell.h"
#import "CircleCommentDataModel.h"

@interface CommentTableViewController ()
{
    NSInteger commentPage;
}
@property (nonatomic,strong)NSMutableArray <CircleCommentDataList*>*commentListArr;

@end

@implementation CommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;

    _commentListArr = [NSMutableArray array];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        commentPage = 0;
        [self requestCommentData:commentPage];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestCommentData:++commentPage];
    }];
    commentPage = 0;
    [self requestCommentData:commentPage];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)requestCommentData:(NSInteger )integer{
    [ZTHttpTool postWithUrl:@"social/post/findNextReplyByCreateTime" param:@{@"postId":_postId,@"userId":[StorageUserInfromation storageUserInformation].userId,@"page":[NSString stringWithFormat:@"%ld",integer],@"pagesize":@"10"} success:^(id responseObj) {
        //        NSLog(@"%@",responseObj);
        NSLog(@"responseObj==%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        CircleCommentDataModel *commentData = [CircleCommentDataModel mj_objectWithKeyValues:str];
        if (commentData.rcode == 0) {
            if (integer == 0) {
                [_commentListArr removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            }else{
                if (commentData.form.count == 0) {
                    commentPage--;
                }
                [self.tableView.mj_footer endRefreshing];
            }
            [_commentListArr addObjectsFromArray:commentData.form];
            [self.tableView reloadData];
        }else{
            if (integer == 0) {
                [self.tableView.mj_header endRefreshing];
            }else{
                commentPage--;
                [self.tableView.mj_footer endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        if (integer == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            commentPage--;
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD showError:@"网络请求失败"];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentListArr.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleCommentTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CircleCommentTableViewCell" owner:self options:nil] lastObject];
    }
    if (_commentListArr.count>0) {
        CircleCommentDataList * onceDict =_commentListArr[indexPath.row];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar] placeholderImage:[UIImage imageNamed:@"per_head"]];
        cell.name.text = onceDict.nickname;
        cell.time.text = [StorageUserInfromation timeStrFromDateString:onceDict.createTime];
        NSString *str;
        if ([onceDict.targetName isEqualToString:@""]) {
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 3; //设置行间距
            paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0], NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:RGBCOLOR(48, 48, 48)};
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:onceDict.content attributes:dic];
            cell.content.attributedText = attributeStr;
            
            //                cell.content.text = onceDict.content;
            str = onceDict.content;
            CGFloat contentHeight = [StorageUserInfromation getStringSizeWith:str withStringFont:13.0 withWidthOrHeight:SCREEN_WIDTH-66].height;
            
            contentHeight = contentHeight + 5;
            cell.contentHeight.constant = contentHeight;
        }else{
            str = [NSString stringWithFormat:@"回复了%@:%@",onceDict.targetName,onceDict.content];
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 3; //设置行间距
            paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc]initWithString:str attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                    [UIFont systemFontOfSize:13.0],NSFontAttributeName,
                                                                                                                    RGBCOLOR(48, 48, 48),NSForegroundColorAttributeName,paraStyle,NSParagraphStyleAttributeName,nil]];
            [attriStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(156, 156, 156) range:NSMakeRange(0, 3)];
            [attriStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0, 206, 190) range:NSMakeRange(3, onceDict.targetName.length)];
            [attriStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(156, 156, 156) range:NSMakeRange(3+onceDict.targetName.length, 1)];
            cell.content.attributedText = attriStr;
        }
        
        CGFloat contentHeight = [StorageUserInfromation getStringSizeWith:str withStringFont:13.0 withWidthOrHeight:SCREEN_WIDTH-66].height;
        
        contentHeight = contentHeight + 5;
        cell.contentHeight.constant = contentHeight;
        
        cell.icon.tag = indexPath.row;
        cell.headerIconTapBlock = ^(NSInteger index) {
        };
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCommentDataList * onceDict =_commentListArr[indexPath.row];
    NSString *str;
    if ([onceDict.targetName isEqualToString:@""]) {
        str = onceDict.content;
    }else{
        str = [NSString stringWithFormat:@"回复了%@:%@",onceDict.targetName,onceDict.content];
    }
    CGFloat contentHeight = [StorageUserInfromation getStringSizeWith:str withStringFont:13.0 withWidthOrHeight:SCREEN_WIDTH-66].height;
    contentHeight = contentHeight + 5;
    return 60 -21 +contentHeight;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
