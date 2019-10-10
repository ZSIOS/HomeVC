//
//  QJHomePageVC.m
//  QJDriver
//
//  Created by 张帅 on 2018/12/31.
//  Copyright © 2018 张帅. All rights reserved.
//

#import "QJHomePageVC.h"
#import "QJHomePageProtocol.h"
#import "QJDriverInfoModel.h"
#import "QJHomePagePresenter.h"
#import "UIView+Toast.h"
#import "QJOrderHomeCell.h"
#import "QJWayBillDetailVC.h"
#import "CostItemView.h"
#import "QJIncomThisMonth.h"
#import "ZFProgressView.h"
#import "UIImageView+Tool.h"
#import "QJMyWayBillVC.h"
#import "EPRefreshHeader.h"
#import "EPRefreshFooter.h"
@interface QJHomePageVC () <QJHomePageProtocol,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger currentOrderType;//当前订单类型 默认为即时拼
}
@property (nonatomic,strong) QJDriverInfoModel *driverModel;
@property (nonatomic,strong) QJHomePagePresenter *presenter;
@property (nonatomic,strong) NSArray *arrayData;
@property (weak, nonatomic) IBOutlet UILabel *labelServerScore;
@property (weak, nonatomic) IBOutlet UILabel *labelOrderToday;
@property (weak, nonatomic) IBOutlet UILabel *labelFeeToday;
@property (weak, nonatomic) IBOutlet UIView *viewNoOrder;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewOrderType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewOrderTypeLeading;
@property (weak, nonatomic) IBOutlet UILabel *labelOrderTypeOne;
@property (weak, nonatomic) IBOutlet UILabel *labelOrderTypeTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelOrderTypeThree;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewOrderTypeBottom;
@property (weak, nonatomic) IBOutlet UIButton *buttonSaveSetting;
@property (weak, nonatomic) IBOutlet UIButton *buttonOrderTake;//点击接单按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonTakingOrder;//接单中按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonEndCar;//收车按钮
@property (weak, nonatomic) IBOutlet UIView *viewTakingOrder;
@property (nonatomic,strong) CostItemView *viewTakeOrder;
@property (weak, nonatomic) IBOutlet UIImageView *imageTakingOrder;

@end

@implementation QJHomePageVC
-(instancetype)init
{
    self = [super init];
    if(self){
        [self.presenter attachView:self];
        [self.presenter fetchDataDriverInfo];
    }
    return self;
}

-(QJDriverInfoModel *)driverModel
{
    if(!_driverModel){
        _driverModel = [[QJDriverInfoModel alloc]init];
    }
    return _driverModel;
}

-(QJHomePagePresenter *)presenter
{
    if(!_presenter){
        _presenter = [QJHomePagePresenter shareInstance];
    }
    return _presenter;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_presenter fetchDataDriverInfo];
    [_presenter doTakeOrder];
    //刷新gif动画
    [self refreshImageGif];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_presenter endReceive];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initView];
}

-(void)initView
{
    self.buttonSaveSetting.layer.borderColor = UIColorFromRGB(238, 125, 63).CGColor;
    self.buttonSaveSetting.layer.borderWidth = 1.0f;
    self.buttonSaveSetting.layer.cornerRadius = 4.0f;
    [self handleViewTakeOrder];
    
    self.tableView.mj_header = [EPRefreshHeader headerWithRefreshingBlock:^{
        [self.presenter fetchDataDriverInfo];
        [self.presenter beginReceive];
    }];
}

-(void)handleViewTakeOrder
{
    
    if(!_viewTakeOrder){
        _viewTakeOrder = [[CostItemView alloc]init];
    }
    [_viewTakeOrder setProgressFrame:CGRectMake(0, 0, 65, 65)];
    _viewTakeOrder.tag = 1001;
    [_viewTakeOrder setProgress:0 total:100 animated:YES];
    [self refreshImageGif];
}

-(void)refreshImageGif
{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 1.5;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.imageTakingOrder.layer addAnimation:animation forKey:nil];
}

-(void)initData
{
    currentOrderType = 0;
    [self viewNoOrderAppear:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goForeground) name:QJ_FOREGROUND object:nil];
}

-(void)goForeground
{
    [self refreshImageGif];
}
#pragma mark -- Action
//点击 模式
- (IBAction)clickButtonType:(id)sender {
    
    [self viewOrderTypeAppear:YES];
}
//点击 收车
- (IBAction)clickButtonTakeCar:(id)sender {

    [_presenter changeDriverCanReceive:NO];
    
}
//点击 点击接单
- (IBAction)clickButtonTakeOrder:(id)sender {
    
    [_presenter changeDriverCanReceive:YES];
}
//点击 保存设置
- (IBAction)clickButtonSaveSetting:(id)sender {
    
    [_presenter changeDriverSendType:currentOrderType];
}
//点击今日收入
- (IBAction)clickButtonTodayIncome:(id)sender {
    
//    [self goToIncomeThisMonthVC];
}

