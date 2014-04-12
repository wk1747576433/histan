//
//  DownLoadsController.m
//  ZNVAPP
//
//  Created by xiao wenping on 13-10-22.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import "DownLoadsController.h"


@implementation DownLoadsController

@synthesize downingList;
@synthesize finishedList;

@synthesize dirArray=_dirArray;
@synthesize docInteractionController=_docInteractionController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */
- (void)dealloc
{
    [downingList release];
    [finishedList release];
    [_uiTableView_DownLoadFinished release];
    [_uiTableView_DownLoading release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    @try {
        
        
        //调用全局配置
        appDelegate = HISTANdelegate;
        
        appDelegate.downloadDelegate=self;
        self.downingList=appDelegate.downinglist;
        
        PublicDownLoadsBLL *pdownbll=[[PublicDownLoadsBLL alloc]init];
        self.finishedList=[pdownbll GetDownLOadFinishedListArrary];
        [pdownbll release];
        
        _allDataSourceArray_ed=self.finishedList;
        _allDataSourceArray_ding=self.downingList;
        
        ////ZNV //histan_NSLog(@"finishedListcount:%d",[self.finishedList count]);
        
        [_uiTableView_DownLoadFinished reloadData];
        [_uiTableView_DownLoading reloadData];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


- (void)viewDidLoad
{
    
    @try {
        
        
        
        [super viewDidLoad];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        self.navigationItem.title=@"下载中心";

        //在导航右侧加入 返回首页按钮
        rightbutton_backindex=[[UIBarButtonItem alloc]init];
        rightbutton_backindex.tag=-1;
        rightbutton_backindex.title=@"删除";
        rightbutton_backindex.target=self;
        rightbutton_backindex.action=@selector(EditCellSource:);
        rightbutton_backindex.style=UIBarButtonItemStylePlain;
        
        self.navigationItem.rightBarButtonItem=rightbutton_backindex;
        
        //添加tab
        UIImageView *topTitleView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        topTitleView.image=[UIImage imageNamed:@"public_tab_bg"];
        [self.view addSubview:topTitleView];
        
        UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame=CGRectMake(50, 0, 100, 40);
        btn2.frame=CGRectMake(190, 0, 100, 40);
        
        [btn1 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
        
        [btn1 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_press"] forState:UIControlStateHighlighted];
        [btn2 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_press"] forState:UIControlStateHighlighted];
        
        
        btn1.tag=1011;
        
        [btn1 setTitle:@"下载中" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1 ] forState:UIControlStateNormal];
        btn1.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn1.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn1 addTarget:self action:@selector(changeTabButtonFun:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn2 setTitle:@"已下载" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1 ] forState:UIControlStateNormal];
        btn2.tag=1012;
        btn2.titleLabel.font=[UIFont systemFontOfSize:14];
        btn2.titleLabel.textAlignment=NSTextAlignmentCenter;
        [btn2 addTarget:self action:@selector(changeTabButtonFun:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.view addSubview:btn1];//防止空间加载 imgview 里没有 点击事件。
        [self.view addSubview:btn2];
        
        
        //加载搜索条
        //    _uiSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        //    _uiSearchBar.delegate=self;
        //    _uiSearchBar.placeholder=@"Search";
        //    [self.view addSubview:_uiSearchBar];
        //    [_uiSearchBar release];
        
        
        
        //添加 table view
        _uiTableView_DownLoadFinished=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, mainScreen_CGRect.size.height-80) style:UITableViewStylePlain];
        [_uiTableView_DownLoadFinished setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
        [_uiTableView_DownLoadFinished setDelegate:self];
        [_uiTableView_DownLoadFinished setDataSource:self];
        [_uiTableView_DownLoadFinished setTag:102];
        
        _uiTableView_DownLoading=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, mainScreen_CGRect.size.height-80) style:UITableViewStylePlain];
        [_uiTableView_DownLoading setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
        [_uiTableView_DownLoading setDelegate:self];
        [_uiTableView_DownLoading setDataSource:self];
        [_uiTableView_DownLoading setTag:101];
        
        
        UIView *uiview=[[UIView alloc]initWithFrame:CGRectMake(0, 40, 320, mainScreen_CGRect.size.height-80)];
        [uiview setTag:103];
        [self.view addSubview:uiview];
        
        
        [uiview addSubview:_uiTableView_DownLoadFinished];
        [uiview addSubview:_uiTableView_DownLoading];
        
        
        
        
        CurShowTabId=0;//加载就显示正在下载。
        
        
        //注册一个隐藏键盘的方法
        UITapGestureRecognizer *_myTapGr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTppedHideKeyBorad:)];
        _myTapGr.cancelsTouchesInView=NO;
        [self.view addGestureRecognizer:_myTapGr];
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

//点击空白处隐藏键盘
-(void)viewTppedHideKeyBorad:(UITapGestureRecognizer*)tapGr{
    [_uiSearchBar resignFirstResponder];
    _uiSearchBar.showsCancelButton=NO;
    
}


-(void)showFinished
{
    [self startFlipAnimation:0];
    
}

-(void)showDowning
{
    [self startFlipAnimation:1];
}


-(void)startFlipAnimation:(NSInteger)type
{
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    UIView *lastView=[self.view viewWithTag:103];
    
    if(type==0)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:lastView cache:YES];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lastView cache:YES];
    }
    
    UITableView *frontTableView=(UITableView *)[lastView viewWithTag:101];
    UITableView *backTableView=(UITableView *)[lastView viewWithTag:102];
    NSInteger frontIndex=[lastView.subviews indexOfObject:frontTableView];
    NSInteger backIndex=[lastView.subviews indexOfObject:backTableView];
    [lastView exchangeSubviewAtIndex:frontIndex withSubviewAtIndex:backIndex];
    [UIView commitAnimations];
}



