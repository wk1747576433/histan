//
//  PublicDownLoadsBLL.m
//  histan
//
//  Created by liu yonghua on 14-1-22.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import "PublicDownLoadsBLL.h"

@implementation PublicDownLoadsBLL

-(NSMutableArray*)GetDownLOadFinishedListArrary{
     
    NSMutableArray  *finishedlist=[[[NSMutableArray alloc] init] autorelease];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[CommonHelper getTargetFloderPath] error:&error];
    if(error)
    {
        ////ZNV //histan_NSLog(@"%@",[error description]);
    }
    for(NSString *fileName in filelist)
    {
        if([fileName rangeOfString:@"."].location<100)//出去Temp文件夹
        {
            FileModel *finishedFile=[[FileModel alloc] init];
            finishedFile.fileName=fileName;
            
            //根据文件名获取文件的大小
            NSInteger length=[[fileManager contentsAtPath:[[CommonHelper getTargetFloderPath] stringByAppendingPathComponent:fileName]] length];
            finishedFile.fileSize=[CommonHelper getFileSizeString:[NSString stringWithFormat:@"%d",length]];
            
            [finishedlist addObject:finishedFile];
            [finishedFile release];
        }
    }
    
    return finishedlist;
}


//开始下载的方法
-(NSString*)DownLoadAction:(NSString *)fileName url:(NSString *)url fileSize:(NSString*)fileSize fileID:(NSString*)fileID{
 
    HISTANDataBaseContext *dataBase=[[HISTANDataBaseContext alloc]init];
    if([dataBase Check_DownloadsIsHave:fileID]){
        return @"EXIST";//正在下载！
    }
   
     
    FileModel *fileInfos=[[FileModel alloc]init];
    fileInfos.fileName=fileName;
    fileInfos.fileID=fileID;
    fileInfos.fileReceivedData=nil;
    fileInfos.fileReceivedSize=@"";
    fileInfos.fileSize=fileSize;
    fileInfos.fileURL=url;
    fileInfos.fileTitle=@"";
    fileInfos.fileImages=@""; //图片
    fileInfos.IsFirstLoad=NO;//不是第一次从数据库加载
    FileModel *selectFileInfo=fileInfos;
    
    //选择点击的行
    //    UITableView *tableView=(UITableView *)[sender superview];
    //    ////ZNV //histan_NSLog(@"%d",[fileInfo.fileID integerValue]);
    //    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[fileInfo.fileID integerValue] inSection:0];
    //    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    //因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
    NSString *targetPath=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:selectFileInfo.fileName];
    NSString *tempPath=[[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:selectFileInfo.fileName]stringByAppendingString:@".temp"];
    if([CommonHelper isExistFile:targetPath])//已经下载过一次该文件
    {
        return @"EXIST_Complete";//已下载完成！
        
    }
    //存在于临时文件夹里
    if([CommonHelper isExistFile:tempPath])
    {
        return @"EXIST";//正在下载！
        
    }
    selectFileInfo.isDownloading=YES;
    //若不存在文件和临时文件，则是新的下载
    HISTANAPPAppDelegate * appDelegate = HISTANdelegate;
    [appDelegate beginRequest:selectFileInfo isBeginDown:YES];
    
    return @"OK";
    
}

//删除
-(void)DeleteDownLoadFile_FileName:(NSString*)fileName{
    
}

@end
