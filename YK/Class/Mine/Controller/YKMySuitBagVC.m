//
//  YKMySuitBagVC.m
//  YK
//
//  Created by LXL on 2017/11/20.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMySuitBagVC.h"
#import "YKSuitEnsureCell.h"
#import "YKMyBagSMSCell.h"
#import "YKReturnVC.h"
#import "YKSMSInforVC.h"
#import "YKSuitHeader.h"
#import "YKProductDetailVC.h"
#import "YKHomeVC.h"
#import "YKSPDetailVC.h"
#import "YKOrderDetailVC.h"

@interface YKMySuitBagVC ()<UITableViewDelegate,UITableViewDataSource,DXAlertViewDelegate>
{
    YKNoDataView *NoDataView;
    BOOL isHadOrderreceive;//是否预约订单
    int type;
}

@property (nonatomic,strong) UIButton *Button0;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *buttom;
@property (nonatomic,assign) suitBagStatus bagStatus;
@property (nonatomic,strong) NSMutableArray *orderList;//待签收
@property (nonatomic,strong) NSString *orderNo;//订单号

@property (nonatomic,strong) UILabel *line;//红线
@end

@implementation YKMySuitBagVC

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    [YKOrderManager sharedManager].oederSelectIndex = 0;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.layer.shadowColor = [UIColor clearColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    self.navigationController.navigationBar.layer.shadowRadius = 2.f;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(2,0);
//    if (_bagStatus==toBack) {
//        [self searchOrders:type];
//    }
//
    [self searchOrders:[YKOrderManager sharedManager].oederSelectIndex-100];
}

- (void)test{
    [[YKOrderManager sharedManager]toReceiveWithOrderNo:[YKOrderManager sharedManager].ID OnResponse:^(NSDictionary *dic) {
        [self searchOrders:1];
    }];
}

- (void)alert{
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"问题解决" message:@"如果遇到特殊情况无法预约或预约出现问题，需要您主动联系快递上门取件(快递费由衣库平台承担)。收件地址：山东省 青州市 丰收二路 衣库仓储中心,收件人信息：衣库APP,收件人联系方式：15614205180" cancelBtnTitle:@"取消" otherBtnTitle:@"确定"];
    alertView.delegate = self;
   [alertView show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[YKOrderManager sharedManager]clear];
//    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.title = @"历史订单";
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"333333"];
    title.font = PingFangSC_Regular(kSuitLength_H(14));
    
    self.navigationItem.titleView = title;
    UIButton *releaseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.frame = CGRectMake(0, 25, 25, 25);
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"question-1"] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:releaseButton];
    UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.rightBarButtonItems=@[negativeSpacer2,item2];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    [self settingButtons];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(kSuitLength_H(0), kSuitLength_H(50), WIDHT, HEIGHT-64-kSuitLength_H(50)-kSuitLength_H(38)) style:UITableViewStylePlain];
    if (HEIGHT==812) {
         self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(kSuitLength_H(0), kSuitLength_H(50), WIDHT, HEIGHT-104-kSuitLength_H(50)-kSuitLength_H(38)) style:UITableViewStylePlain];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.tableView];
    
    _buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttom.frame = CGRectMake(0, HEIGHT-kSuitLength_H(50)-kSuitLength_H(38)-64, WIDHT, kSuitLength_H(50));
    if (HEIGHT==812) {
         _buttom.frame = CGRectMake(0, HEIGHT-kSuitLength_H(50)-kSuitLength_H(38)-104, WIDHT, kSuitLength_H(50));
    }
    
    _buttom.backgroundColor = YKRedColor;
    [self.view  addSubview:_buttom];
    [_buttom setTitle:@"\\\\" forState:UIControlStateNormal];
    _buttom.titleLabel.font = PingFangSC_Regular(kSuitLength_H(14));
    [_buttom addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    _buttom.hidden = YES;
    self.tableView.hidden = YES;
   
    
    if (WIDHT!=320) {
        NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
        
        [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"无订单"] statusDes:@"暂无订单哦~" hiddenBtn:YES actionTitle:@"" actionBlock:^{
            
        }];
    }
    
  
    NoDataView.frame = CGRectMake(0, HEIGHT/4, WIDHT,HEIGHT-212);
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    NoDataView.backgroundColor = self.view.backgroundColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:NoDataView];
}