-(void)EditCellSource:(id)sender{
    
    ////ZNV //histan_NSLog(@"EditCellSource");
    
    UIBarButtonItem *rbtn=(UIBarButtonItem*)sender;
    
    if(rbtn.tag==-1)//如果是返回按钮
    {
        [rbtn setTag:-2];
        
        //当前按钮变为 完成
        rbtn.title=@"完成";
        
        //开启 tablecell 的编辑模式
        [_uiTableView_DownLoading setEditing:YES animated:YES];
        [_uiTableView_DownLoadFinished setEditing:YES animated:YES];
        
    }else{
        //当前按钮变为 完成
        rbtn.title=@"删除";
        
        [rbtn setTag:-1];
        
        
        //关闭 tablecell 的编辑模式
        [_uiTableView_DownLoading setEditing:NO animated:YES];
        [_uiTableView_DownLoadFinished setEditing:NO animated:YES];
    }
    
    
    
    
    
    
    
}


//
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(editingStyle ==UITableViewCellEditingStyleDelete){
//        ////ZNV //histan_NSLog(@"start delete downloads");
//
//        Model_DownLoad *curdownModel=[[Model_DownLoad alloc]init];
//        if (CurShowTabId==0) {
//            //正在下载的列表
//            curdownModel=[downLoadList_CompleteFalse objectAtIndex:indexPath.row];
//        }else{
//            curdownModel=[downLoadList_CompleteTrue objectAtIndex:indexPath.row];
//        }
//        PublicDownLoadsBLL *pbll=[[PublicDownLoadsBLL alloc]init];
//        NSString *retStr= [pbll DeleteDownLoadFile_FileName:curdownModel.FileName];
//        NSString *retStrShowMsg=@"";
//        ////ZNV //histan_NSLog(@"%@",retStr);
//        if([retStr isEqualToString:@"OK"]){
//            //删除数据库成功，操作界面。
//            if (CurShowTabId==0) {
//                 [downLoadList_CompleteFalse removeObjectAtIndex:indexPath.row];
//            }else{
//           [downLoadList_CompleteTrue removeObjectAtIndex:indexPath.row];
//
//            }
//
//            [_uiTableView_1 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
//            retStrShowMsg=[Public_Tips objectForKey:@"Public_Tips_DeleteSuccess"];
//        }else{
//            retStrShowMsg=[NSString stringWithFormat:[Public_Tips objectForKey:@"Public_Tips_DeleteError"],retStr];
//        }
//
//        [ALToastView toastInView:self.view withText:retStrShowMsg];
//
//        //释放数据库操作对象
//        [pbll release];
//    }
//}

//设置删除按钮的文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"  删   除  ";
}




