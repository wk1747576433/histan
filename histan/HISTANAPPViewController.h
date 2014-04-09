//
//  HISTANAPPViewController.h
//  histan
//
//  Created by liu yonghua on 13-12-27.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTaskController.h"
#import "MyBusinessController.h"
#import "InfoPaperController.h"
#import "ImageCacher.h"
#import "SVWebViewController.h"
#import "LoginViewController.h"
#import "HISTANAPPAppDelegate.h"
#import "ABoutUsViewController.h"
#import "SystemSetViewController.h"
#import "HLSOFTThread.h"
#import "ServicesCenterViewController.h"
#import "LogisticsCenterViewController.h"

@interface HISTANAPPViewController : UIViewController<UIAlertViewDelegate>
{
    UIScrollView *menusScrollView;
    GCDiscreetNotificationView *gcdNotifiView;
    
    BOOL IsLoadFailed;//是否加载菜单失败。
  
}

//当前主菜单所关联的（需要push进来的每个菜单所对应的controller）
@property (strong, nonatomic) UIViewController *subViewControlls;


@end
