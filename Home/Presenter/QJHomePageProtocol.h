//
//  HomePageProtocol.h
//  QJDriver
//
//  Created by 张帅 on 2019/1/1.
//  Copyright © 2019 张帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QJDriverInfoModel.h"
/*
 * 首页协议，定义V和P互相沟通的方法
 **/
@protocol QJHomePageProtocol <NSObject>

@optional
-(void)handleHomePageDriverInfo:(QJDriverInfoModel *)model;
-(void)handleHomePageDataSource:(NSArray*)data;//处理订单数据
-(void)showEmptyView:(BOOL)show;//是否显示空页面
-(void)showIndicator;//请求提示框出现
-(void)hideIndicator;//请求提示框消失
-(void)isTakingOrder:(BOOL)isTakingOrder;//是否是接单中
-(void)showToast:(NSString *)toast;//显示提示语
-(void)changeSendTypeSuccess;//修改接单类型成功
-(void)changeCanReceiveSuccess;//修改接单状态
//-(void)viewNoOrderAppear:(BOOL)appear;
@end
