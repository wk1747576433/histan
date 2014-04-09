//
//  DownLoadsController.h
//  ZNVAPP
//
//  Created by xiao wenping on 13-10-22.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ImageCacher.h"
#import "DownLoadsCell.h"
#import "DownloadCell.h"
#import "PublicDownLoadsBLL.h"
//#import "ALToastView.h"
#import "HISTANAPPAppDelegate.h"
#import "KOAProgressBar.h"
#import "DownloadDelegate.h"
#import "GCDiscreetNotificationView.h"

@interface DownLoadsController : UIViewController< UIDocumentInteractionControllerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DownloadDelegate,UIActionSheetDelegate>
{
    HISTANAPPAppDelegate *appDelegate ;
     
   // UIButton *leftbackbutton;//返回按钮
    UIBarButtonItem *rightbutton_backindex;
    
    UISearchBar *_uiSearchBar;
    UITableView *_uiTableView_DownLoading;
    UITableView *_uiTableView_DownLoadFinished;
    
    //记录该页面的数据集合，用于查找
    NSMutableArray *_allDataSourceArray_ding; //所有数据
    NSMutableArray *_allDataSourceArray_ed; //所有数据
    NSMutableArray *_searchResultSourceArray;//查询的结果集合
     
    NSArray *pathUrlAry;
    
    NSMutableArray *downLoadFlagAry;
    
    NSMutableArray *downLoadList_CompleteFalse;
    NSMutableArray *downLoadList_CompleteTrue;
    
    int CurShowTabId; //当前现实的选项卡， 0：正在下载，1：已下载
    int CurSeleteRowId;//当前选择的行。
    
    NSString *WebProductImageURL;
    
    int CurClickBtnTag;//当前点击的按钮
    
    NSMutableArray *downingList;
    NSMutableArray *finishedList;
    
     
    
}

@property(nonatomic,assign)NSMutableArray *dirArray;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

@property(nonatomic,retain)NSMutableArray *downingList;
@property(nonatomic,retain)NSMutableArray *finishedList;

//获取2位小数点
-(NSString *)notRounding:(float)floatNumber afterPoint:(int)position;

-(void)showFinished;//查看已下载完成的文件视图
-(void)showDowning;//查看正在下载的文件视图
-(void)startFlipAnimation:(NSInteger)type;//播放旋转动画,0从右向左，1从左向右
-(void)updateCellOnMainThread:(FileModel *)fileInfo;//更新主界面的进度条和信息
@end
