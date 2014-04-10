//
//  ServicesCenterViewController.m
//  histan
//
//  Created by lyh on 1/26/14.
//  Copyright (c) 2014 histan. All rights reserved.
//

#import "ServicesCenterViewController.h"

@interface ServicesCenterViewController ()

@end

@implementation ServicesCenterViewController

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
    
    appDelegate = HISTANdelegate;
    
    IsSerch = NO;
    IsFirstLoadOK=NO;
    _status=@"1";
    _curSelectDate=@"";
    
    
    ////histan_NSLog(@"1390233600:%@",[HLSoftTools GetDataTimeStrByIntDate:@"1390233600" DateFormat:@"yyyy-MM-dd"]);
    
    
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    
    
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
    
    //默认选中第一个
    [ALLButton_1011 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
   
    [ALLButton_1011 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_press"] forState:UIControlStateHighlighted];
    [ALLButton_1013 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_press"] forState:UIControlStateHighlighted];
    [ALLButton_1014 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_press"] forState:UIControlStateHighlighted];
    
    
    [ALLButton_1011 setTitle:@"未服务(..)"  forState:UIControlStateNormal];
    [ALLButton_1011 setTitleColor:[UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1 ] forState:UIControlStateNormal];
    ALLButton_1011.titleLabel.textAlignment=NSTextAlignmentCenter;
    ALLButton_1011.titleLabel.font=[UIFont systemFontOfSize:14];
    [ALLButton_1011 addTarget:self action:@selector(changeTabButtonFun:) forControlEvents:UIControlEventTouchUpInside];
    
    [ALLButton_1013 setTitle:@"成功(..)" forState:UIControlStateNormal];
    [ALLButton_1013 setTitleColor:[UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1 ] forState:UIControlStateNormal];
    ALLButton_1013.titleLabel.font=[UIFont systemFontOfSize:14];
    ALLButton_1013.titleLabel.textAlignment=NSTextAlignmentCenter;
    [ALLButton_1013 addTarget:self action:@selector(changeTabButtonFun:) forControlEvents:UIControlEventTouchUpInside];
    
    [ALLButton_1014 setTitle:@"失败(..)" forState:UIControlStateNormal];
    [ALLButton_1014 setTitleColor:[UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1 ] forState:UIControlStateNormal];
    ALLButton_1014.titleLabel.font=[UIFont systemFontOfSize:14];
    ALLButton_1014.titleLabel.textAlignment=NSTextAlignmentCenter;
    [ALLButton_1014 addTarget:self action:@selector(changeTabButtonFun:) forControlEvents:UIControlEventTouchUpInside];
    
    
    ALLButton_1011.tag=initTag+802;
    ALLButton_1013.tag=initTag+803;
    ALLButton_1014.tag=initTag+804;
    
    
    
    [self.view addSubview:ALLButton_1011];//防止空间加载 imgview 里没有 点击事件。
    [self.view addSubview:ALLButton_1013];
    [self.view addSubview:ALLButton_1014];
    
     CGRect r_cg = mainScreen_CGRect;
    
    //添加一个日期选择器，先隐藏
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0,r_cg.size.height, 320, 300)];
    [_maskView setBackgroundColor:[UIColor whiteColor]];
    [_maskView setTag:-321546];
    
    //加入日期选择器(初始为影藏状态，当搜索框被点击收到键盘出现的通知后出现,收到键盘消失通知后消失)
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    [_datePicker setDate:[NSDate date]];
    [_datePicker setAccessibilityLanguage:@"Chinese"];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_datePicker addTarget:self action:@selector(valueChang:) forControlEvents:UIControlEventValueChanged];
    
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
  
    
    //加载搜索条
    //    _uiSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    //    _uiSearchBar.delegate=self;
    //    _uiSearchBar.placeholder=@"Search";
    //    [self.view addSubview:_uiSearchBar];
    //    [_uiSearchBar release];
    //
    //添加tab
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
   // [yearSelectBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"select_item_bg.png"]]];
    [yearSelectBtn setBackgroundImage:[UIImage imageNamed:@"search_state_1"] forState:UIControlStateNormal];
    [yearSelectBtn setBackgroundImage:[UIImage imageNamed:@"search_state_2"] forState:UIControlStateHighlighted];
    
    yearSelectBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    //添加点击事件。弹出年份选择框
    [yearSelectBtn addTarget:self action:@selector(showTheCalendarSelect:) forControlEvents:UIControlEventTouchUpInside];
    [topSearchbg addSubview:yearSelectBtn];
    // [yearSelectBtn release]; //由于后续要用到该按钮，所以不能释放
    [topSearchbg release];
    [sdateStr release];
    
    
    //兼容ios 7 的高度
    float _subHeight=124;
    if (_IsIOS7_) {
        _subHeight=130;
    }
    
    //添加 table view
    _uiTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-_subHeight)];
    [_uiTableView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
    [_uiTableView setDelegate:self];
    [_uiTableView setDataSource:self];
    [_uiTableView setTag:102];
    [self.view addSubview:_uiTableView];
    
    
    //注册一个隐藏键盘的方法
    //  UITapGestureRecognizer *_myTapGr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTppedHideKeyBorad:)];
    //  _myTapGr.cancelsTouchesInView=NO;
    //  [self.view addGestureRecognizer:_myTapGr];
    
    
    
    [self.view addSubview:_maskView];
    
    //实例化
    _allDataSourceArray=[[NSMutableArray alloc]init];
    
    
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
        //histan_NSLog(@"footer 1");
        
        _curPageCount++;
        if(_curPageCount <= _allpage){
            
            //加载数据
            [self LoadDataSourceByReservetime:_curSelectDate status:_status page:_curPageCount pageSize:ServicesCenter_PageSize IsShowHud:NO];
        }else{
            
            JSNotifier *notify = [[JSNotifier alloc]initWithTitle:@"已经加载了所有"];
            notify.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info_icon"]];
            [notify showFor:1.5];
            
            //1 秒后的计时器
            [self performSelector:@selector(hideRefreshing) withObject:nil afterDelay:0.6];
            
        }
        
        
    };
    
    //获取服务预约时间列表
    [self performSelector:@selector(getSerTimeList)];
}

