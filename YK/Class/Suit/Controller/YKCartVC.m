//
//  YKCartVC.m
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCartVC.h"
#import "YKNewSuitCell.h"
#import "YKAddCell.h"
#import "YKSearchVC.h"
#import "YKBuyAddCCVC.h"
#import "YKSuitDetailVC.h"
#import "YKSuitVC.h"
#import "YKProductDetailVC.h"
#import "YKSPDetailVC.h"
#import "YKLoginVC.h"
#import "YKCartHeader.h"
#import "YKCouponListVC.h"
#import "YKMyLoveVC.h"
#import "YKLoveNoDataView.h"


@interface YKCartVC ()<UITableViewDelegate,UITableViewDataSource,DXAlertViewDelegate>
{
    NSInteger maxClothesNum;//最大衣位数
    NSInteger currentClothesNum;//当前衣位数
    YKLoveNoDataView *noDataView;
    YKCartHeader *cartheader;
    
    NSInteger totalNum;//总衣位数
    NSInteger useNum;//已占用衣位数
    NSInteger leaseNum;//剩余衣位数
    NSInteger ccNum;
    UIButton *buttom;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSString *shoppingId;

@property (nonatomic,strong)NSMutableArray *muArr;
@property (nonatomic,strong)NSMutableArray *ownNumArray;
@end

@implementation YKCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WeakSelf(weakSelf)
    maxClothesNum = 4;
    currentClothesNum=3;
    
    _ownNumArray = [NSMutableArray array];
    _muArr = [NSMutableArray array];

    [self creatHeader];
    [self creatTableView];

    noDataView = [[YKLoveNoDataView alloc]initWithFrame:CGRectMake(0, kSuitLength_H(130), WIDHT, kSuitLength_H(500))];
    noDataView.hidden = YES;
    [noDataView reSetTitle];
    noDataView.selectClothes = ^{
        YKSearchVC *chatVC = [[YKSearchVC alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = weakSelf.tabBarController.viewControllers[1];
        chatVC.hidesBottomBarWhenPushed = YES;
        weakSelf.tabBarController.selectedViewController = nav;
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    [self.view addSubview:noDataView];
    
    [self creatButtom];
}

- (void)getNum{
    //查询加衣劵
    [[YKSuitManager sharedManager]searchAddCCOnResponse:^(NSDictionary *dic) {
        //得到总衣位数
        NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
        ccNum = array.count;
        if (array.count>0) {//有加衣劵
            totalNum = 4;

        }else {//没加衣劵
            totalNum = 3;

        }
    
        //购物车已有衣位。请求购物车
        [[YKSuitManager sharedManager]getShoppingListOnResponse:^(NSDictionary *dic) {
            NSArray *array = [NSMutableArray arrayWithArray:dic[@"data"]];
            //得到已用衣位数
            NSInteger use=0;
            for (NSDictionary *dic in array) {
                YKSuit *suit = [[YKSuit alloc]init];
                [suit initWithDictionary:dic];
                NSInteger a = [suit.ownedNum intValue];
                use = use + a;
            }
            if (array.count==0) {
                noDataView.hidden = YES;
                buttom.hidden = NO;
                self.tableView.hidden = NO;
            }
            useNum = use;
            //可用衣位数 = 总衣位-已用衣位数
            leaseNum = totalNum-useNum;
           
      
        }];
    }];
}


- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAddCloth{
    //查询加衣劵
    [[YKSuitManager sharedManager]searchAddCCOnResponse:^(NSDictionary *dic) {
        [self getCartList];
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    self.view.backgroundColor = [UIColor whiteColor];

    if ([Token length] == 0) {
        noDataView.hidden = NO;
        self.tableView.hidden = YES;
        buttom.hidden = YES;
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        
        if (![YKSuitManager sharedManager].isHadCC) {
            self.tableView.frame = CGRectMake(0, kSuitLength_H(73), WIDHT, HEIGHT-kSuitLength_H(150)) ;
            cartheader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(74));
            cartheader.hidden = NO;
        }else {
            self.tableView.frame = CGRectMake(0, kSuitLength_H(0), WIDHT, HEIGHT-kSuitLength_H(150));
            cartheader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(0));
            cartheader.hidden = YES;
        }
        return;
    }
    
    noDataView.hidden = YES;
    self.tableView.hidden = NO;
    buttom.hidden = NO;
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [self searchAddCloth];
    [self getNum];
    
//    if (![YKSuitManager sharedManager].isHadCC) {
//        self.tableView.frame = CGRectMake(0, kSuitLength_H(73), WIDHT, HEIGHT-kSuitLength_H(150)) ;
//        cartheader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(74));
//        cartheader.hidden = NO;
//    }else {
//        self.tableView.frame = CGRectMake(0, kSuitLength_H(0), WIDHT, HEIGHT-kSuitLength_H(150));
//        cartheader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(0));
//        cartheader.hidden = YES;
//    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    
  
    
}

- (void)getCartList{
    
    [[YKSuitManager sharedManager]getShoppingListOnResponse:^(NSDictionary *dic) {
       
        if (![YKSuitManager sharedManager].isHadCC) {
            self.tableView.frame = CGRectMake(0, kSuitLength_H(73), WIDHT, HEIGHT-kSuitLength_H(150)) ;
            cartheader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(74));
            cartheader.hidden = NO;
        }else {
            self.tableView.frame = CGRectMake(0, kSuitLength_H(0), WIDHT, HEIGHT-kSuitLength_H(150));
            cartheader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(0));
            cartheader.hidden = YES;
        }
        
        
        self.tableView.hidden = NO;
        self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
 
        [_muArr removeAllObjects];
        [_ownNumArray removeAllObjects];
        
        _muArr = [NSMutableArray arrayWithArray:self.dataArray];
        for (int i=0; i<self.dataArray.count; i++) {
            [_ownNumArray addObject:@"canClick"];
        }
        [[YKSuitManager sharedManager].suitArray removeAllObjects];
        for (int i=0;i<self.dataArray.count;i++) {
            YKSuit *suit = [[YKSuit alloc]init];
            NSDictionary *d = self.dataArray[i];
            [suit initWithDictionary:d];
            if ([suit.ownedNum intValue] == 2) {
                [_muArr insertObject:d atIndex:i+1];
                [_ownNumArray insertObject:@"canNotClick" atIndex:i+1];
            }
            
            if (![[YKSuitManager sharedManager].suitArray containsObject:suit]) {
                [[YKSuitManager sharedManager].suitArray addObject:suit];
                NSLog(@"%ld",[YKSuitManager sharedManager].suitArray.count);
            }
        }
        
        cartheader.isHadCC = [YKSuitManager sharedManager].isHadCC;
       
        [self.tableView reloadData];
    }];
}

- (void)creatHeader{
    WeakSelf(weakSelf)
    cartheader = [[NSBundle mainBundle]loadNibNamed:@"YKCartHeader" owner:nil options:nil][0];
    cartheader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(74));
    if (![YKSuitManager sharedManager].isHadCC) {
       cartheader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(74));
    }else {
        cartheader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(0));
    }
