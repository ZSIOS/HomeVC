//
//  HomePagePresenter.m
//  QJDriver
//
//  Created by 张帅 on 2019/1/1.
//  Copyright © 2019 张帅. All rights reserved.
//

#import "QJHomePagePresenter.h"
#import "QJLoginService.h"
#import "NSObject+MJKeyValue.h"
#import "QJWayBillService.h"
#import "QJBillListModel.h"
#import "QJSoundManager.h"
@interface QJHomePagePresenter()

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,weak) id<QJHomePageProtocol> attachView;

@end

@implementation QJHomePagePresenter
+(instancetype)shareInstance
{
    static QJHomePagePresenter *_service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _service = [[self alloc] init];
    });
    return _service;
}
-(void)dealloc
{
    [self.timer invalidate];
}

-(NSTimer *)timer
{
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(doTakeOrder) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(void)doTakeOrder
{
    
    NSString *driverid = [[NSUserDefaults standardUserDefaults] objectForKey:QJ_DRIIVER_ID];
    if(!driverid || driverid.length == 0){
        return;
    }
    ESWeakSelf;
    [[QJWayBillService shareService] api_GetWayBillListDriver_id:driverid Success:^(id responseObject) {
        NSDictionary *dic = responseObject[@"res_data"];
        NSArray *arrayData = [QJBillListModel mj_objectArrayWithKeyValuesArray:dic[@"data_list"]];
        if(arrayData.count == 0){
            [__weakSelf.attachView showEmptyView:YES];
        }else{
            [__weakSelf.attachView showEmptyView:NO];
            [__weakSelf.attachView handleHomePageDataSource:arrayData];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)attachView:(id <QJHomePageProtocol>)view
{
    self.attachView = view;
}

-(void)fetchDataDriverInfo
{
    [self doRequestDriverInfo];
}

-(void)doRequestDriverInfo
{
    NSString *driverid = [[NSUserDefaults standardUserDefaults] objectForKey:QJ_DRIIVER_ID];
    if(!driverid || driverid.length == 0){
        return;
    }
    [self.attachView showIndicator];
    ESWeakSelf;
    [[QJLoginService shareService] api_GetDriverInfoDriverid:driverid success:^(NSDictionary *responseObject){
        QJDriverInfoModel *model = [QJDriverInfoModel mj_objectWithKeyValues:responseObject[@"res_data"]];
        [__weakSelf.attachView handleHomePageDriverInfo:model];
        [__weakSelf.attachView hideIndicator];
    } failure:^(NSError *error) {
        [__weakSelf.attachView hideIndicator];
    }];
}

-(void)changeDriverSendType:(NSInteger)index
{
    NSString *type = @"0";
    if(0 == index){
        type = @"1";
    }else if (1 == index){
        type = @"2";
    }else if (2 == index){
        type = @"3";
    }
    NSString *driverid   = [[NSUserDefaults standardUserDefaults] objectForKey:QJ_DRIIVER_ID];
    NSString *drivername = [[NSUserDefaults standardUserDefaults] objectForKey:QJ_DRIIVER_NAME];
    if(!driverid || driverid.length == 0 || !drivername)
    [self.attachView showIndicator];
    ESWeakSelf;
    [[QJLoginService shareService] api_GetUpdateDriverSendTypeDriverid:driverid driver_name:drivername send_type:type success:^(NSDictionary *responseObject) {
        [[QJSoundManager shareInstance] playSoundType:3];
        [__weakSelf.attachView changeSendTypeSuccess];
        [__weakSelf.attachView showToast:@"修改成功"];
        [__weakSelf.attachView hideIndicator];
    } failure:^(NSError *error) {
        [__weakSelf.attachView hideIndicator];
    }];
}

-(void)changeDriverCanReceive:(BOOL)canReceive
{
    NSString *can = @"";
    if(canReceive){
        can = @"Y";
    }else{
        can = @"N";
    }
    NSString *driverid   = [[NSUserDefaults standardUserDefaults] objectForKey:QJ_DRIIVER_ID];
    NSString *drivername = [[NSUserDefaults standardUserDefaults] objectForKey:QJ_DRIIVER_NAME];
    [self.attachView showIndicator];
    ESWeakSelf;
    [[QJLoginService shareService] api_GetUpdateDriverCanReceiveDriverid:driverid driver_name:drivername can_receive:can success:^(NSDictionary *responseObject) {
        if(canReceive){
            [[QJSoundManager shareInstance] playSoundType:1];
        }else{
            [[QJSoundManager shareInstance] playSoundType:2];
        }
        __weakSelf.canReceive = canReceive;
        [__weakSelf.attachView changeCanReceiveSuccess];
        [__weakSelf.attachView hideIndicator];
    } failure:^(NSError *error) {
        [__weakSelf.attachView hideIndicator];
    }];
}

-(void)beganReceiveOrder
{
    
}

-(void)beginReceive
{
//    [_timer fire];
    [self fetchDataDriverInfo];
    [self doTakeOrder];
}

-(void)endReceive
{
//    [_timer invalidate];
}
@end
