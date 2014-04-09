//
//  DeviceSenderBLL.h
//  histan
//
//  Created by xiao wenping on 13-11-18.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import <Foundation/Foundation.h>
 

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface DeviceSenderBLL : NSObject
{
   ASIFormDataRequest *request;

}


-(void)sendDeviceToPushServer:(NSString*)Token;

@end