//    cartheader.isHadCC = [YKSuitManager sharedManager].isHadCC;
    cartheader.btnAction = ^(BOOL isHadCC){
        if ([Token length] == 0) {
            [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
                noDataView.hidden = YES;
                self.tableView.hidden = NO;
                buttom.hidden = NO;
                [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
                [self searchAddCloth];
                [self getNum];
                
                if (![YKSuitManager sharedManager].isHadCC) {
                    self.tableView.frame = CGRectMake(0, kSuitLength_H(73), WIDHT, HEIGHT-kSuitLength_H(150)) ;
                    cartheader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(74));
                    cartheader.hidden = NO;
                }else {
                    self.tableView.frame = CGRectMake(0, kSuitLength_H(0), WIDHT, HEIGHT-kSuitLength_H(150));
                    cartheader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(0));
                    cartheader.hidden = YES;
                }
              

            }];
            return;
            
        }
        if (isHadCC) {//使用加衣券，去选加衣券
            YKCouponListVC *list = [[YKCouponListVC alloc]init];
            list.selectedIndex = 102;
            list.isFromSuit = YES;
            list.selectCoupon = ^(NSInteger CouponNum, int CouponId) {
                [YKSuitManager sharedManager].couponId = CouponId;
               
               
            };
            list.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:list animated:YES];
        }else{//购买加衣券，去购买界面
            YKBuyAddCCVC *buy = [[YKBuyAddCCVC alloc]init];
            buy.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:buy animated:YES];
        }
    };
    [self.view addSubview:cartheader];
}

