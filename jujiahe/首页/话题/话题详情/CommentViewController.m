//
//  CommentViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/10/25.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "CommentViewController.h"
#import "ReactiveObjC/ReactiveObjC.h"

@interface CommentViewController ()<UITextViewDelegate>
{
    UILabel *placeHolder;
}
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navTitle.font = [UIFont systemFontOfSize:18.0];
        _navHight.constant = 64+22;
    }
    placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, 150, 20)];
    placeHolder.text = @"请输入你想评论的内容...";
    [placeHolder setTextColor:RGBCOLOR(156, 156, 156)];
    placeHolder.font = [UIFont systemFontOfSize:14];
    [_myTextView addSubview:placeHolder];
    if (_targetName) {
        _myTextView.text = [NSString stringWithFormat:@"@%@ ",_targetName];
    }
    //KVO动态监听text的值变化
    [_myTextView.rac_textSignal  subscribeNext:^(NSString * _Nullable x) {
        if (x.length == 0) {
            placeHolder.hidden = NO;
        }else{
            placeHolder.hidden = YES;
        }
        if (_targetName) {
            if ([x isEqualToString:[NSString stringWithFormat:@"@%@",_targetName]]) {
                _myTextView.text = @"";
                placeHolder.hidden = NO;
            }
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

- (IBAction)publishBtnClick:(id)sender {
    if ([JGIsBlankString isBlankString:self.myTextView.text]) {
        [MBProgressHUD showError:@"评论内容不能为空"];
        return;
    }
    [MBProgressHUD showMessage:@""];
    
    NSString * str = self.myTextView.text;
    NSString * targetUsrId = _targetUserId;
    if (_targetName) {
        if ([self.myTextView.text containsString:_targetName]) {
           str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@ ",_targetName] withString:@""];
        }else{
            targetUsrId  = @"";
        }
    }
    NSDictionary * dict = @{@"userId":[StorageUserInfromation storageUserInformation].userId,@"postId":_postId,@"content":str,@"targetUserId":targetUsrId};
    
    [ZTHttpTool postWithUrl:@"social/post/addReply" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
       NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        if ([dict[@"rcode"] integerValue] == 0) {
            self.commentBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dict[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}
@end
