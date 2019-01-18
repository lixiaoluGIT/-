//
//  YKOrderSegementVC.m
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//

#import "YKOrderSegementVC.h"
#import "YKMySuitBagVC.h"
#import "YKOrderBuyHistoryVC.h"
#import "YKHomeVC.h"
//状态栏高度
#define kStatusnBarHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height)
// 导航栏高度
#define kNavgationBarHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
//字体
#define The_titleFont @"ZHSRXT--GBK1-0"

//#define The_MainColor [LUtils colorHex:@"#B6251E"]

// 设置颜色
#define BXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define The_TitleColor BXColor(85, 85, 85)     //标题文字颜色55555

#define BtnTag 1001

@interface YKOrderSegementVC ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate,DXAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *controllerArr;

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, strong) UIPageViewController *pageController;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) UILabel *theLine;

@property (nonatomic,strong)NSMutableArray *buttonArr;

@property (nonatomic,strong)UIView *btnView;

@end

@implementation YKOrderSegementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    cacheArray = [NSMutableArray array];
    self.title = @"我的订单";
//    self.navigationController.navigationBar.layer.shadowColor = [UIColor clearColor].CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
//    self.navigationController.navigationBar.layer.shadowRadius = 2.f;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(2,0);
//    [NC addObserver:self selector:@selector(navigationBarHidden) name:@"NavigationHidden" object:nil];
//    [NC addObserver:self selector:@selector(navigationBarNotHidden) name:@"NavigationNotHidden" object:nil];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.layer.shadowColor = [UIColor clearColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    self.navigationController.navigationBar.layer.shadowRadius = 2.f;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(2,0);
   
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    //    btn.backgroundColor = [UIColor redColor];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }
    
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    UIButton *releaseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.frame = CGRectMake(0, 25, 25, 25);
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"question-1"] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:releaseButton];
    UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.rightBarButtonItems=@[negativeSpacer2,item2];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    //
    [self setConfig];
    [self addControllerToArr];
    //
    [self updateCurrentPageIndex:self.type];
}

-(void)alert{
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"问题解决" message:@"如果遇到特殊情况无法预约或预约出现问题，需要您主动联系快递上门取件(快递费由衣库平台承担)。收件地址：山东省 青州市 丰收二路 衣库仓储中心,收件人信息：衣库APP,收件人联系方式：15614205180" cancelBtnTitle:@"取消" otherBtnTitle:@"确定"];
    alertView.delegate = self;
    [alertView show];
}
- (void)leftAction{
    if (self.isFromOther) {//不是从个人中心跳进来的
        YKHomeVC *chatVC = [[YKHomeVC alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = self.tabBarController.viewControllers[4];
        chatVC.hidesBottomBarWhenPushed = YES;
        self.tabBarController.selectedViewController = nav;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



- (void)setConfig{
    
    //btnView
    self.btnView = [[UIView alloc]init];
    self.btnView.backgroundColor = [UIColor whiteColor];
    self.btnView.frame = CGRectMake(0, kNavgationBarHeight , WIDHT, kSuitLength_V(38));
    [self.view addSubview:self.btnView];
    
    self.buttonArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    _buttonArr = [NSMutableArray array];
    self.theLine = [[UILabel alloc]init];
    self.theLine.backgroundColor = YKRedColor;
    
    UIButton *clickButton = nil;
    for (NSInteger i = 0; i < self.titleArr.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = BtnTag + i;
        button.layer.masksToBounds = YES;
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [button setTitleColor:YKRedColor forState:UIControlStateSelected];
        //        [button setBackgroundColor:[UIColor lightGrayColor]];
        button.titleLabel.font = PingFangSC_Medium(kSuitLength_V(14));
        
       
        [button addTarget:self action:@selector(changeControllerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        //        button.backgroundColor = [UIColor greenColor];
        [_buttonArr addObject:button];
        
        button.frame = CGRectMake(self.btnView.frame.size.width/self.titleArr.count*i, kSuitLength_V(0), self.btnView.frame.size.width/self.titleArr.count, kSuitLength_V(38));
        
        if (i == self.type) {
            button.selected = YES;
            [button setTitleColor:YKRedColor forState:UIControlStateNormal];
            clickButton = button;
            [button addSubview:self.theLine];
        }
        [self.btnView addSubview:button];
        
    }
    
    self.theLine.frame = CGRectMake(WIDHT/4-10.5,self.btnView.frame.size.height-2 , kSuitLength_H(21), 2);
    [self.btnView addSubview:self.theLine];
}
//
- (void)addControllerToArr{
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    self.pageController.view.frame = CGRectMake(0,self.btnView.bottom , WIDHT, self.view.frame.size.height);
   
    for (UIView *view in self.pageController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *pageScrollView = (UIScrollView *)view;
            pageScrollView.delegate = self;
            pageScrollView.scrollsToTop = NO;
        }
    }
}

#pragma mark - controller
//控制器
- (NSMutableArray *)controllerArr{
    if (!_controllerArr) {
        NSArray *controllerTittle = @[@"YKMySuitBagVC",@"YKOrderBuyHistoryVC"];
        _controllerArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < controllerTittle.count; i ++) {
            NSString *controllerName = controllerTittle[i];
            Class className = NSClassFromString(controllerName);
            UIViewController *baseVC = [[className alloc] init];
            [_controllerArr addObject:baseVC];
        }
    }
    return _controllerArr;
}
//标题
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc] initWithObjects:@"租衣订单", @"买衣订单", nil];
    }
    return _titleArr;
}

