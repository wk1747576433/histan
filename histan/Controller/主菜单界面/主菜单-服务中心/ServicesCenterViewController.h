//
//  ServicesCenterViewController.h
//  histan
//
//  Created by lyh on 1/26/14.
//  Copyright (c) 2014 histan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLSOFTNAVPOPVIEWController.h"
#import "HISTANAPPAppDelegate.h"
#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
#import "ASIHttpSoapPacking.h"
#import "ServicesListCell.h"
#import "MBProgressHUD.h"
#import "HLSOFTThread.h"
#import "MJRefresh.h"
#import "JSNotifier.h"
#import "GCDiscreetNotificationView.h"
#import "HLSoftTools.h"

#import "ServicesDetailsController.h"
#import "UnderLineLabel.h"

#import "UIPopoverListView.h"

@interface ServicesCenterViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIPopoverListViewDataSource,UIPopoverListViewDelegate>
{
    HISTANAPPAppDelegate *appDelegate ;
     
    UITableView *_uiTableView;
    
    NSArray *_allDataSource; //记录当前加载出来的所有记录
    // NSArray *_curLoadDataSource;  //记录本次加载的数据
    
    int _curPageCount; //当前页面页数
    int _allpage; //当前记录的页数
    
    MBProgressHUD *HUD;//HUD层
    JSNotifier *jsnotify;
    
    GCDiscreetNotificationView *gcdNotificationView;
    
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest;
    
    UIButton * ALLButton_1011 ;
    UIButton * ALLButton_1013 ;
    UIButton * ALLButton_1014 ;
    
    //刷新插件
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    
    
    BOOL IsHeader;//是否为顶部重新载入，否则需要累加 _curLoadDataSource
    NSMutableArray *_allDataSourceArray; //所有数据
    
    BOOL IsSerch;//当前操作是否为 搜索
    BOOL IsFirstLoadOK;//第一次加载
    
    NSString * _curSelectDate;//当前要显示日期的时间戳
    NSString *_status;
    
    //保存当前被点击的电话号码
    NSString *thePhoneNum;
    
    //日期选择器
    UIDatePicker *_datePicker;
    UIView *_maskView ;
    
    //时间段选择弹出框
    UIPopoverListView *_poplistview;
    
    //预约时间段数组
    NSMutableArray *Services_TimeArry;
    
    //当前点击的选择时间段按钮对象
    UIButton *_currentBtn;
    
    //当前选择的时间段
    NSString *_selectedTime;
    
    //当前编辑服务单对象的诉求id
    NSString *_currentReqid;
}

-(void)LoadDataSourceByReservetime:(NSString*)reservetime status:(NSString*)status page:(int)page pageSize:(int)pageSize IsShowHud:(BOOL)IsShowHud;

@end
