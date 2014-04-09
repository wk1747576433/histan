//
//  MyPerformanceController.m
//  histan
//
//  Created by liu yonghua on 14-1-11.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import "MyPerformanceController.h"

@implementation MyPerformanceController
{
    UIButton *showYearsBtn;
}

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
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    selectYear = nil;
    performanceArray = [[NSMutableArray alloc] init];
    yearsArray = [[NSMutableArray alloc] init];
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY"];
    int YYYY = [[df stringFromDate:nowDate]intValue];
    
    //最多到当前年份
    for (int i = 2008; i<=YYYY; i++) {
        NSString *iStr = [NSString stringWithFormat:@"%d",i];
        [yearsArray addObject:iStr];
    }
    
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    self.navigationItem.title = appDelegate.CurPageTitile;
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //添加tab
    UIImageView *topTitleView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    topTitleView.image=[UIImage imageNamed:@"public_tab_bg"];
    topTitleView.userInteractionEnabled = YES;

    //欢迎Lebel
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 150, 38)];
    [userLabel setText: [NSString stringWithFormat:@"用户:%@",appDelegate.UserName]];
    [userLabel setBackgroundColor:[UIColor clearColor]];
    
    //年份选择
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(162, 1, 42, 35)];
    [yearLabel setText:@"年份:"];
    [yearLabel setBackgroundColor:[UIColor clearColor]];
    
    //选择按钮
    UIButton *yearSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yearSelectBtn setFrame:CGRectMake(210, 5, 105, 28)];
    [yearSelectBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"select_item_bg.png"]]];
    [yearSelectBtn setBackgroundImage:[UIImage imageNamed:@"select_item_bg.png"] forState:UIControlStateNormal];
    //添加点击事件。弹出年份选择框
    [yearSelectBtn addTarget:self action:@selector(showTheYearSelect:) forControlEvents:UIControlEventTouchUpInside];
    //设置默认年份
    
    selectYear = [df stringFromDate:nowDate];
    [yearSelectBtn setTitle:selectYear forState:UIControlStateNormal];
    [yearSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //表头,月份，任务数量，绩效分值，管理分值，最终得分
    UILabel *tabelHeard = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 30)];
    [tabelHeard setText:@"  月份   任务数量   绩效分值   管理分值   最终得分"];
    [tabelHeard setFont:[UIFont systemFontOfSize:14]];
    [tabelHeard.layer setBorderWidth:1];
    [tabelHeard.layer setBorderColor:[UIColor grayColor].CGColor];
    
    //装在到topView
    [topTitleView addSubview:userLabel];
    [topTitleView addSubview:yearLabel];
    [topTitleView addSubview:yearSelectBtn];
    [topTitleView addSubview:tabelHeard];
    
    //绩效表
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, self.view.frame.size.height-115)];
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    
    [self.view addSubview:_tabelView];
    [self.view addSubview:topTitleView];

    //加载数据
    [self performSelector:@selector(getPerformanceList:) withObject:selectYear];
    
}


#pragma mark -- 选择时间按钮点击事件
-(void)showTheYearSelect:(UIButton *)sender
{
    //histan_NSLog(@"%s",__func__);
    
    //弹出选择框
    //初始化弹出框
    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
    CGFloat yHeight = 400;
    //如果数据较多，固定弹出选择框的高度
    if (yHeight > 400) {
        yHeight = 440;
    }
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    [poplistview setTag:initTag+1317];//设置标识
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = TRUE;
    poplistview.listView.showsVerticalScrollIndicator = NO;
    [poplistview show];
    
    showYearsBtn = (UIButton *)sender;
    
 
}

