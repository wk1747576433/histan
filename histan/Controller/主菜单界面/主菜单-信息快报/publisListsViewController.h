//
//  publisListsViewController.h
//  histan
//
//  Created by lyh on 1/21/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HISTANAPPAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIHttpSoapPacking.h"
#import "publishDitealCell.h"
#import "publishDitealViewController.h"
#import "MBProgressHUD.h"

@interface publisListsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    HISTANAPPAppDelegate *appDelegate;
    ASIHTTPRequest *ASISOAPRequest;
    
    UITableView *_tableView;
    MBProgressHUD *HUD;
    NSString *_isRead;//当前点击的是否为已读
}

@end