-(void)settingButtons{
    self.selectedIndex = [YKOrderManager sharedManager].oederSelectIndex;
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, 50*WIDHT/375)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];

    NSArray *arr  =[NSArray arrayWithObjects:@"全部衣袋",@"待签收",@"待归还",@"已归还", nil];
    int index = 0;
    if (self.selectedIndex == 100) {
        index = 0;
        _bagStatus = totalBag;
    }
    if (self.selectedIndex == 101) {
        _bagStatus = toReceive;
        index = 1;
    }
    if (self.selectedIndex == 102) {
        index = 2;
        _bagStatus = toBack;
    }
    if (self.selectedIndex == 103) {
        index = 3;
        _bagStatus = hadBack;
    }
    _line.frame = CGRectMake(WIDHT/8+WIDHT/4*index-kSuitLength_H(30), kSuitLength_H(45), kSuitLength_H(30), 2);
    //查询订单,刚进来的时候
    [self searchOrders:self.selectedIndex-100];
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(WIDHT/4*i, 0, WIDHT /4, kSuitLength_H(50));
        button.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.titleLabel.font = PingFangSC_Regular(kSuitLength_H(14));
        [button setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
//        button.titleLabel setf
        [button setTitleColor:YKRedColor forState:UIControlStateSelected];
//        button.clipsToBounds = YES;
//        button.layer.cornerRadius = 15;
        button.tag = 100+i;
        
        if (i == index) {
            button.selected = YES;
            button.titleLabel.font = PingFangSC_Regular(kSuitLength_H(14));
            [button setTitleColor:YKRedColor forState:UIControlStateNormal];
            self.Button0 = button;
        }
//        [button setBackgroundImage:[UIImage imageNamed:@"白.png"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"红.jpg"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
    }
    self.line = [[UILabel alloc]initWithFrame:CGRectMake(WIDHT/8-kSuitLength_H(30)/2, kSuitLength_H(50)-1, kSuitLength_H(30), 2)];
    _line.backgroundColor = YKRedColor;
    _line.frame = CGRectMake(WIDHT/8+WIDHT/4*index-kSuitLength_H(30)/2, kSuitLength_H(45), kSuitLength_H(30), 2);
//    [backView addSubview:_line];
}

- (void)searchOrders:(NSInteger)orderStatus{

    WeakSelf(weakSelf)
             
             [[YKOrderManager sharedManager]searchHistoryOrderWithOrderStatus:orderStatus OnResponse:^(NSArray *array) {
                         [self.orderList removeAllObjects];
                         self.orderList = [NSMutableArray arrayWithArray:array];
                 
                 if (self.orderList.count==0) {
                     NoDataView.hidden = NO;
                     self.tableView.hidden = YES;
                 }else {
                     NoDataView.hidden = YES;
                     self.tableView.hidden = NO;
                 }
                 
                 if (_bagStatus == toReceive) {
                     _buttom.hidden = NO;
                     if (self.orderList.count==0) {
                         _buttom.hidden = YES;
                     }else {
                         NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.orderList[0]];
                         if ([dic[@"sendTime"] isEqual:[NSNull null]]) {//是否发货
                             [_buttom setTitle:@"等待发货" forState:UIControlStateNormal];
                             [_buttom setUserInteractionEnabled:NO];
                              _buttom.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
                             [_buttom setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                         }else {
                             [_buttom setTitle:@"确认收货" forState:UIControlStateNormal];
                             _buttom.backgroundColor = YKRedColor;
                             [_buttom setUserInteractionEnabled:YES];
                              [_buttom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                         }
                     }
                 }else {
                     _buttom.hidden = YES;
                 }
                 [self.tableView reloadData];
//                         if (orderStatus==2) {//待归还,判断是否已预约归还
//                 //            [[YKOrderManager sharedManager]queryReceiveOrderOnResponse:^(NSDictionary *dic) {
//                 //                NSString *s = [NSString stringWithFormat:@"%@",dic[@"data"]];
//                 //                if ([s isEqualToString:@"该订单未预约归还"]) {//未预约归还
//                 //                    isHadOrderreceive = NO;
//                 //                }else {//未预约
//                 //                    isHadOrderreceive = YES;
//                 //                }
//                 //
//                                 [weakSelf reloadUI];
//                 //
//                 //            }];
//
//                         }else {
//                             [weakSelf reloadUI];
//                         }
                     }];
    
  
//    [[YKOrderManager sharedManager]searchOrderWithOrderStatus:orderStatus OnResponse:^(NSMutableArray *array) {
//        [self.orderList removeAllObjects];
//        self.orderList = [NSMutableArray arrayWithArray:array];
//        if (orderStatus==102) {//待归还,判断是否已预约归还
////            [[YKOrderManager sharedManager]queryReceiveOrderOnResponse:^(NSDictionary *dic) {
////                NSString *s = [NSString stringWithFormat:@"%@",dic[@"data"]];
////                if ([s isEqualToString:@"该订单未预约归还"]) {//未预约归还
////                    isHadOrderreceive = NO;
////                }else {//未预约
////                    isHadOrderreceive = YES;
////                }
////
//                [weakSelf reloadUI];
////
////            }];
//
//        }else {
//            [weakSelf reloadUI];
//        }
//    }];
}

-(void)buttonAction:(UIButton *)button{
    
    [[YKOrderManager sharedManager]clear];
    
    self.tableView.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    
    int index = 0;
    if (button.tag == 100) {
        index=0;
        _bagStatus = totalBag;
    }
    if (button.tag == 101) {
        index=1;
        _bagStatus = toReceive;
    }
    if (button.tag == 102) {
        index=2;
        _bagStatus = toBack;
    }
    if (button.tag == 103) {
        index=3;
        _bagStatus = hadBack;
    }
    type = index;
    [YKOrderManager sharedManager].oederSelectIndex = button.tag;
    [UIView animateWithDuration:0.25 animations:^{
        _line.frame = CGRectMake(WIDHT/8+WIDHT/4*index-kSuitLength_H(30)/2, kSuitLength_H(45), kSuitLength_H(30), 2);
    }];
    
    if (self.Button0 != button) {
        self.Button0.selected = NO;
        button.selected = YES;
        button.titleLabel.font = PingFangSC_Regular(kSuitLength_H(14));
        [button setTitleColor:YKRedColor forState:UIControlStateNormal];
        [self.Button0 setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        self.Button0.titleLabel.font =  PingFangSC_Regular(kSuitLength_H(14));
    }
    self.Button0 = button;
    [self searchOrders:button.tag-100];
}

- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndexz:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[YKOrderManager sharedManager]ensureReceiveWithOrderNo:[YKOrderManager sharedManager].ID OnResponse:^(NSDictionary *dic) {
                [self searchOrders:1];
            
        }];
    }
    
}


