//
//  publishDitealViewController.m
//  histan
//
//  Created by lyh on 1/21/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "publishDitealViewController.h"

@interface publishDitealViewController ()
{
    float webViewHeight;//webView 的内容高度
    BOOL isReload;      //是否已经重新加载数据
    NSDictionary *currtNotify;//当前的这条公告信息
}
@end

@implementation publishDitealViewController

@synthesize docInteractionController=_docInteractionController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    appendArray = [[NSMutableArray alloc] init];
    downloadArray= [[NSMutableArray alloc] init];
    appDelegate.downloadDelegate=self;
    self.navigationItem.title = appDelegate.CurPageTitile;
    
    //循环查找id为appDelegate.infoId的对象并记录
    //获取attachement_name字段中的内容，将文件名称提取出来，加入appendArray
    
    //histan_NSLog(@" appDelegate.noticeListArray：%@",appDelegate.noticeListArray);
    for (NSDictionary *itemDic in appDelegate.noticeListArray) {
        if ([[itemDic objectForKey:@"notify_id"] isEqualToString:appDelegate.infoId]) {
            //记录当前公告信息
            currtNotify = itemDic;
            
            noticesName = [itemDic objectForKey:@"subject"];
            publishDept = [itemDic objectForKey:@"dept_name"];
            publisher = [itemDic objectForKey:@"user_name"];
            publishTime = [itemDic objectForKey:@"send_time"];
            approveMan = [itemDic objectForKey:@"auditer"];
            appendArray = [itemDic objectForKey:@"download"];
            downloadArray= [itemDic objectForKey:@"download"];
            [appendArray retain];
            [downloadArray retain];
            if ([appendArray isEqual:@"null"]) {
                //没有附件
                //histan_NSLog(@"没有附件！");
            }
            else
            {
                NSString *fileNameStr = [itemDic objectForKey:@"attachement_name"];
                NSArray *fileNameArray = [fileNameStr componentsSeparatedByString:@"*"];
                //histan_NSLog(@"fileNameArray  is ****** %@",fileNameArray);
                appendArray = [NSMutableArray arrayWithArray:fileNameArray];
                [appendArray removeLastObject];
                [appendArray retain];
                
            }
            content = [itemDic objectForKey:@"content"];
            //histan_NSLog(@"the content == %@",content);
        }
    }
    
    
    
    webViewHeight = 84;
    isReload = FALSE;
    
    UIImageView *imgv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    [imgv setBackgroundColor:[UIColor whiteColor]];
    
    //添加 table view
    CGRect r_cg=mainScreen_CGRect;

    _uiTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, r_cg.size.height-40) style:UITableViewStylePlain];
    [_uiTableView setDelegate:self];
    [_uiTableView setDataSource:self];
    [_uiTableView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
    _uiTableView.backgroundView=imgv;
    [self.view addSubview:_uiTableView];
    
    //设置 cell 分割线为空
    _uiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    
}


