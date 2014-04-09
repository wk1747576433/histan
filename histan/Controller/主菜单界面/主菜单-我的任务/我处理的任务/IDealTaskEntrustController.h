//
//  IDealTaskEntrustController.h
//  histan
//
//  Created by liu yonghua on 14-1-17.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HISTANAPPAppDelegate.h"
#import "HLSOFTNAVPOPVIEWController.h"
#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
#import "ASIHttpSoapPacking.h"
#import "MBProgressHUD.h"

#import "HLSoftTools.h"
#import <QuartzCore/QuartzCore.h>

#import "UIPopoverListView.h"
#import "IDealTaskEntrustController.h"
#import "IDealTaskController.h"
 
@interface IDealTaskEntrustController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPopoverListViewDataSource,UIPopoverListViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    ASIHTTPRequest *ASISOAPRequest ;
    
    MBProgressHUD *HUD;//HUD层
     
    NSMutableArray *_resultArray;
    UITableView *_uiTableView;
    
    //弹出选择框
    UIPopoverListView *poplistview;
    
    //记录可以循环的 label 行数
    int _foreachLabelCount;
    
    //处理人列表
    NSArray *allHanderArray;
     
    NSString *deptID; //部门ID
    NSString *_typeid;//项目Id
    NSString *_area; //地区
    
    //记录当前选择的技术类别Id
    NSString *_curSelectHander;
    
    HISTANAPPAppDelegate *appDelegate ;
    
    int action_edit; //1可修改 0不可修改
    int action_solve; //1可解决 0不可解决
    int action_commenmt; //1可评价 0不可评价
    int action_entrust; //1可转交 0不可转交
    int action_delete; //1可删除 0不可删除
    
    NSString *_thePhoneNum;
}

-(void)LoadHandPeoples;

@end
