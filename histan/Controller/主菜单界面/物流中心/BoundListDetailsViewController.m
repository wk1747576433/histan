//
//  BoundListDetailsViewController.m
//  histan
//
//  Created by lyh on 1/26/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "BoundListDetailsViewController.h"

@interface BoundListDetailsViewController ()

@end

@implementation BoundListDetailsViewController

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
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
	HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    //histan_NSLog(@"保存的单子对象：%@",appDelegate.boundList_curItemDic);
    [self.navigationItem setTitle:appDelegate.CurPageTitile];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];
    
    //添加 table view
    _uiTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44) style:UITableViewStylePlain];
    [_uiTableView setDelegate:self];
    [_uiTableView setDataSource:self];
    [_uiTableView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
    [_uiTableView setBackgroundView:bgImgView];
    [self.view addSubview:_uiTableView];
    
    //实例化失败原因选择列表
    _popoerView = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, 10, 300, 420)];
    _popoerView.delegate = self;
    _popoerView.datasource = self;
    [_popoerView setTitle:@"失败原因"];
    _popoerView.listView.scrollEnabled = TRUE;
    _popoerView.listView.showsVerticalScrollIndicator = NO;
    [_popoerView retain];
    
    CGRect r_cg=mainScreen_CGRect;
    //添加一个日期选择器，先隐藏
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, r_cg.size.height, 320, 300)];
    [_maskView setBackgroundColor:[UIColor whiteColor]];
    [_maskView setTag:-4321546];
    
    //加入日期选择器(初始为影藏状态，当搜索框被点击收到键盘出现的通知后出现,收到键盘消失通知后消失)
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay];
    [_datePicker setDate:tomorrow];
    [_datePicker setAccessibilityLanguage:@"Chinese"];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    //[_datePicker addTarget:self action:@selector(pickerValueChang:) forControlEvents:UIControlEventValueChanged];
    
    //添加一个收起选择器的按钮
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定选择" style:UIBarButtonItemStylePlain target:self action:@selector(doneItemBtnClick:)];
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
    
    //设置 cell 分割线为空
    _uiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化失败原因数组
    _failedReasonArray = nil;
    
    [self performSelector:@selector(getReason)];
    
    //获取子出库单
    //[self performSelector:@selector(getOutBoundItemList)];
    
    
    
}

#pragma mark -- 获取失败原因
-(void)getReason
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"加载中..."];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"type",@"1",nil];
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Send_Fail_Reason wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess_getReason:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载
    
    
}


//加载数据出错。
-(void)requestDidFailed:(ASIHTTPRequest*)request{
    
    
    if(HUD!=nil){
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText = @"网络连接错误，请检查网络！";
        [HUD hide:YES afterDelay:2];
        
    }
    
}

