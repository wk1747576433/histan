//
//  ISubmitTaskController.m
//  histan
//
//  Created by lyh on 1/9/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "ISubmitTaskController.h"

@interface ISubmitTaskController ()

@end

@implementation ISubmitTaskController

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
	self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    
    HISTANAPPAppDelegate *appDelegate=HISTANdelegate;
    self.navigationItem.title=appDelegate.CurPageTitile;
    
    //添加tab
    UIImageView *topTitleView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 40)];
    topTitleView.image=[UIImage imageNamed:@"public_tab_bg"];
    [self.view addSubview:topTitleView];
    
    ALLButton_1011=[UIButton buttonWithType:UIButtonTypeCustom];
    ALLButton_1013=[UIButton buttonWithType:UIButtonTypeCustom];
    ALLButton_1014=[UIButton buttonWithType:UIButtonTypeCustom];
    ALLButton_1011.frame=CGRectMake(3, 40, 103, 40);
    ALLButton_1013.frame=CGRectMake(106, 40, 103, 40);
    ALLButton_1014.frame=CGRectMake(209, 40, 103, 40);
    
   
    
    if([appDelegate.CurTaskTypeId isEqualToString:@"705"]){
        [ALLButton_1011 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
        
    }else if([appDelegate.CurTaskTypeId isEqualToString:@"706"]){
        [ALLButton_1013 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
        
    }else if([appDelegate.CurTaskTypeId isEqualToString:@"707"]){
        [ALLButton_1014 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
        
    }
    
    [ALLButton_1011 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_press"] forState:UIControlStateHighlighted];
    [ALLButton_1013 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_press"] forState:UIControlStateHighlighted];
    [ALLButton_1014 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_press"] forState:UIControlStateHighlighted];
    
    
    [ALLButton_1011 setTitle:@"未完成(..)"  forState:UIControlStateNormal];
    [ALLButton_1011 setTitleColor:[UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1 ] forState:UIControlStateNormal];
    ALLButton_1011.titleLabel.textAlignment=NSTextAlignmentCenter;
    ALLButton_1011.titleLabel.font=[UIFont systemFontOfSize:14];
    [ALLButton_1011 addTarget:self action:@selector(changeTabButtonFun:) forControlEvents:UIControlEventTouchUpInside];
    
    [ALLButton_1013 setTitle:@"未评价(..)" forState:UIControlStateNormal];
    [ALLButton_1013 setTitleColor:[UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1 ] forState:UIControlStateNormal];
    ALLButton_1013.titleLabel.font=[UIFont systemFontOfSize:14];
    ALLButton_1013.titleLabel.textAlignment=NSTextAlignmentCenter;
    [ALLButton_1013 addTarget:self action:@selector(changeTabButtonFun:) forControlEvents:UIControlEventTouchUpInside];
    
    [ALLButton_1014 setTitle:@"已评价(..)" forState:UIControlStateNormal];
    [ALLButton_1014 setTitleColor:[UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1 ] forState:UIControlStateNormal];
    ALLButton_1014.titleLabel.font=[UIFont systemFontOfSize:14];
    ALLButton_1014.titleLabel.textAlignment=NSTextAlignmentCenter;
    [ALLButton_1014 addTarget:self action:@selector(changeTabButtonFun:) forControlEvents:UIControlEventTouchUpInside];
    
    ALLButton_1011.tag=initTag+805;
    ALLButton_1013.tag=initTag+806;
    ALLButton_1014.tag=initTag+807;
    
    [self.view addSubview:ALLButton_1011];//防止空间加载 imgview 里没有 点击事件。
    [self.view addSubview:ALLButton_1013];
    [self.view addSubview:ALLButton_1014];
    
    
    
    //加载搜索条
    _uiSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _uiSearchBar.delegate=self;
    _uiSearchBar.placeholder=@"Search";
    [self.view addSubview:_uiSearchBar];
    [_uiSearchBar release];
    
    
    //添加表头  任务号  名称  提交人 提交时间
    UIImageView *tableviewHead=[[UIImageView alloc]initWithFrame:CGRectMake(0, 80,self.view.frame.size.width, 20)];
    [self.view addSubview:tableviewHead];
    
    //添加表头文字
    UILabel *taskNumber=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 42, 20)];
    taskNumber.text=@"任务号";
    taskNumber.font=[UIFont systemFontOfSize:12];
    taskNumber.textAlignment=NSTextAlignmentCenter;
    
    UILabel *taskName=[[UILabel alloc]initWithFrame:CGRectMake(49, 0, 161, 20)];
    taskName.text=@"名称";
    taskName.font=[UIFont systemFontOfSize:12];
    
    UILabel *taskSubmier=[[UILabel alloc]initWithFrame:CGRectMake(216, 0, 42, 20)];
    taskSubmier.text=@"提交人";
    taskSubmier.font=[UIFont systemFontOfSize:12];
    taskSubmier.textAlignment=NSTextAlignmentCenter;
    
    UILabel *taskSubmiDate=[[UILabel alloc]initWithFrame:CGRectMake(264, 0, 51, 20)];
    taskSubmiDate.text=@"提交时间";
    taskSubmiDate.font=[UIFont systemFontOfSize:12];
    taskSubmiDate.textAlignment=NSTextAlignmentCenter;
    
    [tableviewHead addSubview:taskNumber];
    [tableviewHead addSubview:taskName];
    [tableviewHead addSubview:taskSubmier];
    [tableviewHead addSubview:taskSubmiDate];
    [tableviewHead release];
    
    //添加 table view
    _uiTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-143) style:UITableViewStylePlain];
    [_uiTableView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
    [_uiTableView setDelegate:self];
    [_uiTableView setDataSource:self];
    [_uiTableView setTag:102];
    [self.view addSubview:_uiTableView];
    
    
    //注册一个隐藏键盘的方法
    UITapGestureRecognizer *_myTapGr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTppedHideKeyBorad:)];
    _myTapGr.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:_myTapGr];
    
    //第一次加载是第一页
    _curPageCount=1;
    
    //集成下拉刷新控件
    header = [MJRefreshHeaderView header];
    header.scrollView = _uiTableView;
    header.delegate = self;
    
    //集成上拉刷新
    footer = [MJRefreshFooterView footer];
    footer.scrollView = _uiTableView;
    
    // 进入上拉加载状态就会调用这个方法
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        _curPageCount++;
        //IsSerch = NO;
        //加载数据
        [self LoadDataSourceByTaskTypeId:appDelegate.CurTaskTypeId pageCount:_curPageCount pageSize:15  taskname:@"" taskdesc:@"" IsShowHud:NO];
        
    };
    
    
    //0.5秒后自动下拉刷新
    //[header performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0.5];
    
    [self LoadDataSourceByTaskTypeId:appDelegate.CurTaskTypeId pageCount:_curPageCount pageSize:15 taskname:@"" taskdesc:@""  IsShowHud:YES];
}

