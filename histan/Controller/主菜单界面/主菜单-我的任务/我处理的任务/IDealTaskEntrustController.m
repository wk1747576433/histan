;//
//  IDealTaskEntrustController.m
//  histan
//
//  Created by liu yonghua on 14-1-17.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import "IDealTaskEntrustController.h"

@implementation IDealTaskEntrustController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"任务转交";

    
    appDelegate=HISTANdelegate;
    
    _curSelectHander=@"";
    
    _resultArray=appDelegate.IdealTaskEntrust;
    //histan_NSLog(@"%@",_resultArray);
    NSDictionary *tempDict=[_resultArray objectAtIndex:7];
    //histan_NSLog(@"%@",tempDict);
    _typeid=[tempDict objectForKey:@"typeid"];
    deptID=[tempDict objectForKey:@"deptid"];
    _area=[tempDict objectForKey:@"area"];
    
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];
    
    //添加 table view
    _uiTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-40) style:UITableViewStylePlain];
    [_uiTableView setDelegate:self];
    [_uiTableView setDataSource:self];
    [_uiTableView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
    [_uiTableView setBackgroundView:bgImgView];
    [self.view addSubview:_uiTableView];
    
    //设置 cell 分割线为空
    _uiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    
     //加载处理人
   [self LoadHandPeoples];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    //注意！添加了手势要用设置代理，用代理方法判断消息发送者来处理事件，否则所有其他事件都会被手势事件所屏蔽
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewInputDone:)];
    //点击一下的时候触发
    gesture.numberOfTapsRequired = 1;
    //设置代理
    gesture.delegate=self;
    [_uiTableView addGestureRecognizer:gesture];
}




