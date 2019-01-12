//
//  YKRefundVC.m
//  YK
//
//  Created by edz on 2019/1/3.
//  Copyright © 2019 YK. All rights reserved.
//

#import "YKRefundVC.h"
#import "YKRefundHeader.h"
#import "YKRefundReasonView.h"

@interface YKRefundVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>{
    NSInteger totalRow;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)YKRefundReasonView *refundView;
@property (nonatomic,strong)UIButton *refundBtn;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *reasonLable;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)NSString *reasonString;
@property (nonatomic,strong)UITextField *nameTextField;
@property (nonatomic,strong)UITextField *phoneTextField;

@end

@implementation YKRefundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    totalRow = 3;
    self.titleArray = [NSArray array];
    self.titleArray = @[@"退款原因：",@"退款联系人：",@"联系方式："];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.title = @"申请退款";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"333333"];
    title.font = PingFangSC_Medium(15);
    self.navigationItem.titleView = title;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    YKRefundHeader *header = [[YKRefundHeader alloc]init];
    header.frame = CGRectMake(0, 0, WIDHT,kSuitLength_H(190));
    self.tableView.tableHeaderView = header;
    
    //退货按钮
    _refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refundBtn.frame = CGRectMake(kSuitLength_H(40), HEIGHT-kSuitLength_H(90),kSuitLength_H(290) ,kSuitLength_H(50));
    [_refundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
    [_refundBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    _refundBtn.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [_refundBtn setUserInteractionEnabled:NO];
    [_refundBtn addTarget:self action:@selector(refundDo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refundBtn];

    _refundBtn.layer.masksToBounds = YES;
    _refundBtn.layer.cornerRadius = kSuitLength_H(50)/2;
    
    self.backView = [[UIView alloc]initWithFrame:kWindow.bounds];
    self.backView.backgroundColor = [UIColor colorWithHexString:@"000000"];
    self.backView.alpha = 0.5;
    self.backView.hidden = YES;
    [self.backView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [UIView animateWithDuration:0.3 animations:^{
           self.refundView.frame = CGRectMake(0, HEIGHT, WIDHT, kSuitLength_H(300));
        }completion:^(BOOL finished) {
             self.backView.hidden = YES;
        }];
    }];
    [self.backView addGestureRecognizer:tap];
    [kWindow addSubview:self.backView];
    
    WeakSelf(weakSelf)
    _refundView = [[YKRefundReasonView alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDHT, kSuitLength_H(300))];
    _refundView.reasonList = @[];
    _refundView.btnClickBlock = ^(NSString * _Nonnull reasonString){
        if (reasonString.length!=0) {
            weakSelf.reasonString = reasonString;
            
           if ([reasonString isEqualToString:@"其他"]) {
                totalRow = 4;
            }else {
                totalRow = 3;
            }
            
            
//            weakSelf.reasonLable.text = reasonString;
            
            [UIView  animateWithDuration:0.3 animations:^{
                weakSelf.refundView.frame = CGRectMake(0, HEIGHT, WIDHT, kSuitLength_H(300));
            }completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.backView.hidden = YES;
                }completion:^(BOOL finished) {
                    [weakSelf.tableView reloadData];
                    weakSelf.refundBtn.backgroundColor = YKRedColor;
                    [weakSelf.refundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [weakSelf.refundBtn setUserInteractionEnabled:NO];
                }];
                
                
            }];
        }else {
        [UIView  animateWithDuration:0.3 animations:^{
            weakSelf.refundView.frame = CGRectMake(0, HEIGHT, WIDHT, kSuitLength_H(300));
        }completion:^(BOOL finished) {
            
            weakSelf.backView.hidden = YES;
            
           
        }];
            
        }
    };
    [kWindow addSubview:_refundView];
}

//退款退货
- (void)refundDo{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return totalRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (totalRow==4) {
        if (indexPath.row==1) {
            return kSuitLength_H(90);
        }
    }
    return kSuitLength_H(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row==0) {//选择退货原因
//        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = self.titleArray[0];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = PingFangSC_Medium(kSuitLength_H(14));
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *jiantou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiajiantou"]];
        [cell addSubview:jiantou];
        [jiantou mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(20));
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
        
        UILabel *reasonLable = [[UILabel alloc]init];
       
        if (self.reasonString) {
            reasonLable.text = self.reasonString;
        }else {
             reasonLable.text = @"请选择退款原因";
        }
        reasonLable.textColor = [UIColor colorWithHexString:@"666666"];
        reasonLable.font = PingFangSC_Regular(kSuitLength_H(14));
        self.reasonLable = reasonLable;
        [cell addSubview:reasonLable];
        [reasonLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(jiantou.mas_left).offset(-kSuitLength_H(4));
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(WIDHT/2, 0, WIDHT/2, kSuitLength_H(60));
        [btn addTarget:self action:@selector(showReasonView) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }
    
    if (totalRow == 4) {
        if (indexPath.row==1) {
            UITextView *textView = [[UITextView alloc]init];
            textView.text = @"请输入退款原因";
            textView.textColor = [UIColor colorWithHexString:@"cccccc"];
            textView.textAlignment = NSTextAlignmentLeft;
            textView.backgroundColor = [UIColor whiteColor];
            textView.delegate = self;
            textView.layer.masksToBounds = YES;
            textView.layer.cornerRadius = 4;
            textView.layer.borderWidth = 1;
            textView.returnKeyType = UIReturnKeyDone;
            textView.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
            [cell addSubview:textView];
            self.textView = textView;
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kSuitLength_H(20));
                make.top.mas_equalTo(kSuitLength_H(5));
                make.right.mas_equalTo(-kSuitLength_H(20));
                make.height.mas_equalTo(kSuitLength_H(80));
            }];
       }
        
    }
    
    if (indexPath.row==totalRow-2) {//收货人
        cell.textLabel.text = self.titleArray[1];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = PingFangSC_Medium(kSuitLength_H(14));
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField *textField1 = [[UITextField alloc]init];
        textField1.text = @"收货人";
        textField1.textColor = [UIColor colorWithHexString:@"333333"];
        textField1.font = PingFangSC_Regular(kSuitLength_H(14));
        textField1.delegate = self;
        self.nameTextField = textField1;
        [cell addSubview:textField1];
        [textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(20));
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
    }
    if (indexPath.row==totalRow-1) {//联系方式
        cell.textLabel.text = self.titleArray[2];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = PingFangSC_Medium(kSuitLength_H(14));
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField *textField2 = [[UITextField alloc]init];
        textField2.text = @"18310243204";
        textField2.textColor = [UIColor colorWithHexString:@"333333"];
        textField2.font = PingFangSC_Regular(kSuitLength_H(14));
        textField2.delegate = self;
        self.phoneTextField = textField2;
        [cell addSubview:textField2];
        [textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSuitLength_H(20));
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)showReasonView{
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.hidden = NO;
        _refundView.frame = CGRectMake(0, HEIGHT-kSuitLength_H(300), WIDHT, kSuitLength_H(300));
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入退货原因";
        textView.textColor = [UIColor colorWithHexString:@"cccccc"];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入退货原因"]){
        textView.text=@"";
        textView.textColor=[UIColor colorWithHexString:@"333333"];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    [self.textView resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
