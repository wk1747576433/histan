//
//  publishDitealViewController.h
//  histan
//
//  Created by lyh on 1/21/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HISTANAPPAppDelegate.h"
#import "HLSOFTNAVPOPVIEWController.h"
#import <QuartzCore/QuartzCore.h>
#import <QuickLook/QuickLook.h> 

@interface publishDitealViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIDocumentInteractionControllerDelegate,DownloadDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
    NSString *noticesName;
    NSString *publishDept;
    NSString *publisher;
    NSString *publishTime;
    NSString *approveMan;
    NSString *content;
    NSMutableArray *appendArray;
    NSMutableArray *downloadArray;
    //显示详情内容
   UITableView *_uiTableView;
    
    NSURL *local_file_URL;
}
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

@end
