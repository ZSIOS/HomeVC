//
//  QJBillModel.m
//  QJDriver
//
//  Created by 张帅 on 2018/12/26.
//  Copyright © 2018 张帅. All rights reserved.
//

#import "QJBillListModel.h"

@implementation QJBillListGoodsItemsModel

@end

@implementation QJBillListModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"goodsItems":@"QJBillListGoodsItemsModel",
             };
}
@end
