//
//  YKOrderDetailVC.m
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//

#import "YKOrderDetailVC.h"
#import "YKOrderDetailHeader.h"
#import "CGQCollectionViewCell.h"
#import "YKRefundVC.h"
#import "YKOrderDetail.h"
#import "YKProductDetailVC.h"
#import "YKSMSInforVC.h"
#import "YKSelectPayView.h"
#import "YKReturnVC.h"

@interface YKOrderDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,DXAlertViewDelegate>{
    BOOL hadMakeHeader;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YKOrderDetail *orderDetail;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)YKSelectPayView *payView;
@property (nonatomic,strong) YKOrderDetailHeader *header;
@end

@implementation YKOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NC addObserver:self selector:@selector(alipayResultCurrent:) name:@"alipayres" object:nil];
    [NC addObserver:self selector:@selector(wxpayresultCurrent:) name:@"wxpaysuc" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单详情";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    
  
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"右-4"] forState:UIControlStateNormal];
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
    title.textColor = [UIColor colorWithHexString:@"ffffff"];
    title.font = PingFangSC_Medium(kSuitLength_H(18));
    self.navigationItem.titleView = title;
    
    self.productArray = [NSArray array];
    self.productArray = @[@"1",@"2"];
    
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((WIDHT-30)/2, (WIDHT-30)/2*240/140);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-64) collectionViewLayout:layoutView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGQCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CGQCollectionViewCell"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView2"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer2"];
    self.collectionView.hidden = YES;
//    self.collectionView.sc
   
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil  forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //设置导航渐变
    self.navigationController.navigationBar.layer.shadowColor = [UIColor clearColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    self.navigationController.navigationBar.layer.shadowRadius = 2.f;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0,0);
    CGRect frame = CGRectMake(0, 0, WIDHT, BarH );
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:frame];
    UIGraphicsBeginImageContext(imgview.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGContextScaleCTM(context, frame.size.width, frame.size.height);
    CGFloat colors[] = {
        255.0/255.0, 80.0/255.0, 84.0/255.0, 1.0,
        255.0/255.0, 66.0/255.0, 70.0/255.0, 1.0,
    };
    CGGradientRef backGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, backGradient, CGPointMake(0, 0), CGPointMake(1.0, 0), kCGGradientDrawsBeforeStartLocation);
    [self.navigationController.navigationBar setBackgroundImage:UIGraphicsGetImageFromCurrentImageContext()  forBarMetrics:UIBarMetricsDefault];
    
    //请求订单详情数据
    [self getOrderDetail:self.orderId];
}

- (void)getOrderDetail:(NSString *)orderId{
    [[YKOrderManager sharedManager]getOrderDetailWithOrderId:orderId OnResponse:^(NSDictionary *dic) {
        self.collectionView.hidden = NO;
        self.orderDetail = [[YKOrderDetail alloc]init];
        [self.orderDetail initWithDictionary:dic];
       
        self.header.orderDetail = self.orderDetail;
        [self.collectionView reloadData];
        
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.orderDetail.recommentProductList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
    YKProduct *product = [[YKProduct alloc]init];
    [product initWithDictionary:self.orderDetail.recommentProductList[indexPath.row]];
    cell.product = product;
    return cell;
}

//头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([self.orderDetail.orderType intValue] == 1) {
         return CGSizeMake(WIDHT, kSuitLength_H(276) + kSuitLength_H(14) + kSuitLength_H(10) + kSuitLength_H(79)*(self.orderDetail.productList.count-1) + kSuitLength_H(30)*2 + kSuitLength_H(40) + kSuitLength_H(90)+kSuitLength_H(30));
    }else {
        return CGSizeMake(WIDHT, kSuitLength_H(276) + kSuitLength_H(125)*2 +(self.orderDetail.productList.count-1)*(kSuitLength_H(79)) + kSuitLength_H(14)*2 + kSuitLength_H(90)-kSuitLength_H(30));
    }
}

