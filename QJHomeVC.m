
//
//  QJHomeVC.m
//  QJDriver
//
//  Created by 张帅 on 2018/12/26.
//  Copyright © 2018 张帅. All rights reserved.
//

#import "QJHomeVC.h"
#import "QJShowLayerViewModel.h"
#import "QJLoginModelManager.h"
#import "QJLoginVC.h"
#import "Masonry.h"
#import "QJOrderHallVC.h"
#import "QJHomePageVC.h"
#import "QJNoticeListVC.h"
#import "QJMyInfoVC.h"
#import "QJVoiceManager.h"
#import <BaiduMapAPI/BMKGeometry.h>
#import "QJUserinfoService.h"
#import "AppDelegate.h"
#import "QJWayBillService.h"
#import "QJBillDetailModel.h"
#import "NSObject+MJKeyValue.h"
#import "QJMessageService.h"
#import "QJMessageModel.h"
#import "QJLoginService.h"
#import "QJDriverInfoModel.h"
//暂时借用
#import "QJLoginModelManager.h"
@interface QJHomeVC ()
{
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonHomePage;
@property (weak, nonatomic) IBOutlet UIButton *buttonOrderHall;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UIView *viewNav;
@property (strong, nonatomic) QJHomePageVC *homepage;
@property (strong, nonatomic) QJOrderHallVC *orderhall;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (strong, nonatomic) QJBillDetailModel *billDetailModel;
@property (weak, nonatomic) IBOutlet UILabel *labelNoticeNumber;
@property (strong, nonatomic) QJDriverInfoModel *driverInfoModel;
@end

@implementation QJHomeVC

-(QJOrderHallVC *)orderhall
{
    if(!_orderhall){
        _orderhall = [[QJOrderHallVC alloc]init];
    }
    return _orderhall;
}

-(QJHomePageVC *)homepage
{
    if(!_homepage){
        _homepage = [[QJHomePageVC alloc] init];
    }
    return _homepage;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
    [self.view addGestureRecognizer:pan];
    
    if(![QJLoginModelManager shareManager].isLogin){

        [self gotoLoginVC];
        return;
    }
    [self doRequestNotice];
    //无视延迟直接触发timer
    [timer fire];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self initData];
    
}

-(void)initData
{
    [self registerNotification];
    [self updateLocationWhenBackgroundMode];
}

-(void)initView
{
    [self setViewLineLayout];
    [self homepageAppear];
}

-(void)orderhallAppear
{
    [self.homepage willMoveToParentViewController:nil];
    [self.homepage.view removeFromSuperview];
    [self.homepage removeFromParentViewController];
    
    [self addChildViewController:self.orderhall];
    [self.viewMain addSubview:self.orderhall.view];
    [self.orderhall.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
    [self.orderhall didMoveToParentViewController:self];
}

-(void)homepageAppear
{
    [self.orderhall willMoveToParentViewController:nil];
    [self.orderhall.view removeFromSuperview];
    [self.orderhall removeFromParentViewController];
    
    [self addChildViewController:self.homepage];
    [self.viewMain addSubview:self.homepage.view];
    [self.homepage.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
    [self.homepage didMoveToParentViewController:self];
}

-(void)setViewLineLayout
{
    [_viewLine setFrame:CGRectMake(CGRectGetMinX(_buttonHomePage.frame), CGRectGetHeight(self.viewNav.frame)-1, CGRectGetWidth(_buttonHomePage.frame), 1)];

}
//注册新订单的通知
-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOrderCome:) name:QJ_NEWORDER object:nil];
}

-(void)newOrderCome:(NSNotification *)center
{
    NSDictionary *dic = center.userInfo;
    NSLog(@"diccc =  %@",dic);
    [self showNewOrderLayer:dic];//显示新订单页面
}