- (void)btnClick{
    if (_bagStatus==toReceive) {

//        [[YKOrderManager sharedManager]ensureReceiveWithOrderNo:[YKOrderManager sharedManager].orderNo OnResponse:^(NSDictionary *dic) {
//            [self searchOrders:1];
            DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"温馨提示" message:@"您是否确认已收到衣袋？" cancelBtnTitle:@"还没收到" otherBtnTitle:@"已签收"];
        NSDictionary *DIC = [NSDictionary dictionaryWithDictionary:self.orderList[0]];
        alertView.yesBlock = ^(void){
            [[YKOrderManager sharedManager]ensureReceiveWithOrderNo:DIC[@"orderNo"] OnResponse:^(NSDictionary *dic) {
                [self searchOrders:1];
                
            }];
        };
            alertView.delegate = self;
            [alertView show];
//        }];
    }
    if (_bagStatus==toBack) {
        
        //预约归还,push
        
        //春节期间不能归还的判断
        if ([steyHelper validateWithStartTime:@"2018-02-13" withExpireTime:@"2018-02-23"]) {
            DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"平台提示" message:@"小仙女，快递小哥还没回来上班，衣服23号以后预约归还即可，此期间会员期会冻结，不会浪费哦!" cancelBtnTitle:@"好的" otherBtnTitle:@"我知道了"];
            alertView.delegate = self;
            [alertView show];
            return;
        }
        YKReturnVC *r = [YKReturnVC new];
        [self.navigationController pushViewController:r animated:YES];
    }
}

