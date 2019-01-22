//
//  YKDetailFootView.m
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKDetailFootView.h"

@interface YKDetailFootView()
{
    UIButton *buyBtn;
    
    CALayer     *layer;
    UILabel     *_cntLabel;
    NSInteger    _cnt;
    UIImageView *_imageView;
    UIButton    *_btn;
}
@property (nonatomic,strong) UIBezierPath *path;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UIButton *suitbtn;
@property (weak, nonatomic) IBOutlet UILabel *owendNumLable;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yidai;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnW;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;


@end
@implementation YKDetailFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    _owendNumLable.layer.masksToBounds = YES;
    _owendNumLable.layer.cornerRadius = 5.5;
    _btnW.constant = kSuitLength_H(243);
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToCartSuccess) name:@"addToCartSuccess" object:nil];
    
    _addBtn.backgroundColor = YKRedColor;
    if (WIDHT==320) {
        _likeLabel.hidden = YES;
        _yidai.hidden = YES;
    }
    
     _cnt = 0;
    
    self.path = [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(50, 150)];
    [_path addQuadCurveToPoint:CGPointMake(270, 300) controlPoint:CGPointMake(150, 20)];
}
-(void)startAnimation
{
    if (!layer) {
        _btn.enabled = NO;
        layer = [CALayer layer];
        layer.contents = (__bridge id)[UIImage imageNamed:@"test01.jpg"].CGImage;
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer.bounds = CGRectMake(0, 0, 50, 50);
        [layer setCornerRadius:CGRectGetHeight([layer bounds]) / 2];
        layer.masksToBounds = YES;
        layer.position =CGPointMake(50, 150);
        [self.layer addSublayer:layer];
    }
    [self groupAnimation];
}
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 1.5f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.5f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 2.0f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [layer addAnimation:groups forKey:@"group"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //    [anim def];
    if (anim == [layer animationForKey:@"group"]) {
        _btn.enabled = YES;
        [layer removeFromSuperlayer];
        layer = nil;
        _cnt++;
        if (_owendNumLable) {
            _owendNumLable.hidden = NO;
        }
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
        _owendNumLable.text = [NSString stringWithFormat:@"%d",_cnt];
        [_owendNumLable.layer addAnimation:animation forKey:nil];
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [_imageView.layer addAnimation:shakeAnimation forKey:nil];
    }
}

- (void)setCanBuy:(BOOL)canBuy{
    _canBuy = canBuy;
//    CGRect frame = _addBtn.frame;
    if (canBuy) {
        _addBtn.hidden = YES;
        buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.backgroundColor = [UIColor colorWithHexString:@"333333"];
        buyBtn.frame = CGRectMake(WIDHT-kSuitLength_H(243), 0, kSuitLength_H(243)/2,kSuitLength_H(50));
        [buyBtn setTitle:@"买这件" forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(12));
        [self addSubview:buyBtn];
        
        UIButton *zuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zuBtn.backgroundColor = YKRedColor;
        zuBtn.frame = CGRectMake(WIDHT-kSuitLength_H(243)/2, 0, kSuitLength_H(243)/2,kSuitLength_H(50));
        [zuBtn setTitle:@"租这件" forState:UIControlStateNormal];
        [zuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        zuBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(12));
        [self addSubview:zuBtn];
        
        [buyBtn addTarget:self action:@selector(toBuy) forControlEvents:UIControlEventTouchUpInside];
        [zuBtn addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setHadStock:(BOOL)hadStock{
    _hadStock = hadStock;
    if (!hadStock) {
        [UIView animateWithDuration:0.3 animations:^{
             [buyBtn setTitle:@"预约购买" forState:UIControlStateNormal];
        }];
       
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            [buyBtn setTitle:@"买这件" forState:UIControlStateNormal];
        }];
    }
}
//购买
- (void)toBuy{
    if (self.buyBlock) {
        self.buyBlock();
    }
}
- (IBAction)selectLike:(id)sender {
//    if (_likeBtn.selected) {
//        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"您已喜欢该商品" delay:1.2];
//        return;
//    }
//    _likeBtn.selected = !_likeBtn.selected;
//    if (_likeBtn.selected) {//已收藏
//        _likeBtn.selected = YES;
//        _likeImage.image = [UIImage imageNamed:@"喜欢已选"];
//        _likeLabel.text = @"已喜欢";
//
//    }else {//未收藏
//        _likeBtn.selected = NO;
//        _likeImage.image = [UIImage imageNamed:@"心111"];
//        _likeLabel.text = @"喜欢";
//    }
    
    if (self.likeSelectBlock) {
        self.likeSelectBlock(_likeBtn.selected);
    }
}

- (IBAction)toCart:(id)sender {
    if (self.ToSuitBlock) {
        self.ToSuitBlock();
    }
    
}

- (IBAction)addToCart:(id)sender {
    if (self.AddToCartBlock) {
        self.AddToCartBlock();
    }
}

- (void)initWithIsLike:(NSString *)isCollect total:(NSString *)total{
    _owendNumLable.text = total;
    
    if ([total intValue] == 0) {
        _owendNumLable.hidden = YES;
    }else {
         _owendNumLable.hidden = NO;
    }
    
    if ([isCollect intValue] == 1) {//已收藏
        _likeBtn.selected = YES;
        _likeImage.image = [UIImage imageNamed:@"喜欢已选"];
        _likeLabel.text = @"已喜欢";
        
    }else {//未收藏
        _likeBtn.selected = NO;
        _likeImage.image = [UIImage imageNamed:@"心111"];
        _likeLabel.text = @"喜欢";
    }
    
}

- (void)setIsLike:(BOOL)isLike{
    _isLike = isLike;
    
    
    if (isLike) {//已收藏
        _likeBtn.selected = YES;
        _likeImage.image = [UIImage imageNamed:@"喜欢已选"];
        _likeLabel.text = @"已喜欢";
        
    }else {//未收藏
        _likeBtn.selected = NO;
        _likeImage.image = [UIImage imageNamed:@"心111"];
        _likeLabel.text = @"喜欢";
    }
}
//添加购物车动画(曲线动画)
- (void)addAnimatedWithFrame:(CGRect)frame {
    
}

//添加购物车动画
- (void)addToCartSuccess{
    [UIView animateKeyframesWithDuration:0.8 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/3.0 animations:^{
            _owendNumLable.transform = CGAffineTransformMakeScale(3.0, 3.0);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:2/3.0 animations:^{
            _owendNumLable.transform = CGAffineTransformIdentity;
        }];
    } completion:^(BOOL finished) {
        
    }];
}

@end
