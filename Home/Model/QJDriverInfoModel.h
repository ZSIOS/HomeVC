//
//  QJDriverInfoModel.h
//  QJDriver
//
//  Created by 张帅 on 2019/1/1.
//  Copyright © 2019 张帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJDriverInfoModel : NSObject
/*
 driver_id        String        司机ID
 partner_id       String        承运商ID
 driver_name      String        司机姓名
 link_tel         String        联系电话
 balance          String        余额
 category         String        品类名称
 platform_flag    String        平台标志
 send_type        String        1 及时 2 次日 3全部 0无
 */
@property (nonatomic,copy) NSString *driver_id;
@property (nonatomic,copy) NSString *partner_id;
@property (nonatomic,copy) NSString *driver_name;
@property (nonatomic,copy) NSString *link_tel;
@property (nonatomic,copy) NSString *balance;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *platform_flag;

@property (nonatomic,copy) NSString *IDCard;
@property (nonatomic,copy) NSString *authentication;
@property (nonatomic,copy) NSString *bank_account;
@property (nonatomic,copy) NSString *bank_name;
@property (nonatomic,copy) NSString *messageNum;
@property (nonatomic,copy) NSString *monthIncome;
@property (nonatomic,copy) NSString *servicePoints;
@property (nonatomic,copy) NSString *todayIncome;
@property (nonatomic,copy) NSString *todayWaybill;
@property (nonatomic,copy) NSString *send_type;
@property (nonatomic,copy) NSString *can_receive;
@property (nonatomic,copy) NSString *batch_bank_name;
@property (nonatomic,copy) NSString *weixin_nick_name;
@property (nonatomic,copy) NSString *weixin_open_id;
@property (nonatomic,copy) NSString *weixin_user_pic;
@property (nonatomic,copy) NSString *fee_change;
@end
