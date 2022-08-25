//
//  KKMyPurseContentView.m
//  yunbaolive
//
//  Created by Peter on 2022/2/26.
//  Copyright © 2022 cat. All rights reserved.
//

#import "KKaddDeviceHeaderView.h"


@interface KKaddDeviceHeaderView ()

@property (nonatomic,weak) UIView *kkContentView;

@property (nonatomic,weak) UIImageView *kkbluetoothImgV;
@property (nonatomic,weak) UIImageView *kkGIFImgV;

@property (nonatomic,weak) UILabel *kkTitleLab;
@property (nonatomic,weak) UILabel *kkAssetsLab;


@end

@implementation KKaddDeviceHeaderView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
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
//    kkContentView.backgroundColor = [UIColor colorWithHexString:@"#24A1FE"];
    
    UIImageView *kkHeadImgV = [[UIImageView alloc]init];
    self.kkbluetoothImgV = kkHeadImgV;
    kkHeadImgV.contentMode  = UIViewContentModeScaleAspectFill;
    [self.kkContentView addSubview:kkHeadImgV];
//    kkHeadImgV.image = [UIImage imageNamed:@"kkbluetoothImgV_icon"];

    UIImageView *kkGIFImgV = [[UIImageView alloc]init];
    self.kkGIFImgV = kkGIFImgV;
    kkGIFImgV.contentMode  = UIViewContentModeScaleAspectFill;
    [self.kkContentView addSubview:kkGIFImgV];
//    kkGIFImgV.image = [UIImage imageNamed:@"addDevice_kkGIFImgV_icon"];
    kkGIFImgV.image = [UIImage imageNamed:@"searchDevice_kkGIFImgV_icon"];


    UILabel *kkTitleLab = [UILabel kkLabelWithText:LDMsg(@"请取出智能测温贴并打开手机蓝牙") textColor:KKBlackLabColor textFont:KKPhoenFont13 andTextAlignment:NSTextAlignmentCenter];
    self.kkTitleLab = kkTitleLab;
    [self.kkContentView addSubview:kkTitleLab];
    kkTitleLab.numberOfLines = 0;
    
    UILabel *kkAssetsLab = [UILabel kkLabelWithText:LDMsg(@"设备列表") textColor:[UIColor colorWithHexString:@"#333333"] textFont:kkFontRegularMT(16) andTextAlignment:NSTextAlignmentCenter];
    self.kkAssetsLab = kkAssetsLab;
    [self.kkContentView addSubview:kkAssetsLab];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.kkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(200);
    }];
    [self.kkGIFImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.centerX.mas_equalTo(self.kkContentView);
        make.width.height.mas_equalTo(130);
    }];

    [self.kkbluetoothImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(46);
        make.center.mas_equalTo(self.kkGIFImgV);
    }];
    [self.kkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkContentView.mas_bottom).mas_offset(-12);
//        make.centerX.mas_equalTo(self.kkContentView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);

    }];
    [self.kkAssetsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.kkContentView);
        make.top.mas_equalTo(self.kkContentView.mas_bottom).mas_offset(15);
    }];
   
}


- (void)setKkInfoDic:(NSDictionary *)kkInfoDic
{
    _kkInfoDic = kkInfoDic;
//    self.kkAssetsLab.text = [NSString kk_isNullString:kkInfoDic[@"moneyall"]];
   
    
}

- (void)starAnimation
{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
//    animation.fromValue = [NSNumber numberWithFloat:M_PI *2];
//    animation.toValue =  [NSNumber numberWithFloat: 0.f];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];

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

- (void)dealloc
{
    [self.kkGIFImgV.layer removeAllAnimations];
}

@end