//加载成功，现实到页面。
-(void)requestDidSuccess_getReason:(ASIHTTPRequest*)requestLoadSource{
    
    @try {
        
        
        
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[requestLoadSource responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        //histan_NSLog(@"allDic --- %@",allDic);
        ////histan_NSLog(@"allDic  objectForKey:the data--- %@",[allDic objectForKey:@"data"]);
        NSString *errorStr = [NSString stringWithFormat:@"%@",[allDic objectForKey:@"error"]];
        if (![errorStr isEqualToString:@"0"]) {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！获取失败原因失败！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        
        //开始加载详情
        [self performSelector:@selector(getOutBoundItemList)];
        
        
        NSDictionary *dataDic = [allDic objectForKey:@"data"];
        _failedReasonArray = [[NSMutableArray alloc] init];
        for ( NSDictionary *item in dataDic) {
            //histan_NSLog(@"失败原因：%@",[item objectForKey:@"rname"]);
            [_failedReasonArray addObject:item];
        }
        [_failedReasonArray retain];
        
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！获取数据失败！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    @finally {
        
    }
}

#pragma mark -- 获取失败原因并弹出选择框
-(void)getReasonAndPopView
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"加载失败原因..."];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"type",@"1",nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest_reason = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Send_Fail_Reason wsParameters:wsParas];
    //异步
    [ASISOAPRequest_reason startAsynchronous];
    
    [ASISOAPRequest_reason setCompletionBlock:^{
        [HUD hide:YES];
        [_popoerView show];
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest_reason responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        //histan_NSLog(@"allDic --- %@",allDic);
        ////histan_NSLog(@"allDic  objectForKey:the data--- %@",[allDic objectForKey:@"data"]);
        NSString *errorStr = [NSString stringWithFormat:@"%@",[allDic objectForKey:@"error"]];
        if (![errorStr isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！获取失败原因失败！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        NSDictionary *dataDic = [allDic objectForKey:@"data"];
        _failedReasonArray = [[NSMutableArray alloc] init];
        for ( NSDictionary *item in dataDic) {
            //histan_NSLog(@"失败原因：%@",[item objectForKey:@"rname"]);
            [_failedReasonArray addObject:item];
        }
        [_failedReasonArray retain];
    }];
    
    //请求失败
    [ASISOAPRequest_reason setFailedBlock:^{
        [HUD hide:YES];
        //  NSError *error = [ASISOAPRequest_reason error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！您的网络目前可能不给力哦^_^" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        //histan_NSLog(@"请求超时！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
    }];
    
}


#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_resultArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
}

#pragma mark -- 加载 cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier =[NSString stringWithFormat:@"cell_%d",indexPath.row];
    //cell 的高度
    float curCellHeight=40;
    
    NSDictionary *dict = [_resultArray objectAtIndex:indexPath.row];
    //histan_NSLog(@"加载时提取的dic:%@",dict);
    
    
    if (indexPath.row<11) {
        
        UITableViewCell *cell= [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        CGRect cellFrame = [cell frame];
        cellFrame.origin = CGPointMake(100, 2);
        
        int textLabelWidth=235;
        //左标题：
        UILabel *TaskTypeName_text1 = [[UILabel alloc] initWithFrame:CGRectMake(3, 2, 80, 21)];
        TaskTypeName_text1.highlightedTextColor = [UIColor whiteColor];
        TaskTypeName_text1.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
        TaskTypeName_text1.backgroundColor = [UIColor clearColor];
        TaskTypeName_text1.font=[UIFont systemFontOfSize:14.0f];
        TaskTypeName_text1.textAlignment=NSTextAlignmentRight;
        TaskTypeName_text1.text=[dict objectForKey:@"leftTitle"];
        [cell.contentView addSubview:TaskTypeName_text1];
        [TaskTypeName_text1 release];
        
        //对应显示的信息（其中业务员信息和促销员信息需要做改色和可拨号处理）
        UILabel *TaskTypeName_text2 = [[UILabel alloc] initWithFrame:CGRectZero];
        TaskTypeName_text2.lineBreakMode = NSLineBreakByWordWrapping;
        TaskTypeName_text2.highlightedTextColor = [UIColor whiteColor];
        TaskTypeName_text2.numberOfLines = 0;
        // TaskTypeName_text2.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
        TaskTypeName_text2.backgroundColor = [UIColor clearColor];
        TaskTypeName_text2.font=[UIFont systemFontOfSize:14.0f];
        TaskTypeName_text2.textAlignment=NSTextAlignmentLeft;
        //顾客电话
        if (indexPath.row == 3) {
            
            NSString *phoneNum = [dict objectForKey:@"content"];
            if ([phoneNum isEqualToString:@"无"] || [phoneNum isEqualToString:@""]) {
                TaskTypeName_text2.text=phoneNum;
            }else{
                
//                TaskTypeName_text2.text=phoneNum;
//                TaskTypeName_text2.textColor=[UIColor blueColor];
//                TaskTypeName_text2.userInteractionEnabled = YES;
//                //添加一个button相应事件
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [btn setFrame:CGRectMake(0, 0, textLabelWidth, 21)];
//                [btn addTarget:self action:@selector(callThePhoneNum:) forControlEvents:UIControlEventTouchUpInside];
//                [TaskTypeName_text2 addSubview:btn];
                
               // TaskTypeName_text2.text=@"";
                
                NSMutableAttributedString *lastString22 = [[NSMutableAttributedString alloc] initWithString:phoneNum];
                [lastString22 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, phoneNum.length)];
                [lastString22 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, phoneNum.length)];
                [TaskTypeName_text2 setAttributedText:lastString22];
                TaskTypeName_text2.userInteractionEnabled = YES;
                //添加一个button相应事件
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(0, 0, textLabelWidth, 21)];
                [btn addTarget:self action:@selector(callThePhoneNum:) forControlEvents:UIControlEventTouchUpInside];
                TaskTypeName_text2.userInteractionEnabled = YES;
                [TaskTypeName_text2 addSubview:btn];
                
            }
            
            
        }
        
        else if (indexPath.row == 4 || indexPath.row == 5) {
            //业务员及电话、促销员及电话
            NSString *phoneNum = [dict objectForKey:@"content"];
            if ([phoneNum isEqualToString:@"无"] || [phoneNum isEqualToString:@""]) {
                TaskTypeName_text2.text=phoneNum;
            }else{
                NSMutableAttributedString *lastString = [[NSMutableAttributedString alloc] initWithString:phoneNum];
                
                int pstartLenght= [phoneNum rangeOfString:@"("].location+1;
                int pendLenght= [phoneNum rangeOfString:@")"].location -pstartLenght;
                if (pendLenght >4) {
                    [lastString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(pstartLenght, pendLenght)];
                    [lastString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(pstartLenght, pendLenght)];
                    [TaskTypeName_text2 setAttributedText:lastString];
                    TaskTypeName_text2.userInteractionEnabled = YES;
                    //添加一个button相应事件
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setFrame:CGRectMake(0, 0, textLabelWidth, 21)];
                    [btn addTarget:self action:@selector(callThePhoneNum:) forControlEvents:UIControlEventTouchUpInside];
                    [TaskTypeName_text2 addSubview:btn];
                }
                else
                {
                    TaskTypeName_text2.text = phoneNum;
                }
            }
        }
        else{
            
            TaskTypeName_text2.text=[dict objectForKey:@"content"];
            
        }
        
        CGRect rect=CGRectMake(80, 4, textLabelWidth, TaskTypeName_text2.frame.size.height);
        TaskTypeName_text2.frame = rect;
        [TaskTypeName_text2 sizeToFit];
        [cell.contentView addSubview:TaskTypeName_text2];
        curCellHeight=TaskTypeName_text2.frame.size.height+5;
        
        //如果是最后一个，则添加一个产品信息头部。
        if(indexPath.row==10){
            UIImageView *imgView_Headbg=[[UIImageView alloc]initWithFrame:CGRectMake(4, curCellHeight+3, self.view.frame.size.width-9, 21)];
            [imgView_Headbg setImage:[UIImage imageNamed:@"solution_hand_bg"]];
            UILabel *TaskDescLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-30)/2-40, 1, 80, 21)];
            TaskDescLabel.text=@"产品信息";
            TaskDescLabel.backgroundColor=[UIColor clearColor];
            TaskDescLabel.font=[UIFont systemFontOfSize:14];
            TaskDescLabel.textColor=[UIColor whiteColor];
            [imgView_Headbg addSubview:TaskDescLabel];
            
            [cell.contentView addSubview:imgView_Headbg];
            
            curCellHeight= curCellHeight+3+21;
        }
        
        cellFrame.size.height=curCellHeight;
        [cell setFrame:cellFrame];
        return cell;
        
    }else if(indexPath.row== ([_resultArray count]-1)){
        
        UITableViewCell *cell= [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        CGRect cellFrame = [cell frame];
        cellFrame.origin = CGPointMake(100, 2);
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        //判断当前是什么状态下的数据，只有是“未成功”状态下的数据时候才添加按钮
        HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        if ([appDelegate.curOutBoundStatus isEqualToString:@"1"]) {
            //未送货状态,添加保存按钮
            UIButton *submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70-10, 5, 65, 30)];
            [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_commit_task"] forState:UIControlStateNormal];
            [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_commit_task_press"] forState:UIControlStateHighlighted];
            [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:submitBtn];
            [submitBtn release];
        }
        else
        {
            
            
        }
        
        curCellHeight=53+8;
        
        cellFrame.size.height=curCellHeight;
        [cell setFrame:cellFrame];
        return cell;
        
    }
    else
    {
        WuLiuDetailsCell *cell=(WuLiuDetailsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            NSArray *nib= [[NSBundle mainBundle]loadNibNamed:@"WuLiuDetailsCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        //取出要显示的信息
        NSDictionary *item=(NSDictionary*)[dict objectForKey:@"content"];
        //histan_NSLog(@"item:%@",item);
        CGRect cellFrame = [cell frame];
        cellFrame.origin = CGPointMake(100, 2);
        
        HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        
        cell.indexLabel.text =[NSString stringWithFormat:@"%d",[[dict objectForKey:@"index"] intValue]+1];
        cell.cInvStdLabel.text = [item objectForKey:@"cInvStd"];
        int iquantity = [[item objectForKey:@"iQuantity"] intValue];
        if (iquantity > 0) {
            
        }
        else
        {
            [cell.iQuantityLabel setTextColor:[UIColor redColor]];
        }
        cell.iQuantityLabel.text = [item objectForKey:@"iQuantity"];
        
        int cindex=[[dict objectForKey:@"index"]intValue];
        [cell setTag:cindex];//设置tag ，方便获取 集合数据
        
        //histan_NSLog(@"在加载每个商品详细cell时_productListArry index为%d的字典的值：%@",cindex,[_productListArry objectAtIndex:cindex]);
        
        //给按钮绑定事件
        [cell.failedBtn addTarget:self action:@selector(FailedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.successBtn addTarget:self action:@selector(SuccessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //修改当前单个商品按钮
        [cell.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.waitingBtn addTarget:self action:@selector(waitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.failedResonBtn addTarget:self action:@selector(failedReasonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.retransDateBtn addTarget:self action:@selector(retransDateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.failedBtn.tag=-1;
        cell.successBtn.tag=-2;
        
        //控制底部的选择和修改按钮的显示
        if ([appDelegate.curOutBoundStatus isEqualToString:@"1"]) {//如果是未送货状态
            //未送货状态，没有修改按钮，不显示底部选择选项
            //隐藏“修改按钮”
            cell.cancelBtn.hidden = YES;
            //隐藏 失败理由控件
            [cell.bottomView setHidden:YES];
        }
        else
        {
            [cell.cancelBtn setHidden:NO];
        }
        
        
        //设置未点击失败的cell 高度
        curCellHeight=70;
        
        NSDictionary *subDict=[_productListArry objectAtIndex:cindex];
        if([[subDict objectForKey:@"result"] isEqualToString:@"null"]) //没有选中 成功 或者 失败
        {
            //如果该商品信息从获取以来没有改变过，则不用选择成功或失败按钮和显示底部失败原因和改送日期
            //NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[item objectForKey:@"cid"],@"id",@"null",@"result",@"\"\"",@"reasonid",[NSString stringWithFormat:@"%f",curCellHeight],@"height",@"\"\"",@"changedate",@"0",@"iswait", nil];
            //                 NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[item objectForKey:@"cid"],@"id",@"null",@"result",@"\"\"",@"reasonid",@"66",@"height",@"\"\"",@"changedate",@"0",@"iswait", nil];
            //                [_productListArry replaceObjectAtIndex:cindex withObject:scItem]; //用于替换数组中的某个对象
            
            
        }
        else                                                            //选择了成功或者失败
        {
            
            
            if ([[subDict objectForKey:@"result"] isEqualToString:@"0"])//如果结果为失败
            {
                curCellHeight=145;
                //设置失败按钮被选择
                [cell.failedBtn setImage:[UIImage imageNamed:@"ping_radio_16"] forState:UIControlStateNormal];
                //显示底部的原因和日期
                [cell.bottomView setHidden:NO];
                //根据_productListArray设置原因
                NSString *reasonid =[NSString stringWithFormat:@"%@",[[_productListArry objectAtIndex:cindex] objectForKey:@"reasonid"]];
                //histan_NSLog(@"从当前编辑商品信息里取出的失败原因id是：%@",reasonid);
                for (NSDictionary *reasonDic in _failedReasonArray) {
                    NSString *tempId = [reasonDic objectForKey:@"rid"];
                    if ([reasonid isEqualToString:tempId]) {
                        //显示到失败原因按钮
                        [cell.failedResonBtn setTitle:[reasonDic objectForKey:@"rname"] forState:UIControlStateNormal];
                    }
                }
                
                //失败状态下和成功状态下，就根据数据显示
                //设置日期
                NSDictionary *productItemDict = [_productListArry objectAtIndex:cindex];
                NSString *dateStr = [productItemDict objectForKey:@"changedate"];//字典当中的日期用时间戳字符串记录，没有时间就用@"" 表示
                //histan_NSLog(@"在对应商品信息中取得的改送日期为：%@",dateStr);
                
                if (![dateStr isEqualToString:@""] && dateStr.length > 8 && ![dateStr isEqual:[NSNull null]] ) {
                    //有设置改送日期,将时间戳字符串转化成“yyyy-MM-dd”形式的字符串，显示在界面
                    
                    NSString *dateStr2 = [HLSoftTools GetDataTimeStrByIntDate:dateStr DateFormat:@"yyyy-MM-dd"];
                    //histan_NSLog(@"显示到界面的yyyy-MM-dd形式的字符串：%@",dateStr2);
                    [cell.retransDateBtn setTitle:dateStr2 forState:UIControlStateNormal];
                    
                }
                else {
//                    //设置待定按钮
//                    NSString *isWait = [productItemDict objectForKey:@"iswait"];
//                    if ([isWait isEqualToString:@"0"] && [appDelegate.curOutBoundStatus isEqualToString:@"1"]) {//未选中状态
//                        cell.retransDateBtn.hidden = NO;
//                        
//                        [cell.waitingBtn setImage:[UIImage imageNamed:@"ping_checked1_16"] forState:UIControlStateNormal];
//                    }
//                    else
//                    {
//                        //待定
//                        cell.retransDateBtn.hidden = YES;
//                        float x = cell.retransDateBtn.frame.origin.x;
//                        [cell.waitingBtn setFrame:CGRectMake(x, cell.waitingBtn.frame.origin.y, cell.waitingBtn.frame.size.width, cell.waitingBtn.frame.size.height)];
//                        [cell.waitingBtn setImage:[UIImage imageNamed:@"ping_checked_16"] forState:UIControlStateNormal];
//                    }
                }
                
            }
            else                                                          //如果选择了成功
            {
                curCellHeight=70;
                //只要设置成功选项被选择
                [cell.successBtn setImage:[UIImage imageNamed:@"ping_radio_16"] forState:UIControlStateNormal];
                //隐藏 失败理由控件
                [cell.bottomView setHidden:YES];
            }
        }
        cellFrame.size.height=curCellHeight;
        [cell setFrame:cellFrame];
        //cell.contentView.backgroundColor=[UIColor whiteColor];
        cell.contentView.frame=CGRectMake(5, 0, 300, curCellHeight);
        UIScrollView *sc=[[UIScrollView alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, curCellHeight)];
        sc.backgroundColor=[UIColor whiteColor];
        sc.layer.borderWidth=1;
        sc.layer.borderColor=[[UIColor grayColor]CGColor];
        [cell.contentView insertSubview:sc atIndex:0];
        return cell;
        
    }
}

#pragma mark -- 拨打电话
-(void)callThePhoneNum:(UIButton *)sender
{
    @try {
        
        UILabel *theLbel = (UILabel *)sender.superview;
        //获取电话号码
        NSString *theLabelString = theLbel.text;
        NSString *thePhoneNum = @"";
        //如果字符串带有“(”就必须截断字符串，如果没有，就是只有号码
        int pstartLenght= [theLabelString rangeOfString:@"("].location+1;
        int pendLenght= [theLabelString rangeOfString:@")"].location -pstartLenght;
        if (pendLenght>4) {
            //如果存在括号,截取出号码
            thePhoneNum = [theLabelString substringWithRange:NSMakeRange(pstartLenght, pendLenght)];
            _thePhoneNum = thePhoneNum;
            [_thePhoneNum retain];
        }
        else
        {
            _thePhoneNum = theLabelString;
            [_thePhoneNum retain];
        }
        
        if ([_thePhoneNum isEqualToString:@""]) {
            return;
        }
        
        //弹出询问框，提示是否确认拨号
        NSString *messageStr = [NSString stringWithFormat:@"您确认要呼叫：%@ 吗？",_thePhoneNum];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"拨号" otherButtonTitles:@"取消", nil];
        [alert show];
        [alert release];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

//拨打电话
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //histan_NSLog(@"theButtoneIndex:%d",buttonIndex);
    //当用户点击了确认后执行拨号
    if (buttonIndex == 0) {
        
        if (IsEditClicknum==1) {
            
            
            NSDictionary *subDict=[_productListArry objectAtIndex:_curIndexInArray];
            
            NSString *showTipsText=@"提醒";
            BOOL IsFalse=NO;
            if([[subDict objectForKey:@"result"] isEqualToString:@"null"]){
                
                showTipsText=@"请选择结果！";
                IsFalse=YES;
                
            }else{
                
            }
            //先判断如果选择的是失败，就必须选择失败原因
            if ([[subDict objectForKey:@"result"] isEqual:@"0"]) {
                //失败
                NSString *rid = [NSString stringWithFormat:@"%@",[subDict objectForKey:@"reasonid"]];
                if ([rid isEqualToString:@""] ) {
                    //有没有设置状态的商品，要求必须选择
                    showTipsText=@"请选择失败原因！";
                    IsFalse=YES;
                    
                }
                
                //判断是否为待定
                NSString *isWait = [subDict objectForKey:@"iswait"];
                NSString *retransdateStr = [subDict objectForKey:@"changedate"];
                
                //不为待定，但没有选择日期
                if ([isWait isEqualToString:@"0"] && retransdateStr.length == 0 ) {
                    
                    showTipsText=@"请选择改送日期！";
                    IsFalse=YES;
                }
            }
            else
            {
                //选择了成功
                
            }
            
            if(IsFalse==YES){
                
                HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
                HUD.labelText =showTipsText;
                // [HUD show:YES];
                [HUD hide:YES afterDelay:1.5];
                return;
            }
            
            NSDictionary *pragramDict = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"cid",[subDict objectForKey:@"result"],@"success",[subDict objectForKey:@"reasonid"],@"reasonid", [subDict objectForKey:@"changedate"],@"retransdate", nil];
            
            [self performSelector:@selector(updateCurrentData:) withObject:pragramDict ];
            
            
            
        }else{
            
            //histan_NSLog(@"thePhontNum:%@",_thePhoneNum);
            NSString *telStr = [NSString stringWithFormat:@"tel://%@",_thePhoneNum];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
        }
    }
    
    IsEditClicknum=0;
}

#pragma mark - UIPopoverListViewDataSource
//加载UIPopoverListViewcell
-(UITableViewCell*)popoverListView:(UIPopoverListView *)popoverListView cellForIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier =[NSString stringWithFormat:@"Pcell_%d",indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier];
    int row = indexPath.row;
    NSString *text = [NSString stringWithFormat:@"%@",[[_failedReasonArray objectAtIndex:row] objectForKey:@"rname"]];
    
    cell.textLabel.text = text;
    
    NSDictionary *subDict = [_productListArry objectAtIndex:_curIndexInArray];
    //histan_NSLog(@"reasonid:%@",[subDict objectForKey:@"reasonid"]);
    //histan_NSLog(@"row:%@",[NSString stringWithFormat:@"%@",[[_failedReasonArray objectAtIndex:row] objectForKey:@"rid"]]);
    
    if ([[[_failedReasonArray objectAtIndex:row] objectForKey:@"rid"] isEqualToString:[subDict objectForKey:@"reasonid"]]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    //    for (NSDictionary *itemDic in _failedReasonArray) {
    //        if ([[itemDic objectForKey:@"rid"] isEqualToString:[subDict objectForKey:@"reasonid"]] && ) {
    //
    //             cell.accessoryType=UITableViewCellAccessoryCheckmark;
    //        }
    //    }
    
    return cell;
}


//行数
- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    //histan_NSLog(@"[_failedReasonArray count]:%d",[_failedReasonArray count]);
    return [_failedReasonArray count];
}

-(float)popoverListView:(UIPopoverListView *)popoverListView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - UIPopoverListViewDelegate
//UIPopoverListViewcell被选择后的操作
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    //histan_NSLog(@"%s : %d", __func__, indexPath.row);
    // your code here
    UITableViewCell *cell = [popoverListView.listView cellForRowAtIndexPath:indexPath];
    
    //当前cell上的文字
    NSString *selectedText = cell.textLabel.text;
    
    //获得原因后显示在button上显示，并记录失败原因id到_productListArry里对应对象的“reasonid”中
    [_curClickBtn setTitle:selectedText forState:UIControlStateNormal];
    
    NSString *rId;
    for (NSDictionary *itemDic in _failedReasonArray) {
        if ([[itemDic objectForKey:@"rname"] isEqualToString:selectedText]) {
            //记录失败原因id
            rId =[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"rid"]];
            [rId retain];
        }
    }
    
    //取得对应dic
    NSDictionary *theDic = [_productListArry objectAtIndex:_curIndexInArray];
    
    NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[theDic objectForKey:@"id"],@"id",[theDic objectForKey:@"result"],@"result",rId,@"reasonid",[theDic objectForKey:@"height"],@"height",[theDic objectForKey:@"changedate"],@"changedate",[theDic objectForKey:@"iswait"],@"iswait", nil];
    [_productListArry replaceObjectAtIndex:_curIndexInArray withObject:scItem];
}


#pragma mark --未成功按钮事件
-(void)FailedBtnClick:(UIButton*)sender{
    
    WuLiuDetailsCell *subCell;
    if (_IsIOS7_) {
        subCell= (WuLiuDetailsCell*)sender.superview.superview.superview;
    }else{
        subCell= (WuLiuDetailsCell*)[[sender superview]superview];
    }
    
    int cindex=subCell.tag;
    //histan_NSLog(@"cindex:%d",cindex);
    NSString *resultStr=sender.tag==-1?@"0":@"1";
    
    //histan_NSLog(@"在点击失败时_productListArry index为%d的字典被替换前的值：%@",cindex,[_productListArry objectAtIndex:cindex]);
    
    NSDictionary *subDict=[_productListArry objectAtIndex:cindex];
    if([[subDict objectForKey:@"result"] isEqualToString:@"0"] && [resultStr isEqualToString:@"0"])//第二次点击同一个状态
    {
        return;
    }
    //设置当前cell 的高度
    float height1=[[subDict objectForKey:@"height"]floatValue]+79;
    //NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[item objectForKey:@"cid"],@"id",@"null",@"result",@"",@"reasonid",[NSString stringWithFormat:@"%f",curCellHeight],@"height",@"",@"changedate",@"0",@"iswait", nil];
    NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",resultStr,@"result",[subDict objectForKey:@"reasonid"],@"reasonid", [NSString stringWithFormat:@"%f",height1],@"height",[subDict objectForKey:@"changedate"],@"changedate",[subDict objectForKey:@"iswait"],@"iswait", nil];
    [_productListArry replaceObjectAtIndex:cindex withObject:scItem]; //用于替换数组中的某个对象
    
    [_uiTableView reloadData];
    //    [_uiTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //histan_NSLog(@"在点击失败后_productListArry index为%d的字典被替换后的值：%@",cindex,[_productListArry objectAtIndex:cindex]);
}

#pragma mark --送货成功按钮事件
-(void)SuccessBtnClick:(UIButton*)sender{
    WuLiuDetailsCell *subCell;
    if (_IsIOS7_) {
        subCell= (WuLiuDetailsCell*)sender.superview.superview.superview;
    }else{
        subCell= (WuLiuDetailsCell*)[[sender superview]superview];
    }
    int cindex=subCell.tag;
    NSDictionary *subDict=[_productListArry objectAtIndex:cindex];
    //histan_NSLog(@"商品列表dic：%@",subDict);
    
    //histan_NSLog(@"在点击成功按钮后_productListArry index为%d的字典被替换前的值：%@",cindex,[_productListArry objectAtIndex:cindex]);
    
    NSString *resultStr=sender.tag==-1?@"0":@"1";
    
    if([[subDict objectForKey:@"result"] isEqualToString:@"1"] && [resultStr isEqualToString:@"1"])//第二次点击同一个状态
    {
        return;
    }
    
    //设置当前cell 的高度
    float height1=[[subDict objectForKey:@"height"]floatValue]-79;
    if([[subDict objectForKey:@"result"] isEqualToString:@"null"]){
        height1=[[subDict objectForKey:@"height"]floatValue];
    }
    NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",resultStr,@"result",@"",@"reasonid", [NSString stringWithFormat:@"%f",height1],@"height",@"",@"changedate",@"0",@"iswait", nil];
    [_productListArry replaceObjectAtIndex:cindex withObject:scItem]; //用于替换数组中的某个对象
    [_uiTableView reloadData];
    //[_uiTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //histan_NSLog(@"在点击成功按钮后_productListArry index为%d的字典被替换后的值：%@",cindex,[_productListArry objectAtIndex:cindex]);
}

#pragma mark -- 修改按钮事件
-(void)cancelBtnClick:(UIButton *)sender
{
    //生成修改所需的参数，用字典传值
    WuLiuDetailsCell *subCell;
    if (_IsIOS7_) {
        subCell= (WuLiuDetailsCell*)sender.superview.superview.superview;
    }else{
        subCell= (WuLiuDetailsCell*)[[sender superview]superview];
    }
    int cindex=subCell.tag;
    
    _curIndexInArray=cindex;
    IsEditClicknum=1;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定修改该纪录吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
    
    
}



#pragma mark --待定按钮事件
-(void)waitBtnClick:(UIButton*)sender{
    
    WuLiuDetailsCell *subCell;
    if (_IsIOS7_) {
        subCell= (WuLiuDetailsCell*)sender.superview.superview.superview.superview;
    }else{
        subCell= (WuLiuDetailsCell*)[[[sender superview]superview] superview];
    }
    int cindex = subCell.tag;
    NSDictionary *subDict=[_productListArry objectAtIndex:cindex];
    NSString *iswait=@"0";
    
    //histan_NSLog(@"在点击待定按钮后_productListArry index为%d的字典被替换前的值：%@",cindex,[_productListArry objectAtIndex:cindex]);
    
    sender.frame=CGRectMake(213, subCell.waitingBtn.frame.origin.y, subCell.waitingBtn.frame.size.width, subCell.waitingBtn.frame.size.height);
    
    NSString *isWait = [subDict objectForKey:@"iswait"];
    //如果原先不是待定，则改为待定
    if(![isWait isEqualToString:@"1"]){
        iswait=@"1";
        //subCell.retransDateBtn.hidden=YES;
        [sender setImage:[UIImage imageNamed:@"ping_checked_16"] forState:UIControlStateNormal];
        
        sender.frame=CGRectMake(subCell.waitingBtn.frame.origin.x-140, subCell.waitingBtn.frame.origin.y, subCell.waitingBtn.frame.size.width, subCell.waitingBtn.frame.size.height);
        
        NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",[subDict objectForKey:@"result"],@"result",[subDict objectForKey:@"reasonid"],@"reasonid",[subDict objectForKey:@"height"],@"height",@"",@"changedate",iswait,@"iswait", nil];
        [_productListArry replaceObjectAtIndex:cindex withObject:scItem]; //用于替换数组中的某个对象
        
    }
    else  //原先为待定，则改为不待定
    {
        iswait=@"0";
        //subCell.retransDateBtn.hidden=NO;
        [sender setImage:[UIImage imageNamed:@"ping_checked1_16"] forState:UIControlStateNormal];
        
        sender.frame=CGRectMake(subCell.waitingBtn.frame.origin.x, subCell.waitingBtn.frame.origin.y, subCell.waitingBtn.frame.size.width, subCell.waitingBtn.frame.size.height);
        
        //改变当前待定状态
        NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",[subDict objectForKey:@"result"],@"result",[subDict objectForKey:@"reasonid"],@"reasonid",[subDict objectForKey:@"height"],@"height",@"",@"changedate",iswait,@"iswait", nil];
        [_productListArry replaceObjectAtIndex:cindex withObject:scItem]; //用于替换数组中的某个对象
        
        [self performSelector:@selector(retransDateBtnClick:) withObject:subCell.retransDateBtn];
    }
    
    //[_uiTableView reloadData];
    //histan_NSLog(@"在点击待定按钮后_productListArry index为%d的字典被替换后的值：%@",cindex,[_productListArry objectAtIndex:cindex]);
    
}

#pragma mark -- 失败原因选项按钮点击事件（弹出选择列表）
-(void)failedReasonBtnClick:(UIButton *)sender
{
    //先记录被编辑对象对应在——productArray中的下标,然后弹出选择框
    //获取下标
    if (_IsIOS7_) {
        _curIndexInArray = sender.superview.superview.superview.superview.tag;
    }else{
        _curIndexInArray = sender.superview.superview.superview.tag;
    }
    
    //记录当前选择按钮
    _curClickBtn = (UIButton *)sender;
    [_curClickBtn retain];
    
    if (_failedReasonArray == nil) {
        //获取失败原因
        [self performSelector:@selector(getReasonAndPopView)];
    }
    else
    {
        
        [_popoerView.listView reloadData];
        [_popoerView show];
    }
}

#pragma mark -- 该送日期选项按钮点击事件（滑出日期选择）
-(void)retransDateBtnClick:(UIButton *)sender
{
    //histan_NSLog(@"%s",__func__);
    //设置当前被点击的按钮
    _curClickBtn = sender;
    if (_IsIOS7_) {
        _curIndexInArray = sender.superview.superview.superview.superview.tag;
    }else{
        _curIndexInArray = sender.superview.superview.superview.tag;
    }
    CGRect r_cg=mainScreen_CGRect;
    //显示日期选择视图_maskView
    //histan_NSLog(@"_maskView frame:%f",_maskView.frame.origin.y);
    CGRect newFrame = CGRectMake(0,r_cg.size.height-300, 320, 300);
    [UIView beginAnimations:@"showTHePiker" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
}

#pragma mark -- 点击确认选择时间按钮的点击事件
-(void)doneItemBtnClick:(UIBarButtonItem *)sender
{
    CGRect r_cg=mainScreen_CGRect;
    //收起键盘，并隐藏picker
    CGRect newFrame = CGRectMake(0, r_cg.size.height, 320, _maskView.frame.size.height);
    [UIView beginAnimations:@"hiedThePikerView" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
    
    //记录所选日期
    NSDate *_selectDate = _datePicker.date;
    //histan_NSLog(@"所选的日期为：%@",_selectDate);
    
    //将所选时间转换为YYYY-MM-dd格式显示在按钮上
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *confromTimespStr = [formatter stringFromDate:_selectDate];
    [_curClickBtn setTitle:confromTimespStr forState:UIControlStateNormal];
    _curClickBtn = nil;
    //    //时间类型转换成int（时间戳）
    //    NSString *dateTime = [NSString stringWithFormat:@"%d",(int)[_selectDate timeIntervalSince1970]]; //测试用
    //    //histan_NSLog(@"shijianchuo =====%@",dateTime);
    
    NSString *dateTime = [HLSoftTools GetdateTimeLong:confromTimespStr];
    
    NSDictionary *subDict = [_productListArry objectAtIndex:_curIndexInArray];
    //histan_NSLog(@"点击确定时间按钮时被替换前：%@",subDict);
    //替换
    //将所选时间的nsdate类型数据记录到——productLIstArray
    NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",[subDict objectForKey:@"result"],@"result",[subDict objectForKey:@"reasonid"],@"reasonid",[subDict objectForKey:@"height"],@"height",dateTime,@"changedate",[subDict objectForKey:@"iswait"],@"iswait", nil];
    [_productListArry replaceObjectAtIndex:_curIndexInArray withObject:scItem]; //用于替换数组中的某个对象
    //histan_NSLog(@"点击确定时间按钮被替换后：%@",[_productListArry objectAtIndex:_curIndexInArray]);
    
    [_uiTableView reloadData];
}


#pragma mark -- 提交操作按钮点击事件
-(void)submitBtnAction:(UIButton *)sender
{
    /*
     步骤：循环判断_productListArry中的对象，（设置为“成功”和“失败”的对象，也即是result字段不为@“null”，@“0”为失败，@“1”为成功）判断是失败还是成功，分别合成json字符串，最后合成json参数（用批处理方法“API_Dealwith_Outbound”）
     */
    NSMutableArray *jsonStrArray = [[NSMutableArray alloc] init];
    _indexForObjArray = [[NSMutableArray alloc] init];
    for ( int i=0 ;i < [_productListArry count]; i++ ) {
        NSDictionary *itemDict = [_productListArry objectAtIndex:i];
        //histan_NSLog(@"the ItemDict:%@",itemDict);
        
        if([[itemDict objectForKey:@"result"] isEqualToString:@"null"])
        {
            //有没有设置状态的商品，要求必须选择
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还有商品未选择结果！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;//终止执行以下语句
        }
        
        else if ([[itemDict objectForKey:@"result"] isEqualToString:@"0"]) {
            NSString *reasonidStr =[NSString stringWithFormat:@"%@",[itemDict objectForKey:@"reasonid"]];
            //histan_NSLog(@"reasonidStr:%@",reasonidStr);
            NSString *retransdateStr =[NSString stringWithFormat:@"%@",[itemDict objectForKey:@"changedate"]];
            //histan_NSLog(@"retransdateStr:%@",retransdateStr);
            NSString *isWait = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"iswait"]];
            //histan_NSLog(@"iswait:%@",isWait);
            //设置为失败的，但是如果没有选择失败原因，则提示必须选择
            if (reasonidStr.length == 0) {
                //有没有设置状态的商品，要求必须选择
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请给失败结果选择失败原因！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            //不为待定，但没有选择日期
            if ([isWait isEqualToString:@"0"] && retransdateStr.length == 0 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请给失败结果选择改送日期！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            //            //记录该对象下标
            //            [_indexForObjArray addObject:[NSString stringWithFormat:@"%d",i]];
            
            NSString *failedString = [NSString stringWithFormat:@"{\"cid\":%@,\"success\":0,\"rid\":%@,\"memo\":\"\",\"retransdate\":\"%@\"}",[itemDict objectForKey:@"id"],[itemDict objectForKey:@"reasonid"],[itemDict objectForKey:@"changedate"]];
            [jsonStrArray addObject:failedString];
            
        }
        
        else if([[itemDict objectForKey:@"result"] isEqualToString:@"1"])
        {
            //设置为成功的
            //            //记录该对象下标
            //            [_indexForObjArray addObject:[NSString stringWithFormat:@"%d",i]];
            NSString *successString = [NSString stringWithFormat:@"{\"cid\":%@,\"success\":1}",[itemDict objectForKey:@"id"]];
            [jsonStrArray addObject:successString];
            
        }
        [_indexForObjArray retain];
    }
    //histan_NSLog(@"调用保存接口需要的json字符串参数数组：%@",jsonStrArray);
    
    if ([jsonStrArray count] < 1) {
        //histan_NSLog(@"没有操作过...");
        
    }
    else
    {
        if ([jsonStrArray count] == 1) {
            
            NSString *theJsonString = [NSString stringWithFormat:@"[%@]",[jsonStrArray objectAtIndex:0]];
            //调用处理函数
            [self performSelector:@selector(deallWithOutBound:) withObject:theJsonString];
        }
        else
        {
            //用@“,”分隔连接成最终json参数字符串
            
            /*正确格式
             [{"cid": 1001185668,"success": 0,"rid": "","memo": "","retransdate": ""}]
             */
            NSString *theJsonString = @"";
            for (NSString *itemStr in jsonStrArray) {
                theJsonString = [theJsonString stringByAppendingFormat:@",%@",itemStr];
            }
            //去掉第一个“，”
            theJsonString = [theJsonString substringFromIndex:1];
            theJsonString = [NSString stringWithFormat:@"[%@]",theJsonString];
            //调用处理函数
            [self performSelector:@selector(deallWithOutBound:) withObject:theJsonString];
        }
        
    }
}

//#pragma mark -- 重置按钮点击事件
//-(void)resetBtnAction:(UIButton *)sender
//{
//    //调用重置函数，成功后返回单子列表页
//    [self performSelector:@selector(resetDataAndBack)];
//}

#pragma mark -- 批处理商品详细
-(void)deallWithOutBound:(NSString *)jsonString
{
    //jsonString = @"[{\"cid\": 1001185668,\"success\": 0,\"rid\": \"\",\"memo\": \"\",\"retransdate\": \"\"}]";
    ////histan_NSLog(@"jsonString:%@",jsonString);
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"操作处理中..."];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    NSString *listCode = [appDelegate.boundList_curItemDic objectForKey:@"cCode"];
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"cCode",listCode,@"itemJson",jsonString,nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest_deal = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Dealwith_Outbound wsParameters:wsParas];
    
    //异步
    [ASISOAPRequest_deal startAsynchronous];
    
    [ASISOAPRequest_deal setCompletionBlock:^{
        
        
        @try {
            
            //获取返回的json数据
            NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest_deal responseString]];
            //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
            
            NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
            //histan_NSLog(@"allDic --- %@",allDic);
            //histan_NSLog(@"allDic  objectForKey:the data--- %@",[allDic objectForKey:@"data"]);
            if ([[allDic objectForKey:@"error"] intValue] == 0) {
                
                appDelegate.opeationSuccessNeedReloadPage=@"1"; //修改成功，返回需要刷新数据
                
                //操作成功
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
                HUD.labelText =@"操作成功！";
                [HUD hide:YES afterDelay:1];
                
                //返回列表页面
                [self performSelector:@selector(backToListView) withObject:nil afterDelay:1.5];
            }
            else
            {
                //操作失败
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
                HUD.labelText =[allDic objectForKey:@"data"];
                [HUD hide:YES afterDelay:2];
                
            }
            
        }
        @catch (NSException *exception) {
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
            HUD.labelText =@"操作超时！";
            [HUD hide:YES afterDelay:2];
        }
        @finally {
            
        }
    }];
    
    //请求失败
    [ASISOAPRequest_deal setFailedBlock:^{
        [HUD hide:YES];
        //  NSError *error = [ASISOAPRequest_deal error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！您的网络目前可能不给力哦^_^" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        //histan_NSLog(@"请求超时！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
    }];
    
}

-(void)backToListView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 获取当前单子中的子订单列表
-(void)getOutBoundItemList
{
    
    @try {
        
        [HUD setLabelText:@"加载中..."];
        HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        NSString *listCode = [appDelegate.boundList_curItemDic objectForKey:@"cCode"];
        
        //初始化参数数组（必须是可变数组）
        NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"cCode",listCode,nil];
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Outbound_Item_List wsParameters:wsParas];
        [wsParas release];
        
        [ASISOAPRequest retain];
        ASISOAPRequest.delegate=self;
        [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
        [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
        [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess_getOutBoundItemList:)];//加载成功的方法
        [ASISOAPRequest startAsynchronous];//异步加载
        
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前没有数据！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    @finally {
        
    }
    
}


//加载成功，现实到页面。
-(void)requestDidSuccess_getOutBoundItemList:(ASIHTTPRequest*)requestLoadSource{
    
    @try {
        
        
        HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        [HUD hide:YES];
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[requestLoadSource responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        //NSLog(@"allDic --- %@",allDic);
        //NSLog(@"allDic  objectForKey:the data--- %@",[allDic objectForKey:@"data"]);
        
        //保存所有返回data的数据
        _allDataDic = [[NSDictionary alloc] init];
        _allDataDic = [allDic objectForKey:@"data"];
        [_allDataDic retain];
        
        //将单号，顾客，电话,地址，业务员，促销员，备注添加到最后要加载的数据集合中(_resultArray)
        NSString *address=[appDelegate.boundList_curItemDic objectForKey:@"cusAddr"];
        NSString *cusMobile=[appDelegate.boundList_curItemDic objectForKey:@"cusMobile"];
        if ([[appDelegate.boundList_curItemDic objectForKey:@"cusAddr"] isEqualToString:@""] || [appDelegate.boundList_curItemDic objectForKey:@"cusAddr"]==nil) {
            address=@"无";
        }
        
        if ([[appDelegate.boundList_curItemDic objectForKey:@"cusMobile"] isEqualToString:@""] ||[appDelegate.boundList_curItemDic objectForKey:@"cusMobile"]==nil) {
            cusMobile=@"无";
        }
        
        //2014-03-03:增加当前日期（appDelegate.boundList_curDate）;“商提单”（cuslading）；“方提单”（folading）
        NSDictionary *dict0 = [NSDictionary dictionaryWithObjectsAndKeys:@"curDate",@"name",@"auto",@"height",appDelegate.boundList_curDate,@"content",@"日　期：",@"leftTitle", nil];
        
        NSDictionary *dict7 = [NSDictionary dictionaryWithObjectsAndKeys:@"cuslading",@"name",@"auto",@"height",[[appDelegate.boundList_curItemDic objectForKey:@"cuslading"] isEqualToString:@""]?@"无":[appDelegate.boundList_curItemDic objectForKey:@"cuslading"],@"content",@"商提单：",@"leftTitle", nil];
        
        NSDictionary *dict8 = [NSDictionary dictionaryWithObjectsAndKeys:@"folading",@"name",@"auto",@"height",[[appDelegate.boundList_curItemDic objectForKey:@"folading"] isEqualToString:@""]?@"无":[appDelegate.boundList_curItemDic objectForKey:@"folading"],@"content",@"方提单：",@"leftTitle", nil];
        
        
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"cCode",@"name",@"auto",@"height",[[appDelegate.boundList_curItemDic objectForKey:@"cCode"] isEqualToString:@""]?@"无":[appDelegate.boundList_curItemDic objectForKey:@"cCode"],@"content",@"单　号：",@"leftTitle", nil];
        
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"cusName",@"name",@"auto",@"height",[[appDelegate.boundList_curItemDic objectForKey:@"cusName"] isEqualToString:@""]?@"无":[appDelegate.boundList_curItemDic objectForKey:@"cusName"],@"content",@"顾　客：",@"leftTitle", nil];
        
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"cusMobile",@"name",@"auto",@"height",cusMobile ,@"content",@"电　话：",@"leftTitle", nil];
        
        NSDictionary *dict10 = [NSDictionary dictionaryWithObjectsAndKeys:@"cusAddr",@"name",@"auto",@"height", address,@"content",@"地　址：",@"leftTitle", nil];
        
        
        
        //从_allDataDic获取业务员姓名+电话
        NSLog(@"_allDataDic:%@ ",_allDataDic);
        NSString *salesStr = @"";
        NSString *salesStr_1 =[_allDataDic objectForKey:@"sales"];
        NSString *salesStr_2 =[_allDataDic objectForKey:@"smobile"];
        
        if ([[_allDataDic objectForKey:@"sales"] isEqual:[NSNull null]] || [[_allDataDic objectForKey:@"sales"] isEqualToString:@""]) {
            salesStr_1=@"无";
        }
        
        if([[_allDataDic objectForKey:@"smobile"] isEqual:[NSNull null]] || [[_allDataDic objectForKey:@"smobile"] isEqualToString:@""]){
            salesStr_2=@"无";
        }
        
        salesStr=[NSString stringWithFormat:@"%@(%@)",salesStr_1,salesStr_2];
        
        
        //4-10增加“司机”字段显示
        NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"driver",@"name",@"auto",@"height",[[appDelegate.boundList_curItemDic objectForKey:@"driver"] isEqualToString:@""]?@"无":[appDelegate.boundList_curItemDic objectForKey:@"driver"],@"content",@"司　机：",@"leftTitle", nil];
        
        
        NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"sales",@"name",@"auto",@"height",salesStr,@"content",@"业务员：",@"leftTitle", nil];
        
        
        NSString *sellerStr  =@"";
        NSString *sellerStr_1 =[_allDataDic objectForKey:@"seller"];
        NSString *sellerStr_2 =[_allDataDic objectForKey:@"mobile"];
        
        if ([[_allDataDic objectForKey:@"seller"] isEqual:[NSNull null]] || [[_allDataDic objectForKey:@"seller"] isEqualToString:@""]) {
            sellerStr_1=@"无";
        }
        
        NSString *str1=[_allDataDic objectForKey:@"mobile"];
        NSLog(@"%@",str1);
        if([str1 isEqual:[NSNull null]] || [str1 isEqualToString:@""]){
            sellerStr_2=@"无";
        }
        
        
        sellerStr=[NSString stringWithFormat:@"%@(%@)",sellerStr_1,sellerStr_2];
        
        //NSString *sellerStr = [NSString stringWithFormat:@"%@(%@)",([[_allDataDic objectForKey:@"seller"] isEqualToString:@""] || [_allDataDic objectForKey:@"seller"]==nil)?@"无": [_allDataDic objectForKey:@"seller"],([[_allDataDic objectForKey:@"mobile"] isEqualToString:@""]?@"无":[_allDataDic objectForKey:@"mobile"])];
        NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"seller",@"name",@"auto",@"height",sellerStr,@"content",@"促销员：",@"leftTitle", nil];
        
        NSDictionary *dict9 = [NSDictionary dictionaryWithObjectsAndKeys:@"cMeno",@"name",@"auto",@"height",[[appDelegate.boundList_curItemDic objectForKey:@"cMemo"] isEqualToString:@""]?@"无":[appDelegate.boundList_curItemDic objectForKey:@"cMemo"],@"content",@"备　注：",@"leftTitle", nil];
        
        //添加到最终要显示的数据集合
        _resultArray = [NSMutableArray arrayWithObjects:dict0,dict1,dict2,dict3,dict4,dict5,dict6, dict7,dict8,dict9,dict10,nil];
        
        //添加商品列表信息
        _productListArry = [[NSMutableArray alloc] init];
        if ([appDelegate.curOutBoundStatus isEqualToString:@"3"] ||[appDelegate.curOutBoundStatus isEqualToString:@"2"] ) {
            //不是未送货状态
            int i = 0;
            for (NSDictionary *item in [_allDataDic objectForKey:@"list"]) {
                //histan_NSLog(@"商品列表之一项:%@",item);
                /*cInvName = "\U6d88\U6bd2\U67dc(ZTD)";
                 cInvStd = "ZTD100F-04QGD";
                 cid = 1001185696;
                 iQuantity = 1;
                 memo = "";
                 retransdate = "2014-02-23";
                 rname = "\U4ea7\U54c1\U6709\U7455\U75b5";
                 success = 0;*/
                NSDictionary *dictItem = [NSDictionary dictionaryWithObjectsAndKeys:@"productDetails",@"name",@"70",@"height",item,@"content",@"商品信息",@"leftTitle",[NSString stringWithFormat:@"%d",i],@"index",nil];
                [_resultArray addObject:dictItem];
                
                
                //找到对应失败原因的id
                NSString *rnameStr = [item objectForKey:@"rname"];
                NSString *rID = @"";
                for (NSDictionary *reasonDic in _failedReasonArray) {
                    NSString *rname = [reasonDic objectForKey:@"rname"];
                    if ([rnameStr isEqualToString:rname]) {
                        rID = [NSString stringWithFormat:@"%@",[reasonDic objectForKey:@"rid"]];
                    }
                }
                NSString *changeDate = [item objectForKey:@"retransdate"];//从接口返回的是“yyyy-MM-dd”形式的字符串，这里转化成时间戳字符串，显示到界面时要转化为“yyyy-MM-dd”，用作参数调用接口时直接做参数不用再转化
                //histan_NSLog(@"改送日期：%@",changeDate);
                
                NSString *changeDateInt = [NSString stringWithFormat:@"%@",[HLSoftTools GetdateTimeLong:changeDate]];
                
                
                NSString *isWait = @"1";//默认为待定
                //判断返回的日期是否为空,这里用时间戳来判断，时间戳一定要等于10位
                if (changeDateInt.length > 9) {
                    //不为空时要转化成时间戳
                    changeDate = changeDateInt;
                    //histan_NSLog(@"日期不为空！将日期：%@转化为了：%@",[item objectForKey:@"retransdate"],changeDate);
                    
                    isWait = @"0";
                }
                else
                {
                    changeDate = @"";
                }
                
                NSString *height = @"70";
                
                //根据状态设置cell的高度
                NSString *result =[NSString stringWithFormat:@"%@",[_allDataDic objectForKey:@"success"]] ;
                if ([result isEqualToString:@"0"]) { //失败
                    height = @"145";
                }
                
                //添加成功或者失败状态的产品内容记录
                NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[item objectForKey:@"cid"],@"id",[item objectForKey:@"success"],@"result",rID,@"reasonid",height,@"height",changeDate,@"changedate",isWait,@"iswait", nil];
                [_productListArry addObject:scItem];
                
                i++;
            }
            
        }
        else
        {
            //状态为未送货
            int i = 0;
            for (NSDictionary *item in [_allDataDic objectForKey:@"list"]) {
                //histan_NSLog(@"商品列表之一项:%@",item);
                NSDictionary *dictItem = [NSDictionary dictionaryWithObjectsAndKeys:@"productDetails",@"name",@"70",@"height",item,@"content",@"商品信息",@"leftTitle",[NSString stringWithFormat:@"%d",i],@"index",nil];
                [_resultArray addObject:dictItem];
                
                
                
                //添加未送货产品内容记录
                NSString *retransDateInt = [HLSoftTools GetdateTimeLong:[item objectForKey:@"retransdate"]];
                //判断返回的日期是否为空
                if (retransDateInt.length > 8) {
                    //不为空时要转化成时间戳
                    retransDateInt = [HLSoftTools GetdateTimeLong:retransDateInt];
                    //histan_NSLog(@"日期不为空！将日期：%@转化为了：%@",[item objectForKey:@"retransdate"],retransDateInt);
                }
                else
                {
                    retransDateInt = @"";
                }
                
                NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[item objectForKey:@"cid"],@"id",@"null",@"result",@"",@"reasonid",@"70",@"height",retransDateInt,@"changedate",@"0",@"iswait", nil];
                [_productListArry addObject:scItem];
                
                i++;
            }
        }
        
        
        NSDictionary *dict11 = [NSDictionary dictionaryWithObjectsAndKeys:@"showButtons",@"name",@"auto",@"height",@"showButtons",@"content",@"按钮组：",@"leftTitle", nil];
        [_resultArray addObject:dict11];
        
        [_resultArray retain];
        [_productListArry retain];
        [_uiTableView reloadData];
        
        
        
        //histan_NSLog(@"在调用获取数据接口API_Outbound_Item_List后_productListArry的值：%@",_productListArry);
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

