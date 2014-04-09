//
//  HISTANDataBaseContext.h
//  histan
//
//  Created by lyh on 1/25/14.
//  Copyright (c) 2014 histan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "FileModel.h"

@interface HISTANDataBaseContext : NSObject
{
    NSConditionLock *databaseLock;//锁
}

//初始化数据库
-(sqlite3*)InitDataBase;
 
//初始化 下载   表：Downloads
-(BOOL)InitTable_Downloads;

//插入一条正在下载的记录
-(NSString*)Insert_DownloadsByFileId:(NSString*)fileId FileName:(NSString*)fileName FileSize:(NSString*)fileSize fileImages:(NSString*)fileImages fileURL:(NSString*)fileURL fileTitle:(NSString*)fileTitle;

//删除一条正在下载的记录
-(BOOL)Delete_DownloadsByFileId:(NSString*)fileId;

//判断当前文件id是否存在
-(BOOL)Check_DownloadsIsHave:(NSString*)fileId;

//得到所有记录
-(NSMutableArray*)Get_DownLoadsArray;


//用户信息
//初始化 用户信息  表：UserInfos
-(BOOL)InitTable_UserInfos;

//得到所有登陆过的用户名集合
-(NSMutableArray*)Get_AllUserInfs;

//插入或者更新一条记录
-(BOOL)InsertOrUpdate_UserInfoByUserName:(NSString *)UserName PassWord:(NSString *)PassWord IsRemindPassWord:(NSString *)IsRemindPassWord;

//删除一条用户记录
-(BOOL)Delete_UserInfoByUserName:(NSString *)UserName;

//获取最后一次登陆的用户名
-(NSString*)Get_LastLoginUserName;

//重新设置最后一次登陆的用户名
-(BOOL)ReSet_LastLoginUserName:(NSString*)UserName;


//获取最后一次使用的服务器名
-(NSString*)Get_LastLoginServiceUrl;

//重新设置最后使用的服务器名
-(BOOL)ReSet_LastLoginServiceUrl:(NSString*)ServiceUrl;



-(BOOL)DeleteAll;


@end
