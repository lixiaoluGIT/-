//
//  YKMineHeaderView.h
//  YK
//
//  Created by edz on 2019/1/7.
//  Copyright © 2019 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKMineHeaderView : UIView
@property (nonatomic,copy)void (^btnClickBlock)(NSInteger tag,NSInteger VIPStatus);
@property (nonatomic,strong)YKUser *user;
@property (nonatomic,assign)NSInteger VIPStatus;
@end

NS_ASSUME_NONNULL_END