//tab 按钮点击事件。
-(void)changeTabButtonFun:(UIButton *)sender{
    
    int tag=sender.tag; //当前按钮 tag
    if(tag==1011){
        
        //查询正在下载的数据
        //PublicDownLoadsBLL *pdownb=[[PublicDownLoadsBLL alloc]init];
        //downLoadList_CompleteFalse=[[NSMutableArray alloc]init];
        //downLoadList_CompleteFalse=[pdownb GetAllDownLoadsArray_IsComplete:0];
        //[pdownb release];
        
        if(CurShowTabId!=0){
            [self showDowning];//查看正在下载的文件视图
        }
        CurShowTabId=0;//加载就显示正在下载。
        
        
        
        
        
    }else{
        
        PublicDownLoadsBLL *pdownbll=[[PublicDownLoadsBLL alloc]init];
        self.finishedList=[pdownbll GetDownLOadFinishedListArrary];
        [pdownbll release];
        [_uiTableView_DownLoadFinished reloadData];
        //PublicDownLoadsBLL *pdownb=[[PublicDownLoadsBLL alloc]init];
        // downLoadList_CompleteTrue=[[NSMutableArray alloc]init];
        // downLoadList_CompleteTrue=[pdownb GetAllDownLoadsArray_IsComplete:1];
        // [pdownb release];
        if(CurShowTabId!=1){
            [self showFinished];//查看已下载完成的文件视图
        }
        CurShowTabId=1;//加载就显示正在下载。
        
        
    }
    
    
    UIButton * ALLButton_1011 = (UIButton*)[self.view viewWithTag:1011];
    UIButton * ALLButton_1012 = (UIButton*)[self.view viewWithTag:1012];
    
    [ALLButton_1011 setBackgroundImage:nil forState:UIControlStateNormal];
    [ALLButton_1012 setBackgroundImage:nil forState:UIControlStateNormal];
    UIButton * curButton = (UIButton*)[self.view viewWithTag:tag];
    [curButton setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
    
    
}




#pragma 表格数据源

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_uiTableView_DownLoading)
    {
        return [self.downingList count];
    }
    else
    {
        return [self.finishedList count];
    }
}
 


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_uiTableView_DownLoading)//正在下载的文件列表
    {
        static NSString *downCellIdentifier=@"DownloadCell";
        DownloadCell *cell=(DownloadCell *)[_uiTableView_DownLoading dequeueReusableCellWithIdentifier:downCellIdentifier];
        if(cell==nil)
        {
            NSArray *objlist=[[NSBundle mainBundle] loadNibNamed:@"DownloadCell" owner:self options:nil];
            for(id obj in objlist)
            {
                if([obj isKindOfClass:[DownloadCell class]])
                {
                    cell=(DownloadCell *)obj;
                }
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //UIProgressView *myProgressV=[[UIProgressView alloc]initWithFrame:CGRectMake(75, 25, 182, 9)];
        //[cell.contentView addSubview:myProgressV];
        
       // KOAProgressBar *progressBar=[[KOAProgressBar alloc]initWithFrame:CGRectMake(20, 34, 200, 9)];
       // [cell.contentView addSubview:progressBar];
        
       // progressBar.progressBarColorBackground=[UIColor grayColor];
        //[progressBar setDisplayedWhenStopped:YES];
        //	[self.progressBar setTimerInterval:0.05];
        //[progressBar setProgressValue:0.005];
        //[progressBar setAnimationDuration:5.0];
        //[progressBar startAnimation:self];
        
        
        ASIHTTPRequest *theRequest=[self.downingList objectAtIndex:indexPath.row];
        FileModel *fileInfo=[theRequest.userInfo objectForKey:@"File"];
        //theRequest.downloadProgressDelegate=myProgressV;
        //theRequest.downloadProgressDelegate=cell.progress;
      //  theRequest.downloadProgressDelegate=progressBar;
        //NSString *sssd=fileInfo.fileTitle;
        //NSString *ii=fileInfo.fileImages;
        ////ZNV //histan_NSLog(@"%@",sssd);
        cell.fileName.text=fileInfo.fileName;
        cell.fileSize.text=[CommonHelper getFileSizeString:fileInfo.fileSize];
        cell.fileInfo=fileInfo;
        cell.request=theRequest;
        
        cell.fileCurrentSize.hidden=YES;
        //cell.fileCurrentSize.text=[CommonHelper getFileSizeString:fileInfo.fileReceivedSize];
        
        ////ZNV //histan_NSLog(@"asdd:%@",fileInfo.fileSize);
        ////ZNV //histan_NSLog(@"img:%@",fileInfo.fileImages);
        ////ZNV //histan_NSLog(@"downurl:%@",fileInfo.fileURL);
        
        //[myProgressV setProgress:[CommonHelper getProgress:[CommonHelper getFileSizeNumber:fileInfo.fileSize] currentSize:[fileInfo.fileReceivedSize floatValue]]];
        // [cell.progress setProgress:[CommonHelper getProgress:[CommonHelper getFileSizeNumber:fileInfo.fileSize] currentSize:[fileInfo.fileReceivedSize floatValue]]];
        @try {
            
         //   [progressBar setProgress:[CommonHelper getProgress:[CommonHelper getFileSizeNumber:fileInfo.fileSize] currentSize:[fileInfo.fileReceivedSize floatValue]] animated:YES];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
             
        }
        
        // UILabel *ll=[[UILabel alloc]initWithFrame:CGRectMake(100, 30, 250, 80)];
        //  ll.text=[NSString stringWithFormat:@"ll:%f",[CommonHelper getProgress:[CommonHelper getFileSizeNumber:fileInfo.fileSize] currentSize:[fileInfo.fileReceivedSize floatValue]]];
        
        //ll.text=[CommonHelper getFileSizeString:fileInfo.fileReceivedSize];
        
        // [cell.contentView addSubview:ll];
        
        
        ////ZNV //histan_NSLog(@"currentSize:%f",[fileInfo.fileReceivedSize floatValue]);
        
        //得到网络图片
        //        NSString *strp=[NSString stringWithFormat: @"%@%@",WebProductImageURL,fileInfo.fileImages];
        //        NSURL *imgpath=[NSURL URLWithString:strp];
        //        if (hasCachedImage(imgpath)) {
        //
        //            [cell.FileImageView setImage:[UIImage imageWithContentsOfFile:pathForURL(imgpath)]];
        //
        //        }else
        //        {
        //
        //            [cell.FileImageView setImage:[UIImage imageNamed:@"loading_90-90"]];
        //            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:imgpath,@"url",cell.FileImageView,@"imageView",@"80",@"imageWidth",@"80",@"imageHeight",nil];
        //            [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dic];
        //        }
        
        
        if(fileInfo.isDownloading==YES)//文件正在下载
        {
            cell.FileDCState.text=@"下载中";
            [cell.operateButton setBackgroundImage:[UIImage imageNamed:@"down_pause"] forState:UIControlStateNormal];
        }
        else
        {
            cell.FileDCState.text=@"暂停";
            [cell.operateButton setBackgroundImage:[UIImage imageNamed:@"down_start"] forState:UIControlStateNormal];
        }
        
        
        
        CALayer *menuBorder=[cell.FileImageView layer];
        [menuBorder setBorderWidth:1.0];
        [menuBorder setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.0].CGColor];
        menuBorder.cornerRadius=6;
        menuBorder.masksToBounds=YES;
        
        return cell;
    }
    else if(tableView==_uiTableView_DownLoadFinished)//已完成下载的列表
    {
        static NSString *finishedCellIdentifier=@"FinishedCell";
        DownLoadsCell *cell=(DownLoadsCell *)[_uiTableView_DownLoadFinished dequeueReusableCellWithIdentifier:finishedCellIdentifier];
        if(cell==nil)
        {
            NSArray *objlist=[[NSBundle mainBundle] loadNibNamed:@"DownLoadsCell" owner:self options:nil];
            cell=[objlist objectAtIndex:0];
        }
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor whiteColor];
        FileModel *fileInfo=[self.finishedList objectAtIndex:indexPath.row];
        
        
        [cell.down_openfile setTitle:@"打开" forState:UIControlStateNormal];
        [cell.down_openfile setTag:indexPath.row]; //集合当前 index
        [cell.down_openfile setBackgroundImage:[UIImage imageNamed:@"btn_blue_1"] forState:UIControlStateNormal];
        [cell.down_openfile setBackgroundImage:[UIImage imageNamed:@"btn_blue_2"] forState:UIControlStateHighlighted];
        [cell.down_openfile addTarget:self action:@selector(OpenFileByFileName:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.down_Title.text=fileInfo.fileName;
        cell.down_Schedule.text=[CommonHelper getFileSizeString:fileInfo.fileSize];
        CALayer *menuBorder=[cell.down_Img layer];
        [menuBorder setBorderWidth:1.0];
        [menuBorder setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.0].CGColor];
        menuBorder.cornerRadius=6;
        menuBorder.masksToBounds=YES;
        
        
        
        return cell;
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)//点击了删除按钮,注意删除了该视图列表的信息后，还要更新UI和APPDelegate里的列表
    {
        CurSeleteRowId=indexPath.row;
        
        //提示，是否要删除。
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"您确定要删除？"
                                      delegate:self
                                      cancelButtonTitle:@"取      消"
                                      destructiveButtonTitle:@"确      定"
                                      otherButtonTitles:nil, nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
        [actionSheet showFromRect:[tableView frame] inView:self.view animated:YES];
        
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //ZNV //histan_NSLog(@"btntag:%d",buttonIndex);
    if(buttonIndex==0){
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        if(CurShowTabId==0)//正在下载的表格
        {
            ASIHTTPRequest *theRequest=[self.downingList objectAtIndex:CurSeleteRowId];
            if([theRequest isExecuting])
            {
                [theRequest cancel];
            }
            FileModel *fileInfo=(FileModel*)[theRequest.userInfo objectForKey:@"File"];
            NSString *path=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]];
            //  NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
            // NSString *name=[fileInfo.fileName substringToIndex:index];
            // NSString *configPath=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",name]];
            [fileManager removeItemAtPath:path error:&error];
            //  [fileManager removeItemAtPath:configPath error:&error];
            //  if(!error)
            //  {
            ////ZNV //histan_NSLog(@"%@",[error description]);
            //  }
            
            //删除数据库的记录
            HISTANDataBaseContext *dataBase=[[HISTANDataBaseContext alloc]init];
            [dataBase Delete_DownloadsByFileId:fileInfo.fileID];
            [dataBase release];
            
            
            [self.downingList removeObjectAtIndex:CurSeleteRowId];
            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:CurSeleteRowId inSection:0];
            [_uiTableView_DownLoading deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationRight];
            
        }
        else//已经完成下载的表格
        {
            FileModel *selectFile=[self.finishedList objectAtIndex:CurSeleteRowId];
            NSString *path=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",selectFile.fileName]];
            NSString *path_exsi=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",selectFile.fileName]];
            
            //删除临时文件
            [fileManager removeItemAtPath:path error:&error];
            
            //删除已经下载的文件
            [fileManager removeItemAtPath:path_exsi error:&error];
            
            if(!error)
            {
                ////ZNV //histan_NSLog(@"删除已下载的文件出错：%@",[error description]);
            }
            
            //移除数据库记录，并且重新加载。
            PublicDownLoadsBLL *pdownbll=[[PublicDownLoadsBLL alloc]init];
            //1,移除
            //[pdownbll DeleteDownLoadFile_FileName:selectFile.fileName];
            
            //2,加载
            self.finishedList=[pdownbll GetDownLOadFinishedListArrary];
            [pdownbll release];
            
            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:CurSeleteRowId inSection:0];
            [_uiTableView_DownLoadFinished deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationRight];
        }
        
        
    }
    
}

