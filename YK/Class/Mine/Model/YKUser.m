//
//  YKUser.m
//  YK
//
//  Created by LXL on 2017/12/4.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKUser.h"

@implementation YKUser

- (instancetype)initWithDictionary:(NSDictionary *)Dictionary{
    if (self = [super init]) {
        if ([Dictionary isEqual:[NSNull null]]) {
            return nil;
        }
        if (Dictionary.allKeys.count == 0) {
            return nil;
        }
        self.rongToken = Dictionary[@"rongToken"];
        
        self.userId = Dictionary[@"userInfo"][@"userId"];
        [UD setObject:self.userId forKey:@"userId"];
        self.nickname = Dictionary[@"userInfo"][@"nickname"];
        self.phone = Dictionary[@"userInfo"][@"phone"];
        
        self.gender = Dictionary[@"userInfo"][@"gender"];
        self.photo = Dictionary[@"userInfo"][@"photo"];
        
        //邀请码
        self.inviteCode = Dictionary[@"userInfo"][@"inviteCode"];
        
        self.cardNum = Dictionary[@"cardInfo"][@"cardNum"];
        self.cardType = Dictionary[@"cardInfo"][@"cardType"];
        self.depositEffective = Dictionary[@"cardInfo"][@"depositEffective"];
        self.effective = Dictionary[@"cardInfo"][@"effective"];
        self.validity = Dictionary[@"cardInfo"][@"validity"];
        
        //是否分享过
        if (Dictionary[@"userInfo"][@"isShare"] == [NSNull null]) {
            self.isShare = @"0";
        }else
            self.isShare = Dictionary[@"userInfo"][@"isShare"];
        }
    
    
    self.colledgeId = Dictionary[@"school"][@"schoolId"];
    self.colledgeName = Dictionary[@"school"][@"schoolName"];
    if([self.colledgeName rangeOfString:@"#"].location !=NSNotFound)//
    {
        self.colledgeName = [self.colledgeName stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    if ([self.colledgeName isEqual:@""]) {
        self.colledgeName = @"选择院校";
    }
    
//    self.newUser = Dictionary[@"school"][@"schoolId"];
    self.isNewUser = Dictionary[@"userInfo"][@"newUser"];
    
    //待签收数量
    NSArray *a = [NSArray arrayWithArray:Dictionary[@"orderNumberList"]];
    for (NSDictionary *dic in a) {
        if ([dic[@"orderStatus"] intValue] == 3) {//待付款
            self.toPayNum = [NSString stringWithFormat:@"%@",dic[@"orderNum"]];
        }
        if ([dic[@"orderStatus"] intValue] == 1) {//待签收
            self.toQianshouNum  = [NSString stringWithFormat:@"%@",dic[@"orderNum"]];
        }
        if ([dic[@"orderStatus"] intValue] == 2) {//待归还
            self.toReceiveNum = [NSString stringWithFormat:@"%@",dic[@"orderNum"]];
        }
    }
//    self.toQianshouNum = [NSString stringWithFormat:@"%@",Dictionary[@"orderNumberList"][0][@"orderNum"]];
//    //待归还数量
//    self.toReceiveNum = [NSString stringWithFormat:@"%@",Dictionary[@"orderNumberList"][1][@"orderNum"]];
    
//    if ([self.phone isEqual:[NSNull null]]) {
//        [[YKUserManager sharedManager]clear];
//    }
    
    if ([Dictionary[@"userInfo"][@"qqUserinfoVO"] isEqual:[NSNull null]]) {
        _isBindQQ = NO;
    }else {
        _isBindQQ = YES;
        _QQimageUrl = [NSString stringWithFormat:@"%@",Dictionary[@"userInfo"][@"qqUserinfoVO"][@"headimgurl"]];
        _QQNickName = [NSString stringWithFormat:@"%@",Dictionary[@"userInfo"][@"qqUserinfoVO"][@"nickname"]];
    }
    
    if ([Dictionary[@"userInfo"][@"wxUserInfoVO"] isEqual:[NSNull null]]) {
        _isBingWX = NO;
    }else {
        _isBingWX = YES;
        _WXimageUrl = [NSString stringWithFormat:@"%@",Dictionary[@"userInfo"][@"wxUserInfoVO"][@"headimgurl"]];
        _WXNickName = [NSString stringWithFormat:@"%@",Dictionary[@"userInfo"][@"wxUserInfoVO"][@"nickname"]];
    }
    
    self.balance = [NSString stringWithFormat:@"%@",Dictionary[@"userInfo"][@"balance"]];
    
    self.couponsNumber = [NSString stringWithFormat:@"%@",Dictionary[@"userInfo"][@"couponsNumber"]];
    
    return self;
}

@end
