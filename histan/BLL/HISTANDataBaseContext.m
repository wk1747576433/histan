//
//  HISTANDataBaseContext.m
//  histan
//
//  Created by lyh on 1/25/14.
//  Copyright (c) 2014 histan. All rights reserved.
//

#import "HISTANDataBaseContext.h"

@implementation HISTANDataBaseContext


-(sqlite3*)InitDataBase{
    
    if(!databaseLock){
        databaseLock=[[NSConditionLock alloc]init];
    }
    
    //初始化数据库对象
    sqlite3 *db;
    
    //插入数据到数据库
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents=[paths objectAtIndex:0];
    NSString *dataBase_path=[documents stringByAppendingPathComponent:@"HISTANData.sqlite"];
    
    if(sqlite3_open([dataBase_path UTF8String], &db) != SQLITE_OK){
        sqlite3_close(db);
        ////ZNV //histan_NSLog(@"数据库打开失败！");
    }else{
        ////ZNV //histan_NSLog(@"数据库打开成功！");
    }
    
    return db;
    
}




-(BOOL)InitTable_Downloads{
    
    char *errorMsg;
    const char *createSql="create table if not exists DownLoads(id integer primary key autoincrement,fileID text,fileName text,fileSize text,fileImages text,fileURL text,fileTitle text,IsDownLoad text)";
    
    if(sqlite3_exec([self InitDataBase], createSql, NULL, NULL, &errorMsg)==SQLITE_OK){
        return YES;
    }else{
        //ZNV //histan_NSLog(@"%@",[NSString stringWithUTF8String: errorMsg]);
    }
    
    return  NO;
}

-(NSString*)Insert_DownloadsByFileId:(NSString *)fileId FileName:(NSString *)fileName FileSize:(NSString *)fileSize fileImages:(NSString *)fileImages fileURL:(NSString *)fileURL fileTitle:(NSString *)fileTitle{
    
    //[databaseLock lock];
    @try {
        
        
        if([self InitDataBase]!=nil){
            if([self InitTable_Downloads]){
                
                //先判断是否已经存在于数据库
                NSString *selectSql_exist=[NSString stringWithFormat:@"select * from DownLoads where fileID='%@' ",fileId];
                sqlite3_stmt *statement;
                if(sqlite3_prepare_v2([self InitDataBase], [selectSql_exist UTF8String], -1, &statement, nil)==SQLITE_OK){
                    //查询成功
                }
                
                if(sqlite3_step(statement)==SQLITE_ROW){
                    //histan_NSLog(@"已存在于数据库");
                    sqlite3_finalize(statement);
                    return @"EXIST";
                }
                
                char *errorMsg22;
                //fileID text
                //fileName text
                //fileSize text
                //fileImages text
                //fileURL text
                //fileTitle text
                //IsDownLoad text
                NSString *insertSql=[NSString stringWithFormat:@"insert into DownLoads(fileID,fileName,fileSize,fileImages,fileURL,fileTitle,IsDownLoad) values('%@','%@','%@','%@','%@','%@','%@')",fileId,fileName,fileSize,fileImages,fileURL,fileTitle,@"0"];
                //histan_NSLog(@"insertSql:%@",insertSql);
                
                if(sqlite3_exec([self InitDataBase], [insertSql UTF8String], NULL, NULL, &errorMsg22)==SQLITE_OK){
                    
                    return @"OK";
                    
                }else{
                    NSString *ss=[NSString stringWithUTF8String:errorMsg22];
                    //histan_NSLog(@"error:%@",ss);
                    return ss;
                }
                
            }
            
        }
        
    }
    @catch (NSException *exception) {
        //histan_NSLog(@"NSException:%@",[exception debugDescription]);
    }
    @finally {
        // [databaseLock unlock];
    }
    //判断是否已经存在于数据库
    return NO;
}

