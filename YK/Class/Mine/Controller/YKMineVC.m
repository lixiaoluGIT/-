//
//  YKMineVC.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMineVC.h"
#import "YKSuitCell.h"
#import "YKMineCell.h"
#import "YKMineBagCell.h"
#import "YKMySuitBagVC.h"
#import "YKOrderSegementVC.h"
#import "YKNormalQuestionVC.h"
#import "YKWalletVC.h"
#import "YKAddressVC.h"
#import "YKSettingVC.h"
#import "YKToBeVIPVC.h"
#import "YKEditInforVC.h"
#import "YKLoginVC.h"
#import "YKDepositVC.h"
#import "YKMyHeaderView.h"
#import "YKMineCategoryCell.h"
#import "YKShareVC.h"
#import "YKReturnVC.h"
#import "YKCouponSegementVC.h"
#import "YKVipCell.h"
#import "YKUserAccountVC.h"
#import "YKSuitVC.h"
#import "YKCouponListVC.h"
#import "YKInvitVC.h"
#import "YKChangeCardVC.h"

#import "YKMineHeaderView.h"
#import "YKSuitSegmentVC.h"
#import "YKHistorySuitVC.h"


@interface YKMineVC ()<UITableViewDelegate,UITableViewDataSource,DXAlertViewDelegate>
{
//    YKMineheader *head;
    YKMyHeaderView *head;
    YKMineHeaderView *header;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *images;
@end

@implementation YKMineVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];;
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
//    [self setStatusBarBackgroundColor:[UIColor colorWithRed:246.0/255 green:102.0/255 blue:102.0/255 alpha:1]];
    [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
         header.user = [YKUserManager sharedManager].user;
        [self.tableView reloadData];
    }];
    
