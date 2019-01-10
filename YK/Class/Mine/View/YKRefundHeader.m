//
//  YKRefundHeader.m
//  YK
//
//  Created by edz on 2019/1/3.
//  Copyright © 2019 YK. All rights reserved.
//

#import "YKRefundHeader.h"

@implementation YKRefundHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI{
    self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    
    UIView *lastView = [[UIView alloc]init];
    lastView.frame = CGRectZero;
    
    UILabel *tip = [[UILabel alloc]init];
    tip.text = @"温馨提示:";
    tip.textColor = mainColor;
    tip.font = PingFangSC_Medium(kSuitLength_H(16));
    [self addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSuitLength_H(kSuitLength_H(16)));
        make.left.mas_equalTo(kSuitLength_H(16));
    }];
    
    lastView = tip;
    
    NSArray *titleArray = [NSArray array];
    titleArray = @[@"1.购买7日内可进行退换货申请;",@"2.限时特价，折扣优惠等购买优惠可能一并取消；",@"3. 购买所得的平台积分等用户成长值将会被扣除；",@"4.支付时所使用的代金劵、优惠券等支付券不予返还，支付优惠一并取消；",@"5. 退货申请一旦提交，无法恢复"];
    
    for (int i=0; i<titleArray.count; i++) {
        UILabel *l = [[UILabel alloc]init];
        l.text = titleArray[i];
        l.textColor = mainColor;
        l.numberOfLines = 0;
        l.font = PingFangSC_Regular(kSuitLength_H(12));
        

        [self addSubview:l];
        
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastView.mas_bottom).offset(kSuitLength_H(7));
            make.left.mas_equalTo(kSuitLength_H(16));
            make.right.mas_equalTo(-kSuitLength_H(16));
        }];
        
        
        lastView = l;
    }
}
@end
