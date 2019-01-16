//
//  YKHadSelectSizeView.h
//  YK
//
//  Created by edz on 2019/1/15.
//  Copyright © 2019 YK. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YKHadSelectSizeView : UIView
@property (nonatomic,strong)NSDictionary *Dic;
@property (nonatomic,copy)void (^payAction)(NSDictionary *dic);
@property (nonatomic,copy)void (^closeAction)(void);
@end

