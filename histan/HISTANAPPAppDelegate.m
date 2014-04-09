//
//  HISTANAPPAppDelegate.m
//  histan
//
//  Created by liu yonghua on 13-12-27.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import "HISTANAPPAppDelegate.h"

#import "HISTANAPPViewController.h"

@implementation HISTANAPPAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize SID = _SID;
@synthesize PValue =_PValue ;
@synthesize UserName = _UserName;
@synthesize MenusArray = _MenusArray;
@synthesize MyTaskArray_hand = _MyTaskArray_hand;
@synthesize MyTaskArray_submit =_MyTaskArray_submit;
@synthesize DeptsDictionary =_DeptsDictionary;

@synthesize MyTaskStatus = _MyTaskStatus;
@synthesize CurPageTitile=_CurPageTitile;
@synthesize CurTaskTypeId=_CurTaskTypeId;
@synthesize CurTaskId=_CurTaskId;
@synthesize WebSevicesURL=_WebSevicesURL;
@synthesize IdealTaskEntrust=_IdealTaskEntrust;
@synthesize upFileNameArray =_upFileNameArray;
@synthesize publishTypeId = _publishTypeId;
@synthesize noticeListArray = _noticeListArray;
@synthesize infoId = _infoId;

@synthesize ServicesDictionary=_ServicesDictionary;

//下载配置
@synthesize downinglist=_downinglist;
@synthesize downloadDelegate=_downloadDelegate;
@synthesize finishedlist=_finishedList;
@synthesize boundList_curItemDic=_boundList_curItemDic;
@synthesize boundList_curDate = _boundList_curDate;

@synthesize month = _month;
@synthesize num_task = _num_task;
 
@synthesize curOutBoundStatus = _curOutBoundStatus;
@synthesize YYShangmenTime=_YYShangmenTime;

@synthesize opeationSuccessNeedReloadPage=_opeationSuccessNeedReloadPage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _MenusArray=nil;
    
    
    
    
//    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:
//            // 没有网络连接
//            NSLog(@"无网络连接");
//            break;
//        case ReachableViaWWAN:
//            // 使用3G网络
//            NSLog(@"使用3G网络");
//            break;
//        case ReachableViaWiFi:
//            // 使用WiFi网络
//            NSLog(@"使用WiFi网络");
//            break;
//    }
    
    
    
    
    //注册推送通知
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
        if(launchOptions){
            NSDictionary *pushNotificationKey=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if(pushNotificationKey){
//                UIAlertView *_al=[[UIAlertView alloc]initWithTitle:@"title" message:@"这里是通过推送窗口启动的程序，你可以在这里处理推送内容" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//                [_al show];
//                [_al release];
    
            }
        }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[HISTANAPPViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navigationController;
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
    
    
    
    
    
    
}


//保存设备 token
-(void)application:(UIApplication*)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token =[NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"apns -> 产生的 devtoken:%@",token);
    
    //请求服务器
    DeviceSenderBLL *dev=[[DeviceSenderBLL alloc]init];
    [dev sendDeviceToPushServer:token];
    [dev release];
    
    
    
    
    
}

-(void)application:(UIApplication*)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    //histan_NSLog(@"apns -> 注册错误：%@",error);
   // UIAlertView *_al=[[UIAlertView alloc]initWithTitle:@"error" message:[NSString stringWithFormat:@"%@",error] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
  //  [_al show];
    
}

-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
   // //histan_NSLog(@"userInfo :%@",userInfo);
     UIAlertView *_al=[[UIAlertView alloc]initWithTitle:[[userInfo objectForKey:@"aps"] objectForKey:@"tl"]  message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]  delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [_al show];
    
    //把 icon 上的数字设置为 0，
    [application setApplicationIconBadgeNumber:0];
  //  if([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL){
   //     //histan_NSLog(@"alert:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
   // }
     
    [_al release];
    
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