-(void)hideRefreshing{
    [header endRefreshing];
    [footer endRefreshing];
}

#pragma mark -- 点击选择日期的按钮
-(void)showTheCalendarSelect:(UIButton*)sender{
    
    NSDate *dd=[HLSoftTools convertDateFromString:[HLSoftTools GetDataTimeStrByIntDate:_curSelectDate DateFormat:@"yyyy-MM-dd"]];
    [_datePicker setDate:dd animated:YES];
    
    CGRect r_cg = mainScreen_CGRect;
    
    
    CGRect newFrame = CGRectMake(0, r_cg.size.height-300, 320, 300);
    [UIView beginAnimations:@"showTHePiker" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
    
     
}

 
-(void)hiddenThePicker:(UIBarButtonItem *)sender
{
    CGRect r_cg = mainScreen_CGRect;
    
    //收起键盘，并隐藏picker
    UIView *pikerView = [self.view viewWithTag:-321546];
    CGRect newFrame = CGRectMake(0, r_cg.size.height, 320, pikerView.frame.size.height);
    [UIView beginAnimations:@"hiedThePikerView" context:nil];
    [pikerView setFrame:newFrame];
    [UIView commitAnimations];
   
    //如果时间没改变，则不加载。
    NSDate  *selectedDate = [_datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    
    NSString *ReservetimeStr=[HLSoftTools GetdateTimeLong:dateString];
    //histan_NSLog(@"ReservetimeStr:%@",ReservetimeStr);
    _curSelectDate=[ReservetimeStr retain];
   
    
    //显示在按钮上
    UIButton *yearSelectBtn =(UIButton*)[self.view viewWithTag:initTag+342];
    if ([yearSelectBtn.titleLabel.text isEqualToString:[HLSoftTools GetDataTimeStrByIntDate:_curSelectDate DateFormat:@"yyyy-MM-dd"]]) {
        //用户没有改变选择
    }
    else
    {
        //显示在按钮上
        UIButton *yearSelectBtn =(UIButton*)[self.view viewWithTag:initTag+342];
        [yearSelectBtn setTitle:dateString forState:UIControlStateNormal];
        
         
        _curPageCount=1;
        [_allDataSourceArray removeAllObjects];
        [self LoadDataSourceByReservetime:_curSelectDate status:_status page:_curPageCount pageSize:ServicesCenter_PageSize IsShowHud:YES];

    }
    
        
}

#pragma mark -- 日期选择变化
-(void)valueChang:(UIDatePicker *)picker
{
    
}

#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //histan_NSLog(@"start mjrefresh");
    
    IsSerch = NO;
    //在这里刷新数据
    if (refreshView == header) { // 下拉刷新
        
        IsHeader=YES;
        _curPageCount = 1;
        
        //清空中间集合。
        [_allDataSourceArray removeAllObjects];
        [_uiTableView reloadData];
        
        
        //加载数据
        [self LoadDataSourceByReservetime:_curSelectDate status:_status page:_curPageCount pageSize:ServicesCenter_PageSize IsShowHud:NO];
        
    }else{
        IsHeader=NO;
        //histan_NSLog(@"footer 2");
        
    }
}

//点击空白处隐藏键盘
-(void)viewTppedHideKeyBorad:(UITapGestureRecognizer*)tapGr{
    
    
}

-(void)changeTabButtonFun:(UIButton*)sender{
    
    [header endRefreshing];
    [footer endRefreshing];
    
    //更换任务类型，先清空原记录
    [_allDataSourceArray removeAllObjects];
    _curPageCount=1;
    [_uiTableView reloadData];
    
    IsSerch=NO;
    
    if(gcdNotificationView!=nil){
        [gcdNotificationView hide:YES];
    }
    
    
    [ALLButton_1011 setBackgroundImage:nil forState:UIControlStateNormal];
    //[ALLButton_1012 setBackgroundImage:nil forState:UIControlStateNormal];
    [ALLButton_1013 setBackgroundImage:nil forState:UIControlStateNormal];
    [ALLButton_1014 setBackgroundImage:nil forState:UIControlStateNormal];
    
    int tag=sender.tag;
    NSString *CurStatus=@"0";
    if(tag-initTag==802){
        CurStatus=@"1";
        [ALLButton_1011 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
        
    }else if(tag-initTag==803){
        CurStatus=@"2";
        [ALLButton_1013 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
    }else if(tag-initTag==804){
        CurStatus=@"3";
        [ALLButton_1014 setBackgroundImage:[UIImage imageNamed:@"public_tab_bg_select"] forState:UIControlStateNormal];
    }
    
    @try {
        
        if (ASISOAPRequest!=nil) {
            [ASISOAPRequest clearDelegatesAndCancel];
            [ASISOAPRequest release];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    _status=[CurStatus retain]; //重新赋值
    //加载数据
    [self LoadDataSourceByReservetime:_curSelectDate status:CurStatus page:1 pageSize:ServicesCenter_PageSize IsShowHud:YES];
    
}

-(void)LoadDataSourceByReservetime:(NSString *)reservetime status:(NSString*)status page:(int)page pageSize:(int)pageSize IsShowHud:(BOOL)IsShowHud{
    
    
    if (IsShowHud) {
        //开始加载
        HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
        
        //常用的设置
        //小矩形的背景色
        //        HUD.color = [UIColor blueColor];//这儿表示无背景
        //显示的文字
        HUD.labelText = IsSerch?@"搜索中...":@"加载中...";
        //细节文字
        //HUD.detailsLabelText = @"Test detail";
        //是否有庶罩
        HUD.dimBackground = YES;
    }
    
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"reservetime",reservetime,@"status",status,@"page",[NSString stringWithFormat:@"%d",page],@"pagesize",[NSString stringWithFormat:@"%d",pageSize],nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Serivces_List wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:ALLButton_1011,@"button1",ALLButton_1013,@"button2",ALLButton_1014,@"button3",_curSelectDate,@"dDate",nil];
    [NSThread detachNewThreadSelector:@selector(LoadService_List_Status_Count:) toTarget:[HLSOFTThread defaultCacher] withObject:dic];
    
    
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
    
    if (gcdNotificationView!=nil) {
        [gcdNotificationView setTextLabel:@"网络错误！"];
        [gcdNotificationView hideAnimatedAfter:1.5];
    }
    
    //    if (jsnotify!=nil) {
    //        jsnotify.accessoryView=  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NotifyCheckX"]];
    //        jsnotify.title=@"加载失败，请检查网络！";
    //        [jsnotify hideIn:1];
    //
    //    }
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
    
    
    if (gcdNotificationView!=nil) {
        [gcdNotificationView setTextLabel:@"刷新成功"];
        [gcdNotificationView hideAnimatedAfter:1.5];
        // jsnotify.accessoryView=  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NotifyCheck"]];
        // jsnotify.title=@"刷新成功";
        //[jsnotify hideIn:1];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"data"] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        @try {
            NSDictionary *retAboutData = [dic objectForKey:@"data"];
            //移除所有原有记录
            //[_allDataSourceArray removeAllObjects];
            
            NSArray *curloadSource=[[NSArray alloc]init];
            curloadSource=[retAboutData objectForKey:@"list"];
            _allpage=[[retAboutData objectForKey:@"allpage"] intValue];
            [_allDataSourceArray addObjectsFromArray:curloadSource];
            [_allDataSourceArray retain];
            //[curloadSource release];
            ////histan_NSLog(@"%@",retAboutData);
            ////histan_NSLog(@"_curLoadDataSource:%@，%d",_allDataSourceArray,[_allDataSourceArray count]);
            [_uiTableView reloadData];
        }
        @catch (NSException *exception) {
            [_allDataSourceArray removeAllObjects];
            [_uiTableView reloadData];
            NSString *showStr=@"当前没有数据！";
            if(IsSerch){
                showStr=@"没有搜索到对应记录！";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        @finally {
            
        }
        
        
    }
    
    
}

//设置显示多少行tableviewcell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_allDataSourceArray count];
}

//加载数据
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier=[NSString stringWithFormat:@"%@%d",@"histan_ServicesListCell",indexPath.row];
    ServicesListCell *cell=(ServicesListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        NSArray *nib= [[NSBundle mainBundle]loadNibNamed:@"ServicesListCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
        if([_allDataSourceArray count]!=0){
            cell.selectionStyle=UITableViewCellSelectionStyleGray;
            //得到当前行的数据
            NSDictionary *dict=[_allDataSourceArray objectAtIndex:indexPath.row];
            //NSLog(@"dict:%@",dict);
            //时间戳转换
            //            NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
            //            [formatter setDateStyle:NSDateFormatterMediumStyle];
            //            [formatter setTimeStyle:NSDateFormatterShortStyle];
            //            [formatter setDateFormat:@"YY-MM-dd"];
            //            int val=[[dict objectForKey:@"createtime"] intValue];
            //            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:val];
            //            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            //
            
            cell.Services_CustomerName.text=[dict objectForKey:@"cusname"];
            cell.Services_MobiePhone.text=@"";
            cell.Services_Phone.text=@"";
            
            //服务列表项的reqid，便于修改预约时间
            //NSLog(@"加载cell时reqid：%@",[dict objectForKey:@"reqid"]);
            cell.reqidLabel.text = [dict objectForKey:@"reqid"];
            //新增加预约时间显示和选择按钮
            //添加选择时间事件
            [cell.Services_selectTimeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
            
            //如果返回的arrivedtime为0，则显示为红色的“未预约”
            NSString *arrivedtimeStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"arrivedtime"]];
            if ([arrivedtimeStr isEqualToString:@"0"]) {
                [cell.Services_selectTimeBtn setTitle:@"未预约" forState:UIControlStateNormal];
                [cell.Services_selectTimeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else
            {
                [cell.Services_selectTimeBtn setTitle:[NSString stringWithFormat:@"%@点",[dict objectForKey:@"arrivedtime"]] forState:UIControlStateNormal];
                [cell.Services_selectTimeBtn setTitleColor:[UIColor colorWithRed:50/255 green:79/255 blue:133/255 alpha:1] forState:UIControlStateNormal];
            }
            
            
            //4-10增加显示服务人字段
            NSString *handlerName = [dict objectForKey:@"handler"];
            [cell.handlerLabel setTextColor:[UIColor blackColor]];
            if (handlerName.length < 1) {
                handlerName = @"无";
                [cell.handlerLabel setTextColor:[UIColor blueColor]];
            }
            cell.handlerLabel.text = handlerName;
            
            //显示手机号码
            UnderLineLabel *phoneNumLabel_MobiePhone = [[UnderLineLabel alloc] initWithFrame:CGRectMake(0, 0, cell.Services_MobiePhone.frame.size.width, cell.Services_Phone.frame.size.height)];
            [phoneNumLabel_MobiePhone setText:[dict objectForKey:@"cusmobile"]];
            [phoneNumLabel_MobiePhone setBackgroundColor:[UIColor clearColor]];
            phoneNumLabel_MobiePhone.textColor = [UIColor blueColor];
            [phoneNumLabel_MobiePhone setFont:[UIFont systemFontOfSize:12.0]];
            
            UIButton *btn_mobie = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn_mobie setBackgroundColor:[UIColor clearColor]];
            [btn_mobie setFrame:phoneNumLabel_MobiePhone.frame];
            [btn_mobie addTarget:self action:@selector(callThePhone:) forControlEvents:UIControlEventTouchUpInside];
            phoneNumLabel_MobiePhone.shouldUnderline = YES;
            phoneNumLabel_MobiePhone.userInteractionEnabled = YES;
            [phoneNumLabel_MobiePhone addSubview:btn_mobie];
            cell.Services_MobiePhone.userInteractionEnabled = YES;
            [cell.Services_MobiePhone addSubview:phoneNumLabel_MobiePhone];
            
            
            //显示电话号码
            UnderLineLabel *phoneNumLabel = [[UnderLineLabel alloc] initWithFrame:CGRectMake(0,0, cell.Services_Phone.frame.size.width, cell.Services_Phone.frame.size.height)];
            NSString *cusphoneStr =[NSString stringWithFormat:@"%@",[dict objectForKey:@"cusphone"]];
            if ([cusphoneStr isEqualToString:@""] || cusphoneStr.length < 1) {
                [phoneNumLabel setText:@"无"];
                
            }
            else
            {
                [phoneNumLabel setText:[dict objectForKey:@"cusphone"]];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundColor:[UIColor clearColor]];
                [btn setFrame:phoneNumLabel.frame];
                [btn addTarget:self action:@selector(callThePhone:) forControlEvents:UIControlEventTouchUpInside];
                phoneNumLabel.shouldUnderline = YES;
                phoneNumLabel.userInteractionEnabled = YES;
                [phoneNumLabel addSubview:btn];
                cell.Services_Phone.userInteractionEnabled = YES;
                
            }
            [cell.Services_Phone addSubview:phoneNumLabel];
            [phoneNumLabel setBackgroundColor:[UIColor clearColor]];
            phoneNumLabel.textColor = [UIColor blueColor];
            [phoneNumLabel setFont:[UIFont systemFontOfSize:12.0]];

            cell.Services_Address.text=[dict objectForKey:@"cusaddr"];
            cell.tag=indexPath.row;
            
        }
        
        
    }
    
    
    return  cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        
        
        //    [tableView beginUpdates];
        //    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
        //    [rowToInsert addObject:indexPath];
        //    [tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
        //    [tableView endUpdates];
        //     [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
        //自定义返回按钮
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.backBarButtonItem=backBtn;
        
        
        UIButton *yearSelectBtn =(UIButton*)[self.view viewWithTag:initTag+342];
        appDelegate.YYShangmenTime=yearSelectBtn.titleLabel.text;
        
        //ServicesListCell *cell=(ServicesListCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        //记录当前选择的服务记录
        appDelegate.ServicesDictionary=[[_allDataSourceArray objectAtIndex:indexPath.row]retain];
        appDelegate.CurTaskTypeId=_status;  //状态
        appDelegate.CurTaskId =_curSelectDate; //当前选择时间的时间戳
        
        //跳转到详情页面
        ServicesDetailsController *details=[[ServicesDetailsController alloc]init];
        [self.navigationController pushViewController:details animated:YES];
        [details release];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


#pragma mark -- 预约时间选择事件
-(void)selectTime:(UIButton *)sender
{
    
    _currentBtn = (UIButton *)sender;
    
    //获得当前单的诉求id（reqId）
    ServicesListCell *cellView;
    if (_IsIOS7_) {
        cellView = (ServicesListCell *)_currentBtn.superview.superview.superview;
    }else{
        cellView = (ServicesListCell *)[_currentBtn superview].superview;
    }
    
    //NSLog(@"记录时reqid：%@",cellView.reqidLabel.text);
    _currentReqid = cellView.reqidLabel.text;
    [_currentReqid retain];
    
    
    //弹出选择框
    //初始化弹出框
    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
    CGFloat yHeight = [Services_TimeArry count]*40+40;
    //如果数据较多，固定弹出选择框的高度
    if (yHeight > 400) {
        yHeight = 440;
    }
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    _poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    //[_poplistview setTag:initTag+1314];//设置标识
    _poplistview.delegate = self;
    _poplistview.datasource = self;
    _poplistview.listView.scrollEnabled = TRUE;
    _poplistview.listView.showsVerticalScrollIndicator = NO;
    
    [_poplistview show];
}

#pragma mark -- 弹出框数据源和代理方法
- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}
//加载cell
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] autorelease];
    int row = indexPath.row;
    [_poplistview setTitle:@"请选择时间段"];
    cell.textLabel.text = [Services_TimeArry objectAtIndex:row];
    return cell;
}

