//
//  ISubmitTaskController.h
//  histan
//
//  Created by lyh on 1/9/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLSOFTNAVPOPVIEWController.h"
#import "HISTANAPPAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIHttpSoapPacking.h"
#import "IDealTaskTableViewCell.h"
#import "MBProgressHUD.h"
#import "IDealTaskDetailsController.h"
#import "HLSOFTThread.h"
#import "MJRefresh.h"

@interface ISubmitTaskController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UISearchBar *_uiSearchBar;
    UITableView *_uiTableView;
    
    NSArray *_allDataSource; //记录当前加载出来的所有记录
    NSArray *_curLoadDataSource;  //记录本次加载的数据
    
    int _curPageCount; //当前页面页数
    
    MBProgressHUD *HUD;//HUD层
    
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest; 
    
    UIButton * ALLButton_1011 ;
    UIButton * ALLButton_1013 ;
    UIButton * ALLButton_1014 ;
    
    //刷新插件
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    

    
}

-(void)LoadDataSourceByTaskTypeId:(NSString*)TaskTypeId pageCount:(int)pageCount pageSize:(int)pageSize taskname:(NSString*)taskname taskdesc:(NSString*)taskdesc IsShowHud:(BOOL)IsShowHud;

@end
