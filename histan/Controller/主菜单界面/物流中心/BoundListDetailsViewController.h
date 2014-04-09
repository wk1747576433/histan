//
//  BoundListDetailsViewController.h
//  histan
//
//  Created by lyh on 1/26/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLSOFTNAVPOPVIEWController.h"
#import "HISTANAPPAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIHttpSoapPacking.h"
#import "MBProgressHUD.h"
#import "HLSOFTThread.h"
#import "WuLiuDetailsCell.h"
#import "UIPopoverListView.h"
#import "UnderLineLabel.h"
#import "HLSoftTools.h"

@interface BoundListDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPopoverListViewDataSource,UIPopoverListViewDelegate>
{
    ASIHTTPRequest *ASISOAPRequest; //网络访问对象
    
    UIScrollView *_scrollView;
    
    CGSize _scrollViewContentSize;
    UITableView *_uiTableView;
    
    MBProgressHUD *HUD;//HUD层
    NSMutableArray *_failedReasonArray;//失败原因
    NSDictionary *_allDataDic; //记录所有返回的数据
    NSMutableArray *_productListArry;//商品信息列表数组
    NSMutableArray *_resultArray; //最终数据集合
    
    UIPopoverListView *_popoerView;//显示失败原因列表
    
    //日期选择器
    UIDatePicker *_datePicker;
    UIView *_maskView ;
    
    //记录当前正被编辑的商品详细对象在_productListArry中对应的下标,方便“保存操作”获取参数
    int _curIndexInArray;
    
    //记录当前被点击的按钮对象，方便给它赋值
    UIButton *_curClickBtn;
    
    //记录保存操作成功了的商品对象在_productListArray中对应的下标，以便操作完成后删除对应对象重新加载界面
    NSMutableArray *_indexForObjArray;
    
    //保存当前被点击的电话号码
    NSString *_thePhoneNum;
    
    int IsEditClicknum;//

}

@end