- (UIPageViewController *)pageController{
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.delegate = self;
        _pageController.dataSource = self;
        [_pageController setViewControllers:@[[self.controllerArr objectAtIndex:self.type]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return _pageController;
}
//
- (void)changeControllerClick:(UIButton *)sender{
    
    NSInteger tempIndex = _currentPageIndex;
    __weak typeof(self) weakSelf = self;
    NSInteger nowTemp = sender.tag - BtnTag;
    if (nowTemp > tempIndex) {
        for (NSInteger i = tempIndex + 1; i <= nowTemp; i ++) {
            
            [weakSelf updateCurrentPageIndex:i];
            
            [self.pageController setViewControllers:@[self.controllerArr[i]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
                if (finished) {
                    //                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    }else if (nowTemp < tempIndex){
        for (NSInteger i = tempIndex; i >= nowTemp; i --) {
            
            [weakSelf updateCurrentPageIndex:i];
            
            [self.pageController setViewControllers:@[self.controllerArr[i]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
                if (finished) {
                    //                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    }
}
//
- (NSInteger)currentIndexOfController:(UIViewController *)viewController{
    for (NSInteger i = 0; i < self.controllerArr.count; i ++) {
        if (viewController == self.controllerArr[i]) {
            return i;
        }
    }return NSNotFound;
}
//
- (void)updateCurrentPageIndex:(NSInteger)newIndex{
 
    _currentPageIndex = newIndex;
    UIButton *button = [self.view viewWithTag:BtnTag + _currentPageIndex];
    button.selected = YES;
   
    [UIView animateWithDuration:0.25 animations:^{
        if (newIndex==0) {
            self.theLine.frame = CGRectMake(WIDHT/4-10.5,self.btnView.frame.size.height-2 , kSuitLength_H(21), 2);
        }else {
            self.theLine.frame = CGRectMake(WIDHT/4*3-10.5,self.btnView.frame.size.height-2 , kSuitLength_H(21), 2);
        }
        
    }];
    for (UIButton *btn in _buttonArr) {
        if (button == btn) {
            btn.titleLabel.textColor = YKRedColor;
        }else {
            btn.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        }
    }
   
}

#pragma mark - 无效代理方法
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [self currentIndexOfController:viewController];
    if ((currentIndex == NSNotFound) || (currentIndex == 0)) {
        return nil;
    }
    currentIndex --;
    return self.controllerArr[currentIndex];
}
//
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [self currentIndexOfController:viewController];
    currentIndex ++;
    if (currentIndex == self.controllerArr.count) {
        return nil;
    }
    return self.controllerArr[currentIndex];
}
//
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        _currentPageIndex = [self currentIndexOfController:[pageViewController.viewControllers lastObject]];
        [self updateCurrentPageIndex:_currentPageIndex];
        NSLog(@"当前选中的是%ld", _currentPageIndex);
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger x = _currentPageIndex;
    
    UIButton *button = [self.view viewWithTag:BtnTag + x];
    [UIView animateWithDuration:.25f animations:^{
        UIView *line = [self.view viewWithTag:2000];
        CGRect sizeRect = line.frame;
        sizeRect.origin.x = button.frame.origin.x;
    }];
}


//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:YES];
////    [ self.navigationController setNavigationBarHidden : NO animated : NO];
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
////    [ self.navigationController setNavigationBarHidden : NO animated : NO ];
////
////    self.navigationController.navigationBar.layer.shadowColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
////    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
////    self.navigationController.navigationBar.layer.shadowRadius = 4.f;
////    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0,0);
//}




@end