-(void)updateCellOnMainThread:(FileModel *)fileInfo
{
    for(id obj in _uiTableView_DownLoading.subviews)
    {
        if([obj isKindOfClass:[DownloadCell class]])
        {
            DownloadCell *cell=(DownloadCell *)obj;
            if(cell.fileInfo.fileURL==fileInfo.fileURL)
            {
                ////ZNV //histan_NSLog(@"fileReceivedSizefileReceivedSizefileReceivedSize:%@",fileInfo.fileReceivedSize);
                
                //[cell.progress setProgress:[CommonHelper getProgress:[CommonHelper getFileSizeNumber:fileInfo.fileSize] currentSize:[fileInfo.fileReceivedSize floatValue]]];
                //cell.fileCurrentSize.text=[CommonHelper getFileSizeString:fileInfo.fileReceivedSize];
            }
        }
    }
}

#pragma 下载更新界面的委托
-(void)startDownload:(ASIHTTPRequest *)request;
{
    ////ZNV //histan_NSLog(@"-------开始下载!");
}

-(void)updateCellProgress:(ASIHTTPRequest *)request;
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

-(void)finishedDownload:(ASIHTTPRequest *)request;
{
    //FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    
    [self.downingList removeObject:request];
    PublicDownLoadsBLL *pdownbll=[[PublicDownLoadsBLL alloc]init];
    self.finishedList=[pdownbll GetDownLOadFinishedListArrary];
    [pdownbll release];
    [_uiTableView_DownLoading reloadData];
    [_uiTableView_DownLoadFinished reloadData];
}

