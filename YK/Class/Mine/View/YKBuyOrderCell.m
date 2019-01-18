//
//  YKBuyOrderCell.m
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//

#import "YKBuyOrderCell.h"

@interface YKBuyOrderCell()
@property (nonatomic,strong)UILabel *orderStatusLabel;//ding danzhuang tai
@property (nonatomic,strong)UIImageView *image;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *brand;
@property (nonatomic,strong)UILabel *size;
@property (nonatomic,strong)UILabel *price;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@end

@implementation YKBuyOrderCell

// 1. 初始化子视图
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    
    return self;
}

- (void)setUpUI{
    //XIAN
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(10);
    }];
    //
    UILabel *status = [[UILabel alloc]init];
    status.font = PingFangSC_Medium(kSuitLength_H(14));
    status.textColor = mainColor;
    status.text = @"衣袋状态：待付款";
    self.orderStatusLabel = status;
    [self addSubview:status];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(16));
        make.top.mas_equalTo(line.mas_bottom).offset(kSuitLength_H(20));
    }];
    
    UIImageView *rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:     @"右-2 copy 3"]];
    [self addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-16));
        make.centerY.mas_equalTo(status.mas_centerY);
    }];
    
    
    UILabel *l = [[UILabel alloc]init];
    l.font = PingFangSC_Medium(kSuitLength_H(12));
    l.textColor = mainColor;
    l.text = @"订单详情";
    [self addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightImage.mas_left).offset(-kSuitLength_H(6));
        make.centerY.mas_equalTo(status.mas_centerY);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.toDetail) {
            self.toDetail(self.orderId);
        }
    }];
    l.userInteractionEnabled = YES;
    [l addGestureRecognizer:tap];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(WIDHT);
        make.height.mas_equalTo(kSuitLength_H(60));
    }];
    [btn setUserInteractionEnabled:YES];
    [btn addGestureRecognizer:tap];
    
    UILabel *line2 = [[UILabel alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(status.mas_bottom).offset(kSuitLength_H(20));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(1);
    }];
    
    //
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"top.jpg"];
    self.image = image;