//    if ([Token length] == 0) {
//        self.tableView.scrollEnabled = NO;
//    }else {
//        self.tableView.scrollEnabled = YES;
//    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,-20, WIDHT, HEIGHT-30) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}
//-(UIImageView*)imageview{
//    if (!_headImageView) {
//        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, kSuitLength_H(182))];
////        if (WIDHT==320) {
////            _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, WIDHT, kSuitLength_H(182))];
////        }
////        if (WIDHT==375) {
////            _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, WIDHT, kSuitLength_H(182))];
////        }
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 11) {
//             _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, WIDHT, kSuitLength_H(182))];
//        }
//        if (HEIGHT==812) {
//            _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, WIDHT, kSuitLength_H(182))];
//        }
//        _headImageView.image = [UIImage imageNamed:@"Oval 6"];
////        [_headImageView sizeToFit];
//        _headImageView.backgroundColor = [UIColor whiteColor];
//        self.origialFrame = _headImageView.frame;
//    }
//    return _headImageView;
//}
-(void)addHeadView{
    WeakSelf(weakSelf)
//    head= [[YKMyHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, kSuitLength_H(300))];
    
    header = [[YKMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, kSuitLength_H(220) + kSuitLength_H(84) + kSuitLength_H(10)*3 + kSuitLength_H(82) + kSuitLength_H(114)*2)];
   
    header.userInteractionEnabled = YES;
     self.tableView.tableHeaderView=header;
    header.btnClickBlock = ^(NSInteger tag,NSInteger VIPStatus) {
        switch (tag) {
                case 400:
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    YKInvitVC *set = [YKInvitVC new];
                    set.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:set animated:YES];
                }
                break;
            case 1:
                NSLog(@"1");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    YKEditInforVC *set = [[YKEditInforVC alloc]initWithNibName:@"YKEditInforVC" bundle:[NSBundle mainBundle]];
                    set.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:set animated:YES];
                }
                
                break;
            case 2:
                 NSLog(@"2");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    if (VIPStatus==4) {//未开通
                        YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
                        
                        [weakSelf presentViewController:nav animated:YES completion:^{
                            
                        }];
                    }else {
                        YKWalletVC *wallet = [YKWalletVC new];
                        wallet.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:wallet animated:YES];
                    }
                }
                break;
            case 3:
                 NSLog(@"3");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    YKUserAccountVC *account = [YKUserAccountVC new];
                    account.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:account animated:YES];
                }
                break;
            case 4:
                 NSLog(@"4");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    YKCouponListVC *account = [YKCouponListVC new];
                    account.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:account animated:YES];
                }
                break;
            case 100://全部订单
                 NSLog(@"100");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    YKOrderSegementVC *seg = [YKOrderSegementVC new];
                    seg.hidesBottomBarWhenPushed = YES;
                    seg.isFromOther = NO;
                    seg.type = 0;//到买衣
                    [YKOrderManager sharedManager].selectIndex = 0;//到未支付订单
                    [weakSelf.navigationController pushViewController:seg animated:YES];
                }
                break;
            case 101://待付款
                 NSLog(@"101");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    YKOrderSegementVC *seg = [YKOrderSegementVC new];
                    seg.hidesBottomBarWhenPushed = YES;
                    seg.isFromOther = NO;
                    seg.type = 1;//到买衣
                    [YKOrderManager sharedManager].selectIndex = 1;//到未支付订单
                    [YKOrderManager sharedManager].oederSelectIndex = 0;
                    [weakSelf.navigationController pushViewController:seg animated:YES];
                }
                break;
            case 102://待签收
                 NSLog(@"102");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    YKOrderSegementVC *seg = [YKOrderSegementVC new];
                    seg.hidesBottomBarWhenPushed = YES;
                    seg.isFromOther = NO;
                    seg.type = 0;//到买衣
                    [YKOrderManager sharedManager].oederSelectIndex = 101;
                    
                    [weakSelf.navigationController pushViewController:seg animated:YES];
                }
                break;
            case 103://待归还
                 NSLog(@"103");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    YKOrderSegementVC *seg = [YKOrderSegementVC new];
                    seg.hidesBottomBarWhenPushed = YES;
                    seg.isFromOther = NO;
                    seg.type = 0;
                    [YKOrderManager sharedManager].oederSelectIndex = 102;
                    [weakSelf.navigationController pushViewController:seg animated:YES];
                }
                break;
            case 200://兑换卡
                 NSLog(@"200");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    YKChangeCardVC *account = [YKChangeCardVC new];
                    account.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:account animated:YES];
                }
                break;
            case 201://可购买
                 NSLog(@"201");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    [UD setBool:YES forKey:@"toBuy"];
                    YKHistorySuitVC *chatVC = [[YKHistorySuitVC alloc] init];
                    chatVC.isFromCanBuy = YES;
                    chatVC.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:chatVC animated:YES];