//行数
- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    @try {
        int num = [Services_TimeArry count];
        return num;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return 0;
}


#pragma mark - UIPopoverListViewDelegate
//cell被选择后的操作
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    @try {

        UITableViewCell *cell = [popoverListView.listView cellForRowAtIndexPath:indexPath];
        
        //当前cell上的文字
        _selectedTime = cell.textLabel.text;
        [_selectedTime retain];
        
        //修改前询问是否确认预约9-10点上门
        NSString *msg = [NSString stringWithFormat:@"是否预约%@点上门？",_selectedTime];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert setTag:-887456];
        [alert show];
        [alert release];
     
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
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
    
    //为空则返回
    if ([thePhoneNum isEqualToString:@""]) {
        return;
    }
    
    //弹出询问框，提示是否确认拨号
    NSString *messageStr = [NSString stringWithFormat:@"您确认要呼叫：%@吗？",thePhoneNum];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"拨号" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //histan_NSLog(@"theButtoneIndex:%d",buttonIndex);
    if (alertView.tag == -887456) {
        //提示是否确认修改预约时间段
        //当用户点击了确认后执行后调用方法修改
        if (buttonIndex == 0) {
            [self performSelector:@selector(setServicesTime)];
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


#pragma mark -- 获取服务预约时间段
-(void)getSerTimeList
{
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest1 = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Get_SerTime wsParameters:wsParas];
    //异步
    [ASISOAPRequest1 startAsynchronous];
    [ASISOAPRequest1 setCompletionBlock:^{
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest1 responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        
        //histan_NSLog(@"allDic --- %@",allDic);
        //histan_NSLog(@"allDic  objectForKey:@data--- %@",[allDic objectForKey:@"data"]);
        Services_TimeArry = [[NSMutableArray alloc] init];
        //时间段数组
        NSArray *tempArray = (NSArray *)[allDic objectForKey:@"data"];
        for (NSDictionary *itemDic in tempArray) {
            [Services_TimeArry addObject:[itemDic objectForKey:@"timename"]];
        }
        [Services_TimeArry retain];
    }];
    
    //请求失败
    [ASISOAPRequest setFailedBlock:^{
        NSError *error = [ASISOAPRequest1 error];
        //histan_NSLog(@"请求超时！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
    }];

}


#pragma mark -- 修改预约上门时间
-(void)setServicesTime
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"正在修改时间..."];
    
    //NSLog(@"参数：%@，%@，%@",_currentReqid,_curSelectDate,_selectedTime);
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"reqid",_currentReqid,@"reservetime",_curSelectDate,@"arrivedtime",_selectedTime,nil];
    NSLog(@"参数数组：%@",wsParas);
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest2 = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Set_SerTime wsParameters:wsParas];
    //异步
    [ASISOAPRequest2 startAsynchronous];
    [ASISOAPRequest2 setCompletionBlock:^{
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest2 responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        //NSLog(@"allDic --- %@",allDic);
        //histan_NSLog(@"allDic  objectForKey:@data--- %@",[allDic objectForKey:@"data"]);
        NSString *resultStr = [NSString stringWithFormat:@"%@",[allDic objectForKey:@"data"]];
        if ([resultStr isEqualToString:@""]) {
            //如果成功
            NSString *time = [NSString stringWithFormat:@"%@点",_selectedTime];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:resultStr delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }];
    
    //请求失败
    [ASISOAPRequest setFailedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！请重试..." delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        NSError *error = [ASISOAPRequest2 error];
        //histan_NSLog(@"请求超时！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
    }];

}



