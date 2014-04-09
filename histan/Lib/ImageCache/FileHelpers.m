//
//  FileHelpers.m
//  AAPinChe
//
//  Created by Reese on 13-1-17.
//  Copyright (c) 2013年 Himalayas Technology&Science Company CO.,LTD-重庆喜玛拉雅科技有限公司. All rights reserved.
//

#import "FileHelpers.h"


NSString *pathInDocumentDirectory(NSString *fileName){
    
    //获取沙盒中的文档目录
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

//缓存目录地址
NSString *pathInCacheDirectory(NSString *fileName){
    //获取沙盒中缓存文件目录
    //////ZNV //histan_NSLog(@"pathInCacheDirectory:%@",fileName);
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory=[documentDirectories objectAtIndex:0];
    //NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    
    //将传入的文件名加在目录路径后面并返回
    return [cacheDirectory stringByAppendingPathComponent:fileName];
    //return @"";
}





//根据URL的hash码为图片文件命名
NSString *pathForURL(NSURL *aURL){
   
    //判断是否有该文件夹，没有则创建
    //初始化Documents路径
    NSString *Floderpath = [NSHomeDirectory() stringByAppendingPathComponent:@"com.xmly"];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断文件夹是否存在
    if (![fileManager fileExistsAtPath:Floderpath]) {
        //没有就创建该文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:pathInCacheDirectory(@"com.xmly") withIntermediateDirectories:YES attributes:nil error:nil]; 
    }
    return pathInCacheDirectory([NSString stringWithFormat:@"com.xmly/cachedImage-%u", [[aURL description] hash]]);
}


//判断是否已经缓存过这个URL
BOOL hasCachedImage(NSURL *aURL){
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
     
    if ([fileManager fileExistsAtPath:pathForURL(aURL)]) {
        return YES;
    }
    else return NO;
    
}

NSString *hashCodeForURL(NSURL *aURL)
{
    return [NSString stringWithFormat:@"%u",[[aURL description]hash]];
}