#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    HISTANAPPAppDelegate *appDelegate=HISTANdelegate;
    //IsSerch = NO;
    //在这里刷新数据
    if (refreshView == header) { // 下拉刷新
        //IsHeader=YES;
        _curPageCount = 1;
        
        //清空中间集合。
        //[_Model_ProductListArrays removeAllObjects];
        [self LoadDataSourceByTaskTypeId:appDelegate.CurTaskTypeId pageCount:_curPageCount pageSize:15 taskname:@"" taskdesc:@""  IsShowHud:NO];
        
    }else{
        //IsHeader=NO;
    }
}

//点击空白处隐藏键盘
-(void)viewTppedHideKeyBorad:(UITapGestureRecognizer*)tapGr{
    [_uiSearchBar resignFirstResponder];
    _uiSearchBar.showsCancelButton=NO;
    
}

-(void)changeTabButtonFun:(UIButton*)sender{
    
    [ALLButton_1011 setBackgroundImage:nil forState:UIControlStateNormal];
    //[ALLButton_1012 setBackgroundImage:nil forState:UIControlStateNormal];
    [ALLButton_1013 setBackgroundImage:nil forState:UIControlStateNormal];
    [ALLButton_1014 setBackgroundImage:nil forState:UIControlStateNormal];
    
    int tag=sender.tag;
    NSString *CurTaskTypeId=@"0";
    if(tag-initTag==805){
        CurTaskTypeId=@"705";
        [ALLButton_1011 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
        
    }else if(tag-initTag==806){
        CurTaskTypeId=@"706";
        [ALLButton_1013 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
    }else if(tag-initTag==807){
        CurTaskTypeId=@"707";
        [ALLButton_1014 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
    }
    
    
    //加载数据
    [self LoadDataSourceByTaskTypeId:CurTaskTypeId pageCount:_curPageCount pageSize:15 taskname:@"" taskdesc:@""  IsShowHud:YES];
    
}

-(void)LoadDataSourceByTaskTypeId:(NSString *)TaskTypeId pageCount:(int)pageCount pageSize:(int)pageSize taskname:(NSString *)taskname taskdesc:(NSString *)taskdesc  IsShowHud:(BOOL)IsShowHud{
    
    
    if (IsShowHud) {
        //开始加载
        HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];  
        
        //常用的设置  
        //小矩形的背景色  
        //        HUD.color = [UIColor blueColor];//这儿表示无背景  
        //显示的文字  
        HUD.labelText = @"加载中...";  
        //细节文字  
        //HUD.detailsLabelText = @"Test detail";  
        //是否有庶罩  
        HUD.dimBackground = YES;
    }
    
    
    
    
    //参数数组
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    NSString *taskstatus=@"0";
    if([TaskTypeId isEqualToString:@"705"]){
        taskstatus=@"0";
    }else if([TaskTypeId isEqualToString:@"706"]){
        taskstatus=@"1";
    }else if([TaskTypeId isEqualToString:@"707"]){
        taskstatus=@"2";
    }
    
     
    
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"taskid",@"",@"taskname",taskname,@"taskdesc",taskdesc,@"taskstatus",taskstatus,@"creattimeFr",@"",@"creattimeTo",@"",@"completetimeFr",@"",@"completetimeTo",@"",@"page",[NSString stringWithFormat:@"%d",pageCount],@"pageSize",[NSString stringWithFormat:@"%d",pageSize],nil];
    
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_SelectTask_Sub wsParameters:wsParas];
    [wsParas release];
    
   [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:ALLButton_1011,@"button1",ALLButton_1013,@"button2",ALLButton_1014,@"button3",@"submitter",@"StatisticsType",nil];
    [NSThread detachNewThreadSelector:@selector(LoadHnadOrSubmitStatistics:) toTarget:[HLSOFTThread defaultCacher] withObject:dic];
    
}