#pragma mark -- 键盘的搜索事件
//键盘搜索按钮的 click 事件。
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    IsSerch = YES;
    
    [searchBar resignFirstResponder];
    //清空上次搜索出来的数据
    [_allDataSourceArray removeAllObjects];
    searchBar.showsCancelButton=NO;
    
    UITextField *searchField=[[searchBar subviews]objectAtIndex:1];
    if (_IsIOS7_) {
        
        searchField=[[searchBar.subviews[0] subviews] objectAtIndex:1];
    }else{
        searchField  =[[searchBar subviews]objectAtIndex:1];
    }
    NSString *keyWords=searchField.text;
    
    _curPageCount=1;
    
    
    
}

//点击搜索文本框，出现 cancel 按钮。
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton=YES;
    for (UIView *item in [searchBar subviews]) {
        if ([item isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)item;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

//cancel 按钮的 click事件，（隐藏键盘 和 情况文本框。）
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    
}


//编辑完成后调用的方法
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //histan_NSLog(@"编辑完成。。");
    
}

//搜索文本框的change事件。
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //histan_NSLog(@"change");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    //tanbleview 的选中取消效果
    [_uiTableView deselectRowAtIndexPath:[_uiTableView indexPathForSelectedRow] animated:YES];
    
    if(gcdNotificationView!=nil){
        [gcdNotificationView hide:YES];
    }
    
    if(IsFirstLoadOK==NO){
        IsFirstLoadOK=YES;
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *dates=[NSString stringWithFormat:@"%@",[df stringFromDate:nowDate]];
        
        
        NSString *ReservetimeStr=[HLSoftTools GetdateTimeLong:[df stringFromDate:nowDate]];
       // NSString *ReservetimeStr=[HLSoftTools GetdateTimeLong:@"2014-01-21"];
        //histan_NSLog(@"ReservetimeStr:%@",ReservetimeStr);
        _curSelectDate=[ReservetimeStr retain];
        //显示在按钮上
        UIButton *yearSelectBtn =(UIButton*)[self.view viewWithTag:initTag+342];
        [yearSelectBtn setTitle:dates forState:UIControlStateNormal];
        //[yearSelectBtn setTitle:@"2014-01-21" forState:UIControlStateNormal];
        [self LoadDataSourceByReservetime:_curSelectDate status:_status page:1 pageSize:ServicesCenter_PageSize IsShowHud:YES];
    }else{
        
        //gcdNotificationView = [[GCDiscreetNotificationView alloc] initWithText:@"数据刷新中..." showActivity:YES inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:self.view];
        // [gcdNotificationView show:YES];
        [_uiTableView reloadData];
        if([appDelegate.opeationSuccessNeedReloadPage isEqualToString:@"1"]){
            appDelegate.opeationSuccessNeedReloadPage=@"0";
            [_allDataSourceArray removeAllObjects];
            [_uiTableView reloadData];
            // [self LoadDataSourceByReservetime:_curSelectDate status:_status page:_curPageCount pageSize:ServicesCenter_PageSize IsShowHud:NO];
            [header performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0.3];
        }
        
    }
    
}


-(void)dealloc{
    @try {
        
       NSLog(@"ServiceCenter dealloc");
    //取消和清除当前网络请求
    [ASISOAPRequest clearDelegatesAndCancel];
    [ASISOAPRequest release];
    [jsnotify release];
    if(jsnotify!=nil)
    {
        [jsnotify hide];
        [jsnotify release];
        
    }
    
    _uiTableView=nil;
    _allDataSource=nil;
    HUD=nil;
    gcdNotificationView=nil;
    ALLButton_1011=nil;
    ALLButton_1013=nil;
    ALLButton_1014=nil;
    header=nil;
    footer=nil;
    IsHeader=nil;
    _allDataSourceArray=nil;
    IsSerch=nil;
    IsFirstLoadOK=nil;
    _curSelectDate=nil;
    _status=nil;
    thePhoneNum=nil;
    _datePicker=nil;
    _maskView=nil;
    
    [super dealloc];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

@end
