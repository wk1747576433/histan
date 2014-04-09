//
//  LogisticsCenterViewController.m
//  histan
//
//  Created by lyh on 1/24/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "LogisticsCenterViewController.h"

@interface LogisticsCenterViewController ()

@end

@implementation LogisticsCenterViewController

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
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
     
    //初始化数据源
    _allDataArray = [[NSMutableArray alloc] init];
    [_allDataArray retain];
    
    //默认选择日期为当天(在请求数据时要化成时间戳)
    _selectDate = [NSDate date];
    [_selectDate retain];
    //histan_NSLog(@"当前默认选择日期：%@",_selectDate);
    //测试需要固定为2014-01-23
    
    //初始化弹出时间段选择列表
    popListView = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, 5, 300, 400)];
    popListView.delegate = self;
    popListView.datasource = self;
    popListView.listView.scrollEnabled = TRUE;
    popListView.listView.showsVerticalScrollIndicator = NO;
    [popListView setTitle:@"请选择时间段"];

    //设置刚进入详情页时显示的数据的状态
    appDelegate.curOutBoundStatus = @"1";//未送货
    //默认当前的单子的状态为1（未送货）
    _currentStatus = @"1";
    
    //默认当前页数为1
    _curPageCount = 1;
    
    IsSerch = NO;
    IsFirstLoadOK=NO;
    
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    
    
    self.navigationItem.title=appDelegate.CurPageTitile;
    
    //添加tab
    UIImageView *topTitleView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 40)];
    topTitleView.image=[UIImage imageNamed:@"public_tab_bg"];
    [self.view addSubview:topTitleView];
    
    ALLButton_wsh=[UIButton buttonWithType:UIButtonTypeCustom];
    ALLButton_ysh=[UIButton buttonWithType:UIButtonTypeCustom];
    ALLButton_shsb=[UIButton buttonWithType:UIButtonTypeCustom];
    ALLButton_wsh.frame=CGRectMake(3, 40, 103, 40);
    ALLButton_ysh.frame=CGRectMake(106, 40, 103, 40);
    ALLButton_shsb.frame=CGRectMake(209, 40, 103, 40);

    //默认选中未送货的按钮
    
    [ALLButton_wsh setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
    
    [ALLButton_wsh setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_press"] forState:UIControlStateHighlighted];
    [ALLButton_ysh setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_press"] forState:UIControlStateHighlighted];
    [ALLButton_shsb setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_press"] forState:UIControlStateHighlighted];
    

    
    [ALLButton_wsh setTitle:@"未送货(..)"  forState:UIControlStateNormal];
    [ALLButton_wsh setTitleColor:[UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1 ] forState:UIControlStateNormal];
    ALLButton_wsh.titleLabel.textAlignment=NSTextAlignmentCenter;
    ALLButton_wsh.titleLabel.font=[UIFont systemFontOfSize:14];
    [ALLButton_wsh addTarget:self action:@selector(TabButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    [ALLButton_ysh setTitle:@"已送货(..)" forState:UIControlStateNormal];
    [ALLButton_ysh setTitleColor:[UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1 ] forState:UIControlStateNormal];
    ALLButton_ysh.titleLabel.font=[UIFont systemFontOfSize:14];
    ALLButton_ysh.titleLabel.textAlignment=NSTextAlignmentCenter;
    [ALLButton_ysh addTarget:self action:@selector(TabButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    [ALLButton_shsb setTitle:@"送货失败(..)" forState:UIControlStateNormal];
    [ALLButton_shsb setTitleColor:[UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1 ] forState:UIControlStateNormal];
    ALLButton_shsb.titleLabel.font=[UIFont systemFontOfSize:14];
    ALLButton_shsb.titleLabel.textAlignment=NSTextAlignmentCenter;
    [ALLButton_shsb addTarget:self action:@selector(TabButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [ALLButton_wsh setTag:initTag + 882];
    [ALLButton_ysh setTag:initTag + 883];
    [ALLButton_shsb setTag:initTag + 884];
    
    [self.view addSubview:ALLButton_wsh];//防止控件加载 imgview 里没有 点击事件。
    [self.view addSubview:ALLButton_ysh];
    [self.view addSubview:ALLButton_shsb];
    
    
    UIImageView *topSearchbg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    topSearchbg.image=[UIImage imageNamed:@"public_tab_head_bg"];
    [self.view addSubview:topSearchbg];
    topSearchbg.userInteractionEnabled=YES;
    //添加日期按钮
    UILabel *sdateStr=[[UILabel alloc]initWithFrame:CGRectMake(8, 10, 80, 21)];
    sdateStr.text=@"选择日期：";
    sdateStr.font=[UIFont boldSystemFontOfSize:14];
    sdateStr.backgroundColor=[UIColor clearColor];
    [topSearchbg addSubview:sdateStr];
    
    //选择按钮
    UIButton *yearSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yearSelectBtn.tag=initTag+342;
    [yearSelectBtn setFrame:CGRectMake(89, 2, 200, 35)];
    [yearSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [yearSelectBtn setBackgroundImage:[UIImage imageNamed:@"search_state_1"] forState:UIControlStateNormal];
    [yearSelectBtn setBackgroundImage:[UIImage imageNamed:@"search_state_2"] forState:UIControlStateHighlighted]; 
    yearSelectBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    //添加点击事件。弹出年份选择框
    [yearSelectBtn addTarget:self action:@selector(selectDateBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [topSearchbg addSubview:yearSelectBtn];
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY-MM-dd"];
    NSString *dates=[NSString stringWithFormat:@"%@",[df stringFromDate:nowDate]];
    [yearSelectBtn setTitle:dates forState:UIControlStateNormal];
    
    //记录当前选择日期字符串，供详情页面显示
    appDelegate.boundList_curDate = dates;
    
    //添加一个透明的按钮覆盖住搜索框，点击按钮弹出日期选择框
//    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [topBtn setFrame:CGRectMake(0, 0, 320, 40)];
//    [topBtn addTarget:self action:@selector(selectDateBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:topBtn];
    
    //兼容ios 7 的高度
//    float _subHeight=124;
//    if (_IsIOS7_) {
//        _subHeight=128;
//    }
    //添加 table view
    _uiTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-123) style:UITableViewStylePlain];
    [_uiTableView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
    [_uiTableView setDelegate:self];
    [_uiTableView setDataSource:self];
    [self.view addSubview:_uiTableView];
    
    CGRect r_cg=mainScreen_CGRect;
    
    //添加一个日期选择器，先隐藏
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0,r_cg.size.height, 320, 300)];
    [_maskView setBackgroundColor:[UIColor whiteColor]];
    [_maskView setTag:-321546];
    
    //加入日期选择器(初始为影藏状态，当搜索框被点击收到键盘出现的通知后出现,收到键盘消失通知后消失)
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    [_datePicker setDate:[NSDate date]];
    [_datePicker setAccessibilityLanguage:@"Chinese"];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_datePicker addTarget:self action:@selector(pickerValueChang:) forControlEvents:UIControlEventValueChanged];
    
    //添加一个收起选择器的按钮
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定选择" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenThePicker:)];
    NSArray *barItems = [NSArray arrayWithObjects:spaceItem,doneItem, nil];
    [toolBar setItems:barItems];
    if (_IsIOS7_) {
        //[toolBar setBarTintColor:[UIColor grayColor]];
        toolBar.backgroundColor=[UIColor grayColor];
        [toolBar setBarStyle:UIBarStyleDefault];
    }else{
        [toolBar setBarStyle:UIBarStyleDefault];
    }
    [_maskView addSubview:_datePicker];
    [_maskView addSubview:toolBar];
    [self.view addSubview:_maskView];
    
    //获取状态统计
    [self performSelector:@selector(getStatusCount) withObject:_selectDate];
    //加载数据，先清空数据
    [_allDataArray removeAllObjects];
    [self performSelector:@selector(getOutboundList)];
    
    //集成下拉刷新控件
    header = [MJRefreshHeaderView header];
    header.scrollView = _uiTableView;
    header.delegate = self;
    
    //集成上拉刷新
    footer = [MJRefreshFooterView footer];
    footer.scrollView = _uiTableView;
    footer.delegate = self;
    
    // 进入上拉加载状态就会调用这个方法
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        _curPageCount++;
        if(_curPageCount <= _allpage){
            
            //加载数据
            [self performSelector:@selector(getOutboundList)];
            
        }else{
            
            JSNotifier *notify = [[JSNotifier alloc]initWithTitle:@"已经加载了所有"];
            notify.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info_icon"]];
            [notify showFor:1.5];
            
            //1 秒后的计时器
            [self performSelector:@selector(hideRefreshing) withObject:nil afterDelay:0.6];
            
        }
        
        
    };

    
    
    //获取状态统计
    [self performSelector:@selector(getStatusCount) withObject:_selectDate];
    //获取时间段列表
    [self performSelector:@selector(getTimeList)];

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
        [self performSelector:@selector(getOutboundList)];
        
    }else{
        
        
    }
}


#pragma mark -- 搜索框覆盖按钮点击事件
-(void)selectDateBtnTaped:(UIButton *)sender
{
    //弹出日期选择框
    //显示日期选择框
    CGRect r_cg = mainScreen_CGRect;
    
    CGRect newFrame = CGRectMake(0, r_cg.size.height-300, 320, 300);
    [UIView beginAnimations:@"showTHePiker" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
}


#pragma mark -- 日期选择器日期改变事件
-(void)pickerValueChang:(UIDatePicker *)datePicker
{
//    NSDate *selectedDate = [datePicker date];
//    _selectDate = selectedDate;
//    //时间戳转换
//    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *confromTimespStr = [formatter stringFromDate:_selectDate];
//    [_uiSearchBar setText:confromTimespStr];
}



#pragma mark -- 键盘通知事件处理
//日期选择器确定选择事件
-(void)hiddenThePicker:(UIBarButtonItem *)barButtonItem
{
    CGRect r_cg = mainScreen_CGRect;
    
    //收起键盘，并隐藏picker
    UIView *pikerView = [self.view viewWithTag:-321546];
    CGRect newFrame = CGRectMake(0, r_cg.size.height, 320, pikerView.frame.size.height);
    [UIView beginAnimations:@"hiedThePikerView" context:nil];
    [pikerView setFrame:newFrame];
    [UIView commitAnimations];
    
    //记录所选日期
    _selectDate = _datePicker.date;
    [_selectDate retain];
    //histan_NSLog(@"所选的日期为：%@",_selectDate);
    //时间戳转换
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *confromTimespStr = [formatter stringFromDate:_selectDate];
    
    //显示在按钮上
    UIButton *yearSelectBtn =(UIButton*)[self.view viewWithTag:initTag+342];
    if ([yearSelectBtn.titleLabel.text isEqualToString:confromTimespStr]) {
        //用户没有改变选择
    }
    else
    {
        //只要用户改变了选择的日期，就改变搜索框的文字
        [yearSelectBtn setTitle:confromTimespStr forState:UIControlStateNormal];
        //请求数据
        [self performSelector:@selector(getStatusCount)];
        [self performSelector:@selector(getOutboundList)];
    }
}




#pragma mark -- 顶部送货状态按钮点击事件
-(void)TabButtonTaped:(UIButton *)sender
{
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    [ALLButton_wsh setBackgroundImage:nil forState:UIControlStateNormal];
    [ALLButton_ysh setBackgroundImage:nil forState:UIControlStateNormal];
    [ALLButton_shsb setBackgroundImage:nil forState:UIControlStateNormal];
    [_allDataArray removeAllObjects];
    //histan_NSLog(@"送货状态按钮为%d的按钮被点击",sender.tag);
    //根据tag值加载不同的数据
    int tag=sender.tag;
    if (tag == initTag +882) {
        //选中的是未送货
        
        [ALLButton_wsh setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
        
        //修改当前单子状态为1
        _currentStatus = @"1";
        //记录当前点击的是哪种状态
        appDelegate.curOutBoundStatus = _currentStatus;
        //根据当前的状态调用获取出库单列表
        [self performSelector:@selector(getOutboundList)];
    }else if(tag == initTag + 883)
    {
        [ALLButton_ysh setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
        //修改当前单子状态为2
        _currentStatus = @"2";
        //记录当前点击的是哪种状态
        appDelegate.curOutBoundStatus = _currentStatus;
        [self performSelector:@selector(getOutboundList)];
    }else
    {
        [ALLButton_shsb setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
        //修改当前单子状态为3
        _currentStatus = @"3";
        //记录当前点击的是哪种状态
        appDelegate.curOutBoundStatus = _currentStatus;
        [self performSelector:@selector(getOutboundList)];
        
        //单独有个方法获取失败的列表(没看懂怎么用...)
        //[self performSelector:@selector(getTheFailedList)];
    }
    
    
}

#pragma mark -- 获取送货单状态统计
-(void)getStatusCount
{
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:ALLButton_wsh,@"button1",ALLButton_ysh,@"button2",ALLButton_shsb,@"button3",[NSString stringWithFormat:@"%d",(int)[_selectDate timeIntervalSince1970]],@"dDate",nil];
    [NSThread detachNewThreadSelector:@selector(LoadLogisticsCenter_Status_Count:) toTarget:[HLSOFTThread defaultCacher] withObject:dic];
    
//    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    //[HUD setLabelText:@"加载中..."];
//    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;   
//    //将NSDate时间转化为时间戳
//    NSString *dateStr = [NSString stringWithFormat:@"%d",(int)[_selectDate timeIntervalSince1970]];
//    //初始化参数数组（必须是可变数组）
//    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"dDate",dateStr,nil];
//    //实例化OSAPHTTP类
//    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
//    //获得OSAPHTTP请求
//    ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Outbound_List_Status_Count wsParameters:wsParas];
//    //异步
//    [ASISOAPRequest startAsynchronous];
//    [ASISOAPRequest setCompletionBlock:^{
//        //获取返回的json数据
//        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
//        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
//        
//        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
//        //histan_NSLog(@"allDic --- %@",allDic);
//        //histan_NSLog(@"allDic  objectForKey:@data--- %@",[allDic objectForKey:@"data"]);
//        
//        //根据不同状态将相应数量显示出来
//        NSArray *tempArray = (NSArray *)[allDic objectForKey:@"data"];
//        for (NSDictionary *itemDic in tempArray) {
//            
//            NSString *statusStr = [NSString stringWithFormat:@"%@",[itemDic objectForKey:@"status"]];
//            NSString *statusNumStr = [NSString stringWithFormat:@"%@",[itemDic objectForKey:@"statusNum"]];
//            if ([statusStr isEqualToString:@"1"]) {
//                [ALLButton_wsh setTitle:[NSString stringWithFormat:@"未送货(%@)",statusNumStr] forState:UIControlStateNormal];
//            }
//            if ([statusStr isEqualToString:@"2"]) {
//                [ALLButton_ysh setTitle:[NSString stringWithFormat:@"已送货(%@)",statusNumStr] forState:UIControlStateNormal];
//            }
//            if ([statusStr isEqualToString:@"3"]) {
//                [ALLButton_shsb setTitle:[NSString stringWithFormat:@"送货失败(%@)",statusNumStr] forState:UIControlStateNormal];
//            }
//        }  
//    }];
//    
//    //请求失败
//    [ASISOAPRequest setFailedBlock:^{
//        NSError *error = [ASISOAPRequest error];
//        //histan_NSLog(@"请求超时！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
//    }];

}

#pragma mark -- 获取时间段列表
-(void)getTimeList
{
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Get_Arrive wsParameters:wsParas];
    //异步
    [ASISOAPRequest startAsynchronous];
    [ASISOAPRequest setCompletionBlock:^{
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];

        //histan_NSLog(@"allDic --- %@",allDic);
        //histan_NSLog(@"allDic  objectForKey:@data--- %@",[allDic objectForKey:@"data"]);
        timeArray = [[NSMutableArray alloc] init];
        //时间段数组
        NSArray *tempArray = (NSArray *)[allDic objectForKey:@"data"];
        for (NSDictionary *itemDic in tempArray) {
            [timeArray addObject:[itemDic objectForKey:@"timename"]];
        }
        [timeArray retain];
    }];
    
    //请求失败
    [ASISOAPRequest setFailedBlock:^{
        NSError *error = [ASISOAPRequest error];
        //histan_NSLog(@"请求超时！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
    }];

}


#pragma mark -- 获取相应状态下的送货单列表
-(void)getOutboundList
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"加载中..."];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    
    //histan_NSLog(@"当前选中的日期：%@",_selectDate);
    //将NSDate时间转化为时间戳
    NSString *dateStr = [NSString stringWithFormat:@"%d",(int)[_selectDate timeIntervalSince1970]];
    //histan_NSLog(@"当前选中的日期：%@",dateStr);
    //histan_NSLog(@"当前选中状态：%@",_currentStatus);
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"dDate",dateStr,@"status",_currentStatus,@"page",[NSString stringWithFormat:@"%d",_curPageCount],@"pageSize",@"10",nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Outbound_List wsParameters:wsParas];
    //异步
    [ASISOAPRequest startAsynchronous];
    
    [ASISOAPRequest setCompletionBlock:^{
        [HUD hide:YES];
        [self performSelector:@selector(hideRefreshing)];
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
       // //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        ////histan_NSLog(@"allDic --- %@",allDic);
        NSLog(@"allDic  objectForKey:@data--- %@",[allDic objectForKey:@"data"]);
        
        NSDictionary *dataDic = [allDic objectForKey:@"data"];
        //记录总页数
        _allpage = [[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"allpage"]] intValue];
        
        id list = [dataDic objectForKey:@"list"];
        [list retain];
       // //histan_NSLog(@"list = %@",list);
        
        @try {
            if ([list isEqualToString:@""]) {
                //histan_NSLog(@"list 数据为空");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前没有数据！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
               // [HUD setLabelText:@"该日期没有数据"];
                //[HUD hide:YES afterDelay:2.0];
                _allDataArray = [[NSMutableArray alloc] init];
                //_allDataArray = nil;
                //_allDataArray = [[NSMutableArray alloc] init];
                [_uiTableView reloadData];
            }

        }
        @catch (NSException *exception) {
            //histan_NSLog(@"list不为空");
            [HUD hide:YES];
            //记录数组
            NSArray *tempArray = (NSArray *)[dataDic objectForKey:@"list"];
            [_allDataArray addObjectsFromArray:tempArray];
            [tempArray release];
            [_allDataArray retain];
            //加载成功后重新加载表数据
            [_uiTableView reloadData];
        }
        @finally {
            
        }   
    }];
    
    //请求失败
    [ASISOAPRequest setFailedBlock:^{
        [HUD hide:YES];
        [self performSelector:@selector(hideRefreshing)];
        NSError *error = [ASISOAPRequest error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！您的网络目前可能不给力哦^_^" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        //histan_NSLog(@"请求超时！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
    }];

}

#pragma mark -- 获取失败列表
-(void)getTheFailedList
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"加载中..."];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    
    //histan_NSLog(@"当前选中的日期：%@",_selectDate);
    //将NSDate时间转化为时间戳
    NSString *dateStr = [NSString stringWithFormat:@"%d",(int)[_selectDate timeIntervalSince1970]];
    //histan_NSLog(@"当前选中的日期：%@",dateStr);
    //histan_NSLog(@"当前选中状态：%@",_currentStatus);
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"dDate",dateStr,@"page",[NSString stringWithFormat:@"%d",_curPageCount],@"pageSize",@"10",nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Outbound_Fail_List wsParameters:wsParas];
    //异步
    [ASISOAPRequest startAsynchronous];
    
    [ASISOAPRequest setCompletionBlock:^{
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        //histan_NSLog(@"allDic --- %@",allDic);
        //histan_NSLog(@"allDic  objectForKey:@data--- %@",[allDic objectForKey:@"data"]);
        
        NSDictionary *dataDic = [allDic objectForKey:@"data"];
        //记录总页数
        _allpage = [[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"allpage"]] intValue];
        
        id list = [dataDic objectForKey:@"list"];
        //histan_NSLog(@"list = %@",list);
        
        @try {
            if ([list isEqualToString:@""]) {
                //histan_NSLog(@"list 数据为空");
                [HUD setLabelText:@"该日期没有此状态下的数据"];
                [HUD hide:YES afterDelay:2.0];
                _allDataArray = [[NSMutableArray alloc] init];
                //_allDataArray = nil;
                //_allDataArray = [[NSMutableArray alloc] init];
                [_uiTableView reloadData];
            }
            
        }
        @catch (NSException *exception) {
            //histan_NSLog(@"list不为空");
            [HUD hide:YES];
            _allDataArray = (NSMutableArray *)[dataDic objectForKey:@"list"];
            ////histan_NSLog(@"绩效数组：%@",_allDataArray);
            [_allDataArray retain];
            //加载成功后重新加载表数据
            [_uiTableView reloadData];
        }
        @finally {
            
        }
    }];
    
    //请求失败
    [ASISOAPRequest setFailedBlock:^{
        [HUD hide:YES];
        NSError *error = [ASISOAPRequest error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！您的网络目前可能不给力哦^_^" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
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
    return 110;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_allDataArray count];
    //histan_NSLog(@"_allDataArray count %d",[_allDataArray count]);
}

//cell的加载
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=[NSString stringWithFormat:@"%@%d",@"histan_WuLiuCell",indexPath.row];
    WuLiuCell *cell=(WuLiuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        NSArray *nib= [[NSBundle mainBundle]loadNibNamed:@"WuLiuCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        /*数据示例
         {
         arrivedtime = "6-7";       //时间段
         cCode = XC140123FS0013;    //出库单号
         cMemo = "\U9000-HA1GGD-12T\U6362-HA1GGD-20Y  OA 80800 \U5bf9\U5e94\U9000\U5355XF140121FS0001";  //出库单备注
         cusAddr = "\U7985\U57ce\U533a\U5357\U5e84\U9547\U5357\U5e84\U6751\U5357\U4e09\U961f             //顾客地址\U5927\U8857\U7960\U5802\U5df750\U53f7";
         cusMobile = "13727444510/18144934902"; //顾客电话
         cusName = "\U7f57\U5065\U6c11";        //顾客姓名
         flag = 0;                              //退换货标志 1退货（红字） 0送货（蓝字）
         numberid = 10;                         //显示在最前面的，好像是编号...
         reservetime = "";                      //预计到达时间
         }
         
         
         NSString *textStr = [NSString stringWithFormat:@"%@(%@/%@)",nameStr,numStr1,numStr2];
         NSMutableAttributedString *endString = [[NSMutableAttributedString alloc] initWithString:textStr];
         
         [endString setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(nameStrLength+1,numStr1Length)];
         
         
         */
        if ([_allDataArray count] > 0) {
            NSDictionary *itemDic = [_allDataArray objectAtIndex:indexPath.row];
            NSString *numBerid = [itemDic objectForKey:@"numberid"];
            NSString *danHao = [itemDic objectForKey:@"cCode"]; //单号
            NSString *arrivedTime = [itemDic objectForKey:@"arrivedtime"];
            NSString *cusName = [itemDic objectForKey:@"cusName"];
            NSString *cusMobile = [itemDic objectForKey:@"cusMobile"];
            NSString *cusAddr = [itemDic objectForKey:@"cusAddr"];
            NSString *flagStr = [NSString stringWithFormat:@"%@",[itemDic objectForKey:@"flag"]];
 
            UIColor *textColor = [[UIColor alloc] init];
            if ([flagStr isEqualToString:@"0"]) {
                //送货  蓝色
                flagStr = @"送货";
                textColor = [UIColor blueColor];
            }
            else
            {
                //退货  红色
                flagStr = @"退货";
                textColor = [UIColor redColor];
            }

            NSString *danHaoStr = [NSString stringWithFormat:@"%@(%@)",danHao,flagStr];
            NSMutableAttributedString *endString = [[NSMutableAttributedString alloc] initWithString:danHaoStr];
            //histan_NSLog(@"单号字符串：%@  长度：%d",danHaoStr,danHaoStr.length);
            [endString setAttributes:@{NSForegroundColorAttributeName:textColor} range:NSMakeRange(danHaoStr.length -3, 2)];
            
            cell.numIdLabel.text = numBerid;
            [cell.codeIdLabel setAttributedText:endString];
            if ([arrivedTime isEqualToString:@""]) {
                [cell.timeBtn setTitle:@"未预约" forState:UIControlStateNormal];
                [cell.timeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else
            {
                [cell.timeBtn setTitle:[NSString stringWithFormat:@"%@点",arrivedTime] forState:UIControlStateNormal];
                [cell.timeBtn setTitleColor:[UIColor colorWithRed:50/255 green:79/255 blue:133/255 alpha:1] forState:UIControlStateNormal];
            }
            cell.nameLbel.text = [NSString stringWithFormat:@"%@",cusName];
            cell.addressLabel.text = [NSString stringWithFormat:@"%@",cusAddr];
            
            //显示手机号码
            UnderLineLabel *phoneNumLabel = [[UnderLineLabel alloc] initWithFrame:CGRectMake(2, 2, cell.phoneLabel.frame.size.width-4, cell.phoneLabel.frame.size.height-4)];
            
            [phoneNumLabel setText:[NSString stringWithFormat:@"%@",([cusMobile isEqualToString:@""] || cusMobile==nil)?@"":[cusMobile substringToIndex:11]]];
            [phoneNumLabel setBackgroundColor:[UIColor clearColor]];
            phoneNumLabel.textColor = [UIColor blueColor];
            [phoneNumLabel setFont:[UIFont systemFontOfSize:14.0]];
            //[phoneNumLabel addTarget:self action:@selector(callThePhone:)];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setFrame:phoneNumLabel.frame];
            [btn addTarget:self action:@selector(callThePhone:) forControlEvents:UIControlEventTouchUpInside];
            phoneNumLabel.shouldUnderline = YES;
            phoneNumLabel.userInteractionEnabled = YES;
            [phoneNumLabel addSubview:btn];
            cell.phoneLabel.userInteractionEnabled = YES;
            [cell.phoneLabel addSubview:phoneNumLabel];
 
            //有两个号码就要设置第二个显示手机号的label（phoneLabel2）
            if ([cusMobile rangeOfString:@"/"].location != NSNotFound) {
                //包含“/”符号，说明只有2个号码
                UnderLineLabel *phoneNumLabel = [[UnderLineLabel alloc] initWithFrame:CGRectMake(2, 2, cell.phoneLabel2.frame.size.width-4, cell.phoneLabel2.frame.size.height-4)];
                [phoneNumLabel setText:[NSString stringWithFormat:@"%@",[cusMobile substringWithRange:NSMakeRange(12, 11)]]];
                [phoneNumLabel setBackgroundColor:[UIColor clearColor]];
                phoneNumLabel.textColor = [UIColor blueColor];
                [phoneNumLabel setFont:[UIFont systemFontOfSize:14.0]];
                //[phoneNumLabel addTarget:self action:@selector(callThePhone:)];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundColor:[UIColor clearColor]];
                [btn setFrame:phoneNumLabel.frame];
                [btn addTarget:self action:@selector(callThePhone:) forControlEvents:UIControlEventTouchUpInside];
                phoneNumLabel.shouldUnderline = YES;
                phoneNumLabel.userInteractionEnabled = YES;
                [phoneNumLabel addSubview:btn];
                cell.phoneLabel2.userInteractionEnabled = YES;
                [cell.phoneLabel2 addSubview:phoneNumLabel];
            }

            if ([_currentStatus isEqualToString:@"1"]) {
                [cell.timeBtn addTarget:self action:@selector(showTheTimeList:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [cell.timeImg setImage:nil];
            }
        }
    }
        return  cell;   
}

//电话号码点击事件
-(void)callThePhone:(UIButton *)sender
{
    //histan_NSLog(@"%s",__func__);
    UnderLineLabel *label = (UnderLineLabel *)[sender superview];
    //histan_NSLog(@"电话号码：%@",label.text);
    //记录当前被点击的电话号码
    thePhoneNum = [NSString stringWithFormat:@"%@",label.text];
    [thePhoneNum retain];
    
    //弹出询问框，提示是否确认拨号
    NSString *messageStr = [NSString stringWithFormat:@"您确认要呼叫：%@吗？",thePhoneNum];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"拨号" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //histan_NSLog(@"theButtoneIndex:%d",buttonIndex);
    
    if (alertView.tag == -987456) {
        //当用户点击了确认后预约时间后
        if (buttonIndex == 0) {
            //调用修改预达时间的函数
            [self performSelector:@selector(changeTheArriveTime:forTheCode:) withObject:_selectedTime withObject:_currentDanhao];
        }
    }
    else
    {
        //当用户点击了确认后执行拨号
        if (buttonIndex == 0) {
            //histan_NSLog(@"thePhontNum:%@",thePhoneNum);
            NSString *telStr = [NSString stringWithFormat:@"tel://%@",thePhoneNum];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
        }
    }
}


//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WuLiuCell *cell = (WuLiuCell *)[tableView cellForRowAtIndexPath:indexPath];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    //记录单子对象
    appDelegate.boundList_curItemDic = [[NSDictionary alloc] init];
    NSString *danhaoStr = cell.codeIdLabel.text;
    NSArray *tempStrArray = [danhaoStr componentsSeparatedByString:@"("];
    //histan_NSLog(@"tempStrArray == %@",tempStrArray);
    danhaoStr = [tempStrArray objectAtIndex:0];
    //histan_NSLog(@"danhaoStr == %@",danhaoStr);
    for (NSDictionary *itemDic in _allDataArray) {
        if ([[itemDic objectForKey:@"cCode"] isEqualToString:danhaoStr]) {
            //记录单子
            appDelegate.boundList_curItemDic = itemDic;
        }
    }
    
    //自定义返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    
    //跳转至送货单详情页
    if ([appDelegate.curOutBoundStatus isEqualToString:@"1"]) {
        appDelegate.CurPageTitile = @"出库单详情(未送货)";
    }
    else if([appDelegate.curOutBoundStatus isEqualToString:@"2"])
    {
        appDelegate.CurPageTitile = @"出库单详情(已送货)";
    }
    else if([appDelegate.curOutBoundStatus isEqualToString:@"3"])
    {
        appDelegate.CurPageTitile = @"出库单详情(送货失败)";
    }
    
    BoundListDetailsViewController *boundListDetailsVC = [[BoundListDetailsViewController alloc] init];
    [self.navigationController pushViewController:boundListDetailsVC animated:YES];
    
}

#pragma mark -- 弹出时间段选择列表
-(void)showTheTimeList:(UIButton *)sender
{
    //记录是哪个按钮被点击
    _currentBtn= (UIButton *)sender;
    [_currentBtn retain];
    
    //弹出popuTableview
    [popListView show];
}

#pragma mark - UIPopoverListViewDataSource
//加载cell
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] autorelease];
    int row = indexPath.row;
    cell.textLabel.text = [timeArray objectAtIndex:row];
    return cell;
}

//行数
- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return [timeArray count];
}


#pragma mark - UIPopoverListViewDelegate
//cell被选择后的操作
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    //histan_NSLog(@"%s : %d", __func__, indexPath.row);
    // your code here
    UITableViewCell *cell = [popoverListView.listView cellForRowAtIndexPath:indexPath];
    
    //当前cell上的文字
    _selectedTime = cell.textLabel.text;
    [_selectedTime retain];
    
    //获得当前单号
    WuLiuCell *cellView;
    if (_IsIOS7_) {
        cellView = (WuLiuCell *)_currentBtn.superview.superview.superview;
    }else{
        cellView = (WuLiuCell *)[_currentBtn superview].superview;
    }
    
    NSString *danhaoStr = cellView.codeIdLabel.text;
    NSArray *tempStrArray = [danhaoStr componentsSeparatedByString:@"("];
    //histan_NSLog(@"tempStrArray == %@",tempStrArray);
    //保存
    _currentDanhao = [tempStrArray objectAtIndex:0];
    [_currentDanhao retain];

    //修改前询问是否确认预约9-10点上门
    NSString *msg = [NSString stringWithFormat:@"是否预约%@点上门？",_selectedTime];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert setTag:-987456];
    [alert show];
    [alert release];
