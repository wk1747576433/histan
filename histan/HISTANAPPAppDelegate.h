//
//  HISTANAPPAppDelegate.h
//  histan
//
//  Created by liu yonghua on 13-12-27.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "DeviceSenderBLL.h" //注册手机推送服务
#import "CommonHelper.h"
#import "DownloadDelegate.h"
#import "FileModel.h"
#import "DownloadCell.h"
#import "Harpy.h"
#import "HISTANDataBaseContext.h"

@class HISTANAPPViewController;

@interface HISTANAPPAppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate>
{

}
@property (strong, nonatomic) UIWindow *window;

//添加一些程序要用到的全局变量
@property (strong, nonatomic) NSString *SID;                            //所有API需要的key
@property (strong, nonatomic) NSString *PValue;                            //P值
@property (strong, nonatomic) NSString *UserName;                       //当前登陆用户名
@property (strong, nonatomic) NSArray *MenusArray;                      //菜单对象数组
@property (strong, nonatomic) NSArray *MyTaskArray_hand;                //我处理的任务列表
@property (strong, nonatomic) NSArray *MyTaskArray_submit;              //我提交的任务列表
@property (strong, nonatomic) NSMutableArray *MyTaskStatus;             //记录我的任务的状态

@property (strong, nonatomic) NSDictionary *DeptsDictionary;             //请求部门列表返回的数据（包括错误信息）
@property (strong, nonatomic) NSDictionary *ServicesDictionary;             //服务中心单记录

@property (strong, nonatomic) HISTANAPPViewController *viewController;

@property (strong, nonatomic) NSString *CurPageTitile;  //当前页面的标题
@property (strong, nonatomic) NSString *CurTaskTypeId;  //当前选择的任务类别ID
@property (strong, nonatomic) NSString *CurTaskId;  //当前选择的任务记录ID
@property (strong,nonatomic) NSString *WebSevicesURL; //服务器路径

@property (strong, nonatomic) NSMutableArray *IdealTaskEntrust; //我处理任务详情记录，供转交界面显示

//新建任务页的上传附件名称列表
@property (strong, nonatomic) NSMutableArray *upFileNameArray;

//公告列表页需要的公告类别id
@property (strong, nonatomic) NSString *publishTypeId;
//公告列表页面存储，供公告详情页显示的详细数据
@property (strong, nonatomic) NSMutableArray *noticeListArray;
//公告详情页所需的当前公告id
@property (strong ,nonatomic) NSString *infoId;


//我的绩效-月份绩效需要的月份和任务数量
@property (strong ,nonatomic) NSString *month;
@property (strong ,nonatomic) NSString *num_task;

//操作成功
@property (strong ,nonatomic) NSString *opeationSuccessNeedReloadPage;


//下载
@property(nonatomic,retain)NSMutableArray *finishedlist;//已下载完成的文件列表（文件对象）

@property(nonatomic,retain)NSMutableArray *downinglist;//正在下载的文件列表(ASIHttpRequest对象)

@property(nonatomic,retain)id<DownloadDelegate> downloadDelegate;

-(void)loadTempfiles;//将本地的未下载完成的临时文件加载到正在下载列表里,但是不接着开始下载
-(void)loadFinishedfiles;//将本地已经下载完成的文件加载到已下载列表里

//2.是否接着开始下载
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown;


//物流中心当前选择查看的单子对象
@property (strong, nonatomic) NSDictionary *boundList_curItemDic;
@property (strong, nonatomic) NSString *boundList_curDate;//当前选择的时间（详情页要显示的时间）
//物流中心当前加载的数据是哪种状态（未送货：1；已完成：2；失败：3）
@property (strong, nonatomic) NSString *curOutBoundStatus;

//记录服务中心的 预约上门时间
@property (strong, nonatomic) NSString *YYShangmenTime;

//当前模块下上传图片的最大尺寸和大小
@property (strong, nonatomic) NSString *upLoadImgMaxWidth;
@property (strong, nonatomic) NSString *upLoadImgMaxSize;
@end
