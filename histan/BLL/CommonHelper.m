//
//  CommonHelper.m
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "CommonHelper.h"


@implementation CommonHelper

//+(NSString *)transformToM:(NSString *)size
//{
//    float oldSize=[size floatValue];
//    float newSize=oldSize/1024.0f;
//    newSize=newSize/1024.0f;
//    return [NSString stringWithFormat:@"%f",newSize];
//}
//
//+(float)transformToBytes:(NSString *)size
//{
//    float totalSize=[size floatValue];
////    ////ZNV //histan_NSLog(@"文件总大小跟踪：%f",totalSize);
//    return totalSize*1024*1024;
//}

+(NSString *)getFileSizeString:(NSString *)size
{
    //这个方法貌似有问题...返回的数据大小都是以B为单位，而且很小（比如0.35B）
    //2014-04-12日修改了下，虽然显示的时候显示比较正常了...但是这里的原因不是很清楚！
    @try {

        NSString *retStr=@"";
        NSString *curSize=@"";
        
        if ([size floatValue]<1024) {
            curSize=[self notRounding:[size floatValue] afterPoint:2];
            retStr= [NSString stringWithFormat:@"%@K",curSize];
        }
        if ([size floatValue]>=1024 && [size floatValue]<1024*1024) {
            curSize = [self notRounding:[size floatValue]/1024 afterPoint:2];
            retStr= [NSString stringWithFormat:@"%@M",curSize];
        }
        if ([size floatValue]>=1024*1024) {
            curSize=[self notRounding:[size floatValue]/1024/1024 afterPoint:2];
            retStr= [NSString stringWithFormat:@"%@",curSize];
        }
        
        //histan_NSLog(@"aaaaaaaaa:%@",retStr);
        return retStr;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return @"0k";
    
}

+(float)getFileSizeNumber:(NSString *)size
{
    @try {
        
        
        NSInteger indexM=[size rangeOfString:@"M"].location;
        NSInteger indexK=[size rangeOfString:@"K"].location;
        NSInteger indexB=[size rangeOfString:@"B"].location;
        
        float retSize;
        if(indexM<1000)//是M单位的字符串
        {
            retSize= [[size substringToIndex:indexM] floatValue]*1024*1024;
        }
        else if(indexK<1000)//是K单位的字符串
        {
            retSize= [[size substringToIndex:indexK] floatValue]*1024;
        }
        else if(indexB<1000)//是B单位的字符串
        {
            retSize= [[size substringToIndex:indexB] floatValue];
        }
        else//没有任何单位的数字字符串
        {
            retSize= [size floatValue];
        }
        
        return retSize;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return 0.0;
}

+(NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

//下载文件目录
+(NSString *)getAboutUsFloderPath
{
    //判断是否有该文件夹，没有则创建
    //初始化AboutUs路径
    NSString *Floderpath = [[self getDocumentPath] stringByAppendingPathComponent:@"AboutUs"];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断文件夹是否存在
    if (![fileManager fileExistsAtPath:Floderpath]) {
        //没有就创建该文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:Floderpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    return Floderpath;
}

//下载文件目录
+(NSString *)getTargetFloderPath
{
    //判断是否有该文件夹，没有则创建
    //初始化Documents路径
    NSString *Floderpath = [[self getDocumentPath] stringByAppendingPathComponent:@"DownLoadFiles"];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断文件夹是否存在
    if (![fileManager fileExistsAtPath:Floderpath]) {
        //没有就创建该文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:Floderpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    return Floderpath;
}

//临时下载文件目录
+(NSString *)getTempFolderPath
{
    //判断是否有该文件夹，没有则创建
    //初始化Documents路径
    NSString *Floderpath = [[self getDocumentPath]stringByAppendingPathComponent:@"Temp"];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断文件夹是否存在
    if (![fileManager fileExistsAtPath:Floderpath]) {
        //没有就创建该文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:Floderpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return Floderpath;
}

+(BOOL)isExistFile:(NSString *)fileName
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+(float)getProgress:(float)totalSize currentSize:(float)currentSize
{
    
    float retss=currentSize/totalSize;
    //////ZNV //histan_NSLog(@"totalSize:%f,currentSize:%f,retss:%f",totalSize,currentSize,retss);
    //  retss=[self notRounding:retss afterPoint:2];
    return retss;
    
}


+(NSString*)notRounding:(float)floatNumber afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:floatNumber];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    [ouncesDecimal release];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


@end
