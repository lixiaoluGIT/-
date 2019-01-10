//
//  YKRefundReasonView.m
//  YK
//
//  Created by edz on 2019/1/4.
//  Copyright © 2019 YK. All rights reserved.
//

#import "YKRefundReasonView.h"
@interface YKRefundReasonView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (assign, nonatomic) NSIndexPath *selIndex;
@property (nonatomic,strong)NSString *reasonString;
@end

@implementation YKRefundReasonView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self setUpUI];
        self.reasonString = @"";
    }
    return self;
}

- (void)setUpUI{
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDHT, kSuitLength_H(50))];
    la.text = @"退款原因";
    la.textColor = mainColor;
    la.font = PingFangSC_Medium(kSuitLength_H(16));
    la.textAlignment = NSTextAlignmentCenter;
    [self addSubview:la];
    
    UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [noBtn setTitle:@"取消" forState:UIControlStateNormal];
    [noBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    noBtn.frame = CGRectMake(0, 0, WIDHT/4, kSuitLength_H(50));
    noBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(14));
//    [self addSubview:noBtn];
    
    UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [yesBtn setTitle:@"确认" forState:UIControlStateNormal];
//    [yesBtn setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [yesBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [yesBtn setTitleColor:YKRedColor forState:UIControlStateNormal];
    yesBtn.frame = CGRectMake(WIDHT/4*3+kSuitLength_H(15), 0, WIDHT/4, kSuitLength_H(50));
    yesBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(14));
    [self addSubview:yesBtn];
    
    noBtn.tag = 101;
    yesBtn.tag = 101;
    
    [noBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [yesBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSuitLength_H(50), WIDHT, self.frame.size.height-kSuitLength_H(50))];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 102) {
        if ([self.reasonString isEqualToString:@""]) {
            [smartHUD alertText:kWindow alert:@"请选择原因" delay:1.0];
            return;
        }
        if (self.btnClickBlock) {
            self.btnClickBlock(self.reasonString);
        }
    }
    
    if (btn.tag == 101) {
//        self.selIndex = nil;
//        self.reasonString = @"";
//        [self.tableView reloadData];
        if (self.btnClickBlock) {
            self.btnClickBlock(@"");
        }
    }
}

- (void)setReasonList:(NSArray *)reasonList{
    _reasonList = reasonList;
    _reasonList = @[@"商品缺货",@"物流问题",@"商品信息填写错误",@"地址信息填写错误",@"商品与描述不符",@"商品质量问题",@"不想要了",@"其他"];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _reasonList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSuitLength_H(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = self.reasonList[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.textLabel.font = PingFangSC_Regular(kSuitLength_H(14));
    
    //图标
    UIImageView *image = [[UIImageView alloc]init];
    [cell addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kSuitLength_H(16));
        make.centerY.mas_equalTo(cell.mas_centerY);
    }];
    if (self.selIndex == indexPath) {
        image.image = [UIImage imageNamed:@"xuanzhong"];
    }else {
        image.image = [UIImage imageNamed:@"weixuanzhong"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selIndex = indexPath;
    self.reasonString = self.reasonList[indexPath.row];
    if (self.btnClickBlock) {
        self.btnClickBlock(self.reasonString);
    }
    [self.tableView reloadData];
}
@end
