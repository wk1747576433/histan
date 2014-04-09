//
//  MyPerformMonthViewController.m
//  histan
//
//  Created by lyh on 1/23/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "MyPerformMonthViewController.h"

@interface MyPerformMonthViewController ()

@end

@implementation MyPerformMonthViewController

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
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    //histan_NSLog(@"appDelegate month and num_task == %@,%@",appDelegate.month,appDelegate.num_task);
    
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    self.navigationItem.title=appDelegate.CurPageTitile;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //实例化月绩效数组
    perfromeMonth = [[NSArray alloc] init];
    
    //添加tab
    UIImageView *topTitleView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    topTitleView.image=[UIImage imageNamed:@"public_tab_bg"];
    topTitleView.userInteractionEnabled = YES;
    
    //欢迎Lebel
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 100, 38)];
    [userLabel setText: [NSString stringWithFormat:@"用户:%@",appDelegate.UserName]];
    [userLabel setFont:[UIFont systemFontOfSize:16]];
    [userLabel setBackgroundColor:[UIColor clearColor]];
    
    //年-月份显示
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(106, 1, 105, 38)];
    [yearLabel setText:[NSString stringWithFormat:@"月份:%@",appDelegate.month]];
    [yearLabel setFont:[UIFont systemFontOfSize:16]];
    [yearLabel setBackgroundColor:[UIColor clearColor]];
    
    //任务数量显示
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(212, 1, 107, 38)];
    [numLabel setText:[NSString stringWithFormat:@"任务数量:%@",appDelegate.num_task]];
    [numLabel setFont:[UIFont systemFontOfSize:16]];
    [numLabel setBackgroundColor:[UIColor clearColor]];
    
    
    //表头,月份，任务数量，绩效分值，管理分值，最终得分
    UILabel *tabelHeard = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 30)];
    [tabelHeard setText:@"  任务号        任务名称         评价     实效     绩效"];
    [tabelHeard setFont:[UIFont systemFontOfSize:14]];
    [tabelHeard.layer setBorderWidth:1];
    [tabelHeard.layer setBorderColor:[UIColor grayColor].CGColor];
    
    //装在到topView
    [topTitleView addSubview:userLabel];
    [topTitleView addSubview:yearLabel];
    [topTitleView addSubview:numLabel];
    [topTitleView addSubview:tabelHeard];
    
    //绩效表
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, self.view.frame.size.height-115)];
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    
    [self.view addSubview:_tabelView];
    [self.view addSubview:topTitleView];
    
    //实例化存放所有数据的数组
    _allDataArray = [[NSMutableArray alloc] init];
    
    //第一次加载是第一页
    _curPageCount=1;
    
    //集成下拉刷新控件
    header = [MJRefreshHeaderView header];
    header.scrollView = _tabelView;
    header.delegate = self;
    
    //集成上拉刷新
    footer = [MJRefreshFooterView footer];
    footer.scrollView = _tabelView;
    footer.delegate = self;
    
    // 进入上拉加载状态就会调用这个方法
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        _curPageCount++;
        if(_curPageCount <= _allpage){
            
            //加载数据
            [self performSelector:@selector(getMonthPerformanceList:) withObject:[NSString stringWithFormat:@"%d",_curPageCount]];
            
        }else{
            
            JSNotifier *notify = [[JSNotifier alloc]initWithTitle:@"已经加载了所有"];
            notify.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info_icon"]];
            [notify showFor:1.5];
            
            //1 秒后的计时器
            [self performSelector:@selector(hideRefreshing) withObject:nil afterDelay:0.6];
            
        }
        
        
    };


    //加载数据
    [self performSelector:@selector(getMonthPerformanceList:) withObject:[NSString stringWithFormat:@"%d",_curPageCount]];

}



-(void)hideRefreshing{
    [header endRefreshing];
    [footer endRefreshing];
}

#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //histan_NSLog(@"start mjrefresh");
    //在这里刷新数据
    if (refreshView == header) { // 下拉刷新
        _curPageCount = 1;
        //清空中间集合。
        [_allDataArray removeAllObjects];
        [self performSelector:@selector(getMonthPerformanceList:) withObject:[NSString stringWithFormat:@"%d",_curPageCount]];
        
    }else{
        
        //[self performSelector:@selector(getMonthPerformanceList:) withObject:[NSString stringWithFormat:@"%d",_curPageCount]];

    }
}