- (void)reloadUI{

//    if (_bagStatus == totalBag) {//全部衣袋
//        if ([YKOrderManager sharedManager].totalOrderList.count==0) {
//            self.tableView.hidden = YES;
//            NoDataView.hidden = NO;
//            _buttom.hidden = YES;
//        }else {
//            if ([YKOrderManager sharedManager].sectionArray.count==1&&([[YKOrderManager sharedManager].sectionArray containsObject:@"2"])) {
//                self.tableView.frame = CGRectMake(10, 50*WIDHT/375, WIDHT-20, HEIGHT-64-50*WIDHT/375);
//            }else {
//                self.tableView.frame = CGRectMake(10, 50*WIDHT/375, WIDHT-20, HEIGHT-64-50*WIDHT/375);
//            }
//            self.tableView.hidden = NO;
//            _buttom.hidden = YES;
//            NoDataView.hidden = YES;
//        }
//        [self.tableView reloadData];
//        return;
//    }
//
//        if (self.orderList.count==0) {
//            self.tableView.hidden = YES;
//            NoDataView.hidden = NO;
//            _buttom.hidden = YES;
//        }else {
//            self.tableView.hidden = NO;
//            _buttom.hidden = NO;
//            NoDataView.hidden = YES;
//        }
//        //请求成功后
//        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//            if ((_bagStatus==toReceive)&&self.orderList.count!=0) {
//                _buttom.hidden = NO;
//                self.tableView.frame = CGRectMake(10, 50*WIDHT/375, WIDHT-20, HEIGHT-64-50*WIDHT/375-50);
//                if (_bagStatus==toReceive) {//待签收
//                    if ([YKOrderManager sharedManager].isOnRoad) {
//                        [_buttom setTitle:@"确认收货" forState:UIControlStateNormal];
//                        [_buttom setBackgroundColor:YKRedColor];
//                        _buttom.userInteractionEnabled = YES;
//
//                    }else {
//                        [_buttom setTitle:@"待发货" forState:UIControlStateNormal];
//                        [_buttom setBackgroundColor:[UIColor colorWithHexString:@"999999"]];
//                         _buttom.userInteractionEnabled = NO;
//                    }
//
//                }else {
////                    if (!isHadOrderreceive) {
////                        [_buttom setTitle:@"预约归还" forState:UIControlStateNormal];
////                         _buttom.titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
////                        _buttom.userInteractionEnabled = YES;
////                    }else {
////                        [_buttom setTitle:@"已预约,等待取件" forState:UIControlStateNormal];
////                        _buttom.titleLabel.textColor = [UIColor colorWithHexString:@"FDDD55"];
////                        _buttom.userInteractionEnabled = NO;
////                    }
//
//                }
//            }else {
//                self.tableView.frame = CGRectMake(10, 50*WIDHT/375, WIDHT-20, HEIGHT-64-50*WIDHT/375);
//                _buttom.hidden = YES;
//            }
    
            [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kSuitLength_H(120) ;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    NSArray *array = [NSArray arrayWithArray:self.orderList[section][@"userOrderDetailsVoList"]];
    
    return array.count;
    
//    if (_bagStatus==totalBag) {
//        NSArray *array = [NSArray arrayWithArray:[YKOrderManager sharedManager].totalOrderList[section]];
//        if (section==0&&([[YKOrderManager sharedManager].sectionArray containsObject:@"0"])) {
//            return array.count;
//        }else {
//            NSArray *a = [NSArray arrayWithArray:array[0]];
//            return a.count;
//        }
//    }
//
//    if (_bagStatus==toReceive) {
//        return self.orderList.count+1;
//    }
//    if (_bagStatus==toBack) {
//        NSArray *array = [NSArray arrayWithArray:self.orderList[section][@"userOrderDetailsVoList"]];
//        return array.count;
//    }
//    if (_bagStatus==hadBack) {
//        return self.orderList.count;
//    }
//    return CGFLOAT_MIN;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (_bagStatus==totalBag) {
    
        return self.orderList.count;

//    }
//    if (_bagStatus == toBack) {
//        return self.orderList.count;
//    }
//    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (_bagStatus==totalBag) {
//        if ([[YKOrderManager sharedManager].sectionArray containsObject:receiveSection]) {
//            if (section==0) {
//                return kSuitLength_H(40);
//            }
//        }
//        return kSuitLength_H(40);
//    }
//
//    if (_bagStatus==toBack) {
//        return kSuitLength_H(40);
//    }
    
    
    return kSuitLength_H(64);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    if (_bagStatus==totalBag) {
//
//        NSInteger headerSection = [[YKOrderManager sharedManager].sectionArray[section] intValue];
//        YKSuitHeader *header = [[NSBundle mainBundle] loadNibNamed:@"YKSuitHeader" owner:self options:nil][headerSection];
//       //物流信息
//        header.SMSBlock = ^(void){
//            YKSMSInforVC *sms = [YKSMSInforVC new];
//            sms.isFromeSF = YES;
//            sms.orderNo = [YKOrderManager sharedManager].orderNo;
//
//             [self.navigationController pushViewController:sms animated:YES];
//        };
//        //确认收货(未用)
//        header.ensureReceiveBlock = ^(void){
//            DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"温馨提示" message:@"您是否确认已收到衣袋？" cancelBtnTitle:@"还没收到" otherBtnTitle:@"已签收"];
//            alertView.delegate = self;
//            [alertView show];
//
//        };
//        //预约归还（未用）
//        header.yuyue.text = @"等待取件";
//        header.orderBackBlock = ^(void){//
//            if (isHadOrderreceive) {
//                return ;
//            }
//            YKReturnVC *r = [YKReturnVC new];
//            [self.navigationController pushViewController:r animated:YES];
//        };
//         return header;
//    }
//
//    if (_bagStatus==toBack) {
//
//         YKSuitHeader *header = [[NSBundle mainBundle] loadNibNamed:@"YKSuitHeader" owner:self options:nil][0];
//        //TODOL：scash
//        [[YKOrderManager sharedManager]queryReceiveOrderNo:self.orderList[section][@"orderNo"] OnResponse:^(NSDictionary *dic) {
//            NSString *s = [NSString stringWithFormat:@"%@",dic[@"data"]];
//            if ([s isEqualToString:@"该订单未预约归还"]) {//未预约归还
//                [header resetUI:0];
//                header.SMSBlock = ^(void){
//                    [YKOrderManager sharedManager].orderNo = self.orderList[section][@"orderNo"];
//                    YKReturnVC *r = [YKReturnVC new];
//                    [self.navigationController pushViewController:r animated:YES];
//                };
//
//            }else {//已预约
//                [header resetUI:1];
//                header.SMSBlock = ^(void){//返件物流信息
//                    YKSMSInforVC *sms = [YKSMSInforVC new];
//                    sms.isFromeSF = NO;
//                    sms.orderNo = self.orderList[section][@"orderNo"];
////                    sms.orderNo = @"2018050398314";
//                    [self.navigationController pushViewController:sms animated:YES];
//                };
//            }
//        }];
//        return header;
//    }
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    //XIAN
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.width.mas_equalTo(view.mas_width);
        make.height.mas_equalTo(10);
    }];
    //
    UILabel *status = [[UILabel alloc]init];
    status.font = PingFangSC_Medium(kSuitLength_H(14));
    status.textColor = mainColor;
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.orderList[section]];
    status.text = @"衣袋状态：";
    NSInteger sta = [dic[@"orderState"] intValue];
    switch (sta) {
        case 1:
            status.text = @"衣袋状态：待签收";
            break;
        case 2:
            //待归还，看是否已经预约
            [self isBack:status section:section];
           
            break;
        case 3:
            status.text = @"衣袋状态：已归还";
            break;
            
        default:
            break;
    }
   
    [view addSubview:status];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(16));
        make.top.mas_equalTo(line.mas_bottom).offset(kSuitLength_H(14));
    }];
    
    UIImageView *rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:     @"右-2 copy 3"]];
    [view addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-16));
        make.centerY.mas_equalTo(status.mas_centerY);
    }];
    
    
    UILabel *l = [[UILabel alloc]init];
    l.font = PingFangSC_Medium(kSuitLength_H(12));
    l.textColor = mainColor;
    l.text = @"订单详情";
    [view addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightImage.mas_left).offset(-kSuitLength_H(6));
        make.centerY.mas_equalTo(status.mas_centerY);
    }];
    
    [l setUserInteractionEnabled:YES];
    UITapGestureRecognizer *TAP = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        //调到订单详情页
        YKOrderDetailVC *orderDetail = [[YKOrderDetailVC alloc]init];
        orderDetail.orderId = self.orderList[section][@"orderNo"];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }];
    [l addGestureRecognizer:TAP];
    [view addGestureRecognizer:TAP];
    
    UILabel *line2 = [[UILabel alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(status.mas_bottom).offset(kSuitLength_H(20));
        make.centerX.mas_equalTo(view.mas_centerX);
        make.width.mas_equalTo(view.mas_width);
        make.height.mas_equalTo(1);
    }];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (_bagStatus == totalBag) {
//        static NSString *ID = @"cell1";
//        YKSuitEnsureCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
//        if (mycell == nil) {
//            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitEnsureCell" owner:self options:nil][0];
//        }
//        YKSuit *suit = [[YKSuit alloc]init];
//        if ([YKOrderManager sharedManager].totalOrderList.count>0) {
//             NSArray *array = [NSArray arrayWithArray:[YKOrderManager sharedManager].totalOrderList[indexPath.section]];//数据源
//            if (indexPath.section==0&&([[YKOrderManager sharedManager].sectionArray containsObject:@"0"] )) {
//                [suit initWithDictionary:array[indexPath.row]];
//            }else {
//                [suit initWithDictionary:array[0][indexPath.row]];
//            }
//        }
//        mycell.suit = suit;
//        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return mycell;
//    }
//    if (_bagStatus == toBack) {
//        static NSString *ID = @"cell2";
//        YKSuitEnsureCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
//        if (mycell == nil) {
//            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitEnsureCell" owner:self options:nil][0];
//        }
//        YKSuit *suit = [[YKSuit alloc]init];
//        if (indexPath.section<self.orderList.count) {
//            [suit initWithDictionary:self.orderList[indexPath.section][@"userOrderDetailsVoList"][indexPath.row]];
//        }
//        mycell.suit = suit;
//        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return mycell;
//    }
//    if (_bagStatus == hadBack) {
//        static NSString *ID = @"cell3";
//        YKSuitEnsureCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
//        if (mycell == nil) {
//            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitEnsureCell" owner:self options:nil][0];
//        }
//        YKSuit *suit = [[YKSuit alloc]init];
//        if (indexPath.row<self.orderList.count) {
//            [suit initWithDictionary:self.orderList[indexPath.row]];
//        }
//
//        mycell.suit = suit;
//        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return mycell;
//    }
//    if (indexPath.row==0&&_bagStatus == toReceive) {//代签收
//        static NSString *ID = @"SMScell";
//        YKMyBagSMSCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
//        if (mycell == nil) {
//            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMyBagSMSCell" owner:self options:nil][0];
//        }
//        mycell.scanSMSBlock = ^(void){
//            YKSMSInforVC *sms = [YKSMSInforVC new];
//            sms.isFromeSF = YES;
//            sms.orderNo = [YKOrderManager sharedManager].orderNo;
//            [self.navigationController pushViewController:sms animated:YES];
//        };
//        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return mycell;
//    }
    static NSString *ID = @"cell5";
    YKSuitEnsureCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (mycell == nil) {
        mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitEnsureCell" owner:self options:nil][0];
    }
    YKSuit *suit = [[YKSuit alloc]init];
    NSArray *a = [NSArray arrayWithArray:self.orderList[indexPath.section][@"userOrderDetailsVoList"]];
    if (indexPath.row<a.count) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:a[indexPath.row]];
        [suit initWithDictionary:dic];
    }
    
    mycell.suit = suit;
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mycell;
}

