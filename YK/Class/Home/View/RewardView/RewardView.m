//
//  RewardView.m
//  TingIPhone
//
//  Created by ya xiao on 2018/7/4.
//  Copyright © 2018年 ya xiao. All rights reserved.
//

#import "RewardView.h"

#define ANGLE_TO_RADIAN(angle) ((angle)/180.0 * M_PI)


@interface RewardView ()<CAAnimationDelegate>
@property(nonatomic, strong)UIButton *rewardButton;//打赏的button
@property(nonatomic, assign)CGFloat intervalTime;//开始动画的时间
@property(nonatomic, assign)CGFloat continueTime;//持续动画的时间
@property(nonatomic, assign)NSInteger shakeFrequency;//抖动次数

@end

@implementation RewardView
- (instancetype)initWithFrame:(CGRect)frame andIntervalTime:(CGFloat)intervalTime andContinueTime:(CGFloat)continueTime andShakeFrequency:(NSInteger)shakeFrequency{
    self = [super initWithFrame:frame];
    if (self) {
        self.intervalTime = intervalTime;
        self.continueTime = continueTime;
        self.shakeFrequency = shakeFrequency;
        [self _initializeView];
    }
    return self;
}
-(void)_initializeView{
    [self addSubview:self.rewardButton];
}
- (UIButton *)rewardButton{
    if (!_rewardButton) {
        _rewardButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_rewardButton setImage:[UIImage imageNamed:@"悬浮窗"] forState:(UIControlStateNormal)];
        [_rewardButton setImage:[UIImage imageNamed:@"悬浮窗"] forState:(UIControlStateHighlighted)];

        [_rewardButton addTarget:self action:@selector(onRewardBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rewardButton;
}
-(void)isShow:(BOOL)resRewardFlag{
    if (resRewardFlag) {
        self.hidden = NO;
        [self removeAnmation];
    } else {
        self.hidden = YES;
        [self removeAnmation];
    }
}
/**
 弹出打赏视图
 */
- (void)onRewardBtnClickEvent {
    
}
-(void)shakeAnimation{
    if (self.hidden)
    return;
    [self removeAnmation];
    [self groupAniamtion];
}
-(void)groupAniamtion{
    CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
    CAKeyframeAnimation *basicAnimation=[self scaleAnimation];
    CAKeyframeAnimation *keyframeAnimation=[self stratAnmation];
    animationGroup.animations=@[basicAnimation,keyframeAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.delegate=self;
    animationGroup.duration=self.continueTime;//设置动画时间，如果动画组中动画已经设置过动画属性则不再生效
    animationGroup.beginTime=CACurrentMediaTime()+self.intervalTime;//延迟三秒执行
    
    //3.给图层添加动画
    [self.layer addAnimation:animationGroup forKey:@"shake"];
    
}
- (CAKeyframeAnimation *)stratAnmation
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    //拿到动画 key
    anim.keyPath =@"transform.rotation";
    anim.duration=self.continueTime/self.shakeFrequency;;//设置动画时间，如果动画组中动画已经设置过动画属性则不再生效
    // 重复的次数
    anim.repeatCount = self.shakeFrequency;
    //设置抖动数值
    anim.values =@[@(ANGLE_TO_RADIAN(0)),@(ANGLE_TO_RADIAN(-17)),@(ANGLE_TO_RADIAN(17)),@(ANGLE_TO_RADIAN(0))];
    // 保持最后的状态
    anim.removedOnCompletion =NO;
    //动画的填充模式
    anim.fillMode =kCAFillModeForwards;
    return anim;
}
-(CAKeyframeAnimation *)scaleAnimation
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    //拿到动画 key
    anim.keyPath =@"transform.scale";
    anim.duration=self.continueTime;//设置动画时间，如果动画组中动画已经设置过动画属性则不再生效
    // 重复的次数
    anim.repeatCount = 0;
    //设置抖动数值
    anim.values =@[@(1.0),@(0.8),@(1.2),@(1.0)];
    // 保持最后的状态
    anim.removedOnCompletion =NO;
    //动画的填充模式
    anim.fillMode =kCAFillModeForwards;
    return anim;

}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([self.layer animationForKey:@"shake"] == anim) {
        [self.layer removeAnimationForKey:@"shake"];
    }

}
-(void)removeAnmation{
    if ([self.layer animationForKey:@"shake"]) {
        [self.layer removeAnimationForKey:@"shake"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