#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier =[NSString stringWithFormat:@"cell_infoDetails_%d",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
        CGRect cellFrame = [cell frame];
        cellFrame.origin = CGPointMake(100, 2);
        
        float curCellHeight=0;//当前cell 高度
        
        float margintop=0;
        if (indexPath.row==0) //第一个cell，显示 标题，发布人等信息
        {
            UILabel *titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(5, 2, mainScreen_CGRect.size.width-10,40)];
            titleLbl.text=noticesName;
            titleLbl.font=[UIFont boldSystemFontOfSize:16.0f];
            titleLbl.lineBreakMode = UILineBreakModeWordWrap;
            titleLbl.highlightedTextColor = [UIColor whiteColor];
            titleLbl.numberOfLines =0;
            //重新设置 label 的高度、
            titleLbl.frame= CGRectMake(5, 2, mainScreen_CGRect.size.width-10, titleLbl.frame.size.height);
            [titleLbl sizeToFit];
            [cell.contentView addSubview:titleLbl];
            
            margintop=titleLbl.frame.size.height+2;
            
            UILabel *publishDeptLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, margintop, mainScreen_CGRect.size.width-10, 18)];
            [publishDeptLabel setText:[NSString stringWithFormat:@"发布部门：%@",publishDept]];
            publishDeptLabel.font=[UIFont systemFontOfSize:14.0f];
            [cell.contentView addSubview:publishDeptLabel];
            
            UILabel *publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, margintop+19, mainScreen_CGRect.size.width-10, 18)];
            [publisherLabel setText:[NSString stringWithFormat:@"发布人：%@",publisher]];
            publisherLabel.font=[UIFont systemFontOfSize:14.0f];
            [cell.contentView addSubview:publisherLabel];
            
            UILabel *publishTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, margintop+19+19, mainScreen_CGRect.size.width-10, 18)];
            [publishTimeLabel setText:[NSString stringWithFormat:@"发布于：%@",publishTime]];
            publishTimeLabel.font=[UIFont systemFontOfSize:14.0f];
            [cell.contentView addSubview:publishTimeLabel];
            
            UILabel *approveManLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, margintop+19+19+19, mainScreen_CGRect.size.width-10, 18)];
            [approveManLabel setText:[NSString stringWithFormat:@"审批人：%@",approveMan]];
            //            [approveManLabel.layer setBorderWidth:2];
            //            [approveManLabel.layer setBorderColor:[UIColor grayColor].CGColor];
            approveManLabel.font=[UIFont systemFontOfSize:14.0f];
            
            //累加cell的高度
            //curCellHeight+=(approveManLabel.frame.size.height+approveManLabel.frame.origin.y);
            curCellHeight=margintop+19+19+19+19+8;
            [cell.layer setBorderWidth:1];
            [cell.layer setBorderColor:[UIColor grayColor].CGColor];
            [cell.contentView addSubview:approveManLabel];
            
        }else if(indexPath.row==1) //显示内容
        {
            
            UIWebView *docView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 0, 310, webViewHeight)];
            docView.delegate = self;
            [docView loadHTMLString:content baseURL:nil];
            [cell.contentView addSubview:docView];
            [cell.contentView setUserInteractionEnabled:NO];
            curCellHeight=webViewHeight+10;
            ////histan_NSLog(@"curCellHeight:%f",curCellHeight);
            
        }else if(indexPath.row==2)//显示下载内容
        {
            //显示附件
            if ([appendArray isEqual:@"null"]) {
                //histan_NSLog(@"没有附件！");
            }
            else
            {
                for (int i=0; i<[appendArray count]; i++) {
                    //histan_NSLog(@"选中的公告的附件数组：%@",appendArray);
                    //得到附件信息。
                    NSDictionary *hubDicts=[downloadArray objectAtIndex:i];
                    NSString *fileStr = [appendArray objectAtIndex:i];
                    UILabel *upFileLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2+40*i, mainScreen_CGRect.size.width - 10-90, 40)];
                    upFileLabel.userInteractionEnabled = YES;
                    upFileLabel.font = [UIFont systemFontOfSize:14.0f];
                    [upFileLabel setLineBreakMode:UILineBreakModeMiddleTruncation];
                    [upFileLabel setText:fileStr];
                    
                    UIButton *dowloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(235, 2+40*i, 80, 38)];
                    NSString *path_exsi=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[appendArray objectAtIndex:i]]];
                    if([CommonHelper isExistFile:path_exsi])//已经下载过了
                    {
                        [dowloadBtn setBackgroundImage:[UIImage imageNamed:@"openfile"] forState:UIControlStateNormal];
                        [dowloadBtn setBackgroundImage:[UIImage imageNamed:@"openfile_press"] forState:UIControlStateHighlighted];
                        [dowloadBtn addTarget:self action:@selector(OpenFileHub:) forControlEvents:UIControlEventTouchUpInside];
                    }else{
                        [dowloadBtn setBackgroundImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
                        [dowloadBtn setBackgroundImage:[UIImage imageNamed:@"down_press"] forState:UIControlStateHighlighted];
                        [dowloadBtn addTarget:self action:@selector(StartDownLoadHub:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    [dowloadBtn setTag:8899+i];
                    
                    [cell.contentView addSubview:upFileLabel];
                    [cell.contentView addSubview:dowloadBtn];
                    [cell.layer setBorderWidth:1];
                    [cell.layer setBorderColor:[UIColor grayColor].CGColor];
                    curCellHeight += 42;
                    
                }
                
            }
            
        }
        
        cellFrame.size.height=curCellHeight+10;
        [cell setFrame:cellFrame];

    return cell;
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    NSString *strHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    //histan_NSLog(@"height = %@", strHeight);
    
    if (isReload) {
        //已经重新加载！
    }
    else
    {
        webViewHeight = [strHeight floatValue]+10;
//        if (webViewHeight > 300) {
//            webViewHeight = 300;
//        }
        [_uiTableView reloadData];
        isReload = TRUE;
    }
    
    
}




