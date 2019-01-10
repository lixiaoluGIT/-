//
//  YKRefundReasonView.h
//  YK
//
//  Created by edz on 2019/1/4.
//  Copyright © 2019 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKRefundReasonView : UIView
@property (nonatomic,copy)void (^btnClickBlock)(NSString *reasonString);
@property (nonatomic,strong)NSArray *reasonList;
@end

NS_ASSUME_NONNULL_END