- (YKOrderDetailHeader *)header{
    if (!_header) {
        _header = [[YKOrderDetailHeader  alloc]init];
    }
    return _header;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf(weakSelf)
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section==0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
           
            if ([self.orderDetail.orderType intValue] == 1) {
                self.header.frame = CGRectMake(0,-64, WIDHT, kSuitLength_H(276) + kSuitLength_H(14) + kSuitLength_H(10) + (kSuitLength_H(79)*(self.orderDetail.productList.count-1)) + kSuitLength_H(30)*2 + kSuitLength_H(40) + kSuitLength_H(90));
            }else {
                self.header.frame = CGRectMake(0,-64, WIDHT, kSuitLength_H(276) + kSuitLength_H(125)*2 +(self.orderDetail.productList.count-1)*(kSuitLength_H(79)) + kSuitLength_H(14)*2 + kSuitLength_H(90));
            }
           self.header.btnActionBlock = ^(BtnActionType actionType){
                switch (actionType) {
                    
                    case cancleOrder://取消订单
                        [weakSelf cancleOrder:weakSelf.orderId];
                        break;
                    
                    case paySoon://立即支付
                        [weakSelf toPay:nil];
                        break;
                    
                    case toScanSMSInfor://查看物流
                        [weakSelf scanSMSInfor:weakSelf.orderId];
                        break;
                    
                    case ensureReceive://买衣确认收货
                        [weakSelf ensureRecevie:weakSelf.orderId];
                        break;
                    
                    case buyAgain://再次购买
                        [weakSelf toProductDetailclothingId:weakSelf.orderDetail.productList[0][@"clothingId"] title:weakSelf.orderDetail.productList[0][@"clothingName"]];
                        break;
                    
                    case contractBusiness://申请售后
                        [weakSelf contactBusiness];
                        break;
                   
                    case deleteOrder://删除订单
                        [weakSelf deleteOrder:weakSelf.orderId];
                        break;
                        
                        //租衣操作
                   
                    case UserEnsureReceive://租衣确认收货
                        NSLog(@"确认收货");
                        [weakSelf ensureRecevie:weakSelf.orderId];
                        break;
                    
                    case UsertoScanSMSInfor://租衣查看物流
                        NSLog(@"查看物流");
                        [weakSelf scanSMSInfor:weakSelf.orderId];
                        break;
                   
                    case UserOrderBack://租衣预约归还
                         NSLog(@"预约归还");
                        [weakSelf orderBack:weakSelf.orderId];
                        break;
                    default:
                        break;
                }
            };
            
           
            if (!hadMakeHeader) {
                [headerView addSubview:self.header];
                hadMakeHeader = YES;
            }
            
            return headerView;
            
        }
        
        
    }
    
    return nil;
}
//设置大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDHT-30)/2, (WIDHT-30)/2*240/140);
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
    detail.productId = cell.goodsId;
    detail.titleStr = cell.goodsName;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

//取消订单
- (void)cancleOrder:(NSString *)orderId{
    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"温馨提示" message:@"确定要取消当前未支付订单吗？" cancelBtnTitle:@"再等等" otherBtnTitle:@"取消"];
    aleart.tag = 101;
    aleart.delegate = self;
    [aleart show];
}
//立即支付
- (void)toPay:(NSDictionary *)dic{
    [self creatPayView];
    //弹出选择支付方式
    WeakSelf(weakSelf)
    weakSelf.backView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.payView.frame = CGRectMake(0, HEIGHT-236, WIDHT, 236);
        weakSelf.backView.alpha = 0.5;
    }completion:^(BOOL finished) {
        
    }];
}
//查看物流
- (void)scanSMSInfor:(NSString *)orderId{
    //需判断租衣还是买衣
    YKSMSInforVC *sms = [YKSMSInforVC new];
    sms.isFromeSF = YES;
    sms.orderNo = orderId;
    [self.navigationController pushViewController:sms animated:YES];
}
//确认收货
- (void)ensureRecevie:(NSString *)orderId{
    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"温馨提示" message:@"您是否确认已收到衣袋？" cancelBtnTitle:@"还没收到" otherBtnTitle:@"已签收"];
    if ([self.orderDetail.orderType intValue] == 1) {
        aleart.tag = 105;
    }else {
        aleart.tag = 102;
    }
    
    aleart.delegate = self;
    [aleart show];
}
//再次购买
- (void)toProductDetailclothingId:(NSString *)clothingId title:(NSString *)title{
    YKProductDetailVC  *detail = [[YKProductDetailVC alloc]init];
    detail.canBuy = YES;
    detail.productId = clothingId;
    detail.titleS = title;
    [self.navigationController pushViewController:detail animated:YES];
}
//申请售后
- (void)contactBusiness{
    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"联系商家" message:@"客服服务时间10:00-19:00" cancelBtnTitle:@"拨打客服电话" otherBtnTitle:@"在线客服"];
    aleart.titleColor = YKRedColor;
    aleart.delegate = self;
    aleart.tag = 103;
    [aleart show];
}
//删除订单
- (void)deleteOrder:(NSString *)orderId{
    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"温馨提示" message:@"确定要删除当前订单吗？" cancelBtnTitle:@"再等等" otherBtnTitle:@"删除"];
    aleart.tag = 104;
    aleart.delegate = self;
    [aleart show];
}

