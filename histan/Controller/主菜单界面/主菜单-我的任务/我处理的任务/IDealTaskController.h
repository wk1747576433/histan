//
//  IDealTaskController.h
//  histan
//
//  Created by lyh on 1/9/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLSOFTNAVPOPVIEWController.h"
#import "HISTANAPPAppDelegate.h"
#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
#import "ASIHttpSoapPacking.h"
#import "IDealTaskTableViewCell.h"
#import "MBProgressHUD.h"
#import "IDealTaskDetailsController.h"
#import "HLSOFTThread.h"
#import "MJRefresh.h"
#import "JSNotifier.h"
#import "ISubmitTaskDetailsController.h"
#import "GCDiscreetNotificationView.h"

@interface IDealTaskController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    HISTANAPPAppDelegate *appDelegate ;
    
    UISearchBar *_uiSearchBar;
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
    
    BOOL IsIdealTask;//当前是显示我处理的任务吗？
}

-(void)LoadDataSourceByTaskTypeId:(NSString*)TaskTypeId pageCount:(int)pageCount pageSize:(int)pageSize taskname:(NSString*)taskname taskdesc:(NSString*)taskdesc taskid:(NSString*)taskid IsShowHud:(BOOL)IsShowHud;

@end
