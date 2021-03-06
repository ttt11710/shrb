//
//  TradingRecordTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/29.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "TradingRecordTableViewController.h"
#import "CardModel.h"
#import "ExpenseTableViewCell.h"
#import "SVPullToRefresh.h"
#import "UITableView+Wave.h"
#import "SVProgressShow.h"
#import "Const.h"
#import "TBUser.h"

@interface TradingRecordTableViewController ()

@property (nonatomic, strong) NSMutableArray *expenseArray;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong)AFHTTPRequestOperationManager *requestOperationManager;


@end

@implementation TradingRecordTableViewController

@synthesize cardNo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressShow showWithStatus:@"加载中..."];
    
    [self creatReq];
    [self loadData];
   // [self initData];
    [self initTableView];
    
}

- (void)loadData
{
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSString *url2=[baseUrl stringByAppendingString:@"/card/v1.0/findCardTradeRecords?"];
    [self.requestOperationManager GET:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token,@"cardNo":self.cardNo} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"findCardTradeRecords operation = %@ JSON: %@", operation,responseObject);
        
        switch ([responseObject[@"code"] integerValue]) {
            case 200:
            {
                self.expenseArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary * dict in responseObject[@"data"]) {
                    CardModel * model = [[CardModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.expenseArray addObject:model];
                }
                [self.tableView reloadData];
                
                [SVProgressShow dismiss];
            }
                break;
            case 201:
            case 500:
                [SVProgressShow showErrorWithStatus:responseObject[@"mes"]];
                break;
                
            default:
                break;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
}

- (void)creatReq
{
    self.requestOperationManager=[AFHTTPRequestOperationManager manager];
    
    self.requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *serializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    self.requestOperationManager.responseSerializer=serializer;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:10*60];
    self.requestOperationManager.requestSerializer=requestSerializer;
}

- (void)initData
{
    
    NSMutableArray *expenseArray = [[NSMutableArray alloc] initWithObjects:
                                    @{
                                      @"date" : @"15:20  2016.3.1",
                                      @"money" : @"100",
                                      @"orderNum" : @"785125632548756321",
                                      @"address":@"上海市",
                                      },
                                    @{
                                      @"date" : @"13:40  2016.4.1",
                                      @"money" : @"200",
                                      @"orderNum" : @"8562541236652589651",
                                      @"address":@"浙江省",
                                      },
                                    @{
                                      @"date" : @"8:12  2015.2.23",
                                      @"money" : @"560",
                                      @"orderNum" : @"856554587452130210",
                                      @"address":@"江苏市",
                                      },
                                    @{
                                      @"date" : @"15:20  2016.3.4",
                                      @"money" : @"890",
                                      @"orderNum" : @"965874521032120120",
                                      @"address":@"云南",
                                      },
                                    nil];
    
    self.expenseArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in expenseArray) {
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.expenseArray addObject:model];
    }
}

- (void)initTableView
{
    
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    
    self.tableView.backgroundColor = shrbTableViewColor;

    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    self.automaticallyAdjustsScrollViewInsets = false;
    
//    __weak TradingRecordTableViewController *weakSelf = self;
//    //下拉加载
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        [weakSelf insertRowAtTop];
//    }];
//    
//    //上拉刷新
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf insertRowAtBottom];
//    }];
}

#pragma mark - top插入数据
- (void)insertRowAtTop {
    __weak TradingRecordTableViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        NSDictionary *dic = @{ @"date" : @"15:20  2016.4.1",
                               @"money" : @"20",
                               @"orderNum" : @"785456320123069852",
                               @"address":@"徐汇区",
                               };
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [weakSelf.expenseArray insertObject:model atIndex:0];
        
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [weakSelf.tableView reloadData];
        [SVProgressShow showSuccessWithStatus:@"刷新成功！"];
    });
}

#pragma mark - bottom插入数据
- (void)insertRowAtBottom {
    __weak TradingRecordTableViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        NSDictionary *dic = @{ @"date" : @"15:20  2015.3.1",
                               @"money" : @"100",
                               @"orderNum" : @"965214785630120125",
                               @"address":@"上海浦东",
                               };
        CardModel * model = [[CardModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [weakSelf.expenseArray addObject:model];
        
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.expenseArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [SVProgressShow showSuccessWithStatus:@"加载成功！"];
    });
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  150;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.expenseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimpleTableIdentifier = @"ExpenseTableViewIdentifier";
    ExpenseTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[ExpenseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    
    cell.model = self.expenseArray[indexPath.row];
    return cell;
    
}
@end