//程序再次显示出来的事件
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    ////histan_NSLog(@"Active...");
    //判断程序是否最新版本
    @try {
        //0:无新版本不弹出
        [Harpy checkVersion:0];
        
        
        //加载下载文件
        [self loadFinishedfiles];
        [self loadTempfiles];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}





-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown
{
    BOOL IsHave=NO;
    //如果存在下载列表，或者下载完成，则直接返回
    //往数据库插入一条正在下载的数据
    HISTANDataBaseContext *dataBase=[[HISTANDataBaseContext alloc]init];
    if ([dataBase Check_DownloadsIsHave:fileInfo.fileID]) {
        IsHave=YES;
    }
    
    NSString *path_exsi=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileInfo.fileName]];
    if([CommonHelper isExistFile:path_exsi])//已经下载过了
    {
        IsHave=YES;
    }
    
    [dataBase Insert_DownloadsByFileId:fileInfo.fileID FileName:fileInfo.fileName FileSize:fileInfo.fileSize fileImages:fileInfo.fileImages fileURL:fileInfo.fileURL fileTitle:fileInfo.fileTitle];
    [dataBase release];
    
    //替换  fileTitle 中的  ,
    //fileInfo.fileTitle=[fileInfo.fileTitle stringByReplacingOccurrencesOfString:@"," withString:@" "];
    //fileInfo.fileTitle=[fileInfo.fileTitle stringByReplacingOccurrencesOfString:@"，" withString:@" "];
    
    
    //如果不存在则创建临时存储目录
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:[CommonHelper getTempFolderPath]])
    {
        [fileManager createDirectoryAtPath:[CommonHelper getTempFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //NSString *sss=[NSString stringWithFormat:@"%@,%@",fileInfo.fileImages,fileInfo.fileTitle];
    ////ZNV //histan_NSLog(@"sss:%@",sss);
    
    //文件开始下载时，把文件名、文件总大小、文件URL写入文件，上海滩.rtf中间用逗号隔开
    //NSString *writeMsg=[fileInfo.fileName stringByAppendingFormat:[NSString stringWithFormat:@",%@,%@,%@",fileInfo.fileSize,fileInfo.fileURL,sss]];
    // //histan_NSLog(@"writeMsg:%@",writeMsg);
    //NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
    //NSString *name=@"";//[fileInfo.fileName substringToIndex:index];
    //获取文件名称
    //NSString *newFileName=@"";
    //    NSArray *firstSplit = [fileInfo.fileName componentsSeparatedByString:@"."];
    //    for(int i=0;i<[firstSplit count];i++){
    //        if(i==[firstSplit count]-1){
    //            continue;
    //        }
    //
    //        if (i==0) {
    //            name=[NSString stringWithFormat:@"%@%@",name,firstSplit[i]];
    //        }else{
    //            name=[NSString stringWithFormat:@"%@.%@",name,firstSplit[i]];
    //        }
    //
    //
    //    }
    //
    //    //histan_NSLog(@"%@",name);
    //
    //    [writeMsg writeToFile:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",name]] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    //
    
    
    
    //按照获取的文件名获取临时文件的大小，即已下载的大小
    fileInfo.isFistReceived=YES;
    NSData *fileData=[fileManager contentsAtPath:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    NSInteger receivedDataLength=[fileData length];
    fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%d",receivedDataLength];
    
    //如果文件重复下载或暂停、继续，则把队列中的请求删除，重新添加
    for(ASIHTTPRequest *tempRequest in self.downinglist)
    {
        //histan_NSLog(@"u1:%@",[NSString stringWithFormat:@"%@",tempRequest.url]);
        //histan_NSLog(@"u2:%@",[NSString stringWithFormat:@"%@",fileInfo.fileURL]);
        FileModel *fileInfosss=[tempRequest.userInfo objectForKey:@"File"];
        if([[NSString stringWithFormat:@"%@",fileInfosss.fileID] isEqual:fileInfo.fileID])
        {
            [self.downinglist removeObject:tempRequest];
            break;
        }
    }
    
  // NSLog(@"原连接：%@",fileInfo.fileURL);
    //先转为 utf-8 编码
    NSString *str2 = [fileInfo.fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  //  NSLog(@"编码后：%@",str2);
    //再替换因为转码后多出的字符： %25
    str2=[str2 stringByReplacingOccurrencesOfString:@"%25" withString:@"%"];
    // NSLog(@"替换后：%@",str2);
    //生成下载路径
    NSURL * urll = [NSURL URLWithString:str2];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:urll];
    request.delegate=self;
    // request.timeOutSeconds=99999999;
    [request setDownloadDestinationPath:[[CommonHelper getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileInfo.fileName]]];
    [request setTemporaryFileDownloadPath:[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    [request setDownloadProgressDelegate:self];
    //    [request setDownloadProgressDelegate:downCell.progress];//设置进度条的代理,这里由于下载是在AppDelegate里进行的全局下载，所以没有使用自带的进度条委托，这里自己设置了一个委托，用于更新UI
    [request setAllowResumeForFileDownloads:YES];//支持断点续传
    if(isBeginDown)
    {
        fileInfo.isDownloading=YES;
    }
    else
    {
        fileInfo.isDownloading=NO;
    }
    [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
    [request setTimeOutSeconds:30.0f];
    if (isBeginDown) {
        [request startAsynchronous];
    }
    
    [self.downinglist addObject:request];
    
//    if(fileInfo.IsFirstLoad){
//        fileInfo.IsFirstLoad=NO;
//        [self.downinglist addObject:request];
//    }else{
//        
//        if (IsHave==NO ) {
//            [self.downinglist addObject:request];
//        }
//        
//    }
    //////ZNV //histan_NSLog(@"fo.f:%@",fileInfo.fileSize);
    
}

-(void)cancelRequest:(ASIHTTPRequest *)request
{
    
}

//加载还未完成的文件
-(void)loadTempfiles
{
    @try {
        
   
    self.downinglist=[[[NSMutableArray alloc] init] autorelease];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    HISTANDataBaseContext *dataBase=[[HISTANDataBaseContext alloc]init];
    //    [dataBase DeleteAll];
    NSMutableArray *arrays=[[NSMutableArray alloc]init];
    arrays=[dataBase Get_DownLoadsArray];
    [dataBase release];
    for (FileModel *item in arrays) {
        
        //histan_NSLog(@"item:%@ --- %@  ---- %@",item.fileID,item.fileName,item.fileURL);
        
        //按照获取的文件名获取临时文件的大小，即已下载的大小
        NSData *fileData=[fileManager contentsAtPath:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",item.fileName]]];
        float receivedDataLength=[fileData length];
        
        FileModel *tempFile=[[FileModel alloc] init];
        tempFile.fileID=item.fileID;
        tempFile.fileName=item.fileName;
        tempFile.fileSize=item.fileSize;
        tempFile.fileReceivedSize=[NSString stringWithFormat:@"%f",receivedDataLength];
        tempFile.fileURL=item.fileURL;
        tempFile.fileTitle=item.fileTitle;
        tempFile.fileImages=item.fileImages;
        tempFile.isDownloading=NO;
        tempFile.IsFirstLoad=YES;
        [self beginRequest:tempFile isBeginDown:NO];
        //[msg release];
        [tempFile release];
        
    }
    
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    //    ////    //NSError *error;
    //   // NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[CommonHelper getTempFolderPath] error:&error];
    //   // if(!error)
    //   // {
    //        ////ZNV //histan_NSLog(@"%@",[error description]);
    //   // }
    //    for(NSString *file in filelist)
    //    {
    //        if([file rangeOfString:@".rtf"].location<=100)//以.rtf结尾的文件是下载文件的配置文件，存在文件名称，文件总大小，文件下载URL
    //        {
    //            //NSInteger index=[file rangeOfString:@"."].location;
    //            NSString *trueName=@"";//[file substringToIndex:index];
    //            NSArray *firstSplit = [file componentsSeparatedByString:@"."];
    //            for(int i=0;i<[firstSplit count];i++){
    //                if(i==[firstSplit count]-1){
    //                    continue;
    //                }
    //
    //                if (i==0) {
    //                    trueName=[NSString stringWithFormat:@"%@%@",trueName,firstSplit[i]];
    //                }else{
    //                    trueName=[NSString stringWithFormat:@"%@.%@",trueName,firstSplit[i]];
    //                }
    //
    //
    //            }
    //
    //            //临时文件的配置文件的内容
    //            NSString *msg=[[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",trueName]]] encoding:NSUTF8StringEncoding]autorelease];
    //            //histan_NSLog(@"msg:%@",msg);
    //            //取得第一个逗号前的文件名
    //            NSInteger index=[msg rangeOfString:@","].location;
    //            NSString *name=[msg substringToIndex:index];
    //            msg=[msg substringFromIndex:index+1];
    //
    //            //取得第一个逗号和第二个逗间的文件总大小
    //            index=[msg rangeOfString:@","].location;
    //            NSString *totalSize=[msg substringToIndex:index];
    //            msg=[msg substringFromIndex:index+1];
    //
    //            //取得第二个逗号和第三个逗间的文件下载的URL
    //            index=[msg rangeOfString:@","].location;
    //            NSString *url=[msg substringToIndex:index];
    //            msg=[msg substringFromIndex:index+1];
    //
    //            //取得第三个逗号和第四个逗间的 文件图片名称
    //            index=[msg rangeOfString:@","].location;
    //            NSString *FileImages=[msg substringToIndex:index];
    //
    //            msg=[msg substringFromIndex:index+1];
    //            //取得第最后一个逗号后的所有内容，即文件名称（标题）
    //            NSString *FileTitle=[NSString stringWithFormat:@"%@",msg];
    //
    //            ////ZNV //histan_NSLog(@"lase:%@",msg);
    //
    //            //按照获取的文件名获取临时文件的大小，即已下载的大小
    //            NSData *fileData=[fileManager contentsAtPath:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",name]]];
    //            float receivedDataLength=[fileData length];
    //
    //            //实例化新的文件对象，添加到下载的全局列表，但不开始下载
    //            FileModel *tempFile=[[FileModel alloc] init];
    //            tempFile.fileName=name;
    //            tempFile.fileSize=totalSize;
    //            tempFile.fileReceivedSize=[NSString stringWithFormat:@"%f",receivedDataLength];
    //            tempFile.fileURL=url;
    //            tempFile.fileTitle=FileTitle;
    //            tempFile.fileImages=FileImages;
    //            tempFile.isDownloading=NO;
    //            [self beginRequest:tempFile isBeginDown:NO];
    //            //[msg release];
    //            [tempFile release];
    //        }
    //    }
}

-(void)loadFinishedfiles
{
    self.finishedlist=[[[NSMutableArray alloc] init] autorelease];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[CommonHelper getTargetFloderPath] error:&error];
    if(error)
    {
        ////ZNV //histan_NSLog(@"%@",[error description]);
    }
    for(NSString *fileName in filelist)
    {
        if([fileName rangeOfString:@"."].location<100)//除去Temp文件夹
        {
            FileModel *finishedFile=[[FileModel alloc] init];
            finishedFile.fileName=fileName;
            
            //根据文件名获取文件的大小
            NSInteger length=[[fileManager contentsAtPath:[[CommonHelper getTargetFloderPath] stringByAppendingPathComponent:fileName]] length];
            finishedFile.fileSize=[CommonHelper getFileSizeString:[NSString stringWithFormat:@"%d",length]];
            
            [self.finishedlist addObject:finishedFile];
            [finishedFile release];
        }
    }
}

- (void)dealloc
{
    
    [_finishedList release];
    [_downloadDelegate release];
    [_downinglist release];
    [_window release];
    
    [super dealloc];
}


#pragma ASIHttpRequest回调委托

//出错了，如果是等待超时，则继续下载
-(void)requestFailed:(ASIHTTPRequest *)request
{
    //下载失败。
    // JSNotifier *notify = [[JSNotifier alloc]initWithTitle:@"网络连接失败、请检查网络！"];
    // notify.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NotifyX"]];
    //[notify showFor:1.5];
    
    NSError *error=[request error];
    //histan_NSLog(@"ASIHttpRequest出错了!%@",error);
    [request release];
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    //histan_NSLog(@"开始下载了!");
}

-(void)requestReceivedResponseHeaders:(ASIHTTPRequest *)request
{
    //histan_NSLog(@"收到下载的回复了！");
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    fileInfo.fileSize=[CommonHelper getFileSizeString:[[request responseHeaders] objectForKey:@"Content-Length"]];
}

////*********
//**注意：如果要要ASIHttpRequest自动断点续传，则不需要写上该方法，整个过程ASIHttpRequest会自动识别URL进行保存数据的
//如果设置了该方法，ASIHttpRequest则不会响应断点续传功能，需要自己手动写入接收到的数据，开始不明白原理，搞了很久才明白，如果本人理解不正确的话，请高人及时指点啊^_^
//***********
//-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
//{
//    FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
//    [fileInfo.fileReceivedData appendData:data];
//    fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%d",[fileInfo.fileReceivedData length]];
//    [fileInfo.fileReceivedData writeToFile:request.temporaryFileDownloadPath atomically:NO];
//    NSString *configPath=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[fileInfo.fileName stringByAppendingString:@".rtf"]];
//    NSString *tmpConfigMsg=[NSString stringWithFormat:@"%@,%@,%@,%@",fileInfo.fileName,fileInfo.fileSize,fileInfo.fileReceivedSize,fileInfo.fileURL];
//    NSError *error;
//    [tmpConfigMsg writeToFile:configPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    if(!error)
//    {
//        ////ZNV //histan_NSLog(@"错误%@",[error description]);
//    }
//    [self.downloadDelegate updateCellProgress:fileInfo];
//    ////ZNV //histan_NSLog(@"正在接受搜数据%d",[fileInfo.fileReceivedData length]);
//}

//1.实现ASIProgressDelegate委托，在此实现UI的进度条更新,这个方法必须要在设置[request setDownloadProgressDelegate:self];之后才会运行
//2.这里注意第一次返回的bytes是已经下载的长度，以后便是每次请求数据的大小
//费了好大劲才发现的，各位新手请注意此处
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    if(!fileInfo.isFistReceived)
    {
        fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];
    }
    if([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:)])
    {
        [self.downloadDelegate updateCellProgress:request];
    }
    fileInfo.isFistReceived=NO;
}

//将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
    
    //删除数据库的记录
    HISTANDataBaseContext *dataBase=[[HISTANDataBaseContext alloc]init];
    [dataBase Delete_DownloadsByFileId:fileInfo.fileID];
    [dataBase release];
    
    //NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
    // NSString *name=[fileInfo.fileName substringToIndex:index];;
    // NSString *configPath=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[name stringByAppendingString:@".rtf"]];
    // NSFileManager *fileManager=[NSFileManager defaultManager];
    //NSError *error;
    //  if([fileManager fileExistsAtPath:configPath])//如果存在临时文件的配置文件
    //   {
    //        [fileManager removeItemAtPath:configPath error:&error];
    //        if(!error)
    //        {
    //            ////ZNV //histan_NSLog(@"%@",[error description]);
    //        }
    //    }
    
    if([self.downloadDelegate respondsToSelector:@selector(finishedDownload:)])
    {
        [self.downloadDelegate finishedDownload:request];
    }
    
    //    for (FileModel *item in _downinglist) {
    //        if([item.fileName isEqualToString:fileInfo.fileName])
    //        {
    //            [_downinglist removeObject:item];
    //        }
    //    }
    
    [_downinglist removeObject:request];
    [request release];
    
    
    JSNotifier *notify = [[JSNotifier alloc]initWithTitle:[NSString stringWithFormat:@"成功下载：%@",fileInfo.fileName]];
    notify.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NotifyCheck"]];
    [notify showFor:1.5];
    
}



@end
