//
//  YKSelectColedgeVC.m
//  YK
//
//  Created by edz on 2018/6/5.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKSelectColedgeVC.h"
#import "YKSelectColedgeCell.h"

@interface YKSelectColedgeVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_searchBtnArr;
}
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *coledgeLists;//原数据源
@property (nonatomic,strong)NSArray *sections;//分好组的数据源
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;

@end

@implementation YKSelectColedgeVC

- (NSArray *)sections{
    if (!_sections) {
        _sections = [NSArray array];
    }
    return _sections;
}

- (NSArray *)_searchBtnArr{
    if (!_searchBtnArr) {
        _searchBtnArr = [NSArray array];
    }
    return _searchBtnArr;
}

- (void)viewWillAppear:(BOOL)animated{
    if ([UD objectForKey:@"colledges"]) {
        self.sections = [NSArray arrayWithArray:[UD objectForKey:@"colledges"]];
        _searchBtnArr = [NSArray arrayWithArray:[UD objectForKey:@"_searchBtnArr"]];
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self.tableView reloadData];
        });

        [[YKUserManager sharedManager]getColedgeListStatus:0 OnResponse:^(NSDictionary *dic) {
            self.coledgeLists = [NSMutableArray arrayWithArray:dic[@"data"]];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 处理耗时操作在此次添加
                [self group:self.coledgeLists];
                
            });
            
        }];
        return;
    }
    [[YKUserManager sharedManager]getColedgeListStatus:1 OnResponse:^(NSDictionary *dic) {
        self.coledgeLists = [NSMutableArray arrayWithArray:dic[@"data"]];
        
            // 处理耗时操作在此次添加
            [self group:self.coledgeLists];
            
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (HEIGHT == 812) {
        _gap.constant = 40;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+20, WIDHT, HEIGHT-84) style:UITableViewStylePlain];
    }else {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDHT, HEIGHT-64) style:UITableViewStylePlain];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:[UIColor colorWithHexString:@"676869"]];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView reloadData];
    
    _searchBtnArr = [NSMutableArray array];
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
//    [[YKUserManager sharedManager]getColedgeListOnResponse:^(NSDictionary *dic) {
//        self.coledgeLists = [NSMutableArray arrayWithArray:dic[@"data"]];
//        [self group:self.coledgeLists];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    [[YKUserManager sharedManager]getColedgeListOnResponse:^(NSDictionary *dic) {
//        self.coledgeLists = [NSMutableArray arrayWithArray:dic[@"data"]];
//        [self group:self.coledgeLists];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    }];
}
- (void)group:(NSArray *)array{
    
    NSLog(@"进来了");
    
    NSMutableArray *indexArray = [NSMutableArray array];
    for (NSDictionary *blacker in array) {
        if (blacker[@"schoolName"] == [NSNull null] || blacker[@"schoolName"] == nil){
            break;
        }
        NSString *firstChar = [self firstCharactor:blacker[@"schoolName"]];
        if ([firstChar characterAtIndex:0] < 'A' || [firstChar characterAtIndex:0] > 'Z') {
            if (![indexArray containsObject:@"#"]) {
                [indexArray addObject:@"#"];
            }
        }else {
            if (![indexArray containsObject:firstChar]) {
                [indexArray addObject:[NSString stringWithFormat:@"%@",firstChar]];
            
            }
        }
    }
    
    NSArray *result = [indexArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    _searchBtnArr = [NSArray arrayWithArray:result];
    
    NSMutableArray *totalSections = [NSMutableArray array];
    for (NSString *cha in _searchBtnArr) {
        NSMutableArray *sections = [NSMutableArray array];
        for (NSDictionary *blacker in self.coledgeLists) {
            
            if (![cha isEqualToString:@"#"] && [[self firstCharactor:blacker[@"schoolName"]] isEqualToString:cha]) {
                [sections addObject:blacker];
            }
            
            if (([cha isEqualToString:@"#"] && [[self firstCharactor:blacker[@"schoolName"]] characterAtIndex:0] < 'A') || [[self firstCharactor:blacker[@"schoolName"]] characterAtIndex:0] > 'Z'){
                [sections addObject:blacker];
            }
        }
        [totalSections addObject:sections];
    }
    self.sections = [NSArray arrayWithArray:totalSections];
    //保存数组
   
    [UD setObject: self.sections forKey:@"colledges"];
    [UD setObject: _searchBtnArr forKey:@"_searchBtnArr"];
    NSLog(@"出去啊");
}

- (NSString *)firstCharactor:(NSString *)aString
{
    if (!aString) {
        return nil;
    }
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //多音字处理
    if ([[(NSString *)aString substringToIndex:1] compare:@"长"] == NSOrderedSame) {
        [str replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([[(NSString *)aString substringToIndex:1] compare:@"沈"] == NSOrderedSame) {
        [str replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([[(NSString *)aString substringToIndex:1] compare:@"重"] == NSOrderedSame) {
        [str replaceCharactersInRange:NSMakeRange(0, 4) withString:@"cong"];
    }
    if ([[(NSString *)aString substringToIndex:1] compare:@"厦"] == NSOrderedSame) {
        [str replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSString *pinYin = [str capitalizedString];//转大写
    
    return [pinYin substringToIndex:1];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [NSArray arrayWithArray:self.sections[section]];
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
//    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     YKSelectColedgeCell *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKSelectColedgeCell" owner:self options:nil][0];
    bagCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [bagCell initWithDic:self.sections[indexPath.section][indexPath.row]];
    return bagCell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _searchBtnArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *header in _searchBtnArr){
        if([header isEqualToString:title]){
            return count;
        }
        count ++;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [[UIView alloc]init];
    head.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    UILabel *title = [[UILabel alloc]init];
    if (section<_searchBtnArr.count) {
        title.text = _searchBtnArr[section];
    }
    title.font = [UIFont boldSystemFontOfSize:16];
//    title.backgroundColor = [UIColor colorWithHexString:@"333333"];
    title.textColor = mainColor;
    title.textAlignment = NSTextAlignmentLeft;
    
    [head addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(head.mas_centerY);
        make.left.equalTo(@24);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
        
    }];
    
    return head;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKSelectColedgeCell *cell = (YKSelectColedgeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (_selectColedgeBlock) {
        _selectColedgeBlock(cell.colledge,cell.colledgeId);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
