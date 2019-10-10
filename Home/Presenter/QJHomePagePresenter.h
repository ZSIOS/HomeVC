//
//  HomePagePresenter.h
//  QJDriver
//
//  Created by 张帅 on 2019/1/1.
//  Copyright © 2019 张帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QJHomePageProtocol.h"
/*
 * homepage的Presenter 定义功能
 **/
@interface QJHomePagePresenter : NSObject
+(instancetype)shareInstance;
@property (nonatomic,assign) BOOL canReceive;

-(void)attachView:(id <QJHomePageProtocol>)view;
//获取司机信息
-(void)fetchDataDriverInfo;
//改变接单类型
-(void)changeDriverSendType:(NSInteger )index;
//修改接单状态
-(void)changeDriverCanReceive:(BOOL)canReceive;
//开始接单
-(void)beginReceive;
//结束接单
-(void)endReceive;
//调用接单接口一次
-(void)doTakeOrder;
@end
