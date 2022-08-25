//
//  KKMyPurseTableViewCell.m
//  yunbaolive
//
//  Created by Peter on 2022/2/26.
//  Copyright © 2022 cat. All rights reserved.
//

#import "KKaddDeviceTableViewCell.h"

@interface KKaddDeviceTableViewCell ()


@property (nonatomic,weak) UILabel *kkTitleLab;
@property (nonatomic,weak) UIButton *connectBtn;
@property (nonatomic,weak) UIView *kkseparatorV;


@end

@implementation KKaddDeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTabelView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"KKaddDeviceTableViewCell";
    KKaddDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[KKaddDeviceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = KKWhiteColor;

    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupView];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = KKWhiteColor;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];

    }
    return self;
}

- (void)setupView
{
    
    UILabel *kkTitleLab = [UILabel kkLabelWithText:@"设备名称" textColor:KKBlackLabColor textFont:KKPhoenFont13 andTextAlignment:NSTextAlignmentLeft];
    self.kkTitleLab = kkTitleLab;
    [self.contentView addSubview:kkTitleLab];
    
    UIButton *kktreatyBtnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:kktreatyBtnIcon];
    self.connectBtn = kktreatyBtnIcon;
    kktreatyBtnIcon.selected = NO;
    [kktreatyBtnIcon setImage:[UIImage imageNamed:@"login_kktreatyBtnIcon_Normal"] forState:UIControlStateNormal];
    [kktreatyBtnIcon setImage:[UIImage imageNamed:@"login_kktreatyBtnIcon_Selected"] forState:UIControlStateSelected];
    kktreatyBtnIcon.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [kktreatyBtnIcon addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [kktreatyBtnIcon setEnLargeEdge:10];

    UIView *kkseparatorV = [[UIView alloc]init];
    self.kkseparatorV = kkseparatorV;
    [self.contentView addSubview:kkseparatorV];
    kkseparatorV.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.kkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(19);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkTitleLab);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
    }];
   
    
    [self.kkseparatorV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(self.kkTitleLab);
        make.right.mas_equalTo(self.connectBtn);
    }];

}

- (void)setKkInfoDic:(NSDictionary *)kkInfoDic
{
    _kkInfoDic = kkInfoDic;
//    self.kkTitleLab.text = [NSString kk_isNullString:kkInfoDic[@"bilicontent_name"]];
    NSDictionary *item = kkInfoDic;
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
    self.kkTitleLab.text = peripheralName;
    //信号和服务
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    if ([item[@"isSelect"] intValue] == 0) {
        self.connectBtn.selected = NO;
    }else{
        self.connectBtn.selected = YES;
    }

}

- (void)connectBtnClick
{
    
}

@end
