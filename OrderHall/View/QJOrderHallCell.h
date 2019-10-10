//
//  QJOrderHallCell.h
//  QJDriver
//
//  Created by 张帅 on 2019/1/1.
//  Copyright © 2019 张帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QJBillListModel.h"
@protocol orderHallTakeOrderDelegate

@optional
-(void)clickButtonTakeOrder:(UIButton *)sender;
@end

@interface QJOrderHallCell : UITableViewCell
@property (nonatomic,assign) id<orderHallTakeOrderDelegate> delegate;
-(void)handleData:(QJBillListModel *)model indexPath:(NSIndexPath *)indexPath;

@end