//    [image setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(16));
        make.top.mas_equalTo(line2.mas_bottom).offset(kSuitLength_H(10));
        make.width.mas_equalTo(kSuitLength_H(76));
        make.height.mas_equalTo(kSuitLength_H(100));
    }];
    
    UILabel *name = [[UILabel alloc]init];
    name.font = PingFangSC_Regular(kSuitLength_H(14));
    name.textColor = mainColor;
    name.text = @"商品名称";
    [self addSubview:name];
    self.name = name;
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(image.mas_top);
        make.left.mas_equalTo(image.mas_right).offset(kSuitLength_H(13));
    }];
    
    UILabel *brand = [[UILabel alloc]init];
    brand.font = PingFangSC_Medium(kSuitLength_H(14));
    brand.textColor = [UIColor colorWithHexString:@"999999"];
    brand.text = @"商品品牌";
    [self addSubview:brand];
    self.brand = brand;
    [brand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(image.mas_centerY);
        make.left.mas_equalTo(image.mas_right).offset(kSuitLength_H(13));
    }];
    
    UILabel *type = [[UILabel alloc]init];
    type.font = PingFangSC_Medium(kSuitLength_H(14));
    type.textColor = [UIColor colorWithHexString:@"999999"];
    type.text = @"商品尺码";
    self.size = type;
    [self addSubview:type];
    [type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(image.mas_bottom);
        make.left.mas_equalTo(image.mas_right).offset(kSuitLength_H(13));
    }];
    
    UILabel *price = [[UILabel alloc]init];
    price.font = PingFangSC_Medium(kSuitLength_H(14));
    price.textColor = [UIColor colorWithHexString:@"333333"];
    price.text = @"¥ 888";
    self.price = price;
    [self addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(brand.mas_centerY);
        make.right.mas_equalTo(rightImage.mas_right);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.backgroundColor = YKRedColor;
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius = kSuitLength_H(26)/2;
    rightBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(12));
    self.rightBtn = rightBtn;
    [self addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-16));
        make.bottom.mas_equalTo(self.image.mas_bottom);
        make.height.mas_equalTo(kSuitLength_H(26));
        make.width.mas_equalTo(kSuitLength_H(62));
    }];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    leftBtn.layer.masksToBounds = YES;
    leftBtn.layer.cornerRadius = kSuitLength_H(26)/2;
    leftBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(12));
    self.leftBtn = leftBtn;
    [self addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightBtn.mas_left).offset(kSuitLength_H(-12));
        make.bottom.mas_equalTo(self.image.mas_bottom);
        make.height.mas_equalTo(kSuitLength_H(26));
        make.width.mas_equalTo(kSuitLength_H(62));
    }];
    self.rightBtn.tag = 102;
    self.leftBtn.tag = 101;
    
    [self.rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    
    self.orderStatus = [dic[@"orderState"] intValue];
    
    switch (self.orderStatus) {
            
        case 1:
            self.orderStatusLabel.text = @"衣箱状态：待付款";
            [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
            self.leftBtn.hidden = NO;
            self.rightBtn.hidden = NO;
            self.rightBtn.backgroundColor = YKRedColor;
            [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.rightBtn setUserInteractionEnabled:YES];
            break;
        case 2:
            self.orderStatusLabel.text = @"衣箱状态：待发货";
            self.leftBtn.hidden = YES;
            [self.rightBtn setTitle:@"买家已付款" forState:UIControlStateNormal];
            self.rightBtn.backgroundColor = [UIColor whiteColor];
            [self.rightBtn setTitleColor:YKRedColor forState:UIControlStateNormal];
            [self.rightBtn setUserInteractionEnabled:NO];
            self.rightBtn.hidden = NO;
            break;
        case 3:
            self.orderStatusLabel.text = @"衣箱状态：待签收";
            [self.leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            self.rightBtn.backgroundColor = YKRedColor;
            [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.rightBtn setUserInteractionEnabled:YES];
            self.leftBtn.hidden = NO;
            self.rightBtn.hidden = NO;
            break;
        case 4:
            self.orderStatusLabel.text = @"衣箱状态：已完成";
            [self.rightBtn setTitle:@"再次购买" forState:UIControlStateNormal];
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = NO;
            self.rightBtn.backgroundColor = YKRedColor;
            [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.rightBtn setUserInteractionEnabled:YES];
            break;
        case 5:
            self.orderStatusLabel.text = @"衣箱状态：已取消";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            break;
        default:
            break;
    }
    
    
    //订单号
    self.orderId = [NSString stringWithFormat:@"%@",dic[@"orderNo"]];
    //取到衣服数据
    NSDictionary *product = [NSDictionary dictionaryWithDictionary:dic[@"userOrderDetailsVoList"][0]];
    self.image.autoresizingMask = NO;
    
    //衣服id
    self.clothingId = [NSString stringWithFormat:@"%@",product[@"clothingId"]];
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:product[@"clothingImgUrl"]]] placeholderImage:[UIImage imageNamed:@"商品图"]];
    self.name.text = [NSString stringWithFormat:@"%@",product[@"clothingName"]];
    self.clothingName = self.name.text;
    self.brand.text = [NSString stringWithFormat:@"%@",product[@"clothingBrandName"]];
    self.size.text = [NSString stringWithFormat:@"%@",product[@"clothingStockType"]];
    self.price.text = [NSString stringWithFormat:@"¥%@",product[@"clothingPrice"]];
}
//赋值
- (void)initWithDic:(NSDictionary *)dic{
 
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

- (void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 101://左边按钮
            switch (self.orderStatus) {
                case 1://取消订单
                    NSLog(@"取消订单");
                    if (self.btnActionBlock) {
                        self.btnActionBlock(cancleOrder,self.orderId,self.clothingId,self.clothingName);
                    }
                    break;
                case 2:
                    
                    break;
                case 3://查看物流
                    NSLog(@"查看物流");
                    if (self.btnActionBlock) {
                        self.btnActionBlock(toScanSMSInfor,self.orderId,self.clothingId,self.clothingName);
                    }
                    break;
                case 4:
                    
                    break;
                case 5:
                    
                    break;
                    
                default:
                    break;
            }
            break;
        case 102://右边按钮
            switch (self.orderStatus) {
                case 1://立即付款
                    NSLog(@"立即付款");
                    if (self.btnActionBlock) {
                        self.btnActionBlock(paySoon,self.orderId,self.clothingId,self.clothingName);
                    }
                    break;
                case 2:
                    
                    break;
                case 3://确认收货
                    NSLog(@"确认收货");
                    if (self.btnActionBlock) {
                        self.btnActionBlock(ensureReceive,self.orderId,self.clothingId,self.clothingName);
                    }
                    break;
                case 4://再次购买
                    NSLog(@"再次购买");
                    if (self.btnActionBlock) {
                        self.btnActionBlock(buyAgain,self.orderId,self.clothingId,self.clothingName);
                    }
                    break;
                case 5:
                    
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

@end
