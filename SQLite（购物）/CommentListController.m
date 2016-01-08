//
//  FeedBack.m
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "CommentListController.h"
#import "CommentListCell.h"
#import "DBComment.h"
#import "CommentInfo.h"
#import "MyFilePlist.h"

@interface CommentListController ()
{
    NSArray *_commentArray;
}
@end

@implementation CommentListController
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"评价";
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    _commentArray=[[DBComment shareDBComment] selectListByGoodsID:_fromGoodsId];
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CommentListCell";
    
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommentListCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    CommentInfo *comment=[_commentArray objectAtIndex:indexPath.row];
    cell.lbNick.text=comment.user_name;
    NSString *headStr=[MyFilePlist documentFilePathStr:[NSString stringWithFormat:@"UserHead/%@",comment.user_head]];
    if ([comment.user_head isEqualToString:@""] || [comment.user_head isEqualToString:@"(null)"]
        || [comment.user_head isEqualToString:@"null"] || comment.user_head==nil) {
        headStr=@"headImg.png";
    }
    [cell.imgHead setImage:[UIImage imageNamed:headStr]];
    cell.lbPostDate.text=comment.comment_time;
    cell.lbContents.text=comment.comment_content;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