#pragma mark -- 实现下载的代理方法
//-(void)startDownload:(ASIHTTPRequest *)requestP
//{}
//-(void)updateCellProgress:(ASIHTTPRequest *)requestP
//{}
-(void)finishedDownload:(ASIHTTPRequest *)requestP
{
    @try {
        FileModel *fileInfo=(FileModel *)[requestP.userInfo objectForKey:@"File"];
        NSString *fileID= fileInfo.fileID;
        for (int i=0; i<[appendArray count]; i++) {
            NSDictionary *dict=[downloadArray objectAtIndex:i];
            if ([[dict objectForKey:@"ATTACHMENT_ID"] isEqualToString:fileID])
            {
                UIButton *btn=(UIButton*)[self.view viewWithTag:8899+i];
                [btn setBackgroundImage:[UIImage imageNamed:@"openfile"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"openfile_press"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(OpenFileHub:) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}


#pragma mark - 打开文件，打开附件：UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}
-(void)OpenFileHub:(UIButton*)sender{
    
    
    @try {
        
        NSString *fileName=[appendArray objectAtIndex:sender.tag-8899];
        NSString *filepath= [[CommonHelper getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
        
        NSFileManager *myfile=[[NSFileManager alloc]init];
        if([myfile fileExistsAtPath:filepath]){
            
          NSURL*fileURL = [NSURL fileURLWithPath:filepath];
           local_file_URL=[fileURL retain];
//            
//            NSURLRequest *req=[NSURLRequest requestWithURL:fileURL];
//            UIWebView *webb=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//            [webb loadRequest:req];
//            [self.view addSubview:webb];
            
//            QLPreviewController *ql = [[[QLPreviewController alloc]initWithNibName:nil bundle:nil] autorelease];
//            ql.navigationController.navigationBarHidden = YES;
//            // Set data source
//            ql.dataSource = self;
//            
//            // Which item to preview
//            [ql setCurrentPreviewItemIndex:0];
//            
//            UINavigationController *navigationController = [[[UINavigationController alloc]initWithRootViewController:ql] autorelease];
//            UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(closeQuickLookAction:)];
//            ql.navigationItem.leftBarButtonItem = backButton;
//            
//            // Push new viewcontroller, previewing the document
//            [self presentModalViewController:navigationController animated:YES];
//            
//
            if(fileURL){
                
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

- (IBAction)closeQuickLookAction:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
#pragma mark - quicklook
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}
- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return local_file_URL;
}

#pragma mark -- 附加下载事件
-(void)StartDownLoadHub:(UIButton*)sender{
    
    
    bool IsComplete=NO;//标识是否完成。
    //histan_NSLog(@"sender.tag:%d",sender.tag);
    NSDictionary *hubDict=(NSDictionary*)[downloadArray objectAtIndex:sender.tag-8899];
    
    HISTANAPPAppDelegate *appDelegate=HISTANdelegate;
    
    //如果是当前按钮做绑定的附件内容，则开始下载
    
    NSString *showretStr=@"";
    float filesize=[[hubDict objectForKey:@"SIZE"] floatValue];
    if(filesize ==0){
        showretStr=@"服务器文件不存在、不能下载！";
    }else{
        
        NSString *dUrl=[NSString stringWithFormat:@"%@?MODULE=%@&YM=%@&ATTACHMENT_ID=%@&ATTACHMENT_NAME=%@&SID=%@",[hubDict objectForKey:@"url"],[hubDict objectForKey:@"MODULE"],[hubDict objectForKey:@"YM"],[hubDict objectForKey:@"ATTACHMENT_ID"],[hubDict objectForKey:@"ATTACHMENT_NAME"],appDelegate.SID];
       //  NSLog(@"%@",dUrl);
        //dUrl=@"http://3dck.nb-rs.com/2013.docx";
        PublicDownLoadsBLL *pdownload=[[PublicDownLoadsBLL alloc]init];
        NSString *retStr= [pdownload DownLoadAction:[appendArray objectAtIndex:sender.tag-8899] url:dUrl fileSize:[hubDict objectForKey:@"SIZE"] fileID:[hubDict objectForKey:@"ATTACHMENT_ID"]];
        
      //  NSString *retStr= [pdownload DownLoadAction:@"测试打开 (test)sdf .docx" url:dUrl fileSize:[hubDict objectForKey:@"SIZE"] fileID:[hubDict objectForKey:@"ATTACHMENT_ID"]];
        
        
        
        [pdownload release];
        if([retStr isEqualToString:@"OK"]){
            //下载成功
            showretStr=@"开始下载！";
        }else if([retStr isEqualToString:@"EXIST"]){
            //已存在，但正在下载
            showretStr=@"该文件正在下载！";
        }else if([retStr isEqualToString:@"EXIST_Complete"]){
            //已存在，并且下载完成了。
            IsComplete=YES;
            //  showretStr=[Public_Tips objectForKey:@"Public_Tips_DownLoaded"];
        }else{
            //失败
            showretStr=[NSString stringWithFormat:@"错误：%@",retStr];
        }
    }
    if(IsComplete==NO){
        [ALToastView toastInView:self.view withText:showretStr];
    }
    
    
    
}


#pragma mark -- 每次现实之前的操作
-(void)viewWillAppear:(BOOL)animated
{
 
    @try {
        
        for (int i=0; i<[appendArray count]; i++) {
            NSString *filename= [appendArray objectAtIndex:i];
            NSString *targetPath=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:filename];
            UIButton *btn=(UIButton*)[self.view viewWithTag:8899+i];
            if([CommonHelper isExistFile:targetPath])//已经下载过一次该文件
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"openfile"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"openfile_press"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(OpenFileHub:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"down_press"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(StartDownLoadHub:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"publisDetails dealloc");
    appendArray=nil;
    downloadArray=nil;
    local_file_URL=nil;
    [super release];
}

@end
