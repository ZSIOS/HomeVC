//
//  QJBillModel.h
//  QJDriver
//
//  Created by 张帅 on 2018/12/26.
//  Copyright © 2018 张帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJBillListGoodsItemsModel : NSObject

@property (nonatomic,copy) NSString *waybill_id;
@property (nonatomic,copy) NSString *delivery_count;
@property (nonatomic,copy) NSString *gross_weight;
@property (nonatomic,copy) NSString *pro_desc;
@property (nonatomic,copy) NSString *sign_count;
@property (nonatomic,copy) NSString *volume;

@end

// api_GetWayBillListDriver_id
@interface QJBillListModel : NSObject
/*
 waybill_id    string        运单ID
 waybil_no    string        运单号
 send_type    string        运单类型
 start_address    string        发货地
 address_number    string        其他发货地
 create_time    string        创建时间
 end_address    string        （收货地）
 delivery_amount    string        交货单数
 cargo_total_weight    string        总重量
 cargo_volume    string        总体积
 fee_total    string        总金额费用
 delivery_count_total string 特殊货物数量
 */
@property (nonatomic,copy) NSString *waybill_id;
@property (nonatomic,copy) NSString *waybil_no;
@property (nonatomic,copy) NSString *send_type;
@property (nonatomic,copy) NSString *start_address;
@property (nonatomic,copy) NSString *address_number;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *end_address;
@property (nonatomic,copy) NSString *delivery_amount;
@property (nonatomic,copy) NSString *cargo_total_weight;
@property (nonatomic,copy) NSString *cargo_volume;
@property (nonatomic,copy) NSString *total_fee;
@property (nonatomic,copy) NSString *send_addres_count;
@property (nonatomic,copy) NSString *delivery_count_total;
@property (nonatomic,copy) NSString *category_names;
@property (nonatomic,copy) NSString *plan_format_sendGoodtime;
@end
