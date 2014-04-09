//
//  LogisticsCenterViewController.h
//  histan
//
//  Created by lyh on 1/24/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLSOFTNAVPOPVIEWController.h"
#import "BoundListDetailsViewController.h"
#import "UIPopoverListView.h"
#import "HISTANAPPAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIHttpSoapPacking.h"
#import "MBProgressHUD.h"
#import "HLSOFTThread.h"
#import "MJRefresh.h"
#import "JSNotifier.h"
#import "WuLiuCell.h"
#import "UnderLineLabel.h"

@interface LogisticsCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIPopoverListViewDelegate,UIPopoverListViewDataSource,UIAlertViewDelegate>
{
     
    UITableView *_uiTableView;
    
    int _curPageCount; //当前页面页数
    int _allpage; //当前记录的页数
    
    MBProgressHUD *HUD;//HUD层
    
    UIButton *ALLButton_wsh;
    UIButton *ALLButton_ysh;
    UIButton *ALLButton_shsb;
    
    //刷新插件
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    
    BOOL IsSerch;//当前操作是否为 搜索
    BOOL IsFirstLoadOK;//第一次加载
    
    //日期选择器
    UIDatePicker *_datePicker;
    UIView *_maskView ;
    
    //当前选择日期
    NSDate *_selectDate;
    
    //表视图的数据源
    NSMutableArray *_allDataArray;
    
    //当前单子的状态
    NSString *_currentStatus;
    
    //从服务器获取的时间短数组
    NSMutableArray *timeArray;
    
    //时段弹出选择列表
    UIPopoverListView *popListView;
    
    //记录当前将要修改的送货单列表的cell
    WuLiuCell *currentCell;
    
    //记录被点击的时间选择按钮
    UIButton *_currentBtn;
    
    //保存当前被点击的电话号码
    NSString *thePhoneNum;
    
    //记录当前是为哪个单号预约上门时间
    NSString *_selectedTime;
    NSString *_currentDanhao;
}

@end