#pragma mark -- 隐藏textView的键盘
-(void)textViewInputDone:(UIBarItem *)sender
{
    UITextView *textview=(UITextView*)[self.view viewWithTag:initTag+987432];
    [textview resignFirstResponder];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier =[NSString stringWithFormat:@"cell_%d",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        //cell 的高度
        float curCellHeight=40;
        
        NSDictionary *dict = [_resultArray objectAtIndex:indexPath.row];
        CGRect cellFrame = [cell frame];
        
        cellFrame.origin = CGPointMake(100, 2); 
        if(indexPath.row<6){
            
            int textLabelWidth=235;
             
            UILabel *TaskTypeName_text1 = [[UILabel alloc] initWithFrame:CGRectMake(3, 2, 80, 21)];
            TaskTypeName_text1.highlightedTextColor = [UIColor whiteColor];
            TaskTypeName_text1.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
            TaskTypeName_text1.backgroundColor = [UIColor clearColor];
            TaskTypeName_text1.font=[UIFont systemFontOfSize:14.0f];
            TaskTypeName_text1.textAlignment=NSTextAlignmentLeft;
            TaskTypeName_text1.text=[dict objectForKey:@"leftTitle"];
            [cell.contentView addSubview:TaskTypeName_text1];
            [TaskTypeName_text1 release];
            
            UILabel *TaskTypeName_text2 = [[UILabel alloc] initWithFrame:CGRectZero];
            TaskTypeName_text2.lineBreakMode = NSTextAlignmentCenter;
            TaskTypeName_text2.highlightedTextColor = [UIColor whiteColor];
            TaskTypeName_text2.numberOfLines = 0;
            // TaskTypeName_text2.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
            TaskTypeName_text2.backgroundColor = [UIColor clearColor];
            TaskTypeName_text2.font=[UIFont systemFontOfSize:14.0f];
            TaskTypeName_text2.textAlignment=NSTextAlignmentLeft;
            TaskTypeName_text2.text=[dict objectForKey:@"content"];
            [cell.contentView addSubview:TaskTypeName_text2];
            
            
            
            if (indexPath.row==3) {
                
                //业务员及电话、促销员及电话
                NSString *phoneNum = [dict objectForKey:@"content"];
                if ([phoneNum isEqualToString:@"无数据"] || [phoneNum isEqualToString:@""]) {
                    TaskTypeName_text2.text=phoneNum;
                }else{
                    NSMutableAttributedString *lastString = [[NSMutableAttributedString alloc] initWithString:phoneNum];
                    //histan_NSLog(@"%d",phoneNum.length);
                    //获取括号内的字符，如果 大于 3位，则添加拨打电话事件。
                    
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

            
            
            
            [TaskTypeName_text2 release];
            
            //  CGRect rect = CGRectInset(cellFrame, 2, 2);
            CGRect rect=CGRectMake(80, 4, textLabelWidth, TaskTypeName_text2.frame.size.height);
            TaskTypeName_text2.frame = rect;
            [TaskTypeName_text2 sizeToFit];
            curCellHeight=TaskTypeName_text2.frame.size.height+5;
        }
        
        if([[dict objectForKey:@"name"] isEqualToString:@"TaskDesc"]){
            
            ////histan_NSLog(@"info:%@:",info);
            
            float _cellHeightDesc=0; //cell 的高度
            
            
            UIScrollView *TasdDesc=[[UIScrollView alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-20, 100)];
            TasdDesc.backgroundColor=[UIColor whiteColor];
            
            TasdDesc.layer.cornerRadius = 8;
            TasdDesc.layer.masksToBounds = YES;
            //给图层添加一个有色边框
            TasdDesc.layer.borderWidth = 0;
            TasdDesc.layer.borderColor=[[UIColor grayColor]CGColor];//[[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor];
            
            //创建任务描述信息面板
            UIImageView *imgView1=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-30, 50)];
            //[imgView1 setImage:[UIImage imageNamed:@"task_information_feedback_bg"]];
            UIImageView *imgView_Headbg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30, 21)];
            [imgView_Headbg setImage:[UIImage imageNamed:@"solution_hand_bg"]];
            [imgView1 addSubview:imgView_Headbg];
            imgView1.userInteractionEnabled=YES;
            
            imgView1.layer.cornerRadius = 8;
            imgView1.layer.masksToBounds = YES;
            imgView1.layer.borderWidth = 1;
            imgView1.layer.borderColor=[[UIColor grayColor]CGColor];//[[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor];
            
            UILabel *TaskDescLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-30)/2-40, 1, 80, 21)];
            TaskDescLabel.text=@"任务描述";
            TaskDescLabel.backgroundColor=[UIColor clearColor];
            TaskDescLabel.font=[UIFont systemFontOfSize:14];
            TaskDescLabel.textColor=[UIColor whiteColor];
            [imgView_Headbg addSubview:TaskDescLabel];
            
            
            UILabel *TaskDescContentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            TaskDescContentsLabel.lineBreakMode = UILineBreakModeWordWrap;
            TaskDescContentsLabel.highlightedTextColor = [UIColor whiteColor];
            TaskDescContentsLabel.numberOfLines = 0;
            TaskDescContentsLabel.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
            TaskDescContentsLabel.backgroundColor = [UIColor clearColor];
            TaskDescContentsLabel.font=[UIFont systemFontOfSize:14.0f];
            TaskDescContentsLabel.textAlignment=UITextAlignmentLeft;
            TaskDescContentsLabel.text=[dict objectForKey:@"content"];
            CGRect rect=CGRectMake(3, 25, self.view.frame.size.width-30, TaskDescContentsLabel.frame.size.height);
            TaskDescContentsLabel.frame = rect;
            [TaskDescContentsLabel sizeToFit];
            
            [imgView1 addSubview:TaskDescContentsLabel];
            
             
            //设置任务描述面板的高度
            imgView1.frame=CGRectMake(5, 5, self.view.frame.size.width-30, TaskDescContentsLabel.frame.size.height+30+25);
            
            _cellHeightDesc+=imgView1.frame.size.height+5;
            
            //1，必须先添加背景
            [cell.contentView addSubview:TasdDesc];
            
            //2，添加任务描述信息
            [TasdDesc addSubview:imgView1];
             
            //当前cell 高度
            curCellHeight= _cellHeightDesc;
             
            [TasdDesc release];
            [TaskDescContentsLabel release];
            
            //得到这个cell 的高度
            curCellHeight+=6;
            
            TasdDesc.frame=CGRectMake(10, 5, self.view.frame.size.width-20, curCellHeight);
            
            curCellHeight+=10;
            
        }else if([[dict objectForKey:@"name"] isEqualToString:@"TaskButton"]){
             
          
                    UIButton *submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70-10, 2, 65, 30)];
                    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_commit_task"] forState:UIControlStateNormal];
                    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_commit_task_press"] forState:UIControlStateHighlighted];
                    [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:submitBtn];
                    [submitBtn release];
                   
            
            curCellHeight=50;
            
        }else if([[dict objectForKey:@"name"] isEqualToString:@"TaskEntrust"]){
             
            UIScrollView *TaskEntrust=[[UIScrollView alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-20, 40)];
            TaskEntrust.backgroundColor=[UIColor whiteColor];
            
            TaskEntrust.layer.cornerRadius = 8;
            TaskEntrust.layer.masksToBounds = YES;
            //给图层添加一个有色边框
            TaskEntrust.layer.borderWidth = 0;
           
            //技术类型
            UILabel *ChoiesTypeLbl=[[UILabel alloc]initWithFrame:CGRectMake(3,9, 80, 21)];
            ChoiesTypeLbl.text=@"转交给谁：";
            ChoiesTypeLbl.backgroundColor=[UIColor clearColor];
            ChoiesTypeLbl.font=[UIFont systemFontOfSize:14];
            [TaskEntrust addSubview:ChoiesTypeLbl];
            
            UIButton *skillTypeName=[[UIButton alloc]initWithFrame:CGRectMake(82, 5, 195, 30)];
            [skillTypeName setBackgroundImage:[UIImage imageNamed:@"select_item_bg"] forState:UIControlStateNormal];
            [skillTypeName setTitle:@"==请选择==" forState:UIControlStateNormal];
            skillTypeName.titleLabel.font=[UIFont systemFontOfSize:14];
            [skillTypeName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [skillTypeName addTarget:self action:@selector(ReSelectSkillTypeName:) forControlEvents:UIControlEventTouchUpInside];
            skillTypeName.tag=-1001;
            [TaskEntrust addSubview:skillTypeName];
            
            
            [cell.contentView addSubview:TaskEntrust];
            [TaskEntrust release];
            
            curCellHeight=55;
        }
        
        
        
        
        //显示内容
        
      
        cellFrame.size.height=curCellHeight;
        [cell setFrame:cellFrame];
    }
    return cell;
    
    
    
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
 
            //histan_NSLog(@"thePhontNum:%@",_thePhoneNum);
            NSString *telStr = [NSString stringWithFormat:@"tel://%@",_thePhoneNum];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
         
    }
    
}

 
#pragma mark -- 提交按钮事件
-(void)submitBtnAction:(UIButton*)sender{
    
    //histan_NSLog(@"%@",appDelegate.CurTaskId);
    if([_curSelectHander isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择您要转交给谁！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    //隐藏导航条
   //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //开始加载
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    //显示的文字
    HUD.labelText = @"提交中...";
    //是否有庶罩
    //HUD.dimBackground = YES;
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"taskid",appDelegate.CurTaskId,@"handler",_curSelectHander,nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest  = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_EntrustTask wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed_submit:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess_submit:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载
    
}

#pragma mark -- textView 代理方法
//输入框开始编辑
-(void)textViewDidBeginEditing:(UITextView *)atextView
{
    //histan_NSLog(@"%s",__func__);
    
    //文字输入视图开始编辑
    CGRect frame = CGRectMake(0, -190, 320, 480);
    [UIView beginAnimations:nil context:nil];
    self.view.frame = frame;
    [UIView commitAnimations];
    
    if ([atextView.text isEqualToString:@"请输入解决方案..."]) {
        atextView.text = @"";
    }
}
//输入框完成编辑
-(void)textViewDidEndEditing:(UITextView *)atextView
{
    //histan_NSLog(@"%s",__func__);
    CGRect frame = CGRectMake(0, 0, 320, 480);
    if (self.view.frame.origin.y == 0) {
        //histan_NSLog(@"当前view的y坐标为0");
    }
    else{
        [UIView beginAnimations:nil context:nil];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    if ([atextView.text isEqualToString:@""] || atextView.text == nil) {
        atextView.text = @"请输入解决方案...";
    }
    
}


-(void)ReSelectSkillTypeName:(UIButton*)sender{
    
    //histan_NSLog(@"%@",appDelegate.WebSevicesURL);
    
    //隐藏键盘
    UITextView *textview=(UITextView*)[self.view viewWithTag:initTag+987432];
    [textview resignFirstResponder];
    
    //加载
    [self LoadHandPeoples];
}

#pragma mark -- 加载处理人
-(void)LoadHandPeoples{
    
    //开始加载
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    //显示的文字
    HUD.labelText = @"加载中...";
    //是否有庶罩
    //HUD.dimBackground = YES;
  
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"deptid",deptID,@"typeid",_typeid,@"area",_area,nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest  = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Get_Hand wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载
      
}
 

#pragma mark - UIPopoverListViewDataSource
//加载cell
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    // NSInteger tag = poplistview.tag;
    
    NSString *identifier =[NSString stringWithFormat:@"cell_%d",indexPath.row];
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] autorelease];
    int row = indexPath.row;
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = [allHanderArray objectAtIndex:row];
    [poplistview setTitle:@"请选择您要转交给谁"];
    
    if ([_curSelectHander isEqualToString:[allHanderArray objectAtIndex:row]]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

//行数
- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return [allHanderArray count];
}


#pragma mark - UIPopoverListViewDelegate 弹出窗口代理事件
//cell被选择后的操作
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
     
    UITableViewCell *cell = [poplistview.listView cellForRowAtIndexPath:indexPath];
     
    //当前cell上的文字
    NSString *selectedText = cell.textLabel.text;
    _curSelectHander=selectedText;
    
    UIButton *btn=(UIButton*)[self.view viewWithTag:-1001];
    [btn setTitle:selectedText forState:UIControlStateNormal];
    
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
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
-(void)requestDidSuccess:(ASIHTTPRequest*)requestLoadSource{
    
    
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
    NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
    NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
    NSString *error = (NSString *)[dic objectForKey:@"error"];
    //histan_NSLog(@"dic 的数据是%@",dic);
    
    if ([error intValue] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"data"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        //记录返回的所有任务类型数据
        NSString *allHanderString = [dic objectForKey:@"data"];
        allHanderArray = [allHanderString componentsSeparatedByString:@","]; 
        //histan_NSLog(@"%@",allHanderArray);
        [allHanderArray retain]; 
        
        if ([allHanderArray count]<1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有处理人" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
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
        }
    }
}



//加载数据出错。
-(void)requestDidFailed_submit:(ASIHTTPRequest*)request{
    
   
    if(HUD!=nil){
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText = @"网络连接错误，请检查网络！";
        [HUD hide:YES afterDelay:2];
        
    }
}

//加载成功，现实到页面。
-(void)requestDidSuccess_submit:(ASIHTTPRequest*)requestLoadSource{
 
     
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获取返回的json数据
    NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
    NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
    NSString *error = (NSString *)[dic objectForKey:@"error"];
   
    if ([error intValue] != 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"data"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        //记录返回的所有任务类型数据
        NSString *retStr = [dic objectForKey:@"data"];
         
//        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        [activityIndicator startAnimating];
//       // JSNotifier *notify = [[JSNotifier alloc]initWithTitle:retStr];
//       // notify.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NotifyCheck"]];
////[notify showFor:2];
        
        HUD.mode = MBProgressHUDModeCustomView;
       HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
        HUD.labelText =retStr;
        [HUD hide:YES afterDelay:1];
        
        //1.5s 后，回到后面的窗口上
        [self performSelector:@selector(BackPrePage) withObject:self afterDelay:0.8];
        //[self performSelector:@selector(BackPrePage)];
    }
}

-(void)BackPrePage{
// self.navigationController   
    //histan_NSLog(@"BackPrePage");
 
   // [self.navigationController popToViewController:2 animated:YES];
    //直接返回到我处理任务的界面
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];  
    
//    IDealTaskController  *fourth=[[IDealTaskController alloc]init];
//    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
//    UINavigationController *nav0=(UINavigationController *)window.rootViewController;
//    UIViewController *viewController=[nav0.viewControllers objectAtIndex:1];
//    [viewController.navigationController pushViewController:fourth animated:YES];
    
  //[self.parentViewController dismissModalViewControllerAnimated:YES];    
    
}

#pragma mark -- 手势代理方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //在这里判断什么时候该执行或不执行这个手势事件
    if ([touch.view isKindOfClass:[UIButton class]]) {
        
        return NO; 
    }
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    
    [ASISOAPRequest clearDelegatesAndCancel];
    [ASISOAPRequest release];
    [HUD release];
    
    [super dealloc];
}

@end