#pragma mark --修改函数
-(void)updateCurrentData:(NSDictionary *)pargramsDict
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"修改中..."];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"cid",[pargramsDict objectForKey:@"cid"],@"success",[pargramsDict objectForKey:@"success"],@"reasonid",[pargramsDict objectForKey:@"reasonid"],@"retransdate",[pargramsDict objectForKey:@"retransdate"],nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Reset_Outbound wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess_updateCurrentData:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载
    
}


//加载成功，现实到页面。
-(void)requestDidSuccess_updateCurrentData:(ASIHTTPRequest*)requestLoadSource{
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    @try {
        
        HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[requestLoadSource responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        //histan_NSLog(@"allDic --- %@",allDic);
        //histan_NSLog(@"allDic  objectForKey:the data--- %@",[allDic objectForKey:@"data"]);
        if ([[allDic objectForKey:@"error"] intValue] == 0) {
            
            appDelegate.opeationSuccessNeedReloadPage=@"1"; //修改成功，返回需要刷新数据
            //操作成功
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
            HUD.labelText =@"操作成功！";
            [HUD hide:YES afterDelay:2];
        }
        else
        {
            //操作失败
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
            HUD.labelText =[allDic objectForKey:@"data"];
            [HUD hide:YES afterDelay:2];
        }
    }
    @catch (NSException *exception) {
        [HUD hide:YES];
        //操作失败
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    @finally {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    NSLog(@"wuliu dealloc");
    [ASISOAPRequest clearDelegatesAndCancel];
    [ASISOAPRequest release];
    ASISOAPRequest =nil;
    [super dealloc];
}

@end
