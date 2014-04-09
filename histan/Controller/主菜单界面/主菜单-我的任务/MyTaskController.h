//
//  MyTaskController.h
//  histan
//
//  Created by liu yonghua on 13-12-30.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTasksController.h"
#import "IDealTaskController.h"
#import "ISubmitTaskController.h"
#import "MyPerformanceController.h"
//#import "MBProgressHUD.h"

@interface MyTaskController : UIViewController
{
    HISTANAPPAppDelegate *appDelegate;
    
    //ASIHTTPRequest *ASISOAPRequest;
    
     MBProgressHUD *HUD;
}

@property (retain, nonatomic) NewTasksController *theNewTaskVC;


- (IBAction)btnTaped:(id)sender;


@end
