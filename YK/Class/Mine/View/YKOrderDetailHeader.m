//
//  YKOrderDetailHeader.m
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//

#import "YKOrderDetailHeader.h"

@interface  YKOrderDetailHeader()
//@property (nonatomic,strong)
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

- (void)setProductArray:(NSArray *)productArray{
    _productArray = productArray;
    
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
    status.text = @"待发货";
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
    time.text = @"下单时间：2018-12-04  17:54:33";
    time.textColor = [UIColor colorWithHexString:@"333333"];
    time.font = PingFangSC_Regular(kSuitLength_H(14));
    [inforView addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(9));
        make.top.mas_equalTo(kSuitLength_H(15));
    }];
    
    UILabel *orderId = [[UILabel alloc]init];
    orderId.text = @"订单编号：201812261545814769273";
    orderId.textColor = [UIColor colorWithHexString:@"333333"];
    orderId.font = PingFangSC_Regular(kSuitLength_H(14));
    [inforView addSubview:orderId];
    [orderId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(9));
        make.top.mas_equalTo(time.mas_bottom).offset(kSuitLength_H(9));
    }];
    
    
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
    name.text = @"侯迪 17611407759";
    name.textColor = [UIColor colorWithHexString:@"333333"];
    name.font = PingFangSC_Medium(kSuitLength_H(14));
    [inforView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(kSuitLength_H(14));
        make.left.mas_equalTo(kSuitLength_H(9));
    }];
    
    UILabel *address = [[UILabel alloc]init];
    address.text = @"北京市海淀区上地五街信息路26号中关村创业大厦";
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
    CGFloat h =productArray.count *(kSuitLength_H(79));
    [productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inforView.mas_bottom).offset(kSuitLength_H(14));
        make.left.mas_equalTo(kSuitLength_H(16));
        make.right.mas_equalTo(-kSuitLength_H(16));
        make.height.mas_equalTo(kSuitLength_H(16) + h + kSuitLength_H(37));
    }];
    
    UIView *lastView = [[UIView alloc]init];
    lastView.frame = CGRectMake(0, 0, 0, 0);
    for (int i=0; i<productArray.count; i++) {
        UIView *pView = [[UIView alloc]init];
        pView.backgroundColor = [UIColor whiteColor];
        pView.frame = CGRectMake(0,kSuitLength_H(10)+kSuitLength_H((10+69))*i, productView.frame.size.width, kSuitLength_H(69));
        [productView addSubview:pView];
//
//        [pView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(lastView.mas_bottom);
//            make.left.mas_equalTo(kSuitLength_H(16));
//            make.right.mas_equalTo(-kSuitLength_H(16));
//            make.height.mas_equalTo(69);
//        }];
        
        UIImageView *productImage = [[UIImageView alloc]init];
        productImage.image = [UIImage imageNamed:@"top.jpg"];
        [pView addSubview:productImage];
        [productImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSuitLength_H(9));
            make.top.mas_equalTo(kSuitLength_H(0));
            make.width.mas_equalTo(kSuitLength_H(53));
            make.height.mas_equalTo(kSuitLength_H(69));
        }];
        
        UILabel *productName = [[UILabel alloc]init];
        productName.text = @"商品名称";
        productName.textColor = [UIColor colorWithHexString:@"333333"];
        productName.font = PingFangSC_Medium(kSuitLength_H(14));
        [pView addSubview:productName];
        [productName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productImage.mas_right).offset(kSuitLength_H(12));
            make.top.mas_equalTo(productImage.mas_top);
        }];
        
        UILabel *productBrand = [[UILabel alloc]init];
        productBrand.text = @"商品品牌";
        productBrand.textColor = [UIColor colorWithHexString:@"999999"];
        productBrand.font = PingFangSC_Regular(kSuitLength_H(12));
        [pView addSubview:productBrand];
        [productBrand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productImage.mas_right).offset(kSuitLength_H(12));
            make.centerY.mas_equalTo(productImage.mas_centerY);
        }];
        
        UILabel *productSize = [[UILabel alloc]init];
        productSize.text = @"商品尺码";
        productSize.textColor = [UIColor colorWithHexString:@"999999"];
        productSize.font = PingFangSC_Regular(kSuitLength_H(12));
        [pView addSubview:productSize];
        [productSize mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productImage.mas_right).offset(kSuitLength_H(12));
            make.bottom.mas_equalTo(productImage.mas_bottom);
        }];
        
        UILabel *productPrice = [[UILabel alloc]init];
        productPrice.text = @"¥188";
        productPrice.textColor = [UIColor colorWithHexString:@"333333"];
        productPrice.font = PingFangSC_Medium(kSuitLength_H(14));
        [productView addSubview:productPrice];
        [productPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(8));
            make.centerY.mas_equalTo(productName.mas_centerY);
        }];
        
        UILabel *productNum = [[UILabel alloc]init];
        productNum.text = @"x1";
        productNum.textColor = [UIColor colorWithHexString:@"999999"];
        productNum.font = PingFangSC_Medium(kSuitLength_H(12));
        [productView addSubview:productNum];
        [productNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(8));
            make.centerY.mas_equalTo(productBrand.mas_centerY);
        }];
        
        lastView = pView;
    }
    
   
    
    UIButton *BBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BBtn setTitle:@"申请退款" forState:UIControlStateNormal];
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
    
    UIView *priceView = [[UIView alloc]init];
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
    total.text = @"¥ 188";
    total.textColor = [UIColor colorWithHexString:@"333333"];
    total.font = PingFangSC_Regular(kSuitLength_H(12));
    [priceView addSubview:total];
    [total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kSuitLength_H(10));
        make.top.mas_equalTo(totalDes.mas_top);
    }];
    
    UILabel *yf = [[UILabel alloc]init];
    yf.text = @"¥ 188";
    yf.textColor = [UIColor colorWithHexString:@"333333"];
    yf.font = PingFangSC_Regular(kSuitLength_H(12));
    [priceView addSubview:yf];
    [yf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kSuitLength_H(10));
        make.top.mas_equalTo(total.mas_bottom).offset(kSuitLength_H(10));
    }];
    
    UILabel *pay = [[UILabel alloc]init];
    pay.text = @"¥ 188";
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
    
    leftBtn.tag = 103;
    
    [rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceView.mas_bottom).offset(kSuitLength_H(14));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(WIDHT);
        make.height.mas_equalTo(kSuitLength_H(90));
    }];
    
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

- (void)btnAction:(UIButton *)btn{
    if (btn.tag==101) {
        if (self.btn1ActionBlock) {
            self.btn1ActionBlock();
        }
    }
    if (btn.tag==102) {
        if (self.btn2ActionBlock) {
            self.btn2ActionBlock();
        }
    }
    if (btn.tag==103) {
        if (self.btn3ActionBlock) {
            self.btn3ActionBlock();
        }
    }
}

- (void)initWithDic:(NSDictionary *)dic{
    
}

@end
