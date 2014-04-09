//
//  MyPerformanceController.h
//  histan
//
//  Created by liu yonghua on 14-1-11.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HISTANAPPAppDelegate.h"
#import "HLSOFTNAVPOPVIEWController.h"
#import "ASIHttpSoapPacking.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "UIPopoverListView.h"
#import "MyPerformMonthViewController.h"



@interface MyPerformanceController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPopoverListViewDataSource,UIPopoverListViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tabelView;
    
    //当前选择年份
    NSString *selectYear;
    
    //年份数组
    NSMutableArray *yearsArray;
    
    MBProgressHUD *HUD;
    
    //绩效数组
    NSMutableArray *performanceArray;
    
    //弹出选择框
    UIPopoverListView *poplistview;
    
    
    
    
}

@end
