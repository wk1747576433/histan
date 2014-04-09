//
//  IDealTaskDetailsController.h
//  histan
//
//  Created by liu yonghua on 14-1-10.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HISTANAPPAppDelegate.h"
#import "HLSOFTNAVPOPVIEWController.h"
#import "ASIHTTPRequest.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ASIHttpSoapPacking.h"
#import "MBProgressHUD.h"

#import "HLSoftTools.h"
#import <QuartzCore/QuartzCore.h>

#import "UIPopoverListView.h"
#import "IDealTaskEntrustController.h"
#import "selectFileViewController.h"
#import "ALToastView.h"
#import "PublicDownLoadsBLL.h"
#import "GTMBase64.h"

@interface IDealTaskDetailsController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPopoverListViewDataSource,UIPopoverListViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentInteractionControllerDelegate,DownloadDelegate,UIAlertViewDelegate>
{
    
    int IsLoadOver;//是否加载完成。
    float TaskDescCellHeight;//记录任务描述的初始高度
    
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
   // NSString *_curSolutionInputStr;//记录输入的解决方案
    
    HISTANAPPAppDelegate *appDelegate ;
    
    int action_edit; //1可修改 0不可修改
    int action_solve; //1可解决 0不可解决
    int action_commenmt; //1可评价 0不可评价
    int action_entrust; //1可转交 0不可转交
    int action_delete; //1可删除 0不可删除
    
    NSArray *Public_hub; //记录附件列表
    NSString *_thePhoneNum;
}

//@property (nonatomic,retain) IBOutlet UILabel *TaskTypeName;
//@property (nonatomic,retain) IBOutlet UILabel *TaskName;
//@property (nonatomic,retain) IBOutlet UILabel *TaskTDeptName;
//@property (nonatomic,retain) IBOutlet UILabel *TaskSubmiter;
//@property (nonatomic,retain) IBOutlet UILabel *TaskSubmitTime;
//@property (nonatomic,retain) IBOutlet UILabel *TaskHopeCompleteTime;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@property (nonatomic, copy) NSString *curSolutionInputStr;



-(void)LoadTaskDetailsByTaskId_IsShowHud:(BOOL)IsShowHud;
-(void)StartDownLoadHub:(UIButton*)sender;
@end
