//
//  YKHadSelectSizeView.m
//  YK
//
//  Created by edz on 2019/1/15.
//  Copyright © 2019 YK. All rights reserved.
//

#import "YKHadSelectSizeView.h"

@implementation YKHadSelectSizeView

- (void)setDic:(NSDictionary *)Dic{
    _Dic = Dic;
    //透明背景
    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(20));
    [self addSubview:view];
    
    //透明背景
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor whiteColor];
    view2.frame = CGRectMake(0, kSuitLength_H(20), WIDHT, kSuitLength_H(300));
    [self addSubview:view2];
    //图片
    UIImageView *image = [[UIImageView alloc]init];
   [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[self URLEncodedString:Dic[@"image"]]]]] placeholderImage:[UIImage imageNamed:@"商品图"]];
    image.frame = CGRectMake(kSuitLength_H(20), 0, kSuitLength_H(82), kSuitLength_H(107));
    [self addSubview:image];
    
    //价钱
    UILabel *price = [[UILabel alloc]init];
    price.text = [NSString stringWithFormat:@"¥%@",Dic[@"price"]];
    price.textColor = YKRedColor;
    price.font = PingFangSC_Medium(kSuitLength_H(14));
    price.frame = CGRectMake(image.frame.size.width + image.frame.origin.x+kSuitLength_H(15), view.bottom+kSuitLength_H(24.7), 100, kSuitLength_H(20));
    [self addSubview:price];
    
    //名称
    UILabel *name = [[UILabel alloc]init];
    name.text = [NSString stringWithFormat:@"%@",Dic[@"name"]];
    name.textColor = mainColor;
    name.font = PingFangSC_Medium(kSuitLength_H(14));
    name.frame = CGRectMake(price.frame.origin.x, price.bottom+kSuitLength_H(3), 200, kSuitLength_H(20));
    [self addSubview:name];
    
    //尺码
    UILabel *size = [[UILabel alloc]init];
    size.text = [NSString stringWithFormat:@"已选尺码：%@",Dic[@"size"]];
    size.textColor = mainColor;
    size.font = PingFangSC_Regular(kSuitLength_H(12));
    size.frame = CGRectMake(price.frame.origin.x, name.bottom+kSuitLength_H(3), 200, kSuitLength_H(17));
    [self addSubview:size];
    
    //去支付按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, self.frame.size.height-kSuitLength_H(50), WIDHT, kSuitLength_H(50));
    btn.backgroundColor = YKRedColor;
    [btn setTitle:@"去支付" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(16));
    [self addSubview:btn];
    [btn addTarget:self action:@selector(payA) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(WIDHT-50,kSuitLength_H(20), kSuitLength_H(50), kSuitLength_H(50));
    [closeBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -kSuitLength_H(0))];
    [self addSubview:closeBtn];
//    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn addTarget:self action:@selector(closeA) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeA{
    if (self.closeAction) {
        self.closeAction();
    }
}

- (void)payA{
    if (self.payAction) {
        self.payAction(self.Dic);
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