- (void)creatTableView{
  
    if (![YKSuitManager sharedManager].isHadCC) {
         self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSuitLength_H(73), WIDHT, HEIGHT-kSuitLength_H(150)) style:UITableViewStylePlain];
    }else {
         self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSuitLength_H(0), WIDHT, HEIGHT-kSuitLength_H(150)) style:UITableViewStylePlain];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)creatButtom{
    buttom = [UIButton buttonWithType:UIButtonTypeCustom];

    buttom.frame = CGRectMake(kSuitLength_H(60),HEIGHT-kSuitLength_H(160), WIDHT-kSuitLength_H(60)*2, kSuitLength_H(36));
    if (WIDHT==320) {
        buttom.frame = CGRectMake(kSuitLength_H(60),HEIGHT-kSuitLength_H(200), WIDHT-kSuitLength_H(60)*2, kSuitLength_H(36));
    }
    if (WIDHT==375) {
        buttom.frame = CGRectMake(kSuitLength_H(60),HEIGHT-kSuitLength_H(160), WIDHT-kSuitLength_H(60)*2, kSuitLength_H(36));
    }
    if (WIDHT==414) {
        buttom.frame = CGRectMake(kSuitLength_H(60),HEIGHT-kSuitLength_H(180), WIDHT-kSuitLength_H(60)*2, kSuitLength_H(36));
    }
    
    if (HEIGHT==812) {
        buttom.frame = CGRectMake(kSuitLength_H(60),HEIGHT-kSuitLength_H(220), WIDHT-kSuitLength_H(60)*2, kSuitLength_H(36));
    }
    
    buttom.backgroundColor = YKRedColor;
    [buttom setTitle:@"确认衣袋" forState:UIControlStateNormal];
    [buttom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttom.layer.masksToBounds = YES;
    buttom.layer.cornerRadius = kSuitLength_H(36)/2;
    buttom.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
    [buttom addTarget:self action:@selector(toRelease) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttom];
    
    if ([Token length] == 0) {
        [buttom setTitle:@"确认衣袋" forState:UIControlStateNormal];
    }
    
    buttom.hidden = YES;
}

- (void)toRelease{
    
    if ([Token length] == 0) {

        YKSearchVC *chatVC = [[YKSearchVC alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = self.tabBarController.viewControllers[1];
        chatVC.hidesBottomBarWhenPushed = YES;
        self.tabBarController.selectedViewController = nav;
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    if (self.dataArray.count==0) {
        [smartHUD alertText:self.view alert:@"请先添加衣物" delay:2];
        return;
    }
    //判断当前衣服是否有无库存状态
    
    
    for (NSDictionary *dic in self.dataArray) {
        YKSuit *suit = [[YKSuit alloc]init];
        [suit initWithDictionary:dic];
        if ([suit.clothingStockNum isEqual:@"0"]) {
            [smartHUD alertText:self.view alert:@"存在待返架衣物" delay:1.4];
            return;
        }
    }
    
    YKSuitDetailVC *detail = [YKSuitDetailVC new];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<_muArr.count) {
        return kSuitLength_H(130);
    }
    return kSuitLength_H(100);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return [YKSuitManager sharedManager].isHadCC ? 4 :3;
//    return useNum;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if (indexPath.row<_muArr.count) {
        static NSString *ll = @"c";
        YKNewSuitCell *cell = [tableView dequeueReusableCellWithIdentifier:ll];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"YKNewSuitCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        YKSuit *suit = [[YKSuit alloc]init];
        [suit initWithDictionary:_muArr[indexPath.row]];
        cell.suit = suit;
        cell.deleteBlock = ^(NSString *shopCartId){
            [self deleteProduct:shopCartId];
        };
        //如果是空位衣
        if ([_ownNumArray[indexPath.row] isEqualToString:@"canNotClick"]) {
            [cell addView];
            [cell setUserInteractionEnabled:NO];
//            cell.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
            
        }
       
        return cell;
    }
    
    YKAddCell *mycell = [[NSBundle mainBundle] loadNibNamed:@"YKAddCell" owner:self options:nil][0];
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mycell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //去详情
    if (indexPath.row<_muArr.count) {
        YKNewSuitCell *mycell = (YKNewSuitCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
//        if (mycell.suit.classify==1) {
            YKProductDetailVC *detail = [YKProductDetailVC new];
            detail.productId = mycell.suitId;
            detail.titleStr = mycell.suit.clothingName;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
//        }else {
//            YKSPDetailVC *detail = [YKSPDetailVC new];
//            detail.productId = mycell.suitId;
//            detail.titleStr = mycell.suit.clothingName;
//            detail.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:detail animated:YES];
//        }
    }else {
        if ([Token length] == 0) {
            [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
                [self searchAddCloth];
                [self getNum];
            }];

            return;
        }
        //如果当前衣位已满
        if (leaseNum<=0) {
            [smartHUD alertText:self.view alert:@"衣位已满" delay:1.4];
            return;
        }
        //去心愿单
        YKMyLoveVC *chatVC = [[YKMyLoveVC alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = self.tabBarController.viewControllers[2];
        chatVC.hidesBottomBarWhenPushed = YES;
        self.tabBarController.selectedViewController = nav;
        [self.navigationController popToRootViewControllerAnimated:YES];

    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return CGFLOAT_MIN;
}


- (void)deleteProduct:(NSString *)shopCartId{
    self.shoppingId = shopCartId;
    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"温馨提示" message:@"确定移除当前衣物吗？" cancelBtnTitle:@"暂不" otherBtnTitle:@"是的"];
    aleart.delegate = self;
    [aleart show];
 
}

- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        NSMutableArray *shopCartList = [NSMutableArray array];
            [shopCartList addObject:self.shoppingId];
            [[YKSuitManager sharedManager]deleteFromShoppingCartwithShoppingCartId:shopCartList OnResponse:^(NSDictionary *dic) {
        //        [self getCartList];
                [self getCartList];
        
                [self getNum];
        
            }];
    }
}
@end
