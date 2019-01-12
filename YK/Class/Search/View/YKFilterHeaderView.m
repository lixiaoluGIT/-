//
//  YKFilterHeaderView.m
//  YK
//
//  Created by edz on 2018/10/29.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKFilterHeaderView.h"

@interface YKFilterHeaderView(){
    //    UIButton *seLabel;
    //    UIButton *jiImage;
}
@property (nonatomic,strong)UIView *staticView;//静态view
@property (nonatomic,strong)UIScrollView *scrollView;//选择出来的标签滚动图
@property (nonatomic,strong)UIButton *seLabel;
@property (nonatomic,strong)UIButton *jiImage;
@end

@implementation YKFilterHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    _staticView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, kSuitLength_H(47))];
    _staticView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_staticView];
    
    //单品推荐
    //    UILabel *reLabel = [[UILabel alloc]init];
    //    reLabel.text = @"单品推荐";
    //    reLabel.textColor = mainColor;
    //    reLabel.font = PingFangSC_Medium(kSuitLength_H(12));
    //    [_staticView addSubview:reLabel];
    //
    //    [reLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(kSuitLength_H(15));
    //        make.centerY.equalTo(_staticView.mas_centerY);
    //    }];
    
    //单品推荐
    _seLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seLabel setTitle:@"全部单品" forState:UIControlStateNormal];
    [_seLabel setTitle:@"在架优先" forState:UIControlStateSelected];
    [_seLabel setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
//     [_seLabel setTitleColor:[UIColor whiteColor]  forState:UIControlStateSelected];
    _seLabel.titleLabel.font = PingFangSC_Medium(kSuitLength_H(12));
    [_seLabel addTarget:self action:@selector(changeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_staticView addSubview:_seLabel];
    _seLabel.backgroundColor = mainColor;
    
    [_seLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(10));
        make.centerY.equalTo(_staticView.mas_centerY);
        make.width.mas_equalTo(kSuitLength_H(kSuitLength_H(65)));
        make.height.mas_equalTo(kSuitLength_H(kSuitLength_H(20)));
    }];
    
    _seLabel.layer.masksToBounds = YES;
    _seLabel.layer.cornerRadius = kSuitLength_H(20)/2;
    
    //箭头图标
    _jiImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_jiImage setImage:[UIImage imageNamed:@"全部单品"] forState:UIControlStateNormal];
    [_jiImage setImage:[UIImage imageNamed:@"在架优先"] forState:UIControlStateSelected];
    [_jiImage setBackgroundImage:[UIImage imageNamed:@"全部单品"] forState:UIControlStateNormal];
    [_jiImage setBackgroundImage:[UIImage imageNamed:@"在架优先"] forState:UIControlStateSelected];
    //    [jiImage sizeToFit];
    [_staticView addSubview:_jiImage];
    
    [_jiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_seLabel.mas_right).offset(kSuitLength_H(6));
        make.centerY.equalTo(_staticView.mas_centerY);
    }];
    
    //全部筛选按钮
    UIButton *filertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filertBtn setTitle:@"全部筛选" forState:UIControlStateNormal];
    [filertBtn setImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
    [filertBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -100)];
    [filertBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    if (WIDHT==320) {
        [filertBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -70)];
    }
    [filertBtn setTitleColor:YKRedColor forState:UIControlStateNormal];
    filertBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
    [filertBtn addTarget:self action:@selector(filterAction) forControlEvents:UIControlEventTouchUpInside];
    //    filertBtn.backgroundColor = [UIColor lightGrayColor];
    [_staticView addSubview:filertBtn];
    
    [filertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-(kSuitLength_H(10))));
        make.centerY.equalTo(_staticView.mas_centerY);
    }];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(filterAction) forControlEvents:UIControlEventTouchUpInside];
    [_staticView addSubview:b];
    
    [b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-(kSuitLength_H(10))));
        make.centerY.equalTo(_staticView.mas_centerY);
        make.width.mas_equalTo(kSuitLength_H(100));
        make.height.mas_equalTo(kSuitLength_H(40));
    }];
    //线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [_staticView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_staticView.mas_bottom);
        make.width.equalTo(_staticView.mas_width);
        make.height.equalTo(@1);
    }];
    
//    //设置阴影
//    self.layer.shadowColor = [UIColor colorWithHexString:@"999999"].CGColor;
//    self.layer.shadowOpacity = 0.5f;
//    self.layer.shadowRadius = 4.f;
//    self.layer.shadowOffset = CGSizeMake(4,4);
    
}

- (void)setFilterKeys:(NSArray *)filterKeys{
    
    if (filterKeys.count==0) {//静态按钮
        
        
    }else{//滚动图
        
    }
}

//切换单品推荐类型
- (void)changeTypeAction:(UIButton *)btn{
    btn.selected = !btn.selected;
     _jiImage.selected = btn.selected;
    if (self.changeTypeBlock) {
        self.changeTypeBlock(btn.selected);
    }
}

//弹出筛选界面
- (void)filterAction{
    if (self.filterActionDid) {
        self.filterActionDid();
    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    _seLabel.selected = _isSelected;
    _jiImage.selected = _isSelected;
}

@end
