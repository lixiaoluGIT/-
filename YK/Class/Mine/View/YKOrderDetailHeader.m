//
//  YKOrderDetailHeader.m
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//

#import "YKOrderDetailHeader.h"
#import "YKBuyOrderCell.h"

@interface  YKOrderDetailHeader()
@property (nonatomic,assign)BtnActionType actionType;
@property (nonatomic,assign)BOOL isHadOrderreceive;//待归还是否已经预约

@end
@implementation YKOrderDetailHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI{
    
}
//查询对归还订单是否预约归还
- (void)isBack:(NSString *)orderId{
    [[YKOrderManager sharedManager]queryReceiveOrderNo:orderId OnResponse:^(NSDictionary *dic) {
        NSString *s = [NSString stringWithFormat:@"%@",dic[@"data"]];
            if ([s isEqualToString:@"该订单未预约归还"]) {//未预约归还
                _isHadOrderreceive = NO;
            }else {//已预约
                _isHadOrderreceive = YES;
            }
        
        [self setUI:self.orderDetail];
        
    }];
}

- (void)setOrderDetail:(YKOrderDetail *)orderDetail{
    _orderDetail = orderDetail;
 
    if ([orderDetail.orderType intValue] == 1 && [orderDetail.orderState intValue] == 2) {//租衣订单并且是待归还的，先查询是否预约归还
        [self isBack:orderDetail.orderNo];
    }else {
        [self setUI:orderDetail];
    }
}

