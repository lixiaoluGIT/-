//
//  RewardView.h
//  TingIPhone
//
//  Created by ya xiao on 2018/7/4.
//  Copyright © 2018年 ya xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardView : UIView
/*
 *创建打赏按钮
 *intervalTime 开始时间
 *continueTime 持续时间
 *shakeFrequency 抖动次数
 */
- (instancetype)initWithFrame:(CGRect)frame andIntervalTime:(CGFloat)intervalTime andContinueTime:(CGFloat)continueTime andShakeFrequency:(NSInteger)shakeFrequency;
/*
 *是否显示打赏按钮
 */
-(void)isShow:(BOOL)resRewardFlag;
/*
 *是否显示打赏按钮
 */
- (void)shakeAnimation;

@end