#pragma mark -- 获取绩效列表
-(void)getPerformanceList:(NSString *)theYear
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"加载中..."];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"year",theYear,nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Performance wsParameters:wsParas];
    ////histan_NSLog(@"发送的路径：%@",);

    //异步
    [ASISOAPRequest startAsynchronous];

    [ASISOAPRequest setCompletionBlock:^{
         [HUD hide:YES];
        ////histan_NSLog(@"responsString-----------------%@",[ASISOAPRequest responseString]);
        
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        //histan_NSLog(@"allDic --- %@",allDic);
        //histan_NSLog(@"allDic  objectForKey:@data--- %@",[allDic objectForKey:@"data"]);
        
        //如果返回的data不为null，则把data赋给performanceArray，否则数据为@“该年份没有数据”
        id dataNull = [allDic objectForKey:@"data"];
        //histan_NSLog(@"the data:%@",dataNull);
        if ([[allDic objectForKey:@"data"] isEqual:[NSNull null]]) {
            //histan_NSLog(@"data 数据为空");
            performanceArray = [[NSMutableArray alloc] init];
            [_tabelView reloadData];
        }
        else
        {
            //记录绩效数组
            performanceArray = (NSMutableArray *)[allDic objectForKey:@"data"];
            //histan_NSLog(@"绩效数组：%@",performanceArray);
            [performanceArray retain];
            //加载成功后重新加载表数据
            [_tabelView reloadData];
        }
        
        
    }];
    
    //请求失败
    [ASISOAPRequest setFailedBlock:^{
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
    
    return [performanceArray count];
    //histan_NSLog(@"performanceArray count %d",[performanceArray count]);
}

//cell的加载
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=[NSString stringWithFormat:@"%@%d",@"histan_performCell",indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        //NSArray *nib= [[NSBundle mainBundle]loadNibNamed:@"IDealTaskTableViewCell" owner:self options:nil];
        //cell=[nib objectAtIndex:0];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
    }
    
    if ([performanceArray count] > 0) {
        NSDictionary *itemDic = [performanceArray objectAtIndex:indexPath.row];
        NSString *GLJX = [itemDic objectForKey:@"GLJX"];
        NSString *JXFZ = [itemDic objectForKey:@"JXFZ"];
        NSString *MONTH = [itemDic objectForKey:@"MONTH"];
        NSString *NUM_TASK = [itemDic objectForKey:@"NUM_TASK"];
        NSString *ZZJX = [itemDic objectForKey:@"ZZJX"];
        
        //月份
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 50, 38)];
        [monthLabel setText:MONTH];
        [monthLabel setTag:-12612];
        [monthLabel setTextAlignment:NSTextAlignmentCenter];
        
        //任务条数
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 1, 65, 38)];
        [numLabel setText:NUM_TASK];
        [numLabel setTag:-12613];
        [numLabel setTextAlignment:NSTextAlignmentCenter];
        
        //绩效分值
        UILabel *jxfzLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 1, 65, 38)];
        [jxfzLabel setText:JXFZ];
        [jxfzLabel setTextAlignment:NSTextAlignmentCenter];
        
        //管理分值
        UILabel *gljxLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 1, 65, 38)];
        [gljxLabel setText:GLJX];
        [gljxLabel setTextAlignment:NSTextAlignmentCenter];
        
        //最终得分
        UILabel *zzjxLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 1, 70, 38)];
        [zzjxLabel setText:ZZJX];
        [zzjxLabel setTextAlignment:NSTextAlignmentCenter];
        
        [cell.contentView addSubview:monthLabel];
        [cell.contentView addSubview:numLabel];
        [cell.contentView addSubview:jxfzLabel];
        [cell.contentView addSubview:gljxLabel];
        [cell.contentView addSubview:zzjxLabel];
        
    }
    return  cell;

}

//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:-12612];
    UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:-12613];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    appDelegate.month = [NSString stringWithFormat:@"%@-%@",selectYear,label1.text];
    //histan_NSLog(@"appDelegate month = %@",appDelegate.month);
    appDelegate.num_task = label2.text;
    //histan_NSLog(@"appDelegate num_task = %@",appDelegate.num_task);
    [label1 release];
    [label2 release];
    
    //自定义返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    //跳转至月绩效
    appDelegate.CurPageTitile = @"月份绩效";
    MyPerformMonthViewController *monthVC = [[MyPerformMonthViewController alloc] init];
    [self.navigationController pushViewController:monthVC animated:YES];
    
}



#pragma mark - UIPopoverListViewDataSource
//UIPopoverListView加载cell
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    // NSInteger tag = poplistview.tag;
    
    NSString *identifier =[NSString stringWithFormat:@"cell_%d",indexPath.row];
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] autorelease];
    int row = indexPath.row;
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = [yearsArray objectAtIndex:row];
    [poplistview setTitle:@"请选择年份"];
    
    return cell;
}

//UIPopoverListView行数
- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return [yearsArray count];
}


#pragma mark - UIPopoverListViewDelegate 弹出窗口代理事件
//UIPopoverListViewcell被选择后的操作
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [poplistview.listView cellForRowAtIndexPath:indexPath];
    selectYear = cell.textLabel.text;
    
    [showYearsBtn setTitle:selectYear forState:UIControlStateNormal];
    
    //如果选择的年份改变了，就要重新加载对应年份的数据
    [self performSelector:@selector(getPerformanceList:) withObject:selectYear];
    
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //_tabelView 的选中取消效果
    [_tabelView deselectRowAtIndexPath:[_tabelView indexPathForSelectedRow] animated:YES];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