//加载数据出错。
-(void)requestDidFailed:(ASIHTTPRequest*)request{
    
    [header endRefreshing];
    [footer endRefreshing];
    
    if(HUD!=nil){
        HUD.mode = MBProgressHUDModeCustomView; 
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease]; 
        HUD.labelText = @"网络连接错误，请检查网络！";  
        [HUD hide:YES afterDelay:2];
        
    }
}

//加载成功，现实到页面。
-(void)requestDidSuccess:(ASIHTTPRequest*)requestLoadSource{
    
    [header endRefreshing];
    [footer endRefreshing];
    
    if(HUD!=nil){
        [HUD hide:YES];
        [HUD removeFromSuperview];
        [HUD release];
        HUD=nil;
    }
    //histan_NSLog(@"ok");
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获取返回的json数据
    NSString *returnString = [soapPacking getReturnFromXMLString:[requestLoadSource responseString]];
    NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
    NSString *error = (NSString *)[dic objectForKey:@"error"];
    //histan_NSLog(@"dic 的数据是%@",dic);
    if ([error intValue] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败" delegate:self cancelButtonTitle:@"I know" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        
        
        
        NSDictionary *retAboutData=[dic objectForKey:@"data"];
        
        @try {
            _curLoadDataSource=nil;
            _curLoadDataSource=[[NSArray alloc]init];
            _curLoadDataSource=[retAboutData objectForKey:@"list"]; 
            [_curLoadDataSource retain];
            //histan_NSLog(@"%@",retAboutData);
            //histan_NSLog(@"_curLoadDataSource:%@，%d",_curLoadDataSource,[_curLoadDataSource count]);
            [_uiTableView reloadData];
        }
        @catch (NSException *exception) {
            NSString *showStr=[NSString stringWithFormat:@"%@",retAboutData];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        @finally {
            
        }
        
        
    }
    
    
}

//设置显示多少行tableviewcell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_curLoadDataSource count];
}

//加载数据
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier=[NSString stringWithFormat:@"%@%d",@"histan_TaskCell",indexPath.row];
    IDealTaskTableViewCell *cell=(IDealTaskTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        NSArray *nib= [[NSBundle mainBundle]loadNibNamed:@"IDealTaskTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    //得到当前行的数据
    NSDictionary *dict=[_curLoadDataSource objectAtIndex:indexPath.row];
    
    //时间戳转换
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];  
    [formatter setDateStyle:NSDateFormatterMediumStyle];  
    [formatter setTimeStyle:NSDateFormatterShortStyle];     
    [formatter setDateFormat:@"YY-MM-dd"];
    int val=[[dict objectForKey:@"createtime"] intValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:val];        
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];  
    
    //histan_NSLog(@"%@",[dict objectForKey:@"taskid"]);
    
    cell.TaskName.text=[dict objectForKey:@"taskname"];
    cell.TaskNumber.text=[dict objectForKey:@"taskid"];
    cell.TaskSubmitDate.text=confromTimespStr;
    cell.TaskSubmiter.text=[dict objectForKey:@"submitter"];
    
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IDealTaskTableViewCell *cell=(IDealTaskTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    //记录当前选择的任务ID
    HISTANAPPAppDelegate *appdelegate=HISTANdelegate;
    appdelegate.CurTaskId=cell.TaskNumber.text;
    
    IDealTaskDetailsController *idealTaskDetails=[[IDealTaskDetailsController alloc]init];
    [self.navigationController pushViewController:idealTaskDetails animated:YES];
    [idealTaskDetails release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    //取消和清除当前网络请求
    [ASISOAPRequest clearDelegatesAndCancel];
    [ASISOAPRequest release];
    
    // [ASISOAPRequest_2 clearDelegatesAndCancel];
    // [ASISOAPRequest_2 release];
    //    [ALLButton_1011 release]; ALLButton_1011=nil;
    //    [ALLButton_1013 release];
    //    ALLButton_1013=nil;
    //    [ALLButton_1014 release];
    //    ALLButton_1014=nil;
    [super dealloc];
}

@end

