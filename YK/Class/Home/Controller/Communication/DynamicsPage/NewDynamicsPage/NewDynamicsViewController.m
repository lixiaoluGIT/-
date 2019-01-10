//
//  NewDynamicsViewController.m
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import "NewDynamicsViewController.h"
#import "NewDynamicsViewController+Delegate.h"
#import "NewDynamicsLayout.h"
#import "DynamicsModel.h"
#import "YKPublicCell.h"
#import "TopPublicVC.h"

#import "SDTimeLineRefreshHeader.h"//下拉刷新控件
#import "YKBaseScrollView.h"

@interface NewDynamicsViewController ()

@property(nonatomic,strong)SDTimeLineRefreshHeader * refreshHeader;
@property(nonatomic,strong)UISegmentedControl * segment;

@end

@implementation NewDynamicsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed  = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"朋友圈";
    [self setup];
    [self dragUpToLoadMoreData];
    [self dragDownToLoadMoreData];
//    [self.view addSubview:self.commentInputTF];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment0" ofType:@"plist"];
    NSArray * dataArray = [NSArray arrayWithContentsOfFile:plistPath];
    
//    [self.layoutsArr removeAllObjects];
    for (id dict in dataArray) {
        //字典转模型
        DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];
        NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
        [self.layoutsArr addObject:layout];
    }
//    [self.dynamicsTable reloadData];
    
    [self performSelector:@selector(refresh) afterDelay:0.1];
//    //外观代理
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//
//    //修改标题颜色
//    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    [navigationBar setTitleTextAttributes:dict];
//
////    navigationBar.barTintColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
////    navigationBar.tintColor = [UIColor whiteColor];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //我要晒图按钮
    
    UIButton *public = [UIButton buttonWithType:UIButtonTypeCustom];
    [public setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [self.view addSubview:public];
    [public mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_bottom).offset(-120);
    }];
    [public addTarget:self action:@selector(Public) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)Public{
    TopPublicVC *hmpositionVC = [[TopPublicVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hmpositionVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)refresh{
     [self.dynamicsTable reloadData];
}
- (void)keyboardWillHide:(NSNotification *)notification{
    
    CGRect frame = _commentInputTF.frame;
    frame.origin.y = self.view.frame.size.height;
    _commentInputTF.frame = frame;
}

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    CGRect keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = _commentInputTF.frame;
    frame.origin.y = keyBoardFrame.origin.y - 45;
    _commentInputTF.frame = frame;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [SVProgressHUD dismiss];
    [JRMenuView dismissAllJRMenu];
}
- (void)setup
{
    [self.view addSubview:self.dynamicsTable];
    
}
#pragma mark - 下啦刷新
- (void)dragDownToLoadMoreData
{
    self.dynamicsTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadMoreData];
            }];
//    [self.dynamicsTable.mj_header beginRefreshing];
//    // 添加默认的上拉刷新
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//
//    // 设置文字
//    [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
//    [footer setTitle:@"加载中......" forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
//
//    // 设置字体
//    footer.stateLabel.font = [UIFont systemFontOfSize:14];
//
//    // 设置颜色
//    footer.stateLabel.textColor = [UIColor grayColor];
//
//    // 设置footer
//    self.dynamicsTable.mj_header = footer;
}
#pragma mark - 上拉加载更多数据
- (void)dragUpToLoadMoreData
{
//    [self.dynamicsTable.footer beginRefreshing];
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    // 设置文字
    [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中......" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];

    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];

    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];

    // 设置footer
    self.dynamicsTable.mj_footer = footer;
}
- (void)loadMoreData
{
    //执行事件
        
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment0" ofType:@"plist"];
//        NSArray * dataArray = [NSArray arrayWithContentsOfFile:plistPath];
//
//        for (id dict in dataArray) {
//            DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];
//            NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
//            [self.layoutsArr addObject:layout];
//        }
//        [self.dynamicsTable reloadData];
        [self.dynamicsTable.mj_footer endRefreshingWithNoMoreData];
    
    [self.dynamicsTable.mj_header endRefreshing];
}
#pragma mark - getter
-(UITableView *)dynamicsTable
{
    if (!_dynamicsTable) {
        _dynamicsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-170) style:UITableViewStylePlain];
        _dynamicsTable.dataSource = self;
        _dynamicsTable.delegate = self;
        _dynamicsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        WeakSelf(weakSelf)
//        YKPublicCell *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKPublicCell" owner:self options:nil][0];
//        bagCell.PublicBlock = ^(void){
//            TopPublicVC *hmpositionVC = [[TopPublicVC alloc] init];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hmpositionVC];
//                    [weakSelf presentViewController:nav animated:YES completion:nil];
//        };
        YKBaseScrollView *cycleView = [[YKBaseScrollView alloc]initWithFrame:CGRectMake(0,0,WIDHT, self.view.frame.size.width*0.58)];
        
        cycleView.imagesArr = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525692612217&di=f0a200f1da4510619be8ef47cc9cd74c&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0193dd57ad44300000018c1b6ea932.jpg%402o.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525692612218&di=7e6eadd43105fdd712e9187d5d4f703b&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01b5f55780cfca0000018c1b5326f9.jpg%402o.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525692612215&di=bf7a100c20dca202bd1f2427f6cc229b&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01973759a45b87a801211d25e6b311.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525692612213&di=377404f36aefd024c6a4eec3f3ce8a2b&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01649759a8c8f6a8012028a9e6dd1a.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525693155271&di=6c5c0ff1c2de534ef6a90e6e12acc46b&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F014bcd585e1c14a801219c7738e3c4.png%402o.jpg"];
//        cycleView.delegate = self;
        
        _dynamicsTable.tableHeaderView = cycleView;
    
        [_dynamicsTable registerClass:[NewDynamicsTableViewCell class] forCellReuseIdentifier:@"NewDynamicsTableViewCell"];
        if ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending) {
            _dynamicsTable.estimatedRowHeight = 0;
        }

        UITapGestureRecognizer * tableViewGesture = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [_commentInputTF resignFirstResponder];
        }];
        
        tableViewGesture.cancelsTouchesInView = NO;
        [_dynamicsTable addGestureRecognizer:tableViewGesture];
    }
    return _dynamicsTable;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    if (scrollView == self.dynamicsTable)
    {
        CGFloat sectionHeaderHeight = 69; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}
-(UITextField *)commentInputTF
{
    if (!_commentInputTF) {
        _commentInputTF = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 45)];
        _commentInputTF.backgroundColor = [UIColor lightGrayColor];
        _commentInputTF.delegate = self;
        _commentInputTF.textColor = [UIColor whiteColor];
    }
    return _commentInputTF;
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

@end
