//
//  LDDeviceConnectView.m
//  Thermometer
//
//  Created by Peter on 2022/3/8.
//

#import "LDDeviceConnectView.h"

@interface LDDeviceConnectView ()

@property (nonatomic,weak) UIView *kkContentView;

@property (nonatomic,weak) UIImageView *kkbgImgV;

@property (nonatomic,weak) UIImageView *kkGIFImgV;
@property (nonatomic,weak) UILabel *kkTitleLab;
@property (nonatomic,weak) UILabel *temperatureLab;
@property (nonatomic,weak) UILabel *temperatureLabType;


@property (nonatomic,weak) UILabel *kkTimeLab;

@property (nonatomic,weak) UILabel *kkTimeDescribeLab;
@property (nonatomic,weak) UILabel *kkDeviceDescribeLab;
@property (nonatomic,weak) UIButton *connectBtn;

@end

@implementation LDDeviceConnectView

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
    UIView *kkContentView = [[UIView alloc]init];
    self.kkContentView = kkContentView;
    [self addSubview:kkContentView];
    kkContentView.backgroundColor = KKWhiteColor;
    
    UIImageView *kkHeadImgV = [[UIImageView alloc]init];
    self.kkbgImgV = kkHeadImgV;
    kkHeadImgV.contentMode  = UIViewContentModeScaleAspectFill;
    [self.kkContentView addSubview:kkHeadImgV];
//    kkHeadImgV.image = [UIImage imageNamed:@"LDDeviceConnectView_bgimage"];
    kkHeadImgV.image = [UIImage imageNamed:@"LDDeviceConnectView_bgicon"];

    
    UIImageView *kkGIFImgV = [[UIImageView alloc]init];
    self.kkGIFImgV = kkGIFImgV;
    kkGIFImgV.contentMode  = UIViewContentModeScaleAspectFill;
    [self.kkContentView addSubview:kkGIFImgV];
//    kkGIFImgV.image = [UIImage imageNamed:@"LDDeviceConnectView_gif"];

//    UILabel *kkTitleLab = [UILabel kkLabelWithText:[NSString stringWithFormat:@"%@:%@",LDMsg(@"实时温度"),LDMsg(@"正常")] textColor:[UIColor colorWithHexString:@"#FDFDFD"] textFont:KKPhoenFont13 andTextAlignment:NSTextAlignmentCenter];
//    self.kkTitleLab = kkTitleLab;
//    [self.kkContentView addSubview:kkTitleLab];
    
    UILabel *temperatureLab = [UILabel kkLabelWithText:@"00.0" textColor:[UIColor colorWithHexString:@"#FFFFFF"] textFont:kkFontRegularMT(70) andTextAlignment:NSTextAlignmentCenter];
    self.temperatureLab = temperatureLab;
    [self.kkContentView addSubview:temperatureLab];

    UILabel *temperatureLabType = [UILabel kkLabelWithText:@"'C" textColor:[UIColor colorWithHexString:@"#FFFFFF"] textFont:kkFontRegularMT(16) andTextAlignment:NSTextAlignmentCenter];
    self.temperatureLabType = temperatureLabType;
    [self.kkContentView addSubview:temperatureLabType];
    
    
    UILabel *kkTimeLab = [UILabel kkLabelWithText:[NSString stringWithFormat:@"%@:09:53",LDMsg(@"倒计时")] textColor:[UIColor colorWithHexString:@"#FDFDFD"] textFont:KKTitleFont andTextAlignment:NSTextAlignmentCenter];
    self.kkTimeLab = kkTimeLab;
    [self.kkContentView addSubview:kkTimeLab];

    UILabel *kkTimeDescribeLab = [UILabel kkLabelWithText:LDMsg(@"您好,倒计时结束后无需任何操作,设备将断开蓝牙,进入休眠状态,如果您要继续测温并进行温度记录请点击下方按钮") textColor:KKWhiteColor textFont:KKLab11Font andTextAlignment:NSTextAlignmentLeft];
    self.kkTimeDescribeLab = kkTimeDescribeLab;
    [self.kkContentView addSubview:kkTimeDescribeLab];
    kkTimeDescribeLab.numberOfLines = 0;

    UILabel *kkDeviceDescribeLab = [UILabel kkLabelWithText:LDMsg(@"进入记录模式:您可以使用24小时即时读取实时温度,查看测量时长、报警记录共享设备等功能.") textColor:KKWhiteColor textFont:KKPhoenFont andTextAlignment:NSTextAlignmentLeft];
    self.kkDeviceDescribeLab = kkDeviceDescribeLab;
    [self.kkContentView addSubview:kkDeviceDescribeLab];
    kkDeviceDescribeLab.numberOfLines = 0;
    
    UIButton *connectBtn = [UIButton buttonWithTitle:LDMsg(@"进入记录模式") titleColor:[UIColor colorWithHexString:@"#24A1FE"] andTitleFont:13];
    [self.kkContentView addSubview:connectBtn];
    self.connectBtn = connectBtn;
    [connectBtn addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];

    connectBtn.backgroundColor = KKWhiteColor;
    connectBtn.layer.mask = [[YBToolClass sharedInstance] kkSetViewCornerRadius:24 fromView:connectBtn];
    
//    [self starAnimation];
    [self starCountDownWithWidget];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.kkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.kkbgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkContentView);
