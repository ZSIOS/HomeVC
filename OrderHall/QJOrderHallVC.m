//
//  QJOrderHallVC.m
//  QJDriver
//
//  Created by 张帅 on 2018/12/31.
//  Copyright © 2018 张帅. All rights reserved.
//

#import "QJOrderHallVC.h"
#import "QJWayBillService.h"
#import "NSObject+MJKeyValue.h"
#import "QJBillListModel.h"
#import "QJOrderHallCell.h"
#import "QJWayBillService.h"
#import "UIView+Toast.h"
#import "QJAppInfoConstant.h"
#import <BaiduMapAPI/BMKGeometry.h>
#import "AppDelegate.h"
#import "QJHomePagePresenter.h"
#import "QJWayBillDetailVC.h"
#import "EPRefreshHeader.h"
#import "EPRefreshFooter.h"
@interface QJOrderHallVC () <orderHallTakeOrderDelegate>
{
    NSMutableArray *arrayData;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation QJOrderHallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)initView
{
    self.tableView.mj_header = [EPRefreshHeader headerWithRefreshingBlock:^{
        [self doRequest];
    }];
}

-(void)initData
{
    
}
#pragma mark -- Request
-(void)doRequest
{
    NSString *driverid = [[NSUserDefaults standardUserDefaults] objectForKey:QJ_DRIIVER_ID];
    [self showHDInView:self.view];
    ESWeakSelf;
    [[QJWayBillService shareService] api_GetNoPickWayBillListDriver_id:driverid Success:^(id responseObject) {
        NSDictionary *dic = responseObject[@"res_data"];
        [__weakSelf hideHDInView:self.view];
        arrayData = [QJBillListModel mj_objectArrayWithKeyValuesArray:dic[@"data_list"]];
        [__weakSelf.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [__weakSelf hideHDInView:self.view];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 191;
}

- (QJOrderHallCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const cellID = @"QJOrderHallCell";
    QJOrderHallCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"QJOrderHallCell" owner:self options:nil].firstObject;
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    QJBillListModel *model = [arrayData objectAtIndex:indexPath.row];
    [cell handleData:model indexPath:indexPath];
    return cell;
}

-(void)clickButtonTakeOrder:(UIButton *)sender
{
    if(![QJHomePagePresenter shareInstance].canReceive){
        [self.view makeToast:@"当前状态为不接单"];
        return;
    }
    NSInteger tag = sender.tag - 1000;
    QJBillListModel *model = arrayData[tag];
    NSString *position = [[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_NAME];
    NSString *driverid = [[NSUserDefaults standardUserDefaults] objectForKey:QJ_DRIIVER_ID];
    double logti = [[[NSUserDefaults standardUserDefaults] objectForKey:LONGTITUDE] doubleValue];
    double lati  = [[[NSUserDefaults standardUserDefaults] objectForKey:LATITUDE] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lati, logti);
    NSDictionary *convertDic = BMKConvertBaiduCoorFrom(coordinate, BMK_COORDTYPE_GPS);//GPS坐标转换成百度坐标
    CLLocationCoordinate2D bdCoordinate = BMKCoorDictionaryDecode(convertDic);
    NSString *bdmaplatilongi = [NSString stringWithFormat:@"%f,%f",bdCoordinate.longitude,bdCoordinate.latitude];
    ESWeakSelf;
    [[QJWayBillService shareService] api_GetWaybillTakingDriver_id:driverid waybill_id:model.waybill_id position:position?position:@"" bdmap_latilongi:bdmaplatilongi Success:^(id responseObject) {
        
        [__weakSelf doRequest];
        [__weakSelf.view makeToast:@"成功接单"];
    } failure:^(NSError *error) {
    }];
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QJBillListModel *model = [arrayData objectAtIndex:indexPath.row];
    QJWayBillDetailVC *vc = [[QJWayBillDetailVC alloc]init];
    vc.showCancelOrder = NO;
    vc.showUnnormalState = NO;
    vc.showPhoneIcon = NO;
    vc.isMyDetail = NO;
    vc.waybill_id = model.waybill_id;
    vc.waybill_no = model.waybil_no;
    vc.showBusinessPic = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
