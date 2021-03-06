//
//  HotViewController.m
//  shrb
//  热点
//  Created by PayBay on 15/5/20.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "HotFocusViewController.h"
#import <Foundation/Foundation.h>
#import "HotFocusTableViewCell.h"
#import "HotFocusModel.h"
#import "HotDetailViewController.h"
#import "UITableView+Wave.h"
#import "Const.h"
#import <CBZSplashView/CBZSplashView.h>
#import "KYCuteView.h"
#import "SVProgressShow.h"
#import "NewStoreViewController.h"
#import "StoreViewController.h"
#import "TQTableViewCellRemoveController.h"
#import "NewStoreCollectController.h"
#import "DB.h"
#import "Migrations.h"
#import "MessageProcessor.h"
#import "HotListSelectViewController.h"
#import "ShoppingCardView.h"

#import "OrderStoreViewController.h"

#import "MyImageView.h"


//#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface HotFocusViewController () <TQTableViewCellRemoveControllerDelegate>
{
    MessageProcessor *_messageProcessor;
    ShoppingCardView *_shoppingCardView;
    
    NSString *_merchId;
    NSString *_merchTitle;
}
@property (nonatomic, strong) UIWindow       *window;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;


@property (nonatomic,strong) TQTableViewCellRemoveController *cellRemoveController;

@end

@implementation HotFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _messageProcessor = [[MessageProcessor alloc] init];
    
    [SVProgressShow showWithStatus:@"加载中..."];
    [self loadData];
    //[self initData];
    //[self getDataFormDB];
    
    [self initController];
    
    [self initTableView];
    [self cardAnimation];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"num"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"num"];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _shoppingCardView.shoppingNumLabel.num = [[NSUserDefaults standardUserDefaults] integerForKey:@"num"];
}

- (void)viewDidLayoutSubviews
{
    if (_shoppingCardView == nil) {
        _shoppingCardView = [[ShoppingCardView alloc] initWithFrame:CGRectMake(16, screenHeight-49-50, 100, 40)];
        _shoppingCardView.shoppingNumLabel.num = [[NSUserDefaults standardUserDefaults] integerForKey:@"num"];
       // [self.view insertSubview:_shoppingCardView aboveSubview:self.view];
    }

    else {
        [_shoppingCardView showShoppingCard];
    }

    if (IsiPhone4s) {
        self.tableView.frame = CGRectMake(0, 64, screenWidth, screenHeight-64-49);
    }
    [self.view layoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"countTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:_shoppingCardView.countTime forKey:@"countTime"];
}



#pragma mark - 网络请求数据
- (void)loadData
{
    DB *db = [DB openDb];
    
    self.dataArray = [[NSMutableArray alloc] init];
    NSString *url=[baseUrl stringByAppendingString:@"/merch/v1.0/getMerchList?"];
    [self.requestOperationManager GET:url parameters:@{@"pageNum":@"1",@"pageCount":@"20",@"orderBy":@"updateTime",@"sort":@"desc",@"whereString":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getMerchList operation = %@ JSON: %@", operation,responseObject);
        
        switch ([responseObject[@"code"] integerValue]) {
            case 200:
                self.dataArray = [responseObject[@"merchList"] mutableCopy];
                [SVProgressShow dismiss];
                [self.tableView reloadData];
                break;
            case 404:
            case 503:
                [SVProgressShow showErrorWithStatus:responseObject[@"msg"]];
                break;
                
            default:
                break;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
        [SVProgressShow showErrorWithStatus:@"加载失败!"];
    }];
    
}

#pragma mark - 数据库插入数据
- (void)insertDataToDB
{
    for (NSDictionary * dict in self.dataArray) {
        NSLog(@"dict = %@",dict);
        Store *store = [[Store alloc] init];
        [store setValuesForKeysWithDictionary:dict];
        [_messageProcessor process:store];
    }
}

#pragma mark - 获取数据库数据
- (void)getDataFormDB
{
    DB *db = [DB openDb];
    FMResultSet *rs = [db executeQuery:@"select * from store"];
    
    [self.dataArray removeAllObjects];
    while ([rs next]) {
        Store *store = [[Store alloc] init];
        store.storeId = [rs stringForColumn:@"storeid"];
        store.storePlistName = [rs stringForColumn:@"storeplistname"];
        store.storeLabel = [rs stringForColumn:@"storelabel"];
        store.storeDetail = [rs stringForColumn:@"storedetail"];
        store.storeLogo = [rs stringForColumn:@"storelogo"];
        store.images = [rs stringForColumn:@"images"];
        store.simpleStoreDetail = [rs stringForColumn:@"simplestoredetail"];
        store.storeName = [rs stringForColumn:@"storename"];
        
        [self.dataArray addObject:store];
        
    }
    if ([self.dataArray count] == 0) {
        for (NSDictionary * dict in self.dataArray) {
            Store * store = [[Store alloc] init];
            [store setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:store];
        }
    }
}


- (void)initController
{
    //导航颜色
    self.navigationController.navigationBar.barTintColor = shrbPink;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //工具栏图片 选中颜色
    self.tabBarController.tabBar.selectedItem.selectedImage = [UIImage imageNamed:@"恋人_highlight"];
    self.tabBarController.tabBar.tintColor = shrbPink;
    
    //动画 全屏
    UIImage *icon = [UIImage imageNamed:@"官方头像"];
    UIColor *color = shrbPink;
    CBZSplashView *splashView = [CBZSplashView splashViewWithIcon:icon backgroundColor:color];
    [self.view addSubview:splashView];
    [splashView startAnimation];

}

- (void)initData
{
    self.dataArray = [[NSMutableArray alloc] init];
}

- (void)initTableView
{
    
    //tableView 去分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //删除底部多余横线
    self.tableView.tableFooterView =[[UIView alloc]init];
    
    //去除tableview顶部留白
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.tableView.backgroundColor = shrbTableViewColor;
   // self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //动画
    //[self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
    
   // self.tableView.backgroundColor = shrbTableViewColor;
    
    //去除顶部空间
//    if (IsiPhone4s)
//    {
//        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, 0.01f)];
//    }
//    else {
//        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, 64.f)];
//    }
   // self.tableView.sectionFooterHeight = 4.0f;
    
    self.cellRemoveController = [[TQTableViewCellRemoveController alloc] initWithTableView:self.tableView];
    self.cellRemoveController.delegate = self;
    
    
}

- (void)cardAnimation
{
    for (NSIndexPath* indexPath in [self.tableView indexPathsForVisibleRows])
    {
        HotFocusTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.hotImageView.layer.transform = CATransform3DMakeScale(1, 0, 1);
        
        //点击弹动动画
        
        [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.hotImageView.layer.transform = CATransform3DIdentity;
            
            } completion:nil];
    }
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 32, 0)];
    UIFont* theFont = [UIFont systemFontOfSize:18.0];
    label.numberOfLines = 0;
    [label setFont:theFont];

