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

@interface YKOrderDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL hadMakeHeader;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation YKOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.collectionView.hidden = NO;
//
//    YKOrderDetailHeader *header = [[YKOrderDetailHeader alloc]initWithFrame:CGRectMake(0,-64, WIDHT, kSuitLength_H(276) + kSuitLength_H(125)*2 +(self.productArray.count-1)*(kSuitLength_H(79)) + kSuitLength_H(14)*2)];
//    header.productArray = self.productArray;
//    [self.view addSubview:header];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.alpha = 1;
//    
//    CGRect frame = CGRectMake(0, 0, WIDHT, BarH );
//    
//    UIImageView *imgview = [[UIImageView alloc]initWithFrame:frame];
//    
//    UIGraphicsBeginImageContext(imgview.frame.size);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    
//    CGContextScaleCTM(context, frame.size.width, frame.size.height);
//    
//    CGFloat colors[] = {
//        
//        255.0/255.0, 2.0/255.0, 55.0/255.0, 1.0,
//        
//        243.0/255.0, 69.0/255.0, 32.0/255.0, 1.0,
//        
//    };
//    
//    
//    CGGradientRef backGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
//    
//    CGColorSpaceRelease(rgb);
//    
//    
//    CGContextDrawLinearGradient(context, backGradient, CGPointMake(0, 0), CGPointMake(1.0, 0), kCGGradientDrawsBeforeStartLocation);
    
    [self.navigationController.navigationBar setBackgroundImage:nil  forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated {
    
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
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 6;
    //    return 100;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
//    YKProduct *product = [[YKProduct alloc]init];
//    [product initWithDictionary:self.productList[indexPath.row]];
//    cell.product = product;
    return cell;
}

//头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WIDHT, kSuitLength_H(276) + kSuitLength_H(125)*2 +(self.productArray.count-1)*(kSuitLength_H(79)) + kSuitLength_H(14)*2 + kSuitLength_H(90));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf(weakSelf)
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section==0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
           
            YKOrderDetailHeader *header = [[YKOrderDetailHeader alloc]initWithFrame:CGRectMake(0,-64, WIDHT, kSuitLength_H(276) + kSuitLength_H(125)*2 +(self.productArray.count-1)*(kSuitLength_H(79)) + kSuitLength_H(14)*2 + kSuitLength_H(90))];
            header.productArray = self.productArray;
            header.btn1ActionBlock = ^(void){//退款退货
                YKRefundVC *refund = [[YKRefundVC alloc]init];
                [weakSelf.navigationController pushViewController:refund animated:YES];
            };
            header.btn2ActionBlock = ^(void){//退款退货
                YKRefundVC *refund = [[YKRefundVC alloc]init];
                [weakSelf.navigationController pushViewController:refund animated:YES];
            };
            header.btn3ActionBlock = ^(void){//退款退货
                YKRefundVC *refund = [[YKRefundVC alloc]init];
                [weakSelf.navigationController pushViewController:refund animated:YES];
            };
           
            if (!hadMakeHeader) {
                [headerView addSubview:header];
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
    
//    YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
//    detail.productId = cell.goodsId;
//    detail.titleStr = cell.goodsName;
//    detail.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detail animated:YES];
}
@end
