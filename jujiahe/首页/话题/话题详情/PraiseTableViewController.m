//
//  PraiseTableViewController.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/16.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PraiseTableViewController.h"
#import "CircleLikeTableViewCell.h"
#import "CircleLikeDataModel.h"

@interface PraiseTableViewController ()
{
    NSInteger likePage;

}
@property (nonatomic,strong)NSMutableArray <CircleLikeDataList*>*likeListArr;

@end

@implementation PraiseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;

    _likeListArr = [NSMutableArray array];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        likePage = 0;
        [self requestLikeData:likePage];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestLikeData:++likePage];
    }];
    likePage = 0;
    [self requestLikeData:likePage];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)requestLikeData:(NSInteger)integer{
    [ZTHttpTool postWithUrl:@"social/post/findLikedUsers" param:@{@"postId":_postId,@"userId":[StorageUserInfromation storageUserInformation].userId,@"page":[NSString stringWithFormat:@"%ld",integer],@"pagesize":@"10"} success:^(id responseObj) {
        //        NSLog(@"%@",responseObj);
        NSLog(@"responseObj==%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        //        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        CircleLikeDataModel *likeData = [CircleLikeDataModel mj_objectWithKeyValues:str];
        if (likeData.rcode == 0) {
            if (integer == 0) {
                [_likeListArr removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            }else{
                if (likeData.form.count == 0) {
                    likePage--;
                }
                [self.tableView.mj_footer endRefreshing];
            }
            [_likeListArr addObjectsFromArray:likeData.form];
            [self.tableView reloadData];
        }else{
            if (integer == 0) {
                [self.tableView.mj_header endRefreshing];
            }else{
                likePage--;
                [self.tableView.mj_footer endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        if (integer == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            likePage--;
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD showError:@"网络请求失败"];
        NSLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _likeListArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleLikeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleLikeTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CircleLikeTableViewCell" owner:self options:nil] lastObject];
    }
    if (_likeListArr.count>0) {
        CircleLikeDataList * onceDict =_likeListArr[indexPath.row];
        [cell.headerIcon sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar] placeholderImage:[UIImage imageNamed:@"per_head"]];
        cell.nickName.text = onceDict.nickname;
        cell.time.text = [StorageUserInfromation timeStrFromDateString:onceDict.createTime];
        cell.headerIcon.tag = indexPath.row;
        cell.headerIconTapBlock = ^(NSInteger index) {
            
        };
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