- (void)isBack:(UILabel *)lable section:(NSInteger)section{
    [[YKOrderManager sharedManager]queryReceiveOrderNo:self.orderList[section][@"orderNo"] OnResponse:^(NSDictionary *dic) {
        NSString *s = [NSString stringWithFormat:@"%@",dic[@"data"]];
        if ([s isEqualToString:@"该订单未预约归还"]) {//未预约归还
            lable.text = @"衣袋状态：待归还";
        }else {//已预约
            lable.text = @"衣袋状态：归还中";
        }
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     YKSuitEnsureCell*cell = (YKSuitEnsureCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    //请求商品信息,判断是否下架
    [[YKHomeManager sharedManager]getProductDetailInforWithProductId:[cell.suit.clothingId intValue] type:1 OnResponse:^(NSDictionary *dic) {

        if ([dic[@"status"] intValue] == 400) {
            [smartHUD alertText:self.view alert:dic[@"msg"] delay:2];
           
        }else {
            
//            if (cell.suit.classify==1) {
                YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
                detail.canBuy = YES;
                detail.productId = cell.suit.clothingId;
                detail.titleStr = cell.suit.clothingName;
                detail.sizeNum = cell.suit.clothingStockId;
                detail.sizeType = cell.suit.clothingStockType;
                detail.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detail animated:YES];
//            }else {
//                YKSPDetailVC *detail = [[YKSPDetailVC alloc]init];
//                detail.productId = cell.suit.clothingId;
//                detail.titleStr = cell.suit.clothingName;
//                detail.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:detail animated:YES];
//            }
            
        }
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (_bagStatus != totalBag&&_bagStatus!=toBack) {
//        return;
//    }
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 69; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)leftAction{
    if (_isFromSuccess) {
        YKHomeVC *chatVC = [[YKHomeVC alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = self.tabBarController.viewControllers[0];
        chatVC.hidesBottomBarWhenPushed = YES;
        self.tabBarController.selectedViewController = nav;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
