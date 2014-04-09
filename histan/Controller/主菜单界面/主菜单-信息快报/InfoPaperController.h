//
//  InfoPaperController.h
//  histan
//
//  Created by liu yonghua on 13-12-30.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HISTANAPPAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIHttpSoapPacking.h"
#import "publisListsViewController.h"
#import "MBProgressHUD.h"
#import <CoreText/CoreText.h>
@interface InfoPaperController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_typeTableView;
    
    HISTANAPPAppDelegate *appDelegate;
    
    ASIHTTPRequest *ASISOAPRequest;
    
    MBProgressHUD *HUD;
}
@property (strong,nonatomic) NSDictionary *typeDic;             //公告类型数据
@property (strong,nonatomic) NSMutableArray *typeIdArray;       //公告类型id数据
@property (strong,nonatomic) NSMutableArray *typeNameArray;     //公告类型名称
@property (strong,nonatomic) NSMutableArray *totalArray;        //统计公告数据
@end
