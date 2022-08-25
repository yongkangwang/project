//
//  LDAddDeviceBottomView.m
//  Thermometer
//
//  Created by Peter on 2022/3/9.
//

#import "LDAddDeviceBottomView.h"


@interface LDAddDeviceBottomView ()
@property (nonatomic,weak) UIImageView *ConnectImgV;

@property (nonatomic,weak) UILabel *kkTitleLab;
@property (nonatomic,weak) UIButton *connectBtn;


@end

@implementation LDAddDeviceBottomView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KKWhiteColor;
        //添加子控件
        [self kksetupUI];
    }
    return self;
}

- (void)kksetupUI
{
   
    UIImageView *ConnectImgV = [[UIImageView alloc]init];
    self.ConnectImgV = ConnectImgV;
    ConnectImgV.contentMode  = UIViewContentModeScaleAspectFill;
    [self addSubview:ConnectImgV];
    ConnectImgV.image = [UIImage imageNamed:@"AddDevice_ConnectImgV_icon"];

    UILabel *kkTitleLab = [UILabel kkLabelWithText:LDMsg(@"请取出智能测温贴并打开手机蓝牙") textColor:KKBlackLabColor textFont:KKTitleFont andTextAlignment:NSTextAlignmentCenter];
    self.kkTitleLab = kkTitleLab;
    [self addSubview:kkTitleLab];
        
    UIButton *connectBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"%@%@",LDMsg(@"开始"),LDMsg(@"连接")] titleColor:[UIColor colorWithHexString:@"#FDFDFD"] andTitleFont:13];
    [self addSubview:connectBtn];
    self.connectBtn = connectBtn;
    [connectBtn addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(-ShowDiff);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(280);

    }];
    connectBtn.backgroundColor = KKNormalColor;
    connectBtn.layer.mask =  [[YBToolClass sharedInstance] kkSetViewCornerRadius:24 fromView:connectBtn];

    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.ConnectImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(70);
        make.height.mas_equalTo(128);
        make.width.mas_equalTo(227);
        make.centerX.mas_equalTo(self);

    }];

    [self.connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(KKScale_Height_i7(41))- ShowDiff);
        make.left.mas_equalTo(47);
        make.right.mas_equalTo(-47);
        make.height.mas_equalTo(48);
    }];
    [self.kkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.connectBtn.mas_top).mas_offset(-(KKScale_Height_i7(40)));
        make.top.mas_equalTo(self.ConnectImgV.mas_bottom).mas_offset(30);

        make.centerX.mas_equalTo(self);
    }];

   
}


- (void)connectBtnClick
{
    if (self.connectBtnClickBlock) {
        self.connectBtnClickBlock(@"");
    }
}

@end