//                    UINavigationController *nav = weakSelf.tabBarController.viewControllers[3];
//                    chatVC.hidesBottomBarWhenPushed = YES;
//                    weakSelf.tabBarController.selectedViewController = nav;
//                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
                break;
            case 202://资金账户
                 NSLog(@"202");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    YKUserAccountVC *user = [[YKUserAccountVC alloc]init];
                    user.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:user animated:YES];
                }
                break;
            case 300://联系客服
                 NSLog(@"300");
                if ([Token length] != 0) {
                    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"联系客服" message:@"客服服务时间10:00-19:00" cancelBtnTitle:@"拨打客服电话" otherBtnTitle:@"在线客服"];
                    aleart.titleColor = YKRedColor;
                    aleart.delegate = weakSelf;
                    [aleart show];
                }else{
                    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"联系客服" message:@"客服服务时间10:00-19:00" cancelBtnTitle:@"拨打客服电话" otherBtnTitle:@"在线客服"];
                    aleart.titleColor = YKRedColor;
                    aleart.delegate = weakSelf;
                    [aleart show];
                }
                break;
            case 301://我的地址
                 NSLog(@"301");
                if ([Token length] == 0) {
                    [weakSelf login];
                }else {
                    YKAddressVC *account = [YKAddressVC new];
                    account.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:account animated:YES];
                }
                break;
            case 302://常见问题
                 NSLog(@"302");
                if ([Token length] == 0) {
                    YKNormalQuestionVC  *account = [YKNormalQuestionVC new];
                    account.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:account animated:YES];
                }else {
                    YKNormalQuestionVC  *account = [YKNormalQuestionVC new];
                    account.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:account animated:YES];
                }
                
                break;
            case 303://设置
                NSLog(@"303");
                if ([Token length] == 0) {
                    YKSettingVC*account = [YKSettingVC new];
                    account.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:account animated:YES];
                }else {
                    YKSettingVC*account = [YKSettingVC new];
                    account.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:account animated:YES];
                }
                
        
                break;
                
            default:
                break;
        }
    };
    
    head.VIPClickBlock = ^(NSInteger VIPStatus){
                if ([Token length] == 0) {
                    [weakSelf login];
                    return ;
                }
        
                if (VIPStatus==1) {//使用中
                    YKWalletVC *wallet = [YKWalletVC new];
                    wallet.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:wallet animated:YES];
                }
                if (VIPStatus==2) {//已过期,充值会员
                    YKWalletVC *wallet = [YKWalletVC new];
                    wallet.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:wallet animated:YES];
                }
                if (VIPStatus==3) {//无押金,充押金
                    YKWalletVC *wallet = [YKWalletVC new];
                    wallet.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:wallet animated:YES];
                }
                if (VIPStatus==4) {//未开通
                    YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];

                    [weakSelf presentViewController:nav animated:YES completion:^{

                    }];
                }
            };
    
            head.viewClickBlock = ^(){
                if ([Token length] == 0) {
                    [weakSelf Login];
                    return ;
                }else {
                    YKEditInforVC *set = [[YKEditInforVC alloc]initWithNibName:@"YKEditInforVC" bundle:[NSBundle mainBundle]];
                    set.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:set animated:YES];
                }
            };
    
        head.btnClickBlock = ^(NSInteger tag){
            if ([Token length] == 0) {
                [weakSelf Login];
            }else {
                if (tag==102) {
                    //优惠劵
                    YKCouponListVC *coupon = [YKCouponListVC new];
                    coupon.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:coupon animated:YES];
                    return ;
                }
                if (tag==103) {
                    //钱包，资金账户
                    YKUserAccountVC *account = [YKUserAccountVC new];
                    account.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:account animated:YES];
                    return ;
                }
//                if (tag==102) {
//                    //心愿单
//                    YKSuitVC *suit = [YKSuitVC new];
//                    suit.isFromeProduct = YES;
//                    suit.isAuto = YES;
//                    suit.hidesBottomBarWhenPushed = YES;
//                    [weakSelf.navigationController pushViewController:suit animated:YES];
//                    return ;
//                }
                
                //历史订单
//                YKMySuitBagVC *suit = [YKMySuitBagVC new];
                YKOrderSegementVC *suit = [YKOrderSegementVC new];
//                suit.selectedIndex = tag+1;
                suit.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:suit animated:YES];
            }
        };
}

