//
//  QJOrderHallCell.m
//  QJDriver
//
//  Created by 张帅 on 2019/1/1.
//  Copyright © 2019 张帅. All rights reserved.
//

#import "QJOrderHomeCell.h"

@interface QJOrderHomeCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelOrdertype;
@property (weak, nonatomic) IBOutlet UILabel *labelTakeGoodTime;

@property (weak, nonatomic) IBOutlet UILabel *labelGoodFee;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodWeight;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressSend;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressTake;
@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressSendOther;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressTakeOther;

@end

@implementation QJOrderHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews
{
    [self.viewBack setNeedsLayout];
    [self.viewBack layoutIfNeeded];
    
    self.viewBack.layer.cornerRadius = 7.0f;
    self.viewBack.layer.borderColor = UIColorFromRGB(170, 170, 170).CGColor;
    self.viewBack.layer.borderWidth = 0.5f;
    self.labelOrdertype.layer.cornerRadius = 7.0f;
}

-(void)handleData:(QJBillListModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.labelOrdertype.text = model.send_type;
    self.labelAddressSend.text = model.start_address;
    self.labelAddressTake.text = model.end_address;
    self.labelTakeGoodTime.text = [NSString stringWithFormat:@"提货时间:%@",model.plan_format_sendGoodtime];
    self.labelGoodItem.text = model.category_names;
//    self.labelGoodItem.text = @"椅子，沙发，凳子，家具，地板，瓷砖，家具，瓷砖，地板，and so on";
    NSString *weight = [NSString stringWithFormat:@"%0.2f",[model.cargo_total_weight floatValue]];
    NSString *volume = [NSString stringWithFormat:@"%0.2f",[model.cargo_volume floatValue]];
    NSString *amount = model.delivery_count_total.length > 0 ? model.delivery_count_total:@"/";
    self.labelGoodWeight.text = [NSString stringWithFormat:@"重量：%@吨     体积：%@m³     数量：%@%@",weight,volume,amount,@""];
    NSString *fee = [NSString stringWithFormat:@"预计收入￥%@",model.total_fee];
    NSMutableAttributedString *mutableAttributeFee = [[NSMutableAttributedString alloc]initWithString:fee];
    [mutableAttributeFee addAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0xEE7D3F)} range:NSMakeRange(4, fee.length-4)];
    self.labelGoodFee.attributedText = mutableAttributeFee;
    self.labelAddressSendOther.text = [NSString stringWithFormat:@"%@",model.send_addres_count];
    self.labelAddressTakeOther.text = [NSString stringWithFormat:@"等%@个提货地",model.delivery_amount];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