#pragma mark -- Action
-(void)gotoLoginVC
{
    QJLoginVC *vc = [[QJLoginVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickButtonMyinfo:(id)sender {

    QJMyInfoVC *vc = [[QJMyInfoVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)clickButtonNotice:(id)sender {
    
    QJNoticeListVC *vc = [[QJNoticeListVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)clickButtonHomePage:(id)sender {
    
    self.buttonHomePage.enabled = NO;
    self.buttonOrderHall.enabled = YES;
    [self homepageAppear];
    [self.buttonHomePage  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonOrderHall setTitleColor:UIColorFromRGB(170, 170, 170) forState:UIControlStateNormal];
    [_viewLine setFrame:CGRectMake(CGRectGetMinX(_buttonHomePage.frame), CGRectGetHeight(self.viewNav.frame)-1, CGRectGetWidth(_buttonHomePage.frame), 1)];
    [_homepage doRequest];

}

- (IBAction)clickButtonOrderHall:(id)sender {
    
    self.buttonHomePage.enabled = YES;
    self.buttonOrderHall.enabled = NO;
    [self orderhallAppear];
    [self.buttonOrderHall  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonHomePage   setTitleColor:UIColorFromRGB(170, 170, 170) forState:UIControlStateNormal];
    [_viewLine setFrame:CGRectMake(CGRectGetMinX(_buttonOrderHall.frame), CGRectGetHeight(self.viewNav.frame)-1, CGRectGetWidth(_buttonOrderHall.frame), 1)];
    [_orderhall doRequest];
}
#pragma mark -- NoticeNum
-(void)doRequestNotice
{
    NSString *driverid = [[NSUserDefaults standardUserDefaults] objectForKey:QJ_DRIIVER_ID];
    if(!driverid || driverid.length == 0){
        return;
    }
    ESWeakSelf;
    [[QJLoginService shareService] api_GetDriverInfoDriverid:driverid success:^(NSDictionary *responseObject){
        __weakSelf.driverInfoModel = [QJDriverInfoModel mj_objectWithKeyValues:responseObject[@"res_data"]];
        [__weakSelf handleNoticeLabel];
    } failure:^(NSError *error) {
    }];

}

-(void)handleNoticeLabel
{
    NSInteger j = [self.driverInfoModel.messageNum integerValue];
    if(j == 0){
        self.labelNoticeNumber.hidden = YES;
        self.labelNoticeNumber.text = @"0";
    }else{
        self.labelNoticeNumber.hidden = NO;
        self.labelNoticeNumber.text = [NSString stringWithFormat:@"%zi",j];
    }
}

-(NSString *)dictionToJson:(NSDictionary *)dic
{
    if(!dic || dic.allKeys.count == 0){
        return @"";
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark -- 新订单弹层
-(void)showNewOrderLayer:(NSDictionary *)userInfo
{
    NSDictionary *dic = userInfo[@"userInfo"];
    NSString *type    = dic[@"type"];
    if(0 != [type integerValue]){
        return;
    }
    NSString *billid    = dic[@"waybill_id"];
    NSString *waybillno = @"";
    ESWeakSelf;
    [[QJWayBillService shareService] api_GetWayBillDetailWaybill_id:billid
                                                         waybill_no:waybillno
                                                            Success:^(id responseObject) {
                                                                __weakSelf.billDetailModel = [QJBillDetailModel mj_objectWithKeyValues:responseObject[@"res_data"]];
                                                                [__weakSelf handleNewOrder];
                                                            }failure:^(NSError *error) {
                                                                
                                                            }];
    
}

-(void)handleNewOrder
{
    QJShowLayerViewModel *viewModel = [QJShowLayerViewModel shareInstance];
    viewModel.takeOrderSuccessblock = ^(NSDictionary *info) {
        [_homepage doRequest];
    };
    [viewModel showView:[AppDelegate appDelegate].window type:cardTypeNewOrder];
    [viewModel refreshViewWithModel:self.billDetailModel];
    //播放声音
    QJVoiceManager *manager = [QJVoiceManager shareInstance];
    [manager setDefaultWithVolume:-1.0 rate:0.4 pitchMultiplier:-1.0];
    NSString *strVoice = [NSString stringWithFormat:@"%@，从%@到%@，全程%@公里",self.billDetailModel.plan_format_sendGoodtime,self.billDetailModel.start_address,self.billDetailModel.end_address,self.billDetailModel.distance];//需要播放的字符串
    [manager play:strVoice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateLocationWhenBackgroundMode
{
    if(!timer){
        timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(doUpdateLocation) userInfo:nil repeats:YES];
    }
    [timer fire];
}

-(void)doUpdateLocation
{
    NSString *driverid = [[NSUserDefaults standardUserDefaults] objectForKey:QJ_DRIIVER_ID];
    NSString *position = [[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_NAME];
    double logti = 0;
    double lati = 0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:LONGTITUDE]){
        logti = [[[NSUserDefaults standardUserDefaults] objectForKey:LONGTITUDE] doubleValue];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:LATITUDE]){
        lati  = [[[NSUserDefaults standardUserDefaults] objectForKey:LATITUDE] doubleValue];
    }
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lati, logti);
    NSDictionary *convertDic = BMKConvertBaiduCoorFrom(coordinate, BMK_COORDTYPE_GPS);//GPS坐标转换成百度坐标
    CLLocationCoordinate2D bdCoordinate = BMKCoorDictionaryDecode(convertDic);
    NSString *bdmaplatilongi = [NSString stringWithFormat:@"%f,%f",bdCoordinate.longitude,bdCoordinate.latitude];
    if(!driverid || driverid.length == 0){
        return;
    }
    
//    ESWeakSelf;
    [[QJUserinfoService shareService] api_SendUserInfoDriver_id:driverid position:position?position:@"" bdmap_latilongi:bdmaplatilongi?bdmaplatilongi:@"" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)dealloc{
    [timer invalidate];
    timer = nil;
}

@end