- (void)viewDidLoad {
    [super viewDidLoad];

     [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    self.title = @"我的";
//    [self.view addSubview:[self imageview]];
    [self.view addSubview:self.tableView];
//    self.tableView.bounces = NO;
    

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addHeadView];

    
    self.images = [NSArray array];
    self.images = @[@"question",@"question",@"1",@"address",@"kefu-1",@"setting"];
    self.titles = [NSArray array];
    self.titles = @[@"激活兑换卡",@"我的地址",@"1",@"常见问题",@"联系客服",@"设置"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==1) {
//        return 10;
//    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([Token length] == 0) {
//        if (indexPath.row==2) {
//            return 10;
//        }
//        return kSuitLength_H(50);
//    }
//
//    if (indexPath.section==0) {
//        return kSuitLength_H(97);
//    }
//
//    if (indexPath.row==2) {
//        return 10;
//    }else {
//        return kSuitLength_H(50);
//    }
    return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if ([Token length] == 0) {
//        return 6;
//    }else {
//        if (section==0) {
//            return 1;
//        }else {
//            return 6;
//        }
//    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
//    if ([Token length] == 0) {
//        return 1;
//    }else {
//        return 2;
//    }
    return 1;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
//    if ([Token length] == 0) {
//        static NSString *ID = @"cell";
//        if (indexPath.row==2) {
//            UITableViewCell *cell = [[UITableViewCell alloc]init];
//            cell.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
//            return cell;
//        }
//        YKMineCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
//        if (mycell == nil) {
//            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMineCell" owner:self options:nil][0];
//            mycell.title.text = [NSString stringWithFormat:@"%@",self.titles[indexPath.row]];
//            mycell.title.font = PingFangSC_Regular(kSuitLength_H(14));
//            mycell.title.textColor = mainColor;
//            mycell.image.image = [UIImage imageNamed:self.images[indexPath.row]];
//        }
//        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        if (indexPath.row==0) {
//            mycell.imaHidden = NO;
//        }
//
//        return mycell;
//    }
//
//        if (indexPath.section==0) {
//            static NSString *ID = @"cell";
//            YKMineCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
//            if (mycell == nil) {
//                mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMineCell" owner:self options:nil][2];
//                mycell.title.text = [NSString stringWithFormat:@"%@",self.titles[indexPath.row]];
//            }
//            mycell.selectionStyle = UITableViewCellSelectionStyleNone;
//            if (indexPath.row==0) {
//                mycell.imaHidden = NO;
//            }
//            return mycell;
//        }
//
//    if (indexPath.row==2) {
//        UITableViewCell *cell = [[UITableViewCell alloc]init];
//        cell.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
//        return cell;
//    }
//
//            static NSString *ID = @"cell";
//            YKMineCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
//            if (mycell == nil) {
//                mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMineCell" owner:self options:nil][0];
//                mycell.title.text = [NSString stringWithFormat:@"%@",self.titles[indexPath.row]];
//                mycell.image.image = [UIImage imageNamed:self.images[indexPath.row]];
//            }
//               mycell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            if (indexPath.row==0) {
//                mycell.imaHidden = NO;
//            }
//
//        return mycell;
}

- (void)kefu{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.3) {
        NSString *callPhone = [NSString stringWithFormat:@"tel://%@",PHONE];
        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            /// 大于等于10.0系统使用此openURL方法
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
        return;
    }
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:PHONE message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    alertview.delegate = self;
    [alertview show];
}

- (void)login{
    [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
        [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {

            header.user = [YKUserManager sharedManager].user;
            [self.tableView reloadData];
        }];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([Token length] == 0) {
//            if (indexPath.row==0) {
//                [self Login];
//            }if (indexPath.row==1) {
//                [self Login];
//            }if (indexPath.row==3) {
//                YKNormalQuestionVC *normal = [YKNormalQuestionVC new];
//                normal.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:normal animated:YES];
////                [self kefu];
//
////                DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"联系客服" message:@"客服服务时间10:00-19:00" cancelBtnTitle:@"拨打客服电话" otherBtnTitle:@"在线客服"];
////                aleart.delegate = self;
////                [aleart show];
//
////                NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"qq号码"];
////                NSURL *url = [NSURL URLWithString:qq];
////                [[UIApplication sharedApplication] openURL:url];
//
////                YKChatVC *chatService = [[YKChatVC alloc] init];
////                chatService.conversationType = ConversationType_CUSTOMERSERVICE;
////                chatService.targetId = RoundCloudServiceId;
////                chatService.hidesBottomBarWhenPushed = YES;
////                [self.navigationController pushViewController :chatService animated:YES];
//            }if (indexPath.row==5) {
//
//                YKSettingVC *set = [[YKSettingVC alloc]initWithNibName:@"YKSettingVC" bundle:[NSBundle mainBundle]];
//                set.hidesBottomBarWhenPushed = YES;
//                                [self.navigationController pushViewController:set animated:YES];
//
//            }
//        if (indexPath.row==4) {
//
//            DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"联系客服" message:@"客服服务时间10:00-19:00" cancelBtnTitle:@"拨打客服电话" otherBtnTitle:@"在线客服"];
//            aleart.delegate = self;
//            aleart.titleColor = YKRedColor;
//            [aleart show];
//
//        }
//
//
//    }else {
//        if (indexPath.section==0){
//            //会员
//        }
//
//        if (indexPath.section==0) {
//            //邀请
//            YKInvitVC *share = [YKInvitVC new];
//            share.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:share animated:YES];
//        }
//        if (indexPath.section==1) {
//            if (indexPath.row==0) {
//                YKChangeCardVC *normal = [YKChangeCardVC new];
//                normal.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:normal animated:YES];
//            }
//            if (indexPath.row==3) {
//                YKNormalQuestionVC *normal = [YKNormalQuestionVC new];
//                normal.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:normal animated:YES];
//            }
//            if (indexPath.row==1) {
//                YKAddressVC *address = [YKAddressVC new];
//                address.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:address animated:YES];
//            }
//            if (indexPath.row==4) {
//                DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"联系客服" message:@"客服服务时间10:00-19:00" cancelBtnTitle:@"拨打客服电话" otherBtnTitle:@"在线客服"];
//                aleart.titleColor = YKRedColor;
//                aleart.delegate = self;
//                [aleart show];
////                [self kefu];
////                YKChatVC *chatService = [[YKChatVC alloc] init];
////                chatService.conversationType = ConversationType_CUSTOMERSERVICE;
////                chatService.targetId = RoundCloudServiceId;
////                chatService.hidesBottomBarWhenPushed = YES;
////                [self.navigationController pushViewController :chatService animated:YES];
//            }
//            if (indexPath.row==5) {
//                YKSettingVC *set = [[YKSettingVC alloc]initWithNibName:@"YKSettingVC" bundle:[NSBundle mainBundle]];
//                set.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:set animated:YES];
//            }
//
//        }
//    }
}
- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQNum];
        NSURL *url = [NSURL URLWithString:qq];
        [[UIApplication sharedApplication] openURL:url];
//        YKChatVC *chatService = [[YKChatVC alloc] init];
//        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
//        chatService.targetId = RoundCloudServiceId;
//        chatService.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController :chatService animated:YES];
    }else {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.3) {
            NSString *callPhone = [NSString stringWithFormat:@"tel://%@",PHONE];
            NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
            if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                /// 大于等于10.0系统使用此openURL方法
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
                } else {
                    // Fallback on earlier versions
                }
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            }
            return;
        }
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:PHONE message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        alertview.delegate = self;
        [alertview show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//取消
        
    }
    if (buttonIndex==1) {//拨打
        NSString *callPhone = [NSString stringWithFormat:@"tel://%@",PHONE];
        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            /// 大于等于10.0系统使用此openURL方法
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}