-(void)goToIncomeThisMonthVC
{
    QJIncomThisMonth *vc = [[QJIncomThisMonth alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//点击今日运单
- (IBAction)clickButtonTodayOrder:(id)sender {
    
    QJMyWayBillVC *vc = [[QJMyWayBillVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)clickButtonOrderTypeOne:(id)sender {
    
    [self setOrderType:0];
}

- (IBAction)clickButtonOrderTypeTwo:(id)sender {
    
    [self setOrderType:1];
}

- (IBAction)clickButtonOrderTypeThree:(id)sender {
    
    [self setOrderType:2];
}

#pragma mark --
-(void)noOrderAppear:(BOOL)appear
{
    self.viewNoOrder.hidden = !appear;
}
//index 0:即时拼 1：次日达 2：全部
-(void)setOrderType:(NSInteger)index
{
    switch (index) {
        case 0:
            currentOrderType = 0;
            break;
        case 1:
            currentOrderType = 1;
            break;
        case 2:
            currentOrderType = 2;
            break;
        default:
            break;
    }
    [self viewTypeMove:index];
}

-(void)viewTypeMove:(NSInteger)index
{
    if(0 == index){
        [UIView animateWithDuration:0.2f animations:^{
            self.viewOrderTypeLeading.constant = CGRectGetMinX(self.labelOrderTypeOne.frame);
        }];
    }else if (1 == index){
        [UIView animateWithDuration:0.2f animations:^{
            self.viewOrderTypeLeading.constant = CGRectGetMinX(self.labelOrderTypeTwo.frame);
        }];
    }else if (2 == index){
        [UIView animateWithDuration:0.2f animations:^{
            self.viewOrderTypeLeading.constant = CGRectGetMinX(self.labelOrderTypeThree.frame);
        }];
    }
    
}

-(void)viewOrderTypeAppear:(BOOL)show
{
    if(show){
        self.viewOrderTypeBottom.constant = 0;
    }else{
        self.viewOrderTypeBottom.constant = -163;
    }
}

-(void)viewTakeOrderButtonAppear:(BOOL)appear
{
    if(appear){
        self.buttonOrderTake.hidden = NO;
        self.buttonTakingOrder.hidden = YES;
        self.viewTakingOrder.hidden = YES;
        self.buttonEndCar.hidden = YES;
    }else{
        self.buttonOrderTake.hidden = YES;
        self.buttonTakingOrder.hidden = NO;
        self.viewTakingOrder.hidden = NO;
        self.buttonEndCar.hidden = NO;
    }
}

#pragma mark -- Protocol
//司机信息
-(void)handleHomePageDriverInfo:(QJDriverInfoModel *)model
{
    self.driverModel = model;
    self.labelFeeToday.text = self.driverModel.todayIncome;
    self.labelOrderToday.text = self.driverModel.todayWaybill;
    self.labelServerScore.text = self.driverModel.servicePoints;
    if([self.driverModel.send_type isEqual:@"0"]){
        [self setOrderType:0];
    }else if ([self.driverModel.send_type isEqual:@"1"]){
        [self setOrderType:0];
    }else if ([self.driverModel.send_type isEqual:@"2"]){
        [self setOrderType:1];
    }else if ([self.driverModel.send_type isEqual:@"3"]){
        [self setOrderType:2];
    }
    if([self.driverModel.can_receive isEqual:@"Y"]){
        _presenter.canReceive = YES;
        [self viewTakeOrderButtonAppear:NO];
    }else{
        _presenter.canReceive = NO;
        [self viewTakeOrderButtonAppear:YES];
    }
    
}
//处理数据
-(void)handleHomePageDataSource:(NSArray*)data
{
    self.arrayData = data;
    [self.tableView reloadData];
}
//显示空页面
-(void)showEmptyView:(BOOL)show
{
    if(show){
        [self viewNoOrderAppear:YES];
    }else{
        [self viewNoOrderAppear:NO];
    }
    
}
//请求提示框出现
-(void)showIndicator
{
    [self showHDInView:self.view];
}
//请求提示框消失
-(void)hideIndicator
{
    [self hideHDInView:self.view];
    [self.tableView.mj_header endRefreshing];
}
//是否接单中
-(void)isTakingOrder:(BOOL)isTakingOrder
{
    
}
//显示提示语
-(void)showToast:(NSString *)toast
{
    [self.view makeToast:toast];
}
//修改接单状态
-(void)changeSendTypeSuccess
{
    [self viewOrderTypeAppear:NO];
}
//修改接单状态成功
-(void)changeCanReceiveSuccess
{
    [self viewTakeOrderButtonAppear:!_presenter.canReceive];
}
//是否显示未接单页面
-(void)viewNoOrderAppear:(BOOL)appear
{
    [self noOrderAppear:appear];
}
#pragma mark -- UITableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = 191;
    return height;
}

- (QJOrderHomeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const cellID = @"QJOrderHomeCell";
    QJOrderHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"QJOrderHomeCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    QJBillListModel *model = [self.arrayData objectAtIndex:indexPath.row];
    [cell handleData:model indexPath:indexPath];
    return cell;
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QJBillListModel *model = [self.arrayData objectAtIndex:indexPath.row];
    QJWayBillDetailVC *vc = [[QJWayBillDetailVC alloc]init];
    vc.showCancelOrder = YES;
    vc.showUnnormalState = YES;
    vc.showPhoneIcon = YES;
    vc.isMyDetail = NO;
    vc.waybill_id = model.waybill_id;
    vc.waybill_no = model.waybil_no;
    vc.showBusinessPic = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self viewOrderTypeAppear:NO];
}

#pragma mark -- Request
-(void)doRequest
{
    [self.presenter fetchDataDriverInfo];
    [self.presenter beginReceive];
}

#pragma mark -- TouchBegan
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self viewOrderTypeAppear:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