//        make.top.left.right.mas_equalTo(self);
//        make.height.mas_equalTo(KKScale_Height_i7(375));
    }];

    [self.temperatureLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.kkbgImgV);
        make.top.mas_equalTo(60);
        make.centerX.mas_equalTo(self.kkContentView);

    }];
    [self.temperatureLabType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.temperatureLab.mas_right).mas_offset(1);
        make.bottom.mas_equalTo(self.temperatureLab.mas_bottom).mas_offset(-15);
    }];
    [self.kkTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.kkbgImgV.mas_bottom).mas_offset(-15);
        make.top.mas_equalTo(self.temperatureLab.mas_bottom).mas_offset(10);

        make.centerX.mas_equalTo(self.kkContentView);
    }];
    [self.kkTimeDescribeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkTimeLab.mas_bottom).mas_offset(11);
//        make.bottom.mas_equalTo(self.kkDeviceDescribeLab.mas_top).mas_offset(-20);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
    }];

    [self.kkGIFImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.kkbgImgV);
//        make.width.height.mas_equalTo(KKScale_Height_i7(240));

        make.top.mas_equalTo(self.kkTimeDescribeLab.mas_bottom).mas_offset(30);
        make.centerX.mas_equalTo(self.kkContentView);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(183);

    }];

    

//    [self.kkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.temperatureLab.mas_top).mas_offset(-20);
//        make.centerX.mas_equalTo(self.kkbgImgV);
//    }];
    
   


    [self.kkDeviceDescribeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.connectBtn.mas_top).mas_offset(-19);
        make.bottom.mas_equalTo(-ShowDiff-20);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
    }];
    
    [self.connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-ShowDiff-20);
        make.bottom.mas_equalTo(self.kkDeviceDescribeLab.mas_top).mas_offset(-19);

        make.right.mas_equalTo(-47);
        make.left.mas_equalTo(47);
        make.height.mas_equalTo(47);
    }];

    
}


- (void)setKkInfoDic:(NSDictionary *)kkInfoDic
{
    _kkInfoDic = kkInfoDic;
    NSString *temperature = [NSString kk_isNullString:kkInfoDic[@"temperature"]];
    self.temperatureLab.text = [NSString stringWithFormat:@"%.1f",[temperature floatValue]];
    self.temperatureLabType.text = [NSString kk_isNullString:kkInfoDic[@"uint"]];

   float temperNum =  [[NSString kk_isNullString:kkInfoDic[@"temperature"]] floatValue];

//    if ([KKChatConfig getcimc_device_temperaturetype] == 1 ) {
//
//    }else{
//        temperNum = 32+ temperNum  * 1.8;
//
//    }

    
    if (temperNum >=[KKChatConfig getcimc_device_hight] || temperNum <=[KKChatConfig getcimc_device_low]) {
//        温度报警
//        self.kkbgImgV.image = [UIImage imageNamed:@"LDDeviceConnectView_bgimage_abnormal"];
        self.kkGIFImgV.image = [UIImage imageNamed:@"temperature_abnormal"];

        
    }else {
//        温度正常
//        self.kkTitleLab.text = [NSString stringWithFormat:@"%@:%@",LDMsg(@"实时温度"),LDMsg(@"正常")];
//        self.kkbgImgV.image = [UIImage imageNamed:@"LDDeviceConnectView_bgimage"];
        self.kkGIFImgV.image = [UIImage imageNamed:@"temperature_normal"];

        
    }

    //                temperature = "28.03";
    //                "temperature_type" = 0;
    //                timestamp = "2022-03-09 09:07:32 +0000";
    //                uint = @"℃";
    
}


- (void)connectBtnClick
{
    if (self.connectBtnClickBlock) {
        self.connectBtnClickBlock(@"");
    }
}



- (void)starAnimation
{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:M_PI *2];
    animation.toValue =  [NSNumber numberWithFloat: 0.f];
    animation.duration  = 1.5;                  //一次时间
    animation.autoreverses = NO;                         //是否自动回倒
    animation.fillMode =kCAFillModeForwards;
//    animation.removedOnCompletion = NO;           //设置进入后台动画不停止
    animation.removedOnCompletion = YES;           //设置进入后台动画不停止
    animation.repeatCount = CGFLOAT_MAX ;            //重复次数
//    animation.delegate = self;                    //动画代理
    [self.kkGIFImgV.layer addAnimation:animation forKey:nil];

}
- (void)stopAnimation
{
    [self.kkGIFImgV.layer removeAllAnimations];

}





- (void)starCountDownWithWidget
{

    __block int timeout= 60 *10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置


                if (self.CountDownEndBlock) {
                    self.CountDownEndBlock(@"");
                }
            });
        }else{
            
            int seconds = timeout % 61;
            NSString *str_minute = [NSString stringWithFormat:@"%02d",(timeout%3600)/60];
            NSString *str_second = [NSString stringWithFormat:@"%02d",timeout%60];
            NSString *strTime = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.kkTimeLab.text = [NSString stringWithFormat:@"%@:%@",LDMsg(@"倒计时"),strTime];
            });

//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                //
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationDuration:1];
//赋值也会影响毛玻璃效果
//                [sender setTitle:[NSString stringWithFormat:@"(%@s)",strTime] forState:UIControlStateNormal];

//                [UIView commitAnimations];

            });

            timeout--;
        }
    });

    dispatch_resume(_timer);
    
//    CGRect senderFrame = sender.frame;
//    senderFrame.size.width = [NSString stringLenthWithString:sender.titleLabel.text WithSize:CGSizeMake(CGFLOAT_MAX, 35) withFontSize:16].size.width +10;
//masnory更新约束会影响毛玻璃效果
//    [sender mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(senderFrame.size.width);
//    }];
}


- (void)dealloc
{
//    [self.kkGIFImgV.layer removeAllAnimations];
}

@end