- (void)Login{
    [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
        [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
            header.user = [YKUserManager sharedManager].user;
            [self.tableView reloadData];
        }];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //往上滑动offset增加，往下滑动，yoffset减小
    CGFloat yoffset = scrollView.contentOffset.y;
    //处理背景图的放大效果和往上移动的效果
    if (yoffset>0) {//往上滑动

        _headImageView.frame = ({
            CGRect frame = self.origialFrame;
            frame.origin.y = self.origialFrame.origin.y - yoffset;
//            frame.size.height = self.origialFrame.size.height - yoffset;
            frame;
        });

    }else {//往下滑动，放大处理
        _headImageView.frame = ({
            CGRect frame = self.origialFrame;
//            frame.size.height = self.origialFrame.size.height - yoffset;
//            frame.size.width = frame.size.width-yoffset;
//            frame.origin.x = _origialFrame.origin.x - (frame.size.width-_origialFrame.size.width)/2;
            frame.origin.y   = _origialFrame.origin.y-yoffset;
            frame;
        });
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//
    UIScrollView * scrollView = (UIScrollView *)object;
//
//    if (self.tableView != scrollView) {
//        return;
//    }
//
//    if (![keyPath isEqualToString:@"contentOffset"]) {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        return;
//    }
//
//    if (scrollView.contentOffset.y>0) {
//        self.navigationController.navigationBar.hidden = NO;
//    }
//    if (scrollView.contentOffset.y>200) {
//        self.navigationController.navigationBar.hidden = NO;
//        self.navigationController.navigationBar.alpha = 1;
//        
//    }else {
//        self.navigationController.navigationBar.alpha = scrollView.contentOffset.y/200 ;
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//        
//        if (scrollView.contentOffset.y<=0) {
//            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//        }
//
//    }
}

@end
