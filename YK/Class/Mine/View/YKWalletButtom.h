//
//  YKWalletButtom.h
//  YK
//
//  Created by LXL on 2017/11/23.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKWalletButtom : UITableViewCell

@property (nonatomic,copy)void (^scanBlock)(NSInteger tag);

- (void)setTitle:(NSInteger)status;
- (void)setTit;
@end