//[btn setBackgroundImage:[UIImage imageNamed:@"down_pause"] forState:UIControlStateNormal];

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _uiTableView_DownLoading=nil;
    _uiTableView_DownLoadFinished=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSString *)notRounding:(float)floatNumber afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:floatNumber];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    [ouncesDecimal release];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}



//点击搜索文本框，出现 cancel 按钮。
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=YES;
}

//cancel 按钮的 click事件，（隐藏键盘 和 情况文本框。）
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    
    [_uiSearchBar setText:@""];
    [_uiSearchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
    
    if(CurShowTabId==0)
    {
        self.downingList=_allDataSourceArray_ding;
        [_uiTableView_DownLoading reloadData];
    }
    else
    {
        self.finishedList=_allDataSourceArray_ed;
        [_uiTableView_DownLoadFinished reloadData];
    }
    
}


//编辑完成后调用的方法
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    ////ZNV //histan_NSLog(@"编辑完成。。");
}

//搜索文本框的change事件。
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    if ([searchText isEqualToString:@""]) {
        
        if(CurShowTabId==0)
        {
            self.downingList=_allDataSourceArray_ding;
            [_uiTableView_DownLoading reloadData];
        }
        else
        {
            self.finishedList=_allDataSourceArray_ed;
            [_uiTableView_DownLoadFinished reloadData];
        }
        
    }else{
        
        //根据 searchText 查询信息，并重新加载界面信息。
        
        
        if(CurShowTabId==0)
        {
            
            NSMutableArray *sqqq =[[NSMutableArray alloc]init];
            for(ASIHTTPRequest *item in _allDataSourceArray_ding){
                FileModel *fileInfo=[item.userInfo objectForKey:@"File"];
                NSString *ttitle=fileInfo.fileTitle;
                Boolean IsContains=[ttitle==nil?@"":ttitle rangeOfString:searchText].length>0;
                
                if(IsContains){
                    [sqqq addObject:item];
                }
                
                
            }
            self.downingList=sqqq;
            [_uiTableView_DownLoading reloadData];
        }
        else
        {
            _searchResultSourceArray=nil;
            [_searchResultSourceArray release];
            _searchResultSourceArray =[[NSMutableArray alloc]init];
            for(FileModel *item in _allDataSourceArray_ed){
                Boolean IsContains=[item.fileTitle rangeOfString:searchText].length>0;
                
                if(IsContains){
                    [_searchResultSourceArray addObject:item];
                }
                
                
            }
            self.finishedList=_searchResultSourceArray;
            [_uiTableView_DownLoadFinished reloadData];
            
        }
        
    }
}


