//
//  ISubmitTaskDetailsController.h
//  histan
//
//  Created by liu yonghua on 14-1-18.
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
#import "ALToastView.h"
#import "PublicDownLoadsBLL.h"

@interface ISubmitTaskDetailsController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPopoverListViewDataSource,UIPopoverListViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIDocumentInteractionControllerDelegate,DownloadDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate>
{
    MBProgressHUD *HUD;//HUD层
    
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest;
    
    NSMutableArray *_resultArray;
    UITableView *_uiTableView;
    
    NSDictionary *info; //info 详情数据
    
    //弹出选择框
    UIPopoverListView *poplistview;
    
    //记录可以循环的 label 行数
    int _foreachLabelCount;
    
    //当前详情页现实任务类别（0：未处理 1：未评价 2：已评价）
    int _curTaskTypeId;
    
    //UIButton *
    //记录对应部门下的任务类型值
    NSArray *typeArray;
    //记录字典中的键（key），也就是任务的id
    NSArray *typeKeys;
    //记录所有任务类型数据
    NSDictionary *allTypeDic;
    
    NSString *deptID; //部门ID
    NSString *_typeid;//项目Id
    
    //记录当前选择的技术类别Id 和 名称
    NSString *_curSelectSkillTypeName;
    
    HISTANAPPAppDelegate *appDelegate ;
    
    int action_edit; //1可修改 0不可修改
    int action_solve; //1可解决 0不可解决
    int action_commenmt; //1可评价 0不可评价
    int action_entrust; //1可转交 0不可转交
    int action_delete; //1可删除 0不可删除
    int comm_way; //评价方式1：四选一评价方式,评价方式2：多选评价方式
    
    NSString *curSelectPingFengShuStr;//当前选择的评分数 ，四选一的情况下
    
    NSArray *PingOptionsArray;//评价集合数据
    
    UIDatePicker *_datePicker;//时间选择器
    UIView *_maskView ;
    
    NSMutableArray *Public_hub; //记录附件列表
    NSString *_thePhoneNum;
    
    BOOL *isSaveImage;
    
    //当前可编辑状态下所选择要删除的附件fid
    NSString *deleteFileFid;
}

@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

-(void)LoadTaskDetailsByTaskId_IsShowHud:(BOOL)IsShowHud;
-(void)StartDownLoadHub:(UIButton*)sender;

@end
