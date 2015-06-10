//
//  CouponsDetailTableViewController.m
//  shrb
//  电子券详情
//  Created by PayBay on 15/6/8.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "CouponsDetailTableViewController.h"
#import "CouponsDetailTableViewCell.h"
#import "StoreViewController.h"
#import "UITableView+Wave.h"

@interface CouponsDetailTableViewController ()
{
    NSMutableArray *_data;
}
@end

@implementation CouponsDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView =[[UIView alloc]init];
    
    _data = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_data count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"CouponsDetailTableViewCellIdentifier";
    CouponsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[CouponsDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier];
    }
    
    cell.couponsImageView.image = [UIImage imageNamed:@"官方头像"];
    cell.moneyLabel.text = @"金额：30RMB";
    cell.expirationDateLabel.text = @"截止日期：2016.1.1";
    cell.userCouponsBtn.tag = indexPath.row;
    return cell;
}

#pragma  mark - 使用电子券
- (IBAction)userCouponsBtnPressed:(UIButton *)sender {
    NSLog(@"sender.tag = %ld",(long)sender.tag);
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StoreViewController *storeViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"storeView"];
    [storeViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController pushViewController:storeViewController animated:YES];
}

@end