-(void)OpenFileByFileName:(UIButton*)btn{
    
    
    @try {
        NSInteger tag=btn.tag;
        ////ZNV //histan_NSLog(@"%d",tag);
        
        FileModel *curmodel= [finishedList objectAtIndex:tag];
        NSString *fileName=curmodel.fileName;
        
        NSString *filepath= [[CommonHelper getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
        
        NSFileManager *myfile=[[NSFileManager alloc]init];
        if([myfile fileExistsAtPath:filepath]){
            
            NSURL*fileURL = [NSURL fileURLWithPath:filepath];
            
            if(fileURL){
                
//                               UIView *aa=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//                               UIWebView *vbview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//                               [self.view addSubview:vbview];
//                              [self loadDocument:filepath inView:vbview];
                //
                self.docInteractionController =[UIDocumentInteractionController interactionControllerWithURL:fileURL];
               [self.docInteractionController setDelegate:self];
                [self.docInteractionController presentPreviewAnimated:YES];
                
                
            }else{
                GCDiscreetNotificationView *gcdNotifiView = [[GCDiscreetNotificationView alloc] initWithText:@"文件不存在！" showActivity:NO inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:self.view];
                [gcdNotifiView showAndDismissAfter:2.0];
                [gcdNotifiView release];
            }
            
        }else{
            GCDiscreetNotificationView *gcdNotifiView = [[GCDiscreetNotificationView alloc] initWithText:@"文件不存在！" showActivity:NO inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:self.view];
            [gcdNotifiView showAndDismissAfter:2.0];
            [gcdNotifiView release];
        }
        
        
    }
    @catch (NSException *exception) {
        
        GCDiscreetNotificationView *gcdNotifiView = [[GCDiscreetNotificationView alloc] initWithText:@"文件有错误！未能打开！" showActivity:NO inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:self.view];
        [gcdNotifiView showAndDismissAfter:2.0];
        [gcdNotifiView release];
    }
    @finally {
        
    }
    
}

-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView
{
  //  NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:documentName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}




//FileModel *curmodel= [finishedList objectAtIndex:idx];
//NSString *fileName=curmodel.fileName;
//
//NSString *filepath= [[CommonHelper getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
//
//fileURL = [NSURL fileURLWithPath:filepath];
//return fileURL;



- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}


@end
