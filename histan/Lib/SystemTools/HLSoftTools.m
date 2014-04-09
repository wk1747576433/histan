//
//  HLSoftTools.m
//  histan
//
//  Created by liu yonghua on 14-1-13.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import "HLSoftTools.h"

@implementation HLSoftTools

+(NSString*)GetDataTimeStrByIntDate:(NSString *)IntDate DateFormat:(NSString*)DateFormat{
    @try {
        
        
        if([IntDate isEqualToString:@""] || IntDate == nil){
            return @"无";
        }
        //时间戳转换
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setTimeZone:timeZone];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:DateFormat];
        int val=[IntDate intValue];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:val];
        return [formatter stringFromDate:confromTimesp];
        
    }
    @catch (NSException *exception) {
        return @"无";
    }
    @finally {
         
    }
    
    
}

+(NSString*)GetdateTimeLong:(NSString *)Date{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* retdate = [formatter dateFromString:Date]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[retdate timeIntervalSince1970]];
    return timeSp;
}

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

@end
