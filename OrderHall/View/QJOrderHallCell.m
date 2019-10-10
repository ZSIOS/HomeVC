//
//  QJOrderHallCell.m
//  QJDriver
//
//  Created by 张帅 on 2019/1/1.
//  Copyright © 2019 张帅. All rights reserved.
//

#import "QJOrderHallCell.h"

@interface QJOrderHallCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelOrdertype;
@property (weak, nonatomic) IBOutlet UILabel *labelTakeGoodTime;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodItem;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodFee;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodWeight;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressSend;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressTake;
@property (weak, nonatomic) IBOutlet UILabel *labelCountNumber;
@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UIButton *buttonTakeOrder;
@property (weak, nonatomic) IBOutlet UIView *viewTakeOrder;

@end

@implementation QJOrderHallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews
{
    self.viewBack.layer.cornerRadius = 7.0f;
    self.labelOrdertype.layer.cornerRadius = 7.0f;
    self.buttonTakeOrder.layer.cornerRadius = 7.0f;
    self.viewTakeOrder.layer.cornerRadius = 7.0f;
}

-(void)handleData:(QJBillListModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.buttonTakeOrder.tag = 1000 + indexPath.row;
    self.labelOrdertype.text = model.send_type;
    self.labelAddressSend.text = model.start_address;
    self.labelAddressTake.text = model.end_address;
    self.labelTakeGoodTime.text = [NSString stringWithFormat:@"提货时间%@",model.plan_format_sendGoodtime];
    self.labelGoodItem.text = model.category_names;
    NSString *weight = [NSString stringWithFormat:@"%0.2f",[model.cargo_total_weight floatValue]];
    NSString *volume = [NSString stringWithFormat:@"%0.2f",[model.cargo_volume floatValue]];
    NSString *amount = model.delivery_count_total.length > 0 ? model.delivery_count_total:@"/";
    self.labelGoodWeight.text = [NSString stringWithFormat:@"重量：%@吨     体积：%@m³     数量：%@",weight,volume,amount];
    self.labelCountNumber.text = [NSString stringWithFormat:@"%@单",model.delivery_amount];
    NSString *fee = [NSString stringWithFormat:@"预计收入￥%@",model.total_fee];
    NSMutableAttributedString *mutableAttributeFee = [[NSMutableAttributedString alloc]initWithString:fee];
    [mutableAttributeFee addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(255, 0, 0)} range:NSMakeRange(4, fee.length-4)];
    self.labelGoodFee.attributedText = mutableAttributeFee;
}


- (IBAction)clickButton:(UIButton *)sender {
    if(self.delegate){
        [self.delegate clickButtonTakeOrder:sender];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