- (void)setUI:(YKOrderDetail *)orderDetail{
    UIImageView *backImage2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Oval"]];
    [self addSubview:backImage2];
    [backImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-kSuitLength_H(166)*2);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(WIDHT);
        make.height.mas_equalTo(kSuitLength_H(176));
        //        make.centerX.mas_equalTo(self.mas_centerY);
    }];
    UIImageView *backImage1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Oval"]];
    [self addSubview:backImage1];
    [backImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-kSuitLength_H(166));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(WIDHT);
        make.height.mas_equalTo(kSuitLength_H(176));
        //        make.centerX.mas_equalTo(self.mas_centerY);
    }];
    
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Oval"]];
    [self addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(WIDHT);
        make.height.mas_equalTo(kSuitLength_H(176));
        //        make.centerX.mas_equalTo(self.mas_centerY);
    }];
    
    UILabel *status = [[UILabel alloc]init];
    switch ([orderDetail.orderType intValue]) {
        case 1://租衣
            switch ([orderDetail.orderState intValue]) {
                case 1://待签收
                    if (orderDetail.isOnRoad) {//已发货
                        status.text = @"待签收";
                    }else {
                        status.text = @"待发货";
                    }
                    
                    break;
                case 2://待归还
                    
                    if (_isHadOrderreceive) {
                        status.text = @"归还中";
                    }else {
                        status.text = @"待归还";
                    }
                    
                    break;
                case 3://已归还
                    status.text = @"已归还";
                    break;
                    
                default:
                    break;
            }
            break;
        case 2://买衣
            switch ([orderDetail.orderState intValue]) {
                case 1://待付款
                    status.text = @"待付款";
                    break;
                case 2://待发货
                    status.text = @"待发货";
                    break;
                case 3://待签收
                    status.text = @"待签收";
                    break;
                case 4://已完成
                    status.text = @"已完成";
                    break;
                case 5://已取消
                    status.text = @"已取消";
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    status.textColor = [UIColor colorWithHexString:@"ffffff"];
    status.font = PingFangSC_Semibold(kSuitLength_H(20));
    [backImage addSubview:status];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(backImage.bottom).offset(-kSuitLength_H(65));
        make.left.mas_equalTo(kSuitLength_H(16));
    }];
    UIView *inforView = [[UIView alloc]init];
    inforView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    inforView.layer.masksToBounds = NO;
    inforView.layer.cornerRadius = 6;
    [self addSubview:inforView];
    inforView.layer.shadowColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    inforView.layer.shadowOpacity = 0.5f;
    inforView.layer.shadowRadius = 4.f;
    inforView.layer.shadowOffset = CGSizeMake(2,2);
    [inforView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backImage.mas_bottom).offset(-kSuitLength_H(50));
        make.left.mas_equalTo(kSuitLength_H(16));
        make.right.mas_equalTo(-kSuitLength_H(16));
        make.centerX.mas_equalTo(self.centerX);
        make.height.mas_equalTo(kSuitLength_H(151));
    }];
    
    UILabel *time = [[UILabel alloc]init];
    time.text = orderDetail.createTime;
    time.textColor = [UIColor colorWithHexString:@"333333"];
    time.font = PingFangSC_Regular(kSuitLength_H(14));
    [inforView addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(9));
        make.top.mas_equalTo(kSuitLength_H(15));
    }];
    
    UILabel *orderId = [[UILabel alloc]init];
    orderId.text = [NSString stringWithFormat:@"下单时间：%@",orderDetail.orderNo];
    orderId.textColor = [UIColor colorWithHexString:@"333333"];
    orderId.font = PingFangSC_Regular(kSuitLength_H(14));
    [inforView addSubview:orderId];
    [orderId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(9));
        make.top.mas_equalTo(time.mas_bottom).offset(kSuitLength_H(9));
    }];
    
    //待签收或归还中 显示物流入口
    if ([status.text isEqual:@"待签收"] || [status.text isEqual:@"归还中"]) {
        UIImageView *im = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"物流-1"]];
        [self addSubview:im];
        [im mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(44));
            make.centerY.mas_equalTo(time.mas_centerY);
        }];
        UILabel *l = [[UILabel alloc]init];
        l.text = @"物流信息";
        l.textColor = [UIColor colorWithHexString:@"333333"];
        l.font = PingFangSC_Medium(kSuitLength_H(12));
        [self addSubview:l];
        
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(im.mas_centerX);
            make.centerY.mas_equalTo(orderId.mas_centerY);
        }];
        UIImageView *im2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Rectangle 62"]];
        [self addSubview:im2];
        [im2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(73+16));
            make.top.mas_equalTo(im.mas_top).offset(kSuitLength_H(5));
        }];
        
        UIButton *smsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        smsBtn.tag = 100;
        //        smsBtn.frame = CGRectMake(self.frame.size.width-100, 0, 50, 100);
        [smsBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:smsBtn];
        [smsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(im2.mas_top);
            make.right.mas_equalTo(inforView.mas_right);
            make.width.height.mas_equalTo(60);
        }];
    }
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
    [inforView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(9));
        make.right.mas_equalTo(-kSuitLength_H(9));
        make.top.mas_equalTo(orderId.mas_bottom).offset(kSuitLength_H(14));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *name = [[UILabel alloc]init];
    name.text = [NSString stringWithFormat:@"%@ %@",orderDetail.consignee,orderDetail.contactNumber];
    name.textColor = [UIColor colorWithHexString:@"333333"];
    name.font = PingFangSC_Medium(kSuitLength_H(14));
    [inforView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(kSuitLength_H(14));
        make.left.mas_equalTo(kSuitLength_H(9));
    }];
    
    UILabel *address = [[UILabel alloc]init];
    address.text = orderDetail.address;
    address.textColor = [UIColor colorWithHexString:@"333333"];
    address.font = PingFangSC_Regular(kSuitLength_H(12));
    [inforView addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(name.mas_bottom).offset(kSuitLength_H(8));
        make.left.mas_equalTo(kSuitLength_H(9));
    }];
    
    UIView *productView = [[UIView alloc]init];
    productView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    productView.layer.masksToBounds = NO;
    productView.layer.cornerRadius = 6;
    [self addSubview:productView];
    productView.layer.shadowColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    productView.layer.shadowOpacity = 0.5f;
    productView.layer.shadowRadius = 4.f;
    productView.layer.shadowOffset = CGSizeMake(2,2);
    CGFloat h =orderDetail.productList.count *(kSuitLength_H(79));
    [productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inforView.mas_bottom).offset(kSuitLength_H(14));
        make.left.mas_equalTo(kSuitLength_H(16));
        make.right.mas_equalTo(-kSuitLength_H(16));
        make.height.mas_equalTo(kSuitLength_H(16) + h + kSuitLength_H(37));
    }];
    
    if ([orderDetail.orderType intValue] == 1) {//租衣订单
        [productView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(inforView.mas_bottom).offset(kSuitLength_H(14));
            make.left.mas_equalTo(kSuitLength_H(16));
            make.right.mas_equalTo(-kSuitLength_H(16));
            make.height.mas_equalTo(kSuitLength_H(10) + h);
        }];
    }
    
    UIView *lastView = [[UIView alloc]init];
    lastView.frame = CGRectMake(0, 0, 0, 0);
    for (int i=0; i<orderDetail.productList.count; i++) {
        //单个商品信息
        NSDictionary *product = [NSDictionary dictionaryWithDictionary:orderDetail.productList[i]];
        UIView *pView = [[UIView alloc]init];
        pView.backgroundColor = [UIColor whiteColor];
        pView.frame = CGRectMake(0,kSuitLength_H(10)+kSuitLength_H((10+69))*i, productView.frame.size.width, kSuitLength_H(69));
        [productView addSubview:pView];
        
        
        UIImageView *productImage = [[UIImageView alloc]init];
        [productImage sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:product[@"clothingImgUrl"]]] placeholderImage:[UIImage imageNamed:@"商品图"]];
        [pView addSubview:productImage];
        [productImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSuitLength_H(9));
            make.top.mas_equalTo(kSuitLength_H(0));
            make.width.mas_equalTo(kSuitLength_H(53));
            make.height.mas_equalTo(kSuitLength_H(69));
        }];
        
        UILabel *productName = [[UILabel alloc]init];
        productName.text = [NSString stringWithFormat:@"%@",product[@"clothingName"]];
        productName.textColor = [UIColor colorWithHexString:@"333333"];
        productName.font = PingFangSC_Medium(kSuitLength_H(14));
        [pView addSubview:productName];
        [productName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productImage.mas_right).offset(kSuitLength_H(12));
            make.top.mas_equalTo(productImage.mas_top);
        }];
        
        UILabel *productBrand = [[UILabel alloc]init];
        productBrand.text = [NSString stringWithFormat:@"%@",product[@"clothingBrandName"]];
        productBrand.textColor = [UIColor colorWithHexString:@"999999"];
        productBrand.font = PingFangSC_Regular(kSuitLength_H(12));
        [pView addSubview:productBrand];
        [productBrand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productImage.mas_right).offset(kSuitLength_H(12));
            make.centerY.mas_equalTo(productImage.mas_centerY);
        }];
        
        UILabel *productSize = [[UILabel alloc]init];
        productSize.text = [NSString stringWithFormat:@"%@",product[@"clothingStockType"]];
        productSize.textColor = [UIColor colorWithHexString:@"999999"];
        productSize.font = PingFangSC_Regular(kSuitLength_H(12));
        [pView addSubview:productSize];
        [productSize mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productImage.mas_right).offset(kSuitLength_H(12));
            make.bottom.mas_equalTo(productImage.mas_bottom);
        }];
        
        UILabel *productPrice = [[UILabel alloc]init];
        productPrice.text = [NSString stringWithFormat:@"%@",product[@"clothingPrice"]];;
        productPrice.textColor = [UIColor colorWithHexString:@"333333"];
        productPrice.font = PingFangSC_Medium(kSuitLength_H(14));
        [productView addSubview:productPrice];
        [productPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(8));
            make.centerY.mas_equalTo(productName.mas_centerY);
        }];
        if ([orderDetail.orderType intValue] == 2) {
            UILabel *productNum = [[UILabel alloc]init];
            productNum.text = [NSString stringWithFormat:@"X%@",product[@"storage"]];
            productNum.textColor = [UIColor colorWithHexString:@"999999"];
            productNum.font = PingFangSC_Medium(kSuitLength_H(12));
            [productView addSubview:productNum];
            [productNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-kSuitLength_H(8));
                make.centerY.mas_equalTo(productBrand.mas_centerY);
            }];
        }
        
        
        lastView = pView;
    }
    
    
    if ([orderDetail.orderType intValue] == 1) {//租衣
        //待发货，确认收货，预约归还按钮，再租这件
        UIButton *BBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [BBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [BBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        BBtn.backgroundColor = YKRedColor;
        BBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(12));
        BBtn.layer.masksToBounds = YES;
        BBtn.layer.cornerRadius = kSuitLength_H(40)/2;
        
        [self addSubview:BBtn];
        [BBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSuitLength_H(40));
            make.top.mas_equalTo(productView.mas_bottom).offset(kSuitLength_H(30));
            make.right.mas_equalTo(-kSuitLength_H(40));
            make.height.mas_equalTo(kSuitLength_H(40));
        }];
        BBtn.tag = 200;
        
        lastView = BBtn;
        switch ([orderDetail.orderState intValue]) {
            case 1://待签收（发货，未发货）
                if (orderDetail.isOnRoad) {//已发货
                    [BBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    [BBtn setUserInteractionEnabled:YES];
                    [BBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                }else {//未发货
                    [BBtn setTitle:@"待发货" forState:UIControlStateNormal];
                    [BBtn setUserInteractionEnabled:YES];
                }
                break;
            case 2://待归还
                if (_isHadOrderreceive) {//已预约归还
                    [BBtn setTitle:@"归还中" forState:UIControlStateNormal];
                    [BBtn setUserInteractionEnabled:YES];
                }else {
                    [BBtn setTitle:@"预约归还" forState:UIControlStateNormal];
                    [BBtn setUserInteractionEnabled:YES];
                    [BBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                break;
            case 3://已归还
                [BBtn setTitle:@"已归还" forState:UIControlStateNormal];
                [BBtn setUserInteractionEnabled:YES];
                break;
            default:
                break;
        }
    }
    UIView *priceView = [[UIView alloc]init];
    if ([[orderDetail orderType] intValue] == 2) {//买衣
        UIButton *BBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [BBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [BBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        BBtn.backgroundColor = [UIColor whiteColor];
        BBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
        BBtn.layer.masksToBounds = YES;
        BBtn.layer.cornerRadius = kSuitLength_H(26)/2;
        BBtn.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
        BBtn.layer.borderWidth = 0.5;
        [productView addSubview:BBtn];
        [BBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(8));
            make.top.mas_equalTo(lastView.mas_bottom).offset(kSuitLength_H(15));
            make.width.mas_equalTo(kSuitLength_H(62));
            make.height.mas_equalTo(kSuitLength_H(26));
        }];
        BBtn.tag = 101;
        
        [BBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //        UIView *priceView = [[UIView alloc]init];
        priceView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        priceView.layer.masksToBounds = NO;
        priceView.layer.cornerRadius = 6;
        [self addSubview:priceView];
        priceView.layer.shadowColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
        priceView.layer.shadowOpacity = 0.5f;
        priceView.layer.shadowRadius = 4.f;
        priceView.layer.shadowOffset = CGSizeMake(2,2);
        [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(productView.mas_bottom).offset(kSuitLength_H(14));
            make.left.mas_equalTo(kSuitLength_H(16));
            make.right.mas_equalTo(-kSuitLength_H(16));
            make.height.mas_equalTo(kSuitLength_H(125));
        }];
        
        UILabel *totalDes = [[UILabel alloc]init];
        totalDes.text = @"商品总额：";
        totalDes.textColor = [UIColor colorWithHexString:@"333333"];
        totalDes.font = PingFangSC_Regular(kSuitLength_H(12));
        [priceView addSubview:totalDes];
        [totalDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSuitLength_H(10));
            make.top.mas_equalTo(kSuitLength_H(10));
        }];
        
        UILabel *yfDes = [[UILabel alloc]init];
        yfDes.text = @"运费：";
        yfDes.textColor = [UIColor colorWithHexString:@"333333"];
        yfDes.font = PingFangSC_Regular(kSuitLength_H(12));
        [priceView addSubview:yfDes];
        [yfDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSuitLength_H(10));
            make.top.mas_equalTo(totalDes.mas_bottom).offset(kSuitLength_H(10));
        }];
        
        UILabel *payDes = [[UILabel alloc]init];
        payDes.text = @"实付：";
        payDes.textColor = [UIColor colorWithHexString:@"333333"];
        payDes.font = PingFangSC_Regular(kSuitLength_H(12));
        [priceView addSubview:payDes];
        [payDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSuitLength_H(10));
            make.top.mas_equalTo(yfDes.mas_bottom).offset(kSuitLength_H(10));
        }];
        
        UILabel *total = [[UILabel alloc]init];
        total.text = [NSString stringWithFormat:@"¥%@",orderDetail.orderAmount];
        total.textColor = [UIColor colorWithHexString:@"333333"];
        total.font = PingFangSC_Regular(kSuitLength_H(12));
        [priceView addSubview:total];
        [total mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(10));
            make.top.mas_equalTo(totalDes.mas_top);
        }];
        
        UILabel *yf = [[UILabel alloc]init];
        yf.text = @"包邮";
        yf.textColor = [UIColor colorWithHexString:@"333333"];
        yf.font = PingFangSC_Regular(kSuitLength_H(12));
        [priceView addSubview:yf];
        [yf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(10));
            make.top.mas_equalTo(total.mas_bottom).offset(kSuitLength_H(10));
        }];
        
        UILabel *pay = [[UILabel alloc]init];
        pay.text = [NSString stringWithFormat:@"¥%@",orderDetail.orderAmount];
        pay.textColor = [UIColor colorWithHexString:@"333333"];
        pay.font = PingFangSC_Regular(kSuitLength_H(12));
        [priceView addSubview:pay];
        [pay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(10));
            make.top.mas_equalTo(yf.mas_bottom).offset(kSuitLength_H(10));
        }];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        leftBtn.backgroundColor = [UIColor whiteColor];
        leftBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
        leftBtn.layer.masksToBounds = YES;
        leftBtn.layer.cornerRadius = kSuitLength_H(26)/2;
        leftBtn.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
        leftBtn.layer.borderWidth = 0.5;
        [priceView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSuitLength_H(10));
            make.top.mas_equalTo(payDes.mas_bottom).offset(kSuitLength_H(10));
            make.width.mas_equalTo(kSuitLength_H(62));
            make.height.mas_equalTo(kSuitLength_H(26));
        }];
        
        leftBtn.tag = 102;
        
        [leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"再次购买" forState:UIControlStateNormal];
        [rightBtn setTitleColor:YKRedColor forState:UIControlStateNormal];
        rightBtn.backgroundColor = [UIColor whiteColor];
        rightBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
        rightBtn.layer.masksToBounds = YES;
        rightBtn.layer.cornerRadius = kSuitLength_H(26)/2;
        rightBtn.layer.borderColor = YKRedColor.CGColor;
        rightBtn.layer.borderWidth = 0.5;
        [priceView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(10));
            make.top.mas_equalTo(payDes.mas_bottom).offset(kSuitLength_H(10));
            make.width.mas_equalTo(kSuitLength_H(62));
            make.height.mas_equalTo(kSuitLength_H(26));
        }];
        
        rightBtn.tag = 103;
        
        [rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        switch ([orderDetail.orderState intValue]) {
            case 1://待付款
                [BBtn setTitle:@"联系商家" forState:UIControlStateNormal];
                [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                BBtn.hidden = NO;
                break;
            case 2://待发货
                [BBtn setTitle:@"联系商家" forState:UIControlStateNormal];
                BBtn.hidden = NO;
                [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                leftBtn.hidden = YES;
                [rightBtn setTitle:@"买家已付款" forState:UIControlStateNormal];
                [rightBtn setTitleColor:YKRedColor forState:UIControlStateNormal];
                rightBtn.layer.borderWidth = 0;
                break;
            case 3://待签收
                [BBtn setTitle:@"联系商家" forState:UIControlStateNormal];
                leftBtn.hidden = YES;
                [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                BBtn.hidden = NO;
                break;
            case 4://已完成
                [BBtn setTitle:@"联系商家" forState:UIControlStateNormal];
                [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [rightBtn setTitle:@"再次购买" forState:UIControlStateNormal];
                BBtn.hidden = NO;
                break;
            case 5://已取消
                BBtn.hidden = NO;
                [BBtn setTitle:@"联系商家" forState:UIControlStateNormal];
                rightBtn.hidden = YES;
                [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                
                break;
                
            default:
                break;
        }
    }
    
    
    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleView];
    if ([orderDetail.orderType intValue] ==2) {//买衣
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(priceView.mas_bottom).offset(kSuitLength_H(15));
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(WIDHT);
            make.height.mas_equalTo(kSuitLength_H(90));
        }];
    }else {//租衣
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastView.mas_bottom).offset(kSuitLength_H(30));
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(WIDHT);
            make.height.mas_equalTo(kSuitLength_H(90));
        }];
    }
    
    
    UILabel *ll  = [[UILabel alloc]init];
    ll.text = @"猜你喜欢";
    ll.textColor = [UIColor colorWithHexString:@"333333"];
    ll.font = PingFangSC_Medium(kSuitLength_H(20));
    ll.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:ll];
    [ll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(titleView.mas_centerX);
        make.top.mas_equalTo(kSuitLength_H(25));
    }];
    
    UILabel *lll = [[UILabel alloc]init];
    lll.text = @"GUESS WHAT YOU LIKE";
    lll.textColor = [UIColor colorWithHexString:@"cccccc"];
    lll.font = PingFangSC_Medium(kSuitLength_H(12));
    lll.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:lll];
    [lll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(titleView.mas_centerX);
        make.top.mas_equalTo(ll.mas_bottom).offset(kSuitLength_H(3));
    }];
}

