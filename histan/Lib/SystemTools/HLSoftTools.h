//
//  HLSoftTools.h
//  histan
//
//  Created by liu yonghua on 14-1-13.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSoftTools : NSObject
{
    
}

//IntDate :时间戳
//DateFormat:需要返回的时间格式（YY-MM-dd）
+(NSString*)GetDataTimeStrByIntDate:(NSString*)IntDate DateFormat:(NSString*)DateFormat;
 
+(NSString*)GetdateTimeLong:(NSString *)Date;

+(NSDate*) convertDateFromString:(NSString*)uiDate;

@end