-(BOOL)Delete_DownloadsByFileId:(NSString *)fileId{
    
    //[databaseLock lock];
    @try {
        
        if([self InitDataBase]!=nil){
            
            char *errorMsg;
            NSString *deleteSql=[NSString stringWithFormat:@"Delete From DownLoads  where fileID='%@'",fileId];
            
            if(sqlite3_exec([self InitDataBase], [deleteSql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK){
                
                return YES;
                
            }else{
                NSString *ss=[NSString stringWithUTF8String:errorMsg];
                //histan_NSLog(@"error:%@",ss);
                return NO;
            }
            
        }
        
    }
    @catch (NSException *exception) {
        //histan_NSLog(@"NSException:%@",[exception debugDescription]);
    }
    @finally {
        //   [databaseLock unlock];
    }
    
    return NO;
    
}

//返回收藏记录
-(NSMutableArray*)Get_DownLoadsArray{
    
    NSMutableArray *retArray=[[NSMutableArray alloc]init];
    
    if([self InitDataBase]!=nil){
        
        //[databaseLock lock];
        const char*selectSql="select * from DownLoads";
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2([self InitDataBase], selectSql, -1, &statement, nil)==SQLITE_OK){
            ////ZNV //histan_NSLog(@"查询到了数据了。。");
            
        }
        
        //fileID text
        //fileName text
        //fileSize text
        //fileImages text
        //fileURL text
        //fileTitle text
        //IsDownLoad text
        while (sqlite3_step(statement)==SQLITE_ROW) {
            //int _id=sqlite3_column_int(statement, 0);
            char *fileID=(char*)sqlite3_column_text(statement, 1);
            char *fileName=(char*)sqlite3_column_text(statement, 2);
            char *fileSize=(char*)sqlite3_column_text(statement, 3);
            char *fileImages=(char*)sqlite3_column_text(statement, 4);
            char *fileURL=(char*)sqlite3_column_text(statement,5);
            char *fileTitle=(char*)sqlite3_column_text(statement,6);
            char *IsDownLoad=(char*)sqlite3_column_text(statement,7);
            
            
            FileModel *fileModel=[[FileModel alloc]init];
            fileModel.fileID=[NSString stringWithUTF8String:fileID];
            fileModel.fileName=[NSString stringWithUTF8String:fileName];
            fileModel.fileSize=[NSString stringWithUTF8String:fileSize];
            fileModel.fileImages=[NSString stringWithUTF8String:fileImages];
            fileModel.fileURL=[NSString stringWithUTF8String:fileURL];
            fileModel.fileTitle=[NSString stringWithUTF8String:fileTitle];
            fileModel.IsDownLoad=[NSString stringWithUTF8String:IsDownLoad];
            
            [retArray addObject:fileModel];
            [fileModel release];
        }
        
        // [databaseLock unlock];
    }
    
    
    return retArray;
}

-(BOOL)Check_DownloadsIsHave:(NSString *)fileId{
    if([self InitDataBase]!=nil){
        if([self InitTable_Downloads]){
            
            //先判断是否已经存在于数据库
            NSString *selectSql_exist=[NSString stringWithFormat:@"select * from DownLoads where fileID='%@' ",fileId];
            sqlite3_stmt *statement;
            if(sqlite3_prepare_v2([self InitDataBase], [selectSql_exist UTF8String], -1, &statement, nil)==SQLITE_OK){
                //查询成功
            }
            
            if(sqlite3_step(statement)==SQLITE_ROW){
                //histan_NSLog(@"已存在于数据库");
                sqlite3_finalize(statement);
                return YES;
            }
        }
    }
    return NO;
}


-(BOOL)DeleteAll{
    
    
    if([self InitDataBase]!=nil){
        
        char *errorMsg;
        NSString *deleteSql=[NSString stringWithFormat:@"Delete From DownLoads"];
        
        if(sqlite3_exec([self InitDataBase], [deleteSql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK){
            
            return YES;
            
        }else{
            NSString *ss=[NSString stringWithUTF8String:errorMsg];
            //histan_NSLog(@"error:%@",ss);
            return NO;
        }
        
    }
    return NO;

}



-(BOOL)InitTable_UserInfos{
    
    char *errorMsg;
    const char *createSql="create table if not exists UserInfos(id integer primary key autoincrement,UserName text,PassWord text,IsRemindPassWord text)";
    
    if(sqlite3_exec([self InitDataBase], createSql, NULL, NULL, &errorMsg)==SQLITE_OK){
        return YES;
    }else{
        //ZNV //histan_NSLog(@"%@",[NSString stringWithUTF8String: errorMsg]);
    }
    
    return  NO;
}

-(BOOL)InsertOrUpdate_UserInfoByUserName:(NSString *)UserName PassWord:(NSString *)PassWord IsRemindPassWord:(NSString *)IsRemindPassWord{
    
    //[databaseLock lock];
    @try {
        
        
        if([self InitDataBase]!=nil){
            if([self InitTable_UserInfos]){
                
                //先判断是否已经存在于数据库
                NSString *selectSql_exist=[NSString stringWithFormat:@"select * from UserInfos where UserName='%@' ",UserName];
                sqlite3_stmt *statement;
                if(sqlite3_prepare_v2([self InitDataBase], [selectSql_exist UTF8String], -1, &statement, nil)==SQLITE_OK){
                    //查询成功
                }
                
                if(sqlite3_step(statement)==SQLITE_ROW){
                    //histan_NSLog(@"已存在于数据库，则更新用户信息");
                    sqlite3_finalize(statement);
                    
                    char *errorMsg22;
                    //UserName text,PassWord text,IsRemindPassWord text
                    NSString *insertSql=[NSString stringWithFormat:@"update UserInfos set PassWord='%@',IsRemindPassWord='%@' where UserName='%@'",PassWord,IsRemindPassWord,UserName];
                    //histan_NSLog(@"insertSql:%@",insertSql);
                    if(sqlite3_exec([self InitDataBase], [insertSql UTF8String], NULL, NULL, &errorMsg22)==SQLITE_OK){
                        
                        return @"OK";
                        
                    }else{
                        NSString *ss=[NSString stringWithUTF8String:errorMsg22];
                        //histan_NSLog(@"error:%@",ss);
                        return ss;
                    }
                    
                    
                    
                     
                }else{
                
                char *errorMsg22;
               //UserName text,PassWord text,IsRemindPassWord text
                NSString *insertSql=[NSString stringWithFormat:@"insert into UserInfos(UserName,PassWord,IsRemindPassWord) values('%@','%@','%@')",UserName,PassWord,IsRemindPassWord];
                //histan_NSLog(@"insertSql:%@",insertSql);
                
                if(sqlite3_exec([self InitDataBase], [insertSql UTF8String], NULL, NULL, &errorMsg22)==SQLITE_OK){
                    
                    return @"OK";
                    
                }else{
                    NSString *ss=[NSString stringWithUTF8String:errorMsg22];
                    //histan_NSLog(@"error:%@",ss);
                    return ss;
                }
                    
                }
                
            }
            
        }
        
    }
    @catch (NSException *exception) {
        //histan_NSLog(@"NSException:%@",[exception debugDescription]);
    }
    @finally {
        // [databaseLock unlock];
    }
    //判断是否已经存在于数据库
    return NO;
}

-(BOOL)Delete_UserInfoByUserName:(NSString *)UserName{
    
    //[databaseLock lock];
    @try {
        
        if([self InitDataBase]!=nil){
            
            char *errorMsg;
            NSString *deleteSql=[NSString stringWithFormat:@"Delete From UserInfos  where UserName='%@'",UserName];
            
            if(sqlite3_exec([self InitDataBase], [deleteSql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK){
                
                return YES;
                
            }else{
                NSString *ss=[NSString stringWithUTF8String:errorMsg];
                //histan_NSLog(@"error:%@",ss);
                return NO;
            }
            
        }
        
    }
    @catch (NSException *exception) {
        //histan_NSLog(@"NSException:%@",[exception debugDescription]);
    }
    @finally {
        //   [databaseLock unlock];
    }
    
    return NO;
    
}
 
-(NSMutableArray*)Get_AllUserInfs{
    
    NSMutableArray *retArray=[[NSMutableArray alloc]init];
    
    if([self InitDataBase]!=nil){
        
        //[databaseLock lock];
        const char*selectSql="select * from UserInfos";
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2([self InitDataBase], selectSql, -1, &statement, nil)==SQLITE_OK){
            ////ZNV //histan_NSLog(@"查询到了数据了。。");
            
        }
        
        //UserName text
        //PassWord text
        //IsRemindPassWord text
        
        while (sqlite3_step(statement)==SQLITE_ROW) {
            //int _id=sqlite3_column_int(statement, 0);
            NSString *UserName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
            NSString *PassWord=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
            NSString *IsRemindPassWord=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
            
            NSDictionary *rd=[[NSDictionary alloc]initWithObjectsAndKeys:UserName,@"UserName",PassWord,@"PassWord",IsRemindPassWord,@"IsRemindPassWord", nil];
           [retArray addObject:rd];
      
        }
        
        // [databaseLock unlock];
    }
    
    
    return retArray;
}

//获取最后一次登陆的用户名
-(NSString*)Get_LastLoginUserName{
    @try {
        NSString *LastLoginUserNameFileSetFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/LastLoginUserName.config"];
        //临时文件的配置文件的内容
        NSString *ss=[NSString stringWithContentsOfFile:LastLoginUserNameFileSetFilePath encoding:NSUTF8StringEncoding error:nil];
        return ss;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
         
    }
   return @"";
}

-(BOOL)ReSet_LastLoginUserName:(NSString *)UserName{
    NSError *error;
    NSString *LastLoginUserNameFileSetFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/LastLoginUserName.config"];
    [UserName writeToFile:LastLoginUserNameFileSetFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    return YES;
}

 
-(NSString*)Get_LastLoginServiceUrl{
    @try {
        NSString *LastLoginServiceUrlFileSetFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/LastLoginServiceUrl.config"];
        //临时文件的配置文件的内容
        NSString *ss=[NSString stringWithContentsOfFile:LastLoginServiceUrlFileSetFilePath encoding:NSUTF8StringEncoding error:nil];
        return ss;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return @"";
}

-(BOOL)ReSet_LastLoginServiceUrl:(NSString *)ServiceUrl{
    NSError *error;
    NSString *LastLoginServiceUrlFileSetFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/LastLoginServiceUrl.config"];
    [ServiceUrl writeToFile:LastLoginServiceUrlFileSetFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    return YES;
}



-(void)dealloc{
    
    [databaseLock release];
    [super dealloc];
    
}

@end