- (void)setProductArray:(NSArray *)productArray{
    
}

- (void)btnAction:(UIButton *)btn{
    
    if (btn.tag == 200) {//租衣的按钮操作
        switch ([self.orderDetail.orderState intValue]) {
            case 1://待签收
                if (self.orderDetail.isOnRoad) {//已发货
                    if (self.btnActionBlock) {//确认收货
                        self.btnActionBlock(UserEnsureReceive);
                    }
                }else {}
                break;
            case 2://待归还
                if (_isHadOrderreceive) {//已经预约
                    if (self.btnActionBlock) {
                        
                    }
                }else {//预约归还
                    if (self.btnActionBlock) {
                        self.btnActionBlock(UserOrderBack);
                    }
                }
                break;
            default:
                break;
        }
    }
    if (btn.tag == 100) {
        if ([self.orderDetail.orderType intValue] == 1) {//租衣
            if (self.btnActionBlock) {
                self.btnActionBlock(toScanSMSInfor);
            }
        }else {//买衣
            if (self.btnActionBlock) {
                self.btnActionBlock(UsertoScanSMSInfor);
            }
        }
        
    }
    if (btn.tag==101) {//打电话
        if (self.btnActionBlock) {
            self.btnActionBlock(contractBusiness);
        }
    }
    if (btn.tag==102) {//左边按钮
        
        switch ([self.orderDetail.orderState intValue]) {
            case 1://待付款
                if (self.btnActionBlock) {
                    self.btnActionBlock(cancleOrder);
                }
                break;
            case 2://待发货
                
                break;
            case 3://待签收
//
                break;
            case 4://已完成
                if (self.btnActionBlock) {
                    self.btnActionBlock(deleteOrder);
                }
                break;
            case 5://已取消
                if (self.btnActionBlock) {
                    self.btnActionBlock(deleteOrder);
                }
                break;
                
            default:
                break;
        }
    
    }
    if (btn.tag==103) {//右边按钮
        switch ([self.orderDetail.orderState intValue]) {
            case 1://待付款
                if (self.btnActionBlock) {
                    self.btnActionBlock(paySoon);
                }
                break;
            case 2://待发货
                
                break;
            case 3://待签收
                if (self.btnActionBlock) {
                    self.btnActionBlock(ensureReceive);
                }
                //
                break;
            case 4://已完成
                if (self.btnActionBlock) {
                    self.btnActionBlock(buyAgain);
                }
                break;
            case 5://已取消
               
                break;
                
            default:
                break;
        }
    }
}

- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

@end
