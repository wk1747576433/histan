//
//  HLSOFTThread.h
//  histan
//
//  Created by liu yonghua on 14-1-11.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HISTANAPPAppDelegate.h"
#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
#import "ASIHttpSoapPacking.h"
#import "JSBadgeView.h"

@interface HLSOFTThread : NSObject

+(HLSOFTThread*)defaultCacher;
-(void)LoadHnadOrSubmitStatistics:(NSDictionary*)aDic;

-(void)LoadIDealTaskCountShowBadge:(NSDictionary*)aDic;

//加载未读信息快报
-(void)LoadNoticeReadCountShowBadge:(NSDictionary *)aDic;

@end
