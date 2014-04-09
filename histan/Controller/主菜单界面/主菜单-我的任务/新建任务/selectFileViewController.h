//
//  selectFileViewController.h
//  histan
//
//  Created by lyh on 1/12/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "HISTANAPPAppDelegate.h"
#import "MBProgressHUD.h"

@interface selectFileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate,UIWebViewDelegate,UIImagePickerControllerDelegate>
{
    UIWebView *showView; //用作缩略图
    
    //信息栏
    UILabel *fileNameLabel;
    UILabel *fileSizeLabel;
    
    UITableView *readTable; //文件列表
    
    //传值代理
    HISTANAPPAppDelegate *appDelegate;
}

@property (assign, nonatomic) UIWebView *showView;
@property (assign, nonatomic) UILabel *fileNameLabel;
@property (assign, nonatomic) UILabel *fileSizeLabel;
@property (assign, nonatomic)  UITableView *readTable; 

@end
