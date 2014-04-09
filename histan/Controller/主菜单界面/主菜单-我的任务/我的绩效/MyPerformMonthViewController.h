//
//  MyPerformMonthViewController.h
//  histan
//
//  Created by lyh on 1/23/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HISTANAPPAppDelegate.h"
#import "HLSOFTNAVPOPVIEWController.h"
#import "MBProgressHUD.h"
#import "ASIHttpSoapPacking.h"
#import "ASIFormDataRequest.h"
#import "IDealTaskDetailsController.h"
#import "MJRefresh.h"


@interface MyPerformMonthViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tabelView;
    MBProgressHUD *HUD;
    
    //月绩效数组
    NSArray *perfromeMonth;
    
    //刷新插件
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    
    int _curPageCount; //当前页面页数
    int _allpage; //当前记录的页数
    
    //所有数据的集合
    NSMutableArray *_allDataArray;
    
}

@end
