//
//  LDSearchDeviceViewController.m
//  Thermometer
//
//  Created by apple on 2022/4/8.
//

#import "LDSearchDeviceViewController.h"


#import "KKaddDeviceTableViewCell.h"
#import "KKaddDeviceHeaderView.h"
#import "LDAddDeviceBottomView.h"

#import "LDDeviceConnectViewController.h"


#define headerH 270
@interface LDSearchDeviceViewController ()<UITableViewDelegate,UITableViewDataSource,AJWaveRefreshProtocol>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) KKaddDeviceHeaderView *kkHeaderView;
@property (nonatomic,strong) NSMutableArray *kkInfoArr;
@property (nonatomic,strong) UILabel *kkFooterLab;

@property (nonatomic,weak) UIButton *connectBtn;

@property (nonatomic,weak) LDAddDeviceBottomView *BottomView;
//
@property (nonatomic,strong) LDMyPeripheral *MyPeripheral;


@end

@implementation LDSearchDeviceViewController

- (void)setIsHidenBackBtn:(BOOL)isHidenBackBtn
{
    _isHidenBackBtn = isHidenBackBtn;
    if (isHidenBackBtn) {
        self.returnBtn.hidden = isHidenBackBtn;
    }
}

- (void)setbabyDelegate
{
    //初始化BabyBluetooth 蓝牙库
    LDMyPeripheral *baby = [LDMyPeripheral kkshareBabyBluetooth];
    self.MyPeripheral = baby;
    [baby cancelAllPeripheralsConnection];
    WeakSelf;
    //设置蓝牙委托
    baby.setBlockOnDiscoverToPeripherals = ^(NSMutableArray * _Nonnull indexPaths, NSMutableArray * _Nonnull Peripherals) {
        [weakSelf.BottomView removeFromSuperview];
        weakSelf.kkInfoArr = Peripherals;
        [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    };
}

-(void)viewDidAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isHidenBackBtn) {
        self.returnBtn.hidden = YES;
    }

    //设置蓝牙委托
    [self setbabyDelegate];
    
    self.titleL.text = [NSString stringWithFormat:@"%@%@",LDMsg(@"连接"),LDMsg(@"测温贴")];
    [self kksetupUI];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    LDAddDeviceBottomView *BottomView = [[LDAddDeviceBottomView alloc]init];
    [self.view addSubview:BottomView];
    self.BottomView = BottomView;
    [BottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(-ShowDiff);
//        make.height.mas_equalTo((KKScale_Height_i7(310)));、

        make.top.mas_equalTo(KKNavH);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    WeakSelf;
    BottomView.connectBtnClickBlock = ^(NSString * _Nonnull string) {
//        weakSelf.baby.scanForPeripherals().begin();//搜索设备
        [weakSelf.MyPeripheral scanForPeripherals];

        [weakSelf.kkHeaderView starAnimation];
    };
    
    
    
}

- (void)kksetupUI
{
    
    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerClass:[KKaddDeviceTableViewCell class] forCellReuseIdentifier:@"KKaddDeviceTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.backgroundColor=[UIColor colorWithHexString:@"#F2F2F2"];
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 15, 20, -15);

    //    self.tableView.tableFooterView =[[UIView alloc]init];
//    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    //下拉刷新动效
//    [self.tableView setupRefreshHeader:self];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(KKNavH);
        make.bottom.mas_equalTo(- ShowDiff-48);

    }];
    self.kkHeaderView = [[KKaddDeviceHeaderView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, headerH)];
    self.tableView.tableHeaderView = self.kkHeaderView;
//    self.tableView.sectionHeaderHeight = 400;
//    self.kkFooterLab = [UILabel kkLabelWithText:@"如遇问题请及时联系平台官方客服" textColor:[UIColor colorWithHexString:@"#999999"] textFont:KKLab11Font andTextAlignment:NSTextAlignmentCenter];
//    self.kkFooterLab.frame = CGRectMake(0, 20, KKScreenWidth, 50);
//    self.tableView.tableFooterView = self.kkFooterLab;
//    [self headerRereshing];
    
    
    
    
    UIButton *connectBtn = [UIButton buttonWithTitle:LDMsg(@"连接") titleColor:[UIColor colorWithHexString:@"#FDFDFD"] andTitleFont:13];
    [self.view addSubview:connectBtn];
    self.connectBtn = connectBtn;
    [connectBtn addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-ShowDiff);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(280);

    }];

    connectBtn.backgroundColor = KKNormalColor;
    connectBtn.layer.mask =  [[YBToolClass sharedInstance] kkSetViewCornerRadius:24 fromView:connectBtn];
}


- (void)connectBtnClick
{

    for (NSMutableDictionary *item in self.kkInfoArr) {
        if ([item[@"isSelect"] intValue] == 1) {
            [self.MyPeripheral setCurrentConnectionPeripheral:item];
            [self.kkHeaderView stopAnimation];
            //停止扫描
            [self.MyPeripheral cancelScan];
            
            LDDeviceConnectViewController *vc = [[LDDeviceConnectViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];

            return;
            
            
        }
    }

}



- (void)headerRereshing
{

//    [self.baby begin];
//    [KKMyPayAPI kk_PostMyPurseInfoWithParameters:[NSDictionary new] successBlock:^(id  _Nullable response) {
//        if ([response[@"status"] intValue] == 1) {
//            self.kkInfoArr = response[@"biliall"];
//            self.kkHeaderView.kkInfoDic = response;
//        }else{
//            [MBProgressHUD kkshowMessage:response[@"cont"]];
//        }
//        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//    } failureBlock:^(NSError * _Nullable error) {
//        [self.tableView.mj_header endRefreshing];
//
//    } mainView:self.view];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];

}

//MARK:-tableviewDateSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KKaddDeviceTableViewCell *cell = [KKaddDeviceTableViewCell cellWithTabelView:tableView];
    cell.kkInfoDic = self.kkInfoArr[indexPath.row];
    WeakSelf;
    //右边箭头，不管用，iOS13适配问题
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    //kk分割线颜色
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = KKRGB(245, 245, 245);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
            return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.kkInfoArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 40;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 400;
//    }
//    else
//        return 8;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    for (NSMutableDictionary *dic in self.kkInfoArr) {
        [dic setValue:@"0" forKey:@"isSelect"];
    }
    NSMutableDictionary *kkdic = self.kkInfoArr[indexPath.row];
    [kkdic setValue:@"1" forKey:@"isSelect"];
    [tableView reloadData];

}

- (NSMutableArray *)kkInfoArr
{
    if (!_kkInfoArr) {
        _kkInfoArr = [NSMutableArray array];
    }
    return _kkInfoArr;
}



@end
