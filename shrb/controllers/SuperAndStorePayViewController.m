//
//  SuperAndStorePayViewController.m
//  shrb
//
//  Created by PayBay on 15/8/6.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "SuperAndStorePayViewController.h"
#import "Const.h"
#import "TNCheckBoxGroup.h"
#import "OrdersTableViewCell.h"


#define imageViewWidth 80
#define imageViewSpace 8

static UIButton *_payTypeButton = nil;

@interface SuperAndStorePayViewController ()
{
    NSMutableArray *_data;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SuperAndStorePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTableView];
}

- (void)initData
{
    _data = [[NSMutableArray alloc] initWithObjects:@"纯色拼接修身外套",@"简约拉链夹克",@"纯棉9分直筒裤",@"男士休闲羊毛西装", nil];
}

- (void)initTableView
{
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;

    
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor = shrbTableViewColor;
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }
    else if (indexPath.row == 1) {
        return 100;
    }
    else {
        return 250;
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *simpleTableIdentifier = @"celltextId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"storeName"];
        cell.textLabel.textColor = shrbText;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *simpleTableIdentifier = @"cellmyId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
        }
        for (int i = 0 ; (i < 3)&&(i<[_data count]); i++) {
            UIImageView *couponsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[_data objectAtIndex:i]]]];
            couponsImageView.frame = CGRectMake(16+i*(imageViewWidth+imageViewSpace), 10, imageViewWidth, imageViewWidth);
            
            couponsImageView.layer.cornerRadius = 8;
            couponsImageView.layer.masksToBounds = YES;
            [cell addSubview:couponsImageView];
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"共%d件",[_data count]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payChanged:) name:PAY_CHANGED object:nil];
        
        return cell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"cellId";
        OrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[OrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        TNImageCheckBoxData *manData = [[TNImageCheckBoxData alloc] init];
        manData.identifier = @"man";
        manData.labelText = @"100RMB电子券";
        manData.labelColor = [UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1];
        manData.labelFont = [UIFont systemFontOfSize:14.0];
        manData.checked = YES;
        manData.checkedImage = [UIImage imageNamed:@"checked"];
        manData.uncheckedImage = [UIImage imageNamed:@"unchecked"];
        
        [cell.payViewCheckCouponsView myInitWithCheckBoxData:@[manData] style:TNCheckBoxLayoutVertical];
        [cell.payViewCheckCouponsView create];
        
        
        return cell;
    }
}

- (void)payChanged:(NSNotification *)notification {
    
    UIButton *button = (UIButton *)notification.object;
    
    NSLog(@"tag = %ld",(long)button.tag);
    switch (button.tag) {
        case 0:
            //会员支付
            break;
        case 1:
            //支付宝支付
            break;
        case 2:
            //银联支付
            break;
            
        default:
            break;
    }
}

@end