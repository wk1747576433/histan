//
//  SystemSetViewController.h
//  histan
//
//  Created by lyh on 1/5/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCacher.h"
#import "ABoutUsViewController.h"
#import "ChangPassWordViewController.h"
#import "GCDiscreetNotificationView.h"
#import "Harpy.h"
#import "LoginViewController.h"
#import "DownLoadsController.h"

@interface SystemSetViewController : UIViewController<UITableViewDelegate,UIActionSheetDelegate,UITableViewDataSource>
{
    UITableView *_tableview;
}
@end
