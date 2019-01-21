//
//  YKNewSuitCell.h
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKNewSuitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (nonatomic,strong)NSString *clothingStockId;
@property (nonatomic,strong)YKSuit *suit;//衣服模型
@property (nonatomic,strong)NSString *suitId;
@property (nonatomic,copy)void (^deleteBlock)(NSString *shopCartId);
@property (nonatomic,copy)void (^publicBlock)(NSString *shopCartId);
@property (nonatomic,copy)void (^buyBlock)(NSString *sizeNum);
@property (nonatomic,strong)NSDictionary *dic;//衣服字典
- (void)resetUI;

- (void)addView;
@end
