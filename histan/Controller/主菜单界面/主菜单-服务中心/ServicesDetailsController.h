//
//  ServicesDetailsController.h
//  histan
//
//  Created by lyh on 1/27/14.
//  Copyright (c) 2014 histan. All rights reserved.
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

#import "ServicesDetailsSubCell.h"
#import <QuartzCore/QuartzCore.h>

#import "ServicesDetailsController.h"
#import "UnderLineLabel.h"


@interface ServicesDetailsController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UIPopoverListViewDataSource,UIPopoverListViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UIPopoverListViewDelegate,UIPopoverListViewDataSource,UIAlertViewDelegate>
{
    ASIHTTPRequest *ASISOAPRequest ;
    
    MBProgressHUD *HUD;//HUD层
    
    NSMutableArray *_resultArray; //数据集合
    UITableView *_uiTableView;
    
     NSMutableArray *_servicesContentArray; //服务内容集合
    
    //弹出选择框
    UIPopoverListView *poplistview;
    
    //记录可以循环的 label 行数
    int _foreachLabelCount;
    
  
    HISTANAPPAppDelegate *appDelegate ;
    
   
    NSMutableArray *_failedReasonArray;//失败原因
    UIPopoverListView *_popoerView;//显示失败原因列表
    
    //日期选择器
    UIDatePicker *_datePicker;
    UIView *_maskView ;
    
    //记录当前正被编辑的商品详细对象在_productListArry中对应的下标,方便“保存操作”获取参数
    int _curIndexInArray;
    
    //记录当前被点击的按钮对象，方便给它赋值
    UIButton *_curClickBtn;
    
    int IsEditClicknum;//是否未修改点击的事件
    
    //保存当前被点击的电话号码
    NSString *_thePhoneNum;
    
}
@end