#pragma mark -- 获取月份绩效
-(void)getMonthPerformanceList:(NSString *)currentPage
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"加载中..."];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"Ymonth",appDelegate.month,@"page",currentPage,@"pageSize",@"20",nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Task_PF wsParameters:wsParas];
    ////histan_NSLog(@"发送的路径：%@",);
    
    //异步
    [ASISOAPRequest startAsynchronous];
    
    [ASISOAPRequest setCompletionBlock:^{
        [self performSelector:@selector(hideRefreshing)];
        [HUD hide:YES];
        ////histan_NSLog(@"responsString-----------------%@",[ASISOAPRequest responseString]);
        
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        ////histan_NSLog(@"allDic --- %@",allDic);
        ////histan_NSLog(@"allDic  objectForKey:@data--- %@",[allDic objectForKey:@"data"]);
        
        //这里没有任务信息的时候会返回@“没有任务信息”，要判断error，如果有错，则月绩效数组为空
        NSString *error =[NSString stringWithFormat:@"%@",[allDic objectForKey:@"error"]] ;
             
        if ([error isEqualToString:@"1"]) {
            //没有信息
        }
        else
        {
            //如果返回的data不为null，则把data赋给performanceArray，否则数据为@“该年份没有数据”
            id dataNull = [allDic objectForKey:@"data"];

            //histan_NSLog(@"the data:%@",dataNull);
            if ([[allDic objectForKey:@"data"] isEqual:[NSNull null]]) {
                //histan_NSLog(@"data 数据为空");
                [_tabelView reloadData];
            }
            else
            {
                
                NSDictionary *tempDic = [allDic objectForKey:@"data"];
                //记录总页数
                _allpage = [[tempDic objectForKey:@"allpage"] intValue];
                //histan_NSLog(@"_allpage == %d",_allpage);
                
                id listNull = [tempDic objectForKey:@"list"];
                if ([listNull isEqual:[NSNull null]]) {
                    [_tabelView reloadData];
                }
                else
                {
                    //记录月绩效数组
                    perfromeMonth = (NSMutableArray *)[tempDic objectForKey:@"list"];
                    //histan_NSLog(@"月绩效数组：%@",perfromeMonth);
                    
                    [_allDataArray addObjectsFromArray:perfromeMonth];
                    [_allDataArray retain];
                    
                    //加载成功后重新加载表数据
                    [_tabelView reloadData];
               
                }
            }

                }
        
    }];
    
    //请求失败
    [ASISOAPRequest setFailedBlock:^{
        [self performSelector:@selector(hideRefreshing)];
        [HUD hide:YES];
        NSError *error = [ASISOAPRequest error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！您的网络目前可能不给力哦^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        //histan_NSLog(@"请求超时！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
    }];
    

}









#pragma mark -- uitabelView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_allDataArray count];
    //histan_NSLog(@"performanceArray count %d",[_allDataArray count]);
}

//cell的加载
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=[NSString stringWithFormat:@"%@%d",@"Cell",indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        //NSArray *nib= [[NSBundle mainBundle]loadNibNamed:@"IDealTaskTableViewCell" owner:self options:nil];
        //cell=[nib objectAtIndex:0];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
     
    if ([_allDataArray count] > 0) {
        NSDictionary *itemDic = [_allDataArray objectAtIndex:indexPath.row];
        NSString *taskId = [itemDic objectForKey:@"ID"];
        NSString *taskName = [itemDic objectForKey:@"TASK_NAME"];
        NSString *PJFZ = [itemDic objectForKey:@"SCORE"];
        NSString *SXFZ = [itemDic objectForKey:@"T_SCORE"];
        NSString *JXFZ = [itemDic objectForKey:@"PERF"];
        //NSString *status =[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"STATUS"]] ;
        
        if (!PJFZ) {
            PJFZ = @"0";
        }
        if(!SXFZ)
        {
            SXFZ = @"0";
        }
        if(!JXFZ)
        {
            JXFZ = @"0";
        }
        
        
        //任务号
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 50, 38)];
        [idLabel setText:taskId];
        [idLabel setTag:-12622];
        [idLabel setFont:[UIFont systemFontOfSize:14.0]];
        [idLabel setTextAlignment:NSTextAlignmentCenter];
        
        //任务名称
        UILabel *taskNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 1, 113, 38)];
        [taskNameLabel setText:taskName];
        [taskNameLabel setFont:[UIFont systemFontOfSize:14.0]];
        [taskNameLabel setTextAlignment:NSTextAlignmentCenter];
        
        //评价分值
        UILabel *pjfzLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 1, 40, 38)];
        [pjfzLabel setText:PJFZ];
        [pjfzLabel setTextAlignment:NSTextAlignmentCenter];
        
        //时效分值
        UILabel *sxfzLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 1, 50, 38)];
        [sxfzLabel setText:SXFZ];
        [sxfzLabel setTextAlignment:NSTextAlignmentCenter];
        
        //绩效分值
        UILabel *jxfzLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 1, 50, 38)];
        [jxfzLabel setText:JXFZ];
        [jxfzLabel setTextAlignment:NSTextAlignmentCenter];
        
        //添加一个隐藏的任务状态label
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, 20, 38)];
        [statusLabel setTag:-12623];
        //[statusLabel setText:status];
        
        [cell.contentView addSubview:idLabel];
        [cell.contentView addSubview:taskNameLabel];
        [cell.contentView addSubview:pjfzLabel];
        [cell.contentView addSubview:sxfzLabel];
        [cell.contentView addSubview:jxfzLabel];
        [cell.contentView addSubview:statusLabel];
        
    }
}
    return  cell;
    
}

//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        
    //UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:-12623];
    UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:-12622];
//    if ([label1.text isEqualToString:@"0"]) {
//        //任务未完成
//        appDelegate.CurTaskTypeId = @"702";
//    }
//    else if([label1.text isEqualToString:@"1"])
//    {
//        //任务未评价
//        appDelegate.CurTaskTypeId = @"703";
//    }
//    else
//    {
//        //任务已结案
//        appDelegate.CurTaskTypeId = @"704";
//    }
    appDelegate.CurTaskTypeId = @"704";
    appDelegate.CurTaskId = label2.text;

    [label2 release];
    //[label1 release];
    
    //自定义返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
//    //跳转至月绩效
//    appDelegate.CurPageTitile = @"月份绩效";
//    MyPerformMonthViewController *monthVC = [[MyPerformMonthViewController alloc] init];
//    [self.navigationController pushViewController:monthVC animated:YES];
//    
    IDealTaskDetailsController *idealTaskDetails=[[IDealTaskDetailsController alloc]init];
    [self.navigationController pushViewController:idealTaskDetails animated:YES];
    [idealTaskDetails release];
    
}

-(void)viewWillAppear:(BOOL)animated
{ 
    //_tabelView 的选中取消效果
    [_tabelView deselectRowAtIndexPath:[_tabelView indexPathForSelectedRow] animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