//    //调用修改预达时间的函数
//    [self performSelector:@selector(changeTheArriveTime:forTheCode:) withObject:selectedText withObject:danhaoStr];
}

//修改预达时间函数
-(void)changeTheArriveTime:(NSString *)timeStr forTheCode:(NSString *)theCode
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"正在修改时间..."];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"cCode",theCode,@"timename",timeStr,nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Set_Arrived wsParameters:wsParas];
    //异步
    [ASISOAPRequest startAsynchronous];
    [ASISOAPRequest setCompletionBlock:^{
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        //histan_NSLog(@"allDic --- %@",allDic);
        //histan_NSLog(@"allDic  objectForKey:@data--- %@",[allDic objectForKey:@"data"]);
        NSString *resultStr = [NSString stringWithFormat:@"%@",[allDic objectForKey:@"data"]];
        if ([resultStr isEqualToString:@""]) {
            //如果成功
            NSString *time = [NSString stringWithFormat:@"%@点",timeStr];
            [_currentBtn setTitle:time forState:UIControlStateNormal];
            [_currentBtn setTitleColor:[UIColor colorWithRed:50/255 green:79/255 blue:133/255 alpha:1] forState:UIControlStateNormal];
            
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
            [HUD setLabelText:@"修改成功！"];
            [HUD hide:YES afterDelay:1.0];
        }
        else
        {
            [HUD setHidden:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改时间失败！请重试..." delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }];
    
    //请求失败
    [ASISOAPRequest setFailedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！请重试..." delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        NSError *error = [ASISOAPRequest error];
        //histan_NSLog(@"请求超时！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
    }];

}





- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [_uiTableView deselectRowAtIndexPath:[_uiTableView indexPathForSelectedRow] animated:YES];
    
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    
    if ([appDelegate.opeationSuccessNeedReloadPage isEqualToString:@"1"]) {
        //histan_NSLog(@"start11");
        appDelegate.opeationSuccessNeedReloadPage=@"0";
        //获取状态统计
        [self performSelector:@selector(getStatusCount) withObject:_selectDate];
        //加载数据，先清空数据
        [_allDataArray removeAllObjects];
        [self performSelector:@selector(getOutboundList)];
    }else{
        
    }
    
}

-(void)dealloc{
    NSLog(@"wuliuDetails dealloc");
}

@end