//    [label setText:self.dataArray[indexPath.section][@"merchDesc"]];
    
    [label setText:self.dataArray[indexPath.section][@"merchDesc"]];
    [label sizeToFit];// 显示文本需要的长度和宽度
    
    CGFloat labelHeight = label.frame.size.height;
    
    return screenWidth/8*5+16+labelHeight+16+8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [self.dataArray count];
    return self.dataArray.count ;
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"HotMembersTableViewCellIdentifier";
    HotFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[HotFocusTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }

    NSMutableArray *ab = [[NSMutableArray alloc] init];
    
    if ([self.dataArray[indexPath.section][@"merchImglist"] count] == 0) {
        [ab addObject:@"热点无图片"];
    }
    else {
        for (int i = 0 ; i < [self.dataArray[indexPath.section][@"merchImglist"] count]; i++) {
            [ab addObject:[self.dataArray[indexPath.section][@"merchImglist"] objectAtIndex:i][@"imgUrl"]];
        }
    }
    cell.descriptionLabel.text = self.dataArray[indexPath.section][@"merchDesc"];
    cell.hotImageView.currentInt = 0;
    [cell.hotImageView initImageArr];
    cell.hotImageView.imageArr = ab;
    [cell.hotImageView beginAnimation];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HotFocusTableViewCell* cell = (HotFocusTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [SVProgressShow showWithStatus:@"进入店铺..."];
    
    //点击弹动动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        cell.hotImageView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            cell.hotImageView.layer.transform = CATransform3DIdentity;
            
            
        } completion:^(BOOL finished) {
            
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:nil];
            [self performSelector:@selector(todoSomething:) withObject:indexPath afterDelay:0.0f];
        }];
        
    }];
}


#pragma mark - 延时显示状态然后跳转
- (void)todoSomething:(NSIndexPath *)indexPath
{
   
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _merchId = [self.dataArray objectAtIndex:indexPath.section][@"merchId"];
    _merchTitle = [self.dataArray objectAtIndex:indexPath.section][@"merchTitle"];
    
    //showType 0:超市  1:点餐
    if ([[self.dataArray objectAtIndex:indexPath.section][@"showType"] isEqualToString:@"0"]) {
        //超市
        NewStoreCollectController *newStoreCollectController = [[NewStoreCollectController alloc] init];
        newStoreCollectController.merchId = _merchId;
        newStoreCollectController.merchTitle = _merchTitle;
        newStoreCollectController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newStoreCollectController animated:YES];
        [SVProgressShow dismiss];
    }
    else  if ([[self.dataArray objectAtIndex:indexPath.section][@"showType"] isEqualToString:@"1"]){
        //点餐
        
        StoreViewController *storeViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"storeView"];
        storeViewController.merchId = _merchId;
        storeViewController.merchTitle = _merchTitle;
        [storeViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        storeViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:storeViewController animated:YES];
        
        [SVProgressShow dismiss];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.alpha = 1;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    cell.alpha = 0;
    cell.transform = CGAffineTransformMakeTranslation(0, 0);
}


- (void)didRemoveTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray* deleteArr = [NSMutableArray arrayWithObject:[self.dataArray objectAtIndex:indexPath.section]];
    [self.dataArray removeObjectAtIndex:indexPath.section];
    
    [self.tableView beginUpdates];
  //  [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    [self.dataArray addObjectsFromArray:deleteArr];
    [self.tableView reloadData];
}

#pragma mark - 筛选商店
- (IBAction)selectStore:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HotListSelectViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"HotListSelectViewController"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.dataArray = self.dataArray;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end