//预约归还
- (void)orderBack:(NSString *)orderId{
    YKReturnVC *r = [YKReturnVC new];
    r.orderId = self.orderId;
    [self.navigationController pushViewController:r animated:YES];
}

- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    WeakSelf(weakSelf)
        if (alertView.tag == 101) {//取消订单
            if (buttonIndex==1) {
            [[YKOrderManager sharedManager]cancleBuyOrderWithOrderId:self.orderId type:1 OnResponse:^(NSArray *array) {
                [self getOrderDetail:self.orderId];
            }];}
        }
        
        if (alertView.tag == 102) {//确认收货
            if (buttonIndex==1) {
            [[YKOrderManager sharedManager]cancleBuyOrderWithOrderId:self.orderId type:2 OnResponse:^(NSArray *array) {
                [self getOrderDetail:self.orderId];
            }];}
        }
        
        if (alertView.tag == 103) {//联系商家
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
    
        if (alertView.tag == 104) {//删除订单
            if (buttonIndex==1) {
                [[YKOrderManager sharedManager]cancleBuyOrderWithOrderId:self.orderId type:3 OnResponse:^(NSArray *array) {
                    //返回上一页
                    [weakSelf leftAction];
                }];}
        }
    
        if (alertView.tag == 105) {//租衣签收订单
            if (buttonIndex==1) {
                [[YKOrderManager sharedManager]ensureReceiveWithOrderNo:self.orderId OnResponse:^(NSDictionary *dic) {
                    [self getOrderDetail:self.orderId];
                }];
                
            }
    }
}

//支付宝支付结果
-(void)alipayResultCurrent:(NSNotification *)notify{
    
    NSDictionary *dict = [notify userInfo];
    if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
        
        [self diss];
        [self getOrderDetail:self.orderId];
        
    }else if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"6001"]) {
        
        [smartHUD alertText:self.view alert:@"支付失败" delay:1.5];
        
    }else{
        
        
    }
}

//微信支付结果
-(void)wxpayresultCurrent:(NSNotification *)notify{
    
    NSDictionary *dict = [notify userInfo];
    
    if ([[dict objectForKey:@"codeid"]integerValue]==0) {
        
        [self diss];
        [self getOrderDetail:self.orderId];
        
    }else{
        
        [smartHUD alertText:self.view alert:@"支付失败" delay:1.5];
        
    }
}

- (void)creatPayView{
    WeakSelf(weakSelf)
    _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor colorWithHexString:@"000000"];
    _backView.hidden = YES;
    _backView.alpha = 0.5;
    _backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(diss)];
    [_backView addGestureRecognizer:tap];
    [kWindow addSubview:_backView];
    _payView = [[NSBundle mainBundle] loadNibNamed:@"YKSelectPayView" owner:self options:nil][0];
    _payView.frame = CGRectMake(0, HEIGHT, WIDHT, 236);
    _payView.selectPayBlock = ^(payMethod payMethod){
        
        NSLog(@"调起支付");
        [[YKPayManager sharedManager]payWithPayMethod:payMethod orderNo:weakSelf.orderId couponId:0 OnResponse:^(NSDictionary *dic) {
            
        }];
        
    };
    _payView.cancleBlock = ^(void){
        [weakSelf diss];
    };
    [kWindow addSubview:_payView];
}

- (void)diss{
    WeakSelf(weakSelf)
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.payView.frame = CGRectMake(0, HEIGHT, WIDHT, 236);
        weakSelf.backView.alpha = 0;
    }completion:^(BOOL finished) {
        weakSelf.backView.hidden = YES;
        [weakSelf.backView removeFromSuperview];
        [weakSelf.payView removeFromSuperview];
    }];
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
@end
