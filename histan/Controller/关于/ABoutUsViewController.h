//
//  ABoutUsViewController.h
//  histan
//
//  Created by lyh on 1/5/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemSetViewController.h"
#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
#import "ASIHttpSoapPacking.h"
#import "GCDiscreetNotificationView.h"
#import "HISTANAPPAppDelegate.h"
#import "HLSOFTNAVPOPVIEWController.h"
#import "MBProgressHUD.h"
@interface ABoutUsViewController : UIViewController
{
    UIScrollView *_scrollView;
    UITextView *_textView;
    
    ASIHTTPRequest *ASISOAPRequest;
    HISTANAPPAppDelegate *appDelegate;
    MBProgressHUD *HUD;
}
@end

