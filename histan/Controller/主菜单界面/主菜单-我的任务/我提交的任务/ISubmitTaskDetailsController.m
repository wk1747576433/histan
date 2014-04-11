//
//  ISubmitTaskDetailsController.m
//  histan
//
//  Created by liu yonghua on 14-1-18.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//
#define randomIdMax -100
#define randomIdMin -200

#import "ISubmitTaskDetailsController.h"

@implementation ISubmitTaskDetailsController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    appDelegate=HISTANdelegate;
    appDelegate.downloadDelegate=self;
    
    _typeid=@"0";
    deptID=@"0";
    _curSelectSkillTypeName=@"";
    curSelectPingFengShuStr=@"";
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];
    // [bgImgView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    // bgImgView.userInteractionEnabled=YES; //启用可响应事件
    // [self.view addSubview:bgImgView];
    
    //添加 table view
    _uiTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-42) style:UITableViewStylePlain];
    [_uiTableView setDelegate:self];
    [_uiTableView setDataSource:self];
    [_uiTableView setBackgroundColor:[UIColor clearColor]];
    [_uiTableView setBackgroundView:bgImgView];
    [self.view addSubview:_uiTableView];
    
    //设置 cell 分割线为空
    _uiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    
    
    //histan_NSLog(@"appDelegate.CurTaskTypeId:%@",appDelegate.CurTaskTypeId);
    NSString *pageTitle=@"任务详情";
    _foreachLabelCount=0;
    if([appDelegate.CurTaskTypeId isEqualToString:@"705"]){
        _curTaskTypeId=0;
        pageTitle=@"我提交-未完成-详情";
    }else if([appDelegate.CurTaskTypeId isEqualToString:@"706"]){
        _curTaskTypeId=1;
        pageTitle=@"我提交-未评价-详情";
    }else if([appDelegate.CurTaskTypeId isEqualToString:@"707"]){
        _curTaskTypeId=2;
        pageTitle=@"我提交-已评价-详情";
    }
    
    
    self.navigationItem.title=pageTitle;
    
    
    
    //异步加载数据
    [self LoadTaskDetailsByTaskId_IsShowHud:YES];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    //注意！添加了手势要用设置代理，用代理方法判断消息发送者来处理事件，否则所有其他事件都会被手势事件所屏蔽
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewInputDone:)];
    //点击一下的时候触发
    gesture.numberOfTapsRequired = 1;
    //设置代理
    gesture.delegate=self;
    [_uiTableView addGestureRecognizer:gesture];
    
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
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    //添加一个收起选择器的按钮
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定选择" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenThePicker)];
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
    
}


-(void)hiddenThePicker
{
    CGRect r_cg = mainScreen_CGRect;
    
    //收起键盘，并隐藏picker
    UIView *pikerView = [self.view viewWithTag:-321546];
    CGRect newFrame = CGRectMake(0, r_cg.size.height, 320, pikerView.frame.size.height);
    [UIView beginAnimations:@"hiedThePikerView" context:nil];
    [pikerView setFrame:newFrame];
    [UIView commitAnimations];
    
}

-(void)dateChanged:(UIDatePicker*)sender{
    
    NSDate* _date = sender.date;
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *nowtimeStr = [formatter stringFromDate:_date];
    
    //histan_NSLog(@"%@",nowtimeStr);
    
    UIButton *uiCompleteTime=(UIButton*)[_uiTableView viewWithTag:initTag+9874561];
    [uiCompleteTime setTitle:nowtimeStr forState:UIControlStateNormal];
    
}

#pragma mark -- 隐藏textView的键盘
-(void)textViewInputDone:(UIBarItem *)sender
{
    //UITextField *textview1=(UITextField*)[self.view viewWithTag:initTag+9874561];
    //[textview1 resignFirstResponder];
    
    UITextView *textview222=(UITextView*)[self.view viewWithTag:initTag+5987];
    [textview222 resignFirstResponder];
    
    UITextField *textview=(UITextField*)[self.view viewWithTag:initTag+987456];
    [textview resignFirstResponder];
    
    
    UITextView *textviewPingjia=(UITextView*)[self.view viewWithTag:initTag+12];
    [textviewPingjia resignFirstResponder];
    
    //隐藏日期选择器
    [self performSelector:@selector(hiddenThePicker)];
    
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
    NSLog(@"第%d个cell的高度是:%f",indexPath.row,cell.frame.size.height);
    NSInteger cellNum = indexPath.row;
    float height = 0;
    //如果是未完成状态并且是附件列表显示cell，手动调节cell高度
    if (cellNum == 7 && _curTaskTypeId == 0) {
        int hubCount = 0;
        for (int i=0; i<[_resultArray count]; i++) {
            NSDictionary *itemDic = [_resultArray objectAtIndex:i];
            if ([[itemDic objectForKey:@"name"] isEqualToString:@"TaskDesc"]) {
                //找到了描述面板的字典
                NSMutableArray *hubArray = [itemDic objectForKey:@"content"];
                hubCount = [hubArray count];
                break;
            }
        }
        height = 125+40*hubCount;
    }
    else
    {
        height = cell.frame.size.height;
    }
    return height;
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
        // //histan_NSLog(@"_foreachLabelCount:%d",_foreachLabelCount);
        if(indexPath.row<_foreachLabelCount){
            
            int textLabelWidth=235;

            UILabel *TaskTypeName_text1 = [[UILabel alloc] initWithFrame:CGRectMake(3, 2, 80, 21)];
            TaskTypeName_text1.highlightedTextColor = [UIColor whiteColor];
            TaskTypeName_text1.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
            TaskTypeName_text1.backgroundColor = [UIColor clearColor];
            TaskTypeName_text1.font=[UIFont systemFontOfSize:14.0f];
            TaskTypeName_text1.textAlignment=NSTextAlignmentRight;
            TaskTypeName_text1.text=[dict objectForKey:@"leftTitle"];
            [cell.contentView addSubview:TaskTypeName_text1];
            [TaskTypeName_text1 release];
            
            curCellHeight=26;
            
            //如果是 任务名称，并且有修改的权限，则可以修改
            if(action_edit==1 && [[dict objectForKey:@"name"] isEqualToString:@"TaskName"]){
                
                UITextField *textfile=[[UITextField alloc]initWithFrame:CGRectMake(80, 2,textLabelWidth, 22)];
                textfile.delegate=self;
                textfile.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
                [textfile setBackground:[UIImage imageNamed:@"loginLable_bg"]];
                textfile.text=[dict objectForKey:@"content"];
                textfile.font=[UIFont systemFontOfSize:14];
                textfile.tag=initTag+987456; //为了获取值和隐藏键盘
                [cell.contentView addSubview:textfile];
                
            }else if(action_edit==1 && [[dict objectForKey:@"name"] isEqualToString:@"TaskHopeCompleteTime"]){
                
                UIButton *showCompleteTimeBtn=[[UIButton alloc]initWithFrame:CGRectMake(80, 2,textLabelWidth, 22)];
                showCompleteTimeBtn.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
                [showCompleteTimeBtn setBackgroundImage:[UIImage imageNamed:@"loginLable_bg"] forState:UIControlStateNormal];
                showCompleteTimeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
                [showCompleteTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                showCompleteTimeBtn.tag=initTag+9874561; //为了获取值和隐藏键盘
                [showCompleteTimeBtn setTitle:[dict objectForKey:@"content"] forState:UIControlStateNormal];
                showCompleteTimeBtn.titleLabel.textAlignment=UITextAlignmentLeft;
                [showCompleteTimeBtn addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:showCompleteTimeBtn];
                
            }else{
                
                UILabel *TaskTypeName_text2 = [[UILabel alloc] initWithFrame:CGRectZero];
                TaskTypeName_text2.lineBreakMode = UILineBreakModeWordWrap;
                TaskTypeName_text2.highlightedTextColor = [UIColor whiteColor];
                TaskTypeName_text2.numberOfLines = 0;
                // TaskTypeName_text2.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
                TaskTypeName_text2.backgroundColor = [UIColor clearColor];
                TaskTypeName_text2.font=[UIFont systemFontOfSize:14.0f];
                TaskTypeName_text2.textAlignment=UITextAlignmentLeft;
                TaskTypeName_text2.text=[dict objectForKey:@"content"];
                [cell.contentView addSubview:TaskTypeName_text2];
                [TaskTypeName_text2 release];
                //  CGRect rect = CGRectInset(cellFrame, 2, 2);
                CGRect rect=CGRectMake(80, 4, textLabelWidth, TaskTypeName_text2.frame.size.height);
                TaskTypeName_text2.frame = rect;
                [TaskTypeName_text2 sizeToFit];
                
                curCellHeight=TaskTypeName_text2.frame.size.height+5;

                
                
              if ((_curTaskTypeId==0 && indexPath.row ==4) ||(_curTaskTypeId==1 && indexPath.row ==4) || (_curTaskTypeId==2 && indexPath.row ==4)|| (_curTaskTypeId==2 && indexPath.row ==5)) {
                    
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
    
            }
      
        }
        
        //描述面板
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
            
            int TaskDescHeight=0;
            
            //如果可修改
            if(action_edit ==1)
            {
                UITextView *textview=[[UITextView alloc]initWithFrame:CGRectMake(2, 23, imgView1.frame.size.width-4, 45)];
                textview.tag=initTag+5987;
                textview.delegate=self;
                textview.text=[[info objectForKey:@"taskdesc"] isEqualToString:@""]? @"请输入任务描述...":[info objectForKey:@"taskdesc"];
                [imgView1 addSubview:textview]; //添加控件到界面
                TaskDescHeight=48;
                
            }else{
                
                UILabel *TaskDescContentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                TaskDescContentsLabel.lineBreakMode = UILineBreakModeWordWrap;
                TaskDescContentsLabel.highlightedTextColor = [UIColor whiteColor];
                TaskDescContentsLabel.numberOfLines = 0;
                TaskDescContentsLabel.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
                TaskDescContentsLabel.backgroundColor = [UIColor clearColor];
                TaskDescContentsLabel.font=[UIFont systemFontOfSize:14.0f];
                TaskDescContentsLabel.textAlignment=UITextAlignmentLeft;
                TaskDescContentsLabel.text=[info objectForKey:@"taskdesc"];
                CGRect rect=CGRectMake(3, 25, self.view.frame.size.width-30, TaskDescContentsLabel.frame.size.height);
                TaskDescContentsLabel.frame = rect;
                [TaskDescContentsLabel sizeToFit];
                
                [imgView1 addSubview:TaskDescContentsLabel];
                TaskDescHeight=TaskDescContentsLabel.frame.size.height;
            }
            
            //得到附件记录
            NSArray *hub=[dict objectForKey:@"content"];
            
            //显示有多少个附件
            UILabel *hubCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(3,TaskDescHeight+28, 280, 21)];
            hubCountLabel.font=[UIFont systemFontOfSize:12.0f];
            [imgView1 addSubview:hubCountLabel]; //添加控件到界面
            
            if (action_delete == 1) {
                //添加拍照 和选择图片 按钮
                UIButton *takePhotoBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-140-28, TaskDescHeight+20, 65, 30)];
                [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"photograph_image"] forState:UIControlStateNormal];
                [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"photograph_press"] forState:UIControlStateHighlighted];
                [takePhotoBtn addTarget:self action:@selector(cameraBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UIButton *takePictures=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70-28, TaskDescHeight+20, 65, 30)];
                [takePictures setBackgroundImage:[UIImage imageNamed:@"option_phont"] forState:UIControlStateNormal];
                [takePictures setBackgroundImage:[UIImage imageNamed:@"option_phont_press"] forState:UIControlStateHighlighted];
                [takePictures addTarget:self action:@selector(fileBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                [imgView1 addSubview:takePhotoBtn];
                [imgView1 addSubview:takePictures];
            }
            
            
            
            
            int hubHeight=0;//附件区域的高度
            int hubCount=0;//附件数量
            //显示附件
            int hub_forIndex_2=0; //记录当前附件的循环 index数
            int hubMarginTop_1=TaskDescHeight+28+23;
            int  curHubCellHeight_1=0;
            NSLog(@"附件数组的cout：%d",[hub count]);
            for (int i=0; i<[hub count]; i++) {
                NSDictionary *hubDict=(NSDictionary*)[hub objectAtIndex:i];
                //type=0表示提交任务时上传的附件，type=1表示解决任务时提交的附件
                if([[hubDict objectForKey:@"type"] isEqualToString:@"0"]){
                    hubCount++;
                    
                    UIImageView *hubCellImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, hubMarginTop_1, self.view.frame.size.width-40, 38)];
                    [hubCellImg setImage:[UIImage imageNamed:@"hubCellbg"]];
                    hubCellImg.userInteractionEnabled=YES;
                    
                    UILabel *cellLineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 2, self.view.frame.size.width-40, 30)];
                    cellLineLabel.backgroundColor=[UIColor whiteColor];
                    [hubCellImg addSubview:cellLineLabel];
                    [cellLineLabel release];
                    
                    UILabel *hubNameLblTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 2, self.view.frame.size.width-170,21)];
                    hubNameLblTitle.text=[hubDict objectForKey:@"attach_name"];
                    hubNameLblTitle.font=[UIFont systemFontOfSize:12.0f];
                    hubNameLblTitle.lineBreakMode = UILineBreakModeWordWrap;
                    hubNameLblTitle.highlightedTextColor = [UIColor whiteColor];
                    hubNameLblTitle.numberOfLines =0;
                    
                    CGRect rect2=CGRectMake(3, 2, self.view.frame.size.width-175, hubNameLblTitle.frame.size.height);
                    hubNameLblTitle.frame = rect2;
                    [hubNameLblTitle sizeToFit];
                    
                    UIButton *hubBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30-72,5, 65, 30)];
                    NSString *path_exsi=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[hubDict objectForKey:@"attach_name"]]];
                    
                    
                    if([CommonHelper isExistFile:path_exsi])//已经下载过了
                    {
                        [hubBtn setBackgroundImage:[UIImage imageNamed:@"openfile"] forState:UIControlStateNormal];
                        [hubBtn setBackgroundImage:[UIImage imageNamed:@"openfile_press"] forState:UIControlStateHighlighted];
                        [hubBtn addTarget:self action:@selector(OpenFileHub:) forControlEvents:UIControlEventTouchUpInside];
                    }else{
                        [hubBtn setBackgroundImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
                        [hubBtn setBackgroundImage:[UIImage imageNamed:@"down_press"] forState:UIControlStateHighlighted];
                        [hubBtn addTarget:self action:@selector(StartDownLoadHub:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    [hubBtn setTag:[[hubDict objectForKey:@"id"]intValue]];
                    
                    //添加一个删除按钮
                    UIButton *hubDelet = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30-72-70,5, 65, 30)];
                    [hubDelet setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [hubDelet setBackgroundImage:[UIImage imageNamed:@"delete_press"] forState:UIControlStateHighlighted];
                    [hubDelet addTarget:self action:@selector(deleteTheFile:) forControlEvents:UIControlEventTouchUpInside];
                    [hubDelet setTag:[[hubDict objectForKey:@"id"]intValue]-1];//设置为文件的id-1
                    
                    
                    if(hub_forIndex_2==0){
                        hubMarginTop_1=TaskDescHeight+50;
                    }else{
                        hubMarginTop_1+=curHubCellHeight_1;
                    }
                    
                    curHubCellHeight_1=hubNameLblTitle.frame.size.height+4;
                    if (curHubCellHeight_1<38) {
                        curHubCellHeight_1=38;
                    }
                    else
                    {
                        
                    }
                    hubHeight+=curHubCellHeight_1;

                    hubCellImg.frame=CGRectMake(5, hubMarginTop_1, self.view.frame.size.width-40,curHubCellHeight_1);
                    
                    [imgView1 addSubview:hubCellImg];
                    [hubCellImg addSubview:hubNameLblTitle];
                    //可删除时把删除按钮加上
                    if (action_delete == 1) {
                        [hubCellImg addSubview:hubDelet];
                    }
                    [hubCellImg addSubview:hubBtn];
                    [hubCellImg release];
                    
                    hub_forIndex_2++;
                    
                }
            }
            
            hubCountLabel.text=[NSString stringWithFormat:@"附件：%d 个",hubCount];
            

            
            //设置任务描述面板的高度
            imgView1.frame=CGRectMake(5, 5, self.view.frame.size.width-30, TaskDescHeight+30+25+hubHeight);
            
            _cellHeightDesc+=imgView1.frame.size.height+5;
            if (action_solve==1) {
                _cellHeightDesc=_cellHeightDesc+5;
                //添加一个选择面板
                UILabel *ChoiesPeopleLbl=[[UILabel alloc]initWithFrame:CGRectMake(5, _cellHeightDesc , self.view.frame.size.width-30, 40)];
                [TasdDesc addSubview:ChoiesPeopleLbl];
                ChoiesPeopleLbl.layer.cornerRadius = 8;
                ChoiesPeopleLbl.layer.masksToBounds = YES;
                ChoiesPeopleLbl.layer.borderWidth = 1;
                ChoiesPeopleLbl.layer.borderColor=[[UIColor grayColor]CGColor];
                ChoiesPeopleLbl.userInteractionEnabled=YES;
                
                //技术类型
                UILabel *ChoiesTypeLbl=[[UILabel alloc]initWithFrame:CGRectMake(3,9, 80, 21)];
                ChoiesTypeLbl.text=@"技术类别：";
                ChoiesTypeLbl.backgroundColor=[UIColor clearColor];
                ChoiesTypeLbl.font=[UIFont systemFontOfSize:14];
                [ChoiesPeopleLbl addSubview:ChoiesTypeLbl];
                
                NSString *showSkillName=[_curSelectSkillTypeName isEqualToString:@""]?@"==请选择==":_curSelectSkillTypeName;
                UIButton *skillTypeName=[[UIButton alloc]initWithFrame:CGRectMake(82, 5, 195, 30)];
                [skillTypeName setBackgroundImage:[UIImage imageNamed:@"select_item_bg"] forState:UIControlStateNormal];
                [skillTypeName setTitle:showSkillName forState:UIControlStateNormal];
                skillTypeName.titleLabel.font=[UIFont systemFontOfSize:14];
                [skillTypeName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [skillTypeName addTarget:self action:@selector(ReSelectSkillTypeName:) forControlEvents:UIControlEventTouchUpInside];
                skillTypeName.tag=-1001;
                [ChoiesPeopleLbl addSubview:skillTypeName];
                
                _cellHeightDesc+=40;
            }
            
            
            //如果不是 未完成状态，可以看到解决方案
            if (_curTaskTypeId!=0) {
                
                
                //创建任务解决方案信息面板
                UIImageView *imgView2=[[UIImageView alloc]initWithFrame:CGRectMake(5, _cellHeightDesc, self.view.frame.size.width-30, 50)];
                UIImageView *imgView2_Headbg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30, 21)];
                [imgView2_Headbg setImage:[UIImage imageNamed:@"solution_hand_bg"]];
                [imgView2 addSubview:imgView2_Headbg];
                
                imgView2.layer.cornerRadius = 8;
                imgView2.layer.masksToBounds = YES;
                imgView2.layer.borderWidth = 1;
                imgView2.layer.borderColor=[[UIColor grayColor]CGColor];
                imgView2.userInteractionEnabled=YES;
                
                UILabel *TaskSoluutionLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-30)/2-40, 1, 80, 21)];
                TaskSoluutionLabel.text=@"解决方案";
                TaskSoluutionLabel.backgroundColor=[UIColor clearColor];
                TaskSoluutionLabel.font=[UIFont systemFontOfSize:14];
                TaskSoluutionLabel.textColor=[UIColor whiteColor];
                [imgView2_Headbg addSubview:TaskSoluutionLabel];
                
                
                int TaskSolutionHeight=0;
                if (action_edit==8) //这个地方不可更改
                {
                    
                    UITextView *textview=[[UITextView alloc]initWithFrame:CGRectMake(2, 23, imgView2.frame.size.width-4, 45)];
                    textview.tag=initTag+987432;
                    textview.delegate=self;
                    textview.text=[[info objectForKey:@"solution_desc"] isEqualToString:@""]? @"请输入解决方案...":[info objectForKey:@"solution_desc"];
                    [imgView2 addSubview:textview]; //添加控件到界面
                    TaskSolutionHeight=48+28;
                }else{
                    UILabel *TaskSolutionContentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                    TaskSolutionContentsLabel.lineBreakMode = UILineBreakModeWordWrap;
                    TaskSolutionContentsLabel.highlightedTextColor = [UIColor whiteColor];
                    TaskSolutionContentsLabel.numberOfLines = 0;
                    TaskSolutionContentsLabel.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
                    TaskSolutionContentsLabel.backgroundColor = [UIColor clearColor];
                    TaskSolutionContentsLabel.font=[UIFont systemFontOfSize:14.0f];
                    TaskSolutionContentsLabel.textAlignment=UITextAlignmentLeft;
                    TaskSolutionContentsLabel.text=[info objectForKey:@"solution_desc"];
                    CGRect rectSolution=CGRectMake(3, 25, self.view.frame.size.width-30, TaskSolutionContentsLabel.frame.size.height);
                    TaskSolutionContentsLabel.frame = rectSolution;
                    [TaskSolutionContentsLabel sizeToFit];
                    
                    [imgView2 addSubview:TaskSolutionContentsLabel];
                    TaskSolutionHeight=TaskSolutionContentsLabel.frame.size.height+28;
                }
                
                UILabel *hubCountLabelSolution = [[UILabel alloc] initWithFrame:CGRectMake(3,TaskSolutionHeight, 280, 21)];
                hubCountLabelSolution.font=[UIFont systemFontOfSize:12.0f];
                [imgView2 addSubview:hubCountLabelSolution]; //添加控件到界面
                
                int hubSolutionCount=0;
                int hubHeightSolution=0;
                int hubMarginTop_2=TaskSolutionHeight+23;
                //显示附件
                int hub_forIndex_1=0;
                for (int i=0; i<[hub count]; i++) {
                    NSDictionary *hubDict=(NSDictionary*)[hub objectAtIndex:i];
                    if([[hubDict objectForKey:@"type"] isEqualToString:@"1"]){
                        
                        hubSolutionCount++;
                        
                        int curHubCellHeight=0;
                        NSLog(@"");
                        
                        //histan_NSLog(@"i:%d,marginTop:%d",hub_forIndex_1,hubMarginTop_2);
                        UIImageView *hubCellImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, hubMarginTop_2, self.view.frame.size.width-40, 38)];
                        [hubCellImg setImage:[UIImage imageNamed:@"hubCellbg"]];
                        hubCellImg.userInteractionEnabled=YES;
                        
                        UILabel *cellLineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 2, self.view.frame.size.width-40, 30)];
                        cellLineLabel.backgroundColor=[UIColor whiteColor];
                        [hubCellImg addSubview:cellLineLabel];
                        [cellLineLabel release];
                        
                        UILabel *hubNameLblTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 2, self.view.frame.size.width-110,21)];
                        hubNameLblTitle.text=[hubDict objectForKey:@"attach_name"];
                        hubNameLblTitle.font=[UIFont systemFontOfSize:12.0f];
                        hubNameLblTitle.lineBreakMode = UILineBreakModeWordWrap;
                        hubNameLblTitle.highlightedTextColor = [UIColor whiteColor];
                        hubNameLblTitle.numberOfLines =0;
                        
                        CGRect rect2=CGRectMake(3, 2, self.view.frame.size.width-150, hubNameLblTitle.frame.size.height);
                        hubNameLblTitle.frame = rect2;
                        [hubNameLblTitle sizeToFit];
                        
                        UIButton *hubBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30-72,5, 65, 30)];
                        NSString *path_exsi=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[hubDict objectForKey:@"attach_name"]]];
                        if([CommonHelper isExistFile:path_exsi])//已经下载过了
                        {
                            [hubBtn setBackgroundImage:[UIImage imageNamed:@"openfile"] forState:UIControlStateNormal];
                            [hubBtn setBackgroundImage:[UIImage imageNamed:@"openfile_press"] forState:UIControlStateHighlighted];
                            [hubBtn addTarget:self action:@selector(OpenFileHub:) forControlEvents:UIControlEventTouchUpInside];
                        }else{
                            [hubBtn setBackgroundImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
                            [hubBtn setBackgroundImage:[UIImage imageNamed:@"down_press"] forState:UIControlStateHighlighted];
                            [hubBtn addTarget:self action:@selector(StartDownLoadHub:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        
                        [hubBtn setTag:[[hubDict objectForKey:@"id"]intValue]];
                        
                        
                        curHubCellHeight=hubNameLblTitle.frame.size.height+4;
                        if (curHubCellHeight<38) {
                            curHubCellHeight=38;
                        }
                        if(hub_forIndex_1==0){
                            hubMarginTop_2=TaskSolutionHeight+23;
                        }else{
                            hubMarginTop_2+=curHubCellHeight;
                        }
                        hubHeightSolution+=curHubCellHeight;
                        hubCellImg.frame=CGRectMake(5, hubMarginTop_2, self.view.frame.size.width-40,curHubCellHeight);
                        
                        [imgView2 addSubview:hubCellImg];
                        [hubCellImg addSubview:hubNameLblTitle];
                        [hubCellImg addSubview:hubBtn];
                        [hubCellImg release];
                        [hubNameLblTitle release];
                        
                        hub_forIndex_1++;
                    }
                }
                
                hubCountLabelSolution.text=[NSString stringWithFormat:@"附件：%d 个",hubSolutionCount];
                
                _cellHeightDesc+=5;
                
                //设置任务描述面板的高度
                imgView2.frame=CGRectMake(5, _cellHeightDesc, self.view.frame.size.width-30, TaskSolutionHeight+25+hubHeightSolution);
                [TasdDesc addSubview:imgView2];
                //当前cell 高度
                curCellHeight=imgView2.frame.size.height+_cellHeightDesc;
                
                
            }else{
                
                //当前cell 高度
                curCellHeight=_cellHeightDesc;
            }
            
            //1，必须先添加背景
            [cell.contentView addSubview:TasdDesc];
            
            //2，添加任务描述信息
            [TasdDesc addSubview:imgView1];
            
            
            //如果是可以提交解决方案的，则显示拍照按钮
            //如果是自己提交的任务还在未完成状态的，也要显示拍照按钮
            if (action_solve==8) //不可更改
            {
                
                //如果是未完成，则显示当前日期
                UILabel *curDateLbl=[[UILabel alloc]initWithFrame:CGRectMake(6, curCellHeight+2, 200, 21)];
                curDateLbl.font=[UIFont systemFontOfSize:12];
                
                NSDate *  senddate=[NSDate date];
                NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/BeiJing"];
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                [dateformatter setTimeZone:timeZone];
                NSString *  locationString=[dateformatter stringFromDate:senddate];
                
                curDateLbl.text=[NSString stringWithFormat:@"今天是：%@",locationString];
                [TasdDesc addSubview:curDateLbl];
                [curDateLbl release];
                
                //累加高度
                curCellHeight+=25;
                
                //添加拍照 和选择图片 按钮
                UIButton *takePhotoBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-140-20, curCellHeight, 65, 30)];
                [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"photograph_image"] forState:UIControlStateNormal];
                [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"photograph_press"] forState:UIControlStateHighlighted];
                //[takePhotoBtn addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UIButton *takePictures=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70-20, curCellHeight, 65, 30)];
                [takePictures setBackgroundImage:[UIImage imageNamed:@"option_phont"] forState:UIControlStateNormal];
                [takePictures setBackgroundImage:[UIImage imageNamed:@"option_phont_press"] forState:UIControlStateHighlighted];
                // [takePictures addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
                
                [TasdDesc addSubview:takePhotoBtn];
                [TasdDesc addSubview:takePictures];
                
                [takePictures release];
                [takePhotoBtn release];
                
                curCellHeight+=34;
            }
            //  }
            
            
            [TasdDesc release];
            
            //得到这个cell 的高度
            
            curCellHeight+=6;
            //curCellHeight += hubHeight;
            TasdDesc.frame=CGRectMake(10, 5, self.view.frame.size.width-20, curCellHeight);
            
            curCellHeight+=10;
            
        }else if([[dict objectForKey:@"name"] isEqualToString:@"TaskButton"]){

            
            float btnMarginLeft=self.view.frame.size.width-10;
            //可解决, 显示在最右侧
            if(action_solve ==1){
                btnMarginLeft=btnMarginLeft-70;
                UIButton *submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnMarginLeft, 2, 65, 30)];
                [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_commit_task"] forState:UIControlStateNormal];
                [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_commit_task_press"] forState:UIControlStateHighlighted];
                [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:submitBtn];
                [submitBtn release];
            }
            
            
            //可品评价
            if(action_commenmt ==1){
                btnMarginLeft=btnMarginLeft-70;
                UIButton *commenmtBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnMarginLeft, 2, 65, 30)];
                [commenmtBtn setBackgroundImage:[UIImage imageNamed:@"evaluation"] forState:UIControlStateNormal];
                [commenmtBtn setBackgroundImage:[UIImage imageNamed:@"evaluation_press"] forState:UIControlStateHighlighted];
                [commenmtBtn addTarget:self action:@selector(action_commenmtAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:commenmtBtn];
                [commenmtBtn release];
                
            }
            
            //可删除
            if(action_delete==1){
                btnMarginLeft=btnMarginLeft-70;
                UIButton *commenmtBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnMarginLeft, 2, 65, 30)];
                [commenmtBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                [commenmtBtn setBackgroundImage:[UIImage imageNamed:@"delete_press"] forState:UIControlStateHighlighted];
                [commenmtBtn addTarget:self action:@selector(action_deleteAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:commenmtBtn];
                [commenmtBtn release];
                
            }
            
            //可修改
            if(action_edit==1){
                btnMarginLeft=btnMarginLeft-70;
                UIButton *commenmtBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnMarginLeft, 2, 65, 30)];
                [commenmtBtn setBackgroundImage:[UIImage imageNamed:@"update_task"] forState:UIControlStateNormal];
                [commenmtBtn setBackgroundImage:[UIImage imageNamed:@"update_task_press"] forState:UIControlStateHighlighted];
                [commenmtBtn addTarget:self action:@selector(action_editAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:commenmtBtn];
                [commenmtBtn release];
                
            }
            
            
            //如果可转交，显示在最左侧
            if(action_entrust==1){
                
                //添加 转交 和 提交 按钮
                UIButton *zhuangjiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 2, 65, 30)];
                [zhuangjiaoBtn setBackgroundImage:[UIImage imageNamed:@"care"] forState:UIControlStateNormal];
                [zhuangjiaoBtn setBackgroundImage:[UIImage imageNamed:@"care_press"] forState:UIControlStateHighlighted];
                [zhuangjiaoBtn addTarget:self action:@selector(zhuangjiaoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:zhuangjiaoBtn];
                [zhuangjiaoBtn release];
                
            }
            
            
            
            curCellHeight=80+5;
            
            
            
        }else if([[dict objectForKey:@"name"] isEqualToString:@"TaskOver"]){
            
            
            UIScrollView *TaskPingjia=[[UIScrollView alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-20, 40)];
            TaskPingjia.backgroundColor=[UIColor whiteColor];
            
            TaskPingjia.layer.cornerRadius = 8;
            TaskPingjia.layer.masksToBounds = YES;
            //给图层添加一个有色边框
            TaskPingjia.layer.borderWidth = 0;
            
            //创建任务描述信息面板
            UIImageView *imgView1=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-30, 50)];
            //[imgView1 setImage:[UIImage imageNamed:@"task_information_feedback_bg"]];
            UIImageView *imgView_Headbg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30, 21)];
            [imgView_Headbg setImage:[UIImage imageNamed:@"job_evaluation_hand_bg"]];
            [imgView1 addSubview:imgView_Headbg];
            imgView1.userInteractionEnabled=YES;
            
            imgView1.layer.cornerRadius = 8;
            imgView1.layer.masksToBounds = YES;
            imgView1.layer.borderWidth = 1;
            imgView1.layer.borderColor=[[UIColor grayColor]CGColor];//[[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor];
            imgView1.tag=initTag+3389;
            
            UILabel *TaskDescLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-30)/2-40, 1, 80, 21)];
            TaskDescLabel.text=@"任务评价";
            TaskDescLabel.backgroundColor=[UIColor clearColor];
            TaskDescLabel.font=[UIFont systemFontOfSize:14];
            TaskDescLabel.textColor=[UIColor whiteColor];
            [imgView_Headbg addSubview:TaskDescLabel];
            
            
            float pingContentHeight=0;
            if(action_commenmt==1){
                
                //加载评论的方式
                UILabel *pingfenLal=[[UILabel alloc]initWithFrame:CGRectMake(3, 25, 40, 21)];
                pingfenLal.text=@"评分：";
                pingfenLal.font=[UIFont systemFontOfSize:12];
                pingfenLal.tag=initTag+3389398;
                [imgView1 addSubview:pingfenLal];
                
                
                
                
                if(comm_way==1) //评价方式1：四选一评价方式  API_Get_Standard
                {
                    
                    float pingbtnMarginTop=0;
                    float pingbtnMarginLeft=47;
                    int pingForCount=0;
                    int lines=0;
                    for (NSDictionary *item in PingOptionsArray) {
                        
                        if(pingForCount%2==0){
                            pingForCount=0;
                            lines++;
                            pingbtnMarginTop+=25;
                            pingbtnMarginLeft=47;
                        }else{
                            pingbtnMarginLeft=145;
                        }
                        
                        
                        UIButton *pingbtn_1=[[UIButton alloc]initWithFrame:CGRectMake(pingbtnMarginLeft, pingbtnMarginTop, 90, 21)];
                        [pingbtn_1 setTitle:[item objectForKey:@"name"] forState:UIControlStateNormal];
                        [pingbtn_1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [pingbtn_1 setImage:[UIImage imageNamed:@"ping_radio2_16"] forState:UIControlStateNormal];
                        pingbtn_1.titleLabel.font=[UIFont systemFontOfSize:12];
                        [pingbtn_1 addTarget:self action:@selector(pingjiabtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        pingbtn_1.tag=300+pingForCount;
                        [imgView1 addSubview:pingbtn_1];
                        
                        pingForCount++;
                    }
                    
                    pingContentHeight=lines*25+25+5;
                    
                }else//评价方式2：多选评价方式  API_Get_Option
                {
                    
                    
                    int pingForCount=0;
                    
                    for (NSString *item in PingOptionsArray) {
                        
                        
                        
                        UIButton *pingbtn_1=[[UIButton alloc]initWithFrame:CGRectMake(47, pingForCount*25+25, 200, 21)];
                        [pingbtn_1 setTitle:item forState:UIControlStateNormal];
                        [pingbtn_1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [pingbtn_1 setImage:[UIImage imageNamed:@"ping_checked1_16"] forState:UIControlStateNormal];
                        pingbtn_1.titleLabel.font=[UIFont systemFontOfSize:12];
                        [pingbtn_1 addTarget:self action:@selector(pingjiabtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        pingbtn_1.tag=pingForCount;
                        [imgView1 addSubview:pingbtn_1];
                        
                        
                        pingForCount++;
                    }
                    
                    pingContentHeight=pingForCount*25+25+5;
                    
                }
                
                //加载评论的方式
                UILabel *pingfenLal_2=[[UILabel alloc]initWithFrame:CGRectMake(3, pingContentHeight+3, 40, 21)];
                pingfenLal_2.text=@"评语：";
                pingfenLal_2.font=[UIFont systemFontOfSize:12];
                pingfenLal_2.tag=initTag+3389398;
                [imgView1 addSubview:pingfenLal_2];
                //添加文本框
                UITextView *pingjiaText=[[UITextView alloc]initWithFrame:CGRectMake(44,pingContentHeight+3, imgView1.frame.size.width-48, 30)];
                // pingjiaText.text=@"";
                pingjiaText.layer.cornerRadius = 8;
                pingjiaText.layer.masksToBounds = YES;
                pingjiaText.layer.borderWidth = 1;
                pingjiaText.layer.borderColor=[[UIColor grayColor]CGColor];
                pingjiaText.font=[UIFont systemFontOfSize:14];
                pingjiaText.tag=initTag+12;
                pingjiaText.delegate=self;
                [imgView1 addSubview:pingjiaText];
                
                
            }else{

                UILabel *TaskDescContentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                TaskDescContentsLabel.lineBreakMode = UILineBreakModeWordWrap;
                TaskDescContentsLabel.highlightedTextColor = [UIColor whiteColor];
                TaskDescContentsLabel.numberOfLines = 0;
                TaskDescContentsLabel.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
                TaskDescContentsLabel.backgroundColor = [UIColor clearColor];
                TaskDescContentsLabel.font=[UIFont systemFontOfSize:14.0f];
                TaskDescContentsLabel.textAlignment=UITextAlignmentLeft;
                TaskDescContentsLabel.text=[NSString stringWithFormat:@"评价：%@",[info objectForKey:@"explanation"]];
                CGRect rect=CGRectMake(3, 25, self.view.frame.size.width-30, TaskDescContentsLabel.frame.size.height);
                TaskDescContentsLabel.frame = rect;
                [TaskDescContentsLabel sizeToFit];
                
                [imgView1 addSubview:TaskDescContentsLabel];
                pingContentHeight=TaskDescContentsLabel.frame.size.height;
                
                float pingTimeHeight=25;
                
                //如果是未完成，则显示当前日期
                UILabel *curDateLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, imgView1.frame.size.height+5, self.view.frame.size.width-50, 21)];
                curDateLbl.font=[UIFont systemFontOfSize:12];
                
                // NSDate *  senddate=[NSDate date];
                // NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/BeiJing"];
                // NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                // [dateformatter setDateFormat:@"yyyy-MM-dd"];
                // [dateformatter setTimeZone:timeZone];
                // NSString *  locationString=[dateformatter stringFromDate:senddate];
                
                curDateLbl.text=[NSString stringWithFormat:@"时间：%@",[HLSoftTools GetDataTimeStrByIntDate:[info objectForKey:@"sub_ratetime"] DateFormat:@"yyyy-MM-dd"]];
                [imgView1 addSubview:curDateLbl];
                curDateLbl.textAlignment=UITextAlignmentRight;
                [curDateLbl release];
                [TaskPingjia addSubview:imgView1];
                [cell.contentView addSubview:TaskPingjia];
                
                [TaskPingjia addSubview:curDateLbl];
                pingContentHeight+=pingTimeHeight;
                
            }
            
            [TaskPingjia addSubview:imgView1];
            [cell.contentView addSubview:TaskPingjia];
            

            //设置任务描述面板的高度
            imgView1.frame=CGRectMake(5, 5, self.view.frame.size.width-30, pingContentHeight +40);
            
            curCellHeight=imgView1.frame.size.height+10;
            TaskPingjia.frame=CGRectMake(10, 5, self.view.frame.size.width-20, curCellHeight);
            
            curCellHeight+=30;
        }
        
        
        
        
        //显示内容
        
        //如果是需要动态加载高度
        //if([[dict objectForKey:@"height"] isEqualToString:@"auto"]){
        //  if (curCellHeight > 46) {
        //    cellFrame.size.height = 50 + curCellHeight - 46;
        //}else{
        cellFrame.size.height=curCellHeight;
        NSLog(@"这个cell的最后高度：%f",curCellHeight);
        //}
        //}else{
        //cellFrame.size.height=[[dict objectForKey:@"height"] intValue]; //直接定义高度
        //  }
        
        
        
        [cell setFrame:cellFrame];
    }
    return cell;
    
    
    
}


#pragma mark -- 拍照按钮点击事件
-(void)cameraBtn:(UIButton *)sender
{
    //执行拍照操作
    isSaveImage = TRUE;
    NSLog(@"issaveimage true");
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.delegate = self;
	camera.allowsEditing = YES;
    
	//检查摄像头是否支持摄像机模式
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		camera.sourceType = UIImagePickerControllerSourceTypeCamera;
		camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	}
	else
	{
		//histan_NSLog(@"Camera not exist");
		return;
	}
    [self presentModalViewController:camera animated:YES];
}

-(void)fileBtn:(UIButton *)sender
{
 
    //每次清空中间“文件搬运工”
    appDelegate.upFileNameArray = [[NSMutableArray alloc] init];
    [appDelegate.upFileNameArray retain];
    
    //自定义返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    selectFileViewController *fileVC = [[selectFileViewController alloc] init];
    [self.navigationController pushViewController:fileVC animated:YES];
    [fileVC release];
    fileVC = nil;
}


//返回照片名字带后缀的方法
-(NSString *)getFileName:(NSString *)fileName
{
	NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
	NSString *suffix = [temp lastObject];
	temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];
	NSString *name = [temp lastObject];
	name = [name stringByAppendingFormat:@".%@",suffix];
	return name;
}

//如果没有名字，取一个
-(NSString *)timeStampAsString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YMdms"];
    NSString *locationString = [df stringFromDate:nowDate];
    NSString *fileName = [NSString stringWithFormat:@"photo_%@%@",locationString,@".png"];
    return fileName;
}


#pragma mark -- 照相机 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)imgInfo
{
    @try {
        
        [picker dismissModalViewControllerAnimated:YES];
        //histan_NSLog(@"info = %@",info);
        
        //获取照片实例
        UIImage *image = [[imgInfo objectForKey:UIImagePickerControllerOriginalImage] retain];
        //初始化照片名
        NSString *fileName = [[NSString alloc] init];
        
        if ([imgInfo objectForKey:UIImagePickerControllerReferenceURL]) {
            fileName = [[imgInfo objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
            //ReferenceURL的类型为NSURL 无法直接使用  必须用absoluteString 转换，照相机返回的没有UIImagePickerControllerReferenceURL，会报错
            fileName = [self performSelector:@selector(getFileName:) withObject:fileName];
            //histan_NSLog(@"getFileName文件名称：%@",fileName);
            
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:fileName delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            //        [alert show];
        }
        else
        {
            fileName = [self performSelector:@selector(timeStampAsString)];
            //histan_NSLog(@"timeStampAsString文件名称：%@",fileName);
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:fileName delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            //        [alert show];
        }
        
        HISTANAPPAppDelegate *appDelegate1 = HISTANdelegate;
        appDelegate1.upFileNameArray = [[NSMutableArray alloc] init];
        //保存到程序doc目录下

        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSString *filePath = [docPath stringByAppendingPathComponent:fileName]; //Add the file name
        [imageData writeToFile:filePath atomically:YES]; //Write the file
        //histan_NSLog(@"程序文档目录下的路径:%@",filePath);
        //将名称（带后缀名）存入“搬运工”
        [appDelegate1.upFileNameArray addObject:fileName];
        //[appDelegate1.upFileNameArray retain];
        
        //存入相册
        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        //保存图片名
        [myDefault setValue:fileName forKey:@"fileName"];
        
        if (isSaveImage) //判定，避免重复保存
        {
            NSLog(@"isSaveImage =====  true");
            //保存到相册
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:[image CGImage]
                                      orientation:(ALAssetOrientation)[image imageOrientation]
                                  completionBlock:nil];
            [library release];
        }
        [image release];
        isSaveImage = FALSE;
        
        [self viewWillAppear:YES];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


//相机点击取消事件
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    isSaveImage = FALSE;
}




#pragma mark -- 点击删除附件事件
-(void)deleteTheFile:(UIButton*)sender
{
    UIButton *deleteBtn = (UIButton *)sender;
    deleteFileFid =[NSString stringWithFormat:@"%d",deleteBtn.tag + 1];
    NSLog(@"The file fid:%@",deleteFileFid);
    [deleteFileFid retain];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该文件吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert setTag:-95648957];
    [alert show];
    [alert release];
    
}

#pragma mark -- alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == -95648957) {
        //如果确定删除
        if (buttonIndex == 0) {
            
            if (0 > [deleteFileFid intValue]  ) {//因为如果是还没有上传的附件，默认是设置fid为负数的
                //不用上传时，遍历public_hub数组对象，找到fid为当前所选附件对象的移除，再reload一下
                //1.删除数据源中的数据
                
                for (int i=0; i<[_resultArray count]; i++) {
                    NSDictionary *itemDic = [_resultArray objectAtIndex:i];
                    if ([[itemDic objectForKey:@"name"] isEqualToString:@"TaskDesc"]) {
                        //找到了描述面板的字典
                        NSMutableArray *hubArray = [itemDic objectForKey:@"content"];
                        for (int j=0; j<[hubArray count]; j++) {
                            NSDictionary *subItemDic = [hubArray objectAtIndex:j];
                            if ([[subItemDic objectForKey:@"id"] isEqualToString:deleteFileFid]) {
                                //终于找到要删除的附件了,果断删除！
                                [hubArray removeObjectAtIndex:j];
                                break;
                            }
                        }
                        
                    }
                }
                
                //2.重新加载视图
                [_uiTableView reloadData];
            }
            else
            {
                //如果是已经上传到服务器的附件，调用方法删除之，再重新获取数据进行显示
                
                [self performSelector:@selector(deleteFileWithFid:) withObject:deleteFileFid];
            }
        }

    }
    else
    {
        //当用户点击了确认后执行拨号
        if (buttonIndex == 0) {
            NSString *telStr = [NSString stringWithFormat:@"tel://%@",_thePhoneNum];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
        }
    }
}

#pragma mark -- 删除附件
-(void)deleteFileWithFid:(NSString *)fid
{

    //开始加载
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    //显示的文字
    HUD.labelText = @"正在删除...";
    
    NSMutableArray *wsParas;
    //初始化参数数组（必须是可变数组）
    wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"fid",fid,nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest  = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_File_Delete wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest startAsynchronous];//异步加载
    //删除成功
    [ASISOAPRequest setCompletionBlock:^{
        //成功
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        NSDictionary *retDict=[soapPacking getDicFromJsonString:returnString];
        //将字典中key为data的对象取出来
        // NSDictionary *dataDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
        //histan_NSLog(@"dataDic:%@",dataDic);
        //判断返回结果是否为登陆成功
        NSString *retError=[NSString stringWithFormat:@"%@",[retDict objectForKey:@"error"]];
        //histan_NSLog(@"retError:%@",retError);
        
        if([retError isEqualToString:@"1"])//有错误，显示错误信息
        {
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
            HUD.labelText = [retDict objectForKey:@"data"];
            [HUD hide:YES afterDelay:1.5];
            
        }
        else
        {
            
            if(HUD!=nil){
                [HUD hide:YES];
                [HUD removeFromSuperview];
                [HUD release];
                HUD=nil;
            }
            //删除附件成功，删除附件表中的数据,并重新加载视图
            //1.删除数据源中的数据
            for (int i=0; i<[_resultArray count]; i++) {
                NSDictionary *itemDic = [_resultArray objectAtIndex:i];
                if ([[itemDic objectForKey:@"name"] isEqualToString:@"TaskDesc"]) {
                    //找到了描述面板的字典
                    NSMutableArray *hubArray = [itemDic objectForKey:@"content"];
                    for (int j=0; j<[hubArray count]; j++) {
                        NSDictionary *subItemDic = [hubArray objectAtIndex:j];
                        if ([[subItemDic objectForKey:@"id"] isEqualToString:fid]) {
                            //终于找到要删除的附件了,果断删除！
                            [hubArray removeObjectAtIndex:j];
                            break;
                        }
                    }
                    
                }
            }
            //2.重新加载视图
            [_uiTableView reloadData];
            
        }
    }];
    //删除失败
    [ASISOAPRequest setFailedBlock:^{
        
    }];

}
#pragma mark -- 点击评价按钮的事件
-(void)pingjiabtnClick:(UIButton*)sender{
    
    UIImageView *imgview=(UIImageView*)[_uiTableView viewWithTag:initTag+3389];
    
    if(comm_way==1) //四选一
    {
        //移除其他按钮的背景
        for (UIView *item in [imgview subviews]) {
            if([item isKindOfClass:[UIButton class]]){
                UIButton *btn=(UIButton*)item;
                [btn setImage:[UIImage imageNamed:@"ping_radio2_16"] forState:UIControlStateNormal];
            }
            
        }
        
        [sender setImage:[UIImage imageNamed:@"ping_radio_16"] forState:UIControlStateNormal];
        //NSDictionary *dict=(NSDictionary*)[PingOptionsArray objectAtIndex:sender.tag];
        
        ////histan_NSLog(@"bbb:%@",[dict objectForKey:@"value"]);
        //  curSelectPingFengShuStr=[dict objectForKey:@"value"];
        // [curSelectPingFengShu retain];
        if (sender.tag-300==0) {
            curSelectPingFengShuStr=@"1,0,0,0";
        }else if (sender.tag-300==1) {
            curSelectPingFengShuStr=@"0,1,0,0";
        }else if (sender.tag-300==2) {
            curSelectPingFengShuStr=@"0,0,1,0";
        }else if (sender.tag-300==3) {
            curSelectPingFengShuStr=@"0,0,0,1";
        }
        
        
    }else//多选
    {
        
        if ([sender isSelected]) {
            [sender setSelected:NO];
            [sender setImage:[UIImage imageNamed:@"ping_checked1_16"] forState:UIControlStateNormal];
            
        }else
        {
            [sender setSelected:YES];
            [sender setImage:[UIImage imageNamed:@"ping_checked_16"] forState:UIControlStateNormal];
            
        }
        
        
        NSString *tempdStrPingStr=@"";
        for (UIView *item in [imgview subviews]) {
            if([item isKindOfClass:[UIButton class]]){
                UIButton *btn=(UIButton*)item;
                if ([btn isSelected]) {
                    //如果被选择，则累加评价字符串
                    tempdStrPingStr=[NSString stringWithFormat:@"%@,%@",tempdStrPingStr,[PingOptionsArray objectAtIndex:btn.tag]];
                }
                
            }
            
        }
        
        //histan_NSLog(@"%@",tempdStrPingStr);
        curSelectPingFengShuStr=tempdStrPingStr;
        [curSelectPingFengShuStr retain];
        
    }
    
    
    
    
}

-(void)showDatePicker:(UIButton*)sender{
    
    [self textViewInputDone:nil];
    
    
    CGRect r_cg = mainScreen_CGRect;
    CGRect newFrame = CGRectMake(0, r_cg.size.height-300, 320, 300);
    [UIView beginAnimations:@"showTHePiker" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
    
    
}

#pragma mark -- 修改按钮事件
-(void)action_editAction:(UIButton*)sender{
    
    //判断任务名称
    UITextField *taskName=(UITextField*)[_uiTableView viewWithTag:initTag+987456];
    if ([taskName.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入任务名称！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    UITextView *textview=(UITextView*)[self.view viewWithTag:initTag+5987];
    NSString *textviewText=textview.text;
    if([textviewText isEqualToString:@""] || [textviewText isEqualToString:@"请输入任务描述..."]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入任务描述！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    //开始加载
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    //显示的文字
    HUD.labelText = @"修改中...";
    //调用修改之前检查附件数组中的附件是否存在id为负数的附件，id为负数，则代表此附件是需要添加但还未上传的，所以要先上传附件成功后再进行非附件修改的方法
    //将当前附件数组Public_hub数组中id为负数的对象的文件名存储到全局变量中的appDelegate.upFileNameArray中,之后会根据这里的附件名上传附件
    appDelegate.upFileNameArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[_resultArray count]; i++) {
        NSDictionary *itemDic = [_resultArray objectAtIndex:i];
        if ([[itemDic objectForKey:@"name"] isEqualToString:@"TaskDesc"]) {
            //找到了描述面板的字典
            NSMutableArray *hubArray = [itemDic objectForKey:@"content"];
            for (int j=0; j<[hubArray count]; j++) {
                NSDictionary *subItemDic = [hubArray objectAtIndex:j];
                if ( 0 > [[subItemDic objectForKey:@"id"] intValue]) {
                    //找到要添加的附件了,保存文件名至全局变量appDelegate.upFileNameArray！
                    [appDelegate.upFileNameArray addObject:[subItemDic objectForKey:@"attach_name"]];
                }
            }
            break;
            
        }
    }
    [appDelegate.upFileNameArray retain];
    
    //循环上传文件
    @try {
        //如果用户选择了附件上传就上传附件，否则不上传，直接调用非附件修改方法
        if ([appDelegate.upFileNameArray count] > 0) {
            [HUD setLabelText:@"附件上传中..."];
            for (int i = 0; i<[appDelegate.upFileNameArray count]; i ++) {
                //获取fileName和contents参数
                NSString *fileName = [appDelegate.upFileNameArray objectAtIndex:i];
                NSString *contents = [self performSelector:@selector(getContentByFileName:) withObject:fileName];
                @try {
                    //循环发送文件
                    [self performSelector:@selector(upLoadOne:fileContent:) withObject:fileName withObject:contents];
                }
                @catch (NSException *exception) {
                    //如果有异常
                    [HUD hide:YES];
                    //histan_NSLog(@"异常：%@",exception);
                }
                @finally {
                    //清除资源占用
                    
                }
                
            }
            
        }
        else
        {
            //没有要添加的附件就调用非附件修改方法
            [self performSelector:@selector(updateTaskWithoutHub)];
        }
        
    }
    @catch (NSException *exception) {
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        //不用上传文件，跳转回新建页面
        [HUD setLabelText:@"修改失败！请重试..."];
        [HUD hide:YES afterDelay:1.5];
    }
    @finally {
        
    }
   
}

//上传单个文件 fileName文件名  contents 文件内容（加密后）
-(void)upLoadOne:(NSString *)fileName fileContent:(NSString *)contents
{
    //histan_NSLog(@"%s",__func__);
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas = nil;
    wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"bustype",@"1",@"filename",fileName,@"content",contents,@"tasked",appDelegate.CurTaskId,@"step",@"0",nil];
    
    for (NSString *item in  wsParas) {
        //histan_NSLog(@"参数数组项：%@",item);
    }
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest_uploadfile = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_File_Upload wsParameters:wsParas];
    
    //异步
    [ASISOAPRequest_uploadfile retain];
    [ASISOAPRequest_uploadfile setTimeOutSeconds:5000]; //超时时间
    [ASISOAPRequest_uploadfile startAsynchronous];
    //使用block就不用代理了
    [ASISOAPRequest_uploadfile setCompletionBlock:^{
        //[HUD hide:YES];
        //histan_NSLog(@"上传文件时：  responsString-----------------%@",[ASISOAPRequest_uploadfile responseString]);
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest_uploadfile responseString]];
        //histan_NSLog(@"上传文件时调用getReturnFromXMLString方法返回的数据：%@",returnString);
        //获取返回内容为字典
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        //histan_NSLog(@"获取返回内容为字典 ：%@",allDic);
        NSString *error = [allDic objectForKey:@"error"];
        //histan_NSLog(@"获取返回error ：%@",error);
        if ([error intValue] == 1) {
            [HUD hide:YES];
            //histan_NSLog(@"上传失败！！！");
            //抛出错误并停止流程
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[allDic objectForKey:@"data"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        else if([error intValue] == 2)
        {
            [HUD hide:YES];
            //histan_NSLog(@"上传超时！！！");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[allDic objectForKey:@"data"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        else if([error intValue] == 0)
        {
            //histan_NSLog(@"上传成功！！！");
            //如果最后一个附件都上传成功了就调用非附件修改方法
            if (fileName == [appDelegate.upFileNameArray lastObject]) {
                
                [HUD setLabelText:@"附件上传成功！"];
                [appDelegate.upFileNameArray release];
//                [HUD hide:YES afterDelay:0.8];
                @try {
                    //删除文件照相文件
                    NSFileManager *fileManager=[NSFileManager defaultManager];
                    for (NSString *item in appDelegate.upFileNameArray) {
                        if ([item hasPrefix:@"photo_"]) {
                            NSString *path_exsi=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",item]];
                            if([CommonHelper isExistFile:path_exsi])//已经下载过了
                            {
                                [fileManager removeItemAtPath:path_exsi error:nil];
                            }
                        }
                    }
                    
                    //调用非附件修改方法
                    [self performSelector:@selector(updateTaskWithoutHub) withObject:self afterDelay:1];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
        }
        else
        {
            [HUD hide:YES];
            //本地错误
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传失败，请检查网络！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        
    }];
    
    //请求失败
    [ASISOAPRequest_uploadfile setFailedBlock:^{
        [HUD setLabelText:@"网络超时！ 上传文件失败！"];
        [HUD hide:YES afterDelay:2.0];
        // NSError *error = [ASISOAPRequest error];
        //histan_NSLog(@"request failed!!!  error:%@",error);
    }];
    
}


//获取指定文件名的内容并加密
-(NSString *)getContentByFileName:(NSString *)fileName
{
    NSString *contents = nil;
    //根据文件名称得到文件路径
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    //压缩图片
    CGSize imagesize = image.size;//相片的尺寸
    //限制尺寸
    float ImgMaxWidth = [appDelegate.upLoadImgMaxWidth floatValue];
    //float ImgMaxSize = [appDelegate.upLoadImgMaxSize floatValue];
    //如果图片宽度大于ImgMaxMaxWidth，则调整尺寸
    float oldImgHeight = imagesize.height;
    float oldImgWidth = imagesize.width;
    if (oldImgWidth > ImgMaxWidth) {
        //调整尺寸
        imagesize.width = ImgMaxWidth;
        imagesize.height = (imagesize.height*(ImgMaxWidth/oldImgWidth));
        //对图片大小进行压缩
        image = [self imageWithImage:image scaledToSize:imagesize];
    }
    
    NSData *contentData = UIImageJPEGRepresentation(image, 0.1);
    //将内容加密
    contents = [[NSString alloc] initWithData:[GTMBase64 encodeData:contentData] encoding:NSUTF8StringEncoding];
    //返回加密后的字符串
    return contents;
}



#pragma mark -- 非附件修改
-(void)updateTaskWithoutHub
{
    //把时间转为时间戳
    UIButton *uiCompleteTime=(UIButton*)[_uiTableView viewWithTag:initTag+9874561];
    NSString *wCompleteTimeSTr=uiCompleteTime.titleLabel.text;
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:wCompleteTimeSTr]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    //histan_NSLog(@"timeSp:%@",timeSp); //时间戳的值

    UITextField *taskName=(UITextField*)[_uiTableView viewWithTag:initTag+987456];
    UITextView *textview=(UITextView*)[self.view viewWithTag:initTag+5987];
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"taskid",appDelegate.CurTaskId,@"taskname",taskName.text,@"taskdesc",textview.text,@"wcomptime",timeSp,nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest  = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_UpdateTask wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed_edit:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess_edit:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载

}

#pragma mark -- 新增附件上传


#pragma mark -- 删除按钮事件
-(void)action_deleteAction:(UIButton*)sender{
    
    //提示，是否要还原系统配置。
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"您确定要删除吗？"
                                  delegate:self
                                  cancelButtonTitle:@"取      消"
                                  destructiveButtonTitle:@"删      除"
                                  otherButtonTitles:nil, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    [actionSheet showFromRect:[_uiTableView frame] inView:self.view animated:YES];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //ZNV //histan_NSLog(@"btntag:%d",buttonIndex);
    if(buttonIndex==0){
        
        
        //开始加载
        HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
        //显示的文字
        HUD.labelText = @"删除中...";
        //是否有庶罩
        //HUD.dimBackground = YES;
        
        //初始化参数数组（必须是可变数组）
        NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"taskid",appDelegate.CurTaskId,nil];
        
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASISOAPRequest  = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_DeleteTask wsParameters:wsParas];
        [wsParas release];
        
        [ASISOAPRequest retain];
        ASISOAPRequest.delegate=self;
        [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
        [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed_delete:)];//加载出错的方法。
        [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess_delete:)];//加载成功的方法
        [ASISOAPRequest startAsynchronous];//异步加载
        
        
        
    }
    
    
}

#pragma mark -- 评价按钮事件
-(void)action_commenmtAction:(UIButton*)sender{
    
    
    if (comm_way==2) {
        
        
    }
    
    //histan_NSLog(@"curSelectPingFengShu22:%@",curSelectPingFengShuStr);
    
    if([curSelectPingFengShuStr isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择评分！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    //开始加载
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    //显示的文字
    HUD.labelText = @"提交中...";
    //是否有庶罩
    //HUD.dimBackground = YES;
    
    UITextView *textviewPingjia=(UITextView*)[self.view viewWithTag:initTag+12];
    
    NSMutableArray *wsParas;
    //初始化参数数组（必须是可变数组）
    if (comm_way==1) {
        wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"taskid",appDelegate.CurTaskId,@"explanation",textviewPingjia.text,@"commentoption",curSelectPingFengShuStr,@"cause",@"",nil];
    }else{
        wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"taskid",appDelegate.CurTaskId,@"explanation",textviewPingjia.text,@"commentoption",curSelectPingFengShuStr,@"cause",@"",nil];
    }
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest  = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_CommenmtTask wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed_CommenmtTask:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess_CommenmtTask:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载
    
    
}

#pragma mark -- 转交按钮事件
-(void)zhuangjiaoBtnAction:(UIButton*)sender{
    IDealTaskEntrustController *idealTaskEntrust=[[IDealTaskEntrustController alloc]init];
    //自定义返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    [self.navigationController pushViewController:idealTaskEntrust animated:YES];
    [idealTaskEntrust release];
}

#pragma mark -- 提交按钮时间
-(void)submitBtnAction:(UIButton*)sender{
    
    //判断解决方案 和 技术类别是否为空
    if([_curSelectSkillTypeName isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择技术类别！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    UITextView *textview=(UITextView*)[self.view viewWithTag:initTag+987432];
    NSString *textviewText=textview.text;
    if([textviewText isEqualToString:@""] || [textviewText isEqualToString:@"请输入解决方案..."]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入解决方案！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    //开始加载
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    //显示的文字
    HUD.labelText = @"提交中...";
    //是否有庶罩
    //HUD.dimBackground = YES;
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"taskid",appDelegate.CurTaskId,@"slution",textviewText,@"type",_curSelectSkillTypeName,nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest  = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_SolutionTask wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed_submit:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess_submit:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载
    
    
    
}




//加载数据出错。
-(void)requestDidFailed_CommenmtTask:(ASIHTTPRequest*)request{
    
    
    if(HUD!=nil){
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText = @"网络连接错误，请检查网络！";
        [HUD hide:YES afterDelay:2];
        
    }
}

//加载成功，现实到页面。
-(void)requestDidSuccess_CommenmtTask:(ASIHTTPRequest*)requestLoadSource{
    
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获取返回的json数据
    NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
    NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
    NSString *error = (NSString *)[dic objectForKey:@"error"];
    
    if ([error intValue] == 0) {
        
        NSString *retStr = [dic objectForKey:@"data"];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
        HUD.labelText =retStr;
        [HUD hide:YES afterDelay:1.5];
        
        [self performSelector:@selector(BackPrePage) withObject:self afterDelay:1];
        
    }
    else
    {
        if(HUD!=nil){
            [HUD hide:YES];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"data"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
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
        
        if(HUD!=nil){
            [HUD hide:YES];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"data"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        //记录返回的所有任务类型数据
        NSString *retStr = [dic objectForKey:@"data"];
        
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
        HUD.labelText =retStr;
        [HUD hide:YES afterDelay:1.5];
        
        [self performSelector:@selector(BackPrePage) withObject:self afterDelay:1];
        
    }
}

-(void)BackPrePage{
    
    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}



//加载数据出错。
-(void)requestDidFailed_delete:(ASIHTTPRequest*)request{
    
    
    if(HUD!=nil){
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText = @"网络连接错误，请检查网络！";
        [HUD hide:YES afterDelay:2];
        
    }
}

//加载成功，现实到页面。
-(void)requestDidSuccess_delete:(ASIHTTPRequest*)requestLoadSource{
    
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获取返回的json数据
    NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
    NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
    NSString *error = (NSString *)[dic objectForKey:@"error"];
    
    if ([error intValue] == 0) {
        
        NSString *retStr = [dic objectForKey:@"data"];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
        HUD.labelText =retStr;
        [HUD hide:YES afterDelay:1.5];
        
        [self performSelector:@selector(BackPrePage) withObject:self afterDelay:1];
        
    }
    else
    {
        if(HUD!=nil){
            [HUD hide:YES];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"data"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}


//加载数据出错。
-(void)requestDidFailed_edit:(ASIHTTPRequest*)request{
    
    
    if(HUD!=nil){
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText = @"网络连接错误，请检查网络！";
        [HUD hide:YES afterDelay:2];
        
    }
}

//加载成功，现实到页面。
-(void)requestDidSuccess_edit:(ASIHTTPRequest*)requestLoadSource{
    
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获取返回的json数据
    NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
    NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
    NSString *error = (NSString *)[dic objectForKey:@"error"];
    
    if ([error intValue] == 0) {
        
        NSString *retStr = [dic objectForKey:@"data"];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
        HUD.labelText =retStr;
        [HUD hide:YES afterDelay:1.5];
        
        [self performSelector:@selector(BackPrePage) withObject:self afterDelay:1];
        
    }
    else
    {
        if(HUD!=nil){
            [HUD hide:YES];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"data"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //隐藏日期选择器
    [self performSelector:@selector(hiddenThePicker)];
    
}


#pragma mark -- textView 代理方法
//输入框开始编辑
-(void)textViewDidBeginEditing:(UITextView *)atextView
{
    
    //隐藏日期选择器
    [self performSelector:@selector(hiddenThePicker)];
    
    CGRect r_cg = mainScreen_CGRect;
    
    //histan_NSLog(@"%s",__func__);
    
    //文字输入视图开始编辑
    CGRect frame = CGRectMake(0, -100, 320, r_cg.size.height);
    [UIView beginAnimations:nil context:nil];
    self.view.frame = frame;
    [UIView commitAnimations];
    
    if ([atextView.text isEqualToString:@"请输入解决方案..."]) {
        atextView.text = @"";
    } else if ([atextView.text isEqualToString:@"请输入任务描述..."]) {
        atextView.text = @"";
    }
    
    
    
    //    CGRect endFrame = CGRectMake(0, self.view.frame.size.height+260, self.view.frame.size.width, 260);
    //
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.3];
    //    [UIView setAnimationDelegate:self];
    //    _datePicker.frame = endFrame;
    //    [UIView commitAnimations];
}
//输入框完成编辑
-(void)textViewDidEndEditing:(UITextView *)atextView
{
    CGRect r_cg = mainScreen_CGRect;
    
    //histan_NSLog(@"%s",__func__);
    CGRect frame = CGRectMake(0, 0, 320, r_cg.size.height);
    if (_IsIOS7_) {
        frame = CGRectMake(0, 64, 320,  r_cg.size.height);
    }
    if (self.view.frame.origin.y == 0) {
        //histan_NSLog(@"当前view的y坐标为0");
    }
    else{
        [UIView beginAnimations:nil context:nil];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    
    if ([atextView.text isEqualToString:@""] || atextView.text == nil) {
        if(atextView.tag==initTag+987432){
            atextView.text = @"请输入解决方案...";
        }else if(atextView.tag==initTag+5987){
            atextView.text = @"请输入任务描述...";
        }
        
    }
    
    
    
    
}


-(void)ReSelectSkillTypeName:(UIButton*)sender{
    
    //histan_NSLog(@"%@",appDelegate.WebSevicesURL);
    
    //隐藏键盘
    UITextView *textview=(UITextView*)[self.view viewWithTag:initTag+987432];
    [textview resignFirstResponder];
    
    //开始加载
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    //显示的文字
    HUD.labelText = @"加载中...";
    //是否有庶罩
    //HUD.dimBackground = YES;
    
    
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"deptid",deptID,@"typeid",_typeid,nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest_2 = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Get_Tec wsParameters:wsParas];
    ////histan_NSLog(@"发送的路径：%@",);
    
    
    // NSError *error = [ASISOAPRequest_2 error];
    
    [ASISOAPRequest_2 setCompletionBlock:^{
        
        if(HUD!=nil){
            [HUD hide:YES];
            [HUD removeFromSuperview];
            [HUD release];
            HUD=nil;
        }
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest_2 responseString]];
        NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
        NSString *error = (NSString *)[dic objectForKey:@"error"];
        // //histan_NSLog(@"dic 的数据是%@",dic);
        
        if ([error intValue] != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败,可能是网络问题,请重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
            //记录返回的所有任务类型数据
            allTypeDic = (NSDictionary *)[dic objectForKey:@"data"];
            [allTypeDic retain];
            //histan_NSLog(@"返回的所有任务类型:%@",allTypeDic);
            
            //histan_NSLog(@"此时的部门id：%@",deptID);
            //获取对应部门id下的任务类型
            // NSDictionary *typeDic = [allTypeDic objectForKey:deptID];
            ////histan_NSLog(@"获取对应部门下的任务为:%@",typeDic);
            
            //记录到对应部门下的类型数组
            typeArray = [allTypeDic allValues];
            [typeArray retain];
            typeKeys  = [allTypeDic allKeys];
            [typeKeys retain];
            
            //histan_NSLog(@"对应部门下类型数据：%@",typeArray);
            //histan_NSLog(@"key值为：%@",typeKeys);
            
            if ([typeArray count]<1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有该部门下的任务" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
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
                [poplistview show];            }
        }
        
    }];
    
    [ASISOAPRequest_2 setFailedBlock:^{
        
        if(HUD!=nil){
            [HUD hide:YES];
            [HUD removeFromSuperview];
            [HUD release];
            HUD=nil;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败,可能是网络问题,请重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }];
    
    //异步步请求
    [ASISOAPRequest_2 startAsynchronous];
    
    
    
}



#pragma mark -- 附加下载事件
-(void)StartDownLoadHub:(UIButton*)sender{
    //histan_NSLog(@"StartDownLoadHub:%f  , bounds:%f",sender.frame.size.height,sender.layer.bounds.size.height);
    NSString *btnTag=[NSString stringWithFormat:@"%d",sender.tag];
    bool IsComplete=NO;//标识是否完成。
    for (int i=0; i<[Public_hub count]; i++) {
        
        NSDictionary *hubDict=(NSDictionary*)[Public_hub objectAtIndex:i];
        if([[hubDict objectForKey:@"id"] isEqualToString:btnTag]){
            
            //如果是当前按钮做绑定的附件内容，则开始下载
            
            NSString *showretStr=@"";
            if([[hubDict objectForKey:@"url"] isEqualToString:@""] ){
                showretStr=@"没有文件";
            }else{
                
                PublicDownLoadsBLL *pdownload=[[PublicDownLoadsBLL alloc]init];
                NSString *retStr= [pdownload DownLoadAction:[hubDict objectForKey:@"attach_name"] url:[hubDict objectForKey:@"url"] fileSize:[hubDict objectForKey:@"size"] fileID:[hubDict objectForKey:@"id"]];
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
            
            
            break;
        }
        
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
    
    NSString *btnTag=[NSString stringWithFormat:@"%d",sender.tag];
    for (int i=0; i<[Public_hub count]; i++) {
        
        NSDictionary *hubDict=(NSDictionary*)[Public_hub objectAtIndex:i];
        if([[hubDict objectForKey:@"id"] isEqualToString:btnTag]){
            
            
            @try {
                
                NSString *fileName=[hubDict objectForKey:@"attach_name"];
                
                NSString *filepath= [[CommonHelper getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
                
                NSFileManager *myfile=[[NSFileManager alloc]init];
                if([myfile fileExistsAtPath:filepath]){
                    
                    NSURL*fileURL = [NSURL fileURLWithPath:filepath];
                    
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
            
            
            
            
            
            
            break;
        }
        
    }
    
    
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
//
//

-(void)LoadTaskDetailsByTaskId_IsShowHud:(BOOL)IsShowHud{
    
    
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
    
    
    
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"taskid",appDelegate.CurTaskId,nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_selectTask_Hand_One wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess:)];//加载成功的方法
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
-(void)requestDidSuccess:(ASIHTTPRequest*)requestLoadSource{
    
    
    //histan_NSLog(@"ok");
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获取返回的json数据
    NSString *returnString =[soapPacking getReturnFromXMLString:[requestLoadSource responseString]];
    //  NSString *str1=[[requestLoadSource responseString] stringByReplacingOccurrencesOfString:@"&#13;" withString:@""];
    NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
    NSString *error = (NSString *)[dic objectForKey:@"error"];
    NSLog(@"LoadTaskDetailsByTaskId_IsShowHud: 的数据是%@",dic);
    if ([error intValue] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！您的网络目前可能不给力哦^_^" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        
        NSDictionary *retTaskDetailsData=[dic objectForKey:@"data"];
        
        @try {
            NSDictionary *action=[retTaskDetailsData objectForKey:@"action"];//操作权限
            info=[retTaskDetailsData objectForKey:@"info"];//信息
            
            Public_hub = [[NSMutableArray alloc] initWithArray:[retTaskDetailsData objectForKey:@"hub"]]; //附件列表
            if([info isEqual:[NSNull null]]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据不存在，可能已经被删除！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            
            [Public_hub retain];
            [info retain];
            
            //部门ID
            deptID=[info objectForKey:@"deptid"];
            _typeid=[info objectForKey:@"typeid"];
            _curSelectSkillTypeName=[info objectForKey:@"tec_type"];
            
            //设置 action 权限
            action_delete=[[action objectForKey:@"delete"]intValue];
            action_edit=[[action objectForKey:@"edit"]intValue];
            action_solve=0;//[[action objectForKey:@"solve"]intValue];
            //action_solve=[[action objectForKey:@"solve"]intValue];
            action_commenmt=[[action objectForKey:@"commenmt"]intValue];
            action_entrust=[[action objectForKey:@"entrust"]intValue];
            comm_way=[[info objectForKey:@"comm_way"]intValue];
            
            NSString *taskName=[NSString stringWithFormat:@"%@(%@)",[info objectForKey:@"taskname"],[info objectForKey:@"taskid"]];
            if(action_edit==1){
                taskName=[info objectForKey:@"taskname"];
            }
            
            NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskTypeName",@"name",@"auto",@"height",[info objectForKey:@"typename"],@"content",@"任务类别：",@"leftTitle", nil];
            
            NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskName",@"name",@"auto",@"height",taskName,@"content",@"任务名称：",@"leftTitle", nil];
            NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskTDeptName",@"name",@"auto",@"height",[info objectForKey:@"deptname"],@"content",@"任务部门：",@"leftTitle", nil];
             NSString *submitPeopleName=[NSString stringWithFormat:@"%@(%@)",[info objectForKey:@"submitter"],[[info objectForKey:@"phone"] isEqualToString:@""]?@"无":[info objectForKey:@"phone"]];
         
            NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskSubmiter",@"name",@"auto",@"height",submitPeopleName,@"content",@"提交人：",@"leftTitle", nil];
            NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskSubmitTime",@"name",@"auto",@"height",[HLSoftTools GetDataTimeStrByIntDate:[info objectForKey:@"createtime"] DateFormat:@"yyyy-MM-dd"],@"content",@"提交时间：",@"leftTitle", nil];
            NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskHopeCompleteTime",@"name",@"auto",@"height",[HLSoftTools GetDataTimeStrByIntDate:[info objectForKey:@"w_comp_time"] DateFormat:@"yyyy-MM-dd"],@"content",@"期望时间：",@"leftTitle", nil];
            
            NSDictionary *dict7 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskDesc",@"name",@"auto",@"height",Public_hub,@"content",@"",@"leftTitle",nil];
            NSDictionary *dict8 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskButton",@"name",@"50",@"height",@"noCode",@"content",@"",@"leftTitle", nil];
            
            NSDictionary *dict9 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskSkill",@"name",@"auto",@"height",[info objectForKey:@"tec_type"],@"content",@"技术类别：",@"leftTitle", nil];
            
            NSString *dealPeopleName=[NSString stringWithFormat:@"%@(%@)",[info objectForKey:@"handler"],[[info objectForKey:@"mobile"] isEqualToString:@""]?@"无":[info objectForKey:@"mobile"]];
          

            NSDictionary *dict10 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskdealPeopleName",@"name",@"auto",@"height",dealPeopleName,@"content",@"处 理 人：",@"leftTitle", nil];
            
            NSDictionary *dict11 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskSubmitTime",@"name",@"auto",@"height",[HLSoftTools GetDataTimeStrByIntDate:[info objectForKey:@"completetime"] DateFormat:@"yyyy-MM-dd"],@"content",@"完成时间：",@"leftTitle", nil];
            
            NSDictionary *dict14 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskOver",@"name",@"auto",@"height",@"over",@"content",@"NO",@"leftTitle", nil];
            
            NSDictionary *dict15 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskId",@"name",@"auto",@"height",[info objectForKey:@"taskid"],@"content",@"任 务 号：",@"leftTitle", nil];
            
            _resultArray=[[NSMutableArray alloc]init];
            if (_curTaskTypeId==0) {
                _resultArray = [NSMutableArray arrayWithObjects:dict1,dict15,dict2,dict3,dict10,dict5,dict6,dict7,dict8, nil];
                _foreachLabelCount=7;
            }else if (_curTaskTypeId==1){
                _resultArray = [NSMutableArray arrayWithObjects:dict1,dict9,dict2,dict3,dict10,dict5,dict6,dict11,dict7,dict14,dict8, nil];
                _foreachLabelCount=8;
            }else if (_curTaskTypeId==2){
                _resultArray = [NSMutableArray arrayWithObjects:dict1,dict9,dict2,dict3,dict4,dict10,dict5,dict11,dict7,dict14, nil];
                _foreachLabelCount=8;
                
                //添加显示评价数
                UIImageView *pingfens=[[UIImageView alloc]initWithFrame:CGRectMake(230, 20, 80, 80)];
                [pingfens setImage:[UIImage imageNamed:@"task_handle_ico_bg"]];
                UILabel *pingfensLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
                pingfensLabel.text=[info objectForKey:@"sub_score"];
                pingfensLabel.backgroundColor=[UIColor clearColor];
                pingfensLabel.font=[UIFont boldSystemFontOfSize:26];
                pingfensLabel.textAlignment=UITextAlignmentCenter;
                [pingfens addSubview:pingfensLabel];
                
                [_uiTableView addSubview:pingfens];
                [pingfensLabel release];
                [pingfens release];
            }
            
            [_resultArray retain];
            
            
            if(action_commenmt==1){
                
                //显示正在加载评分规则
                HUD.labelText = @"正在加载评分规则、请稍等...";
                
                //参数数组
                NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"taskid",appDelegate.CurTaskId, nil];
                
                //实例化OSAPHTTP类
                ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
                //获得OSAPHTTP请求
                ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:comm_way==1?API_Get_Standard:API_Get_Standard wsParameters:wsParas];
                ////histan_NSLog(@"发送的路径：%@",);
                
                //设置代理（使用block就不用代理）
                //[ASISOAPRequest setDelegate:self];
                
                //为了使代码更加简洁，使用代码块，而不是用回调方法
                //使用block就不用代理了
                [ASISOAPRequest retain];
                [ASISOAPRequest setCompletionBlock:^{
                    
                    ////histan_NSLog(@"responsString-----------------%@",[ASISOAPRequest responseString]);
                    
                    //登陆成功后保存SID，跳转界面至主菜单
                    NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
                    //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
                    NSDictionary *retDict=[soapPacking getDicFromJsonString:returnString];
                    //将字典中key为data的对象取出来
                   // NSDictionary *dataDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
                    //histan_NSLog(@"dataDic:%@",dataDic);
                    //判断返回结果是否为登陆成功
                    NSString *retError=[NSString stringWithFormat:@"%@",[retDict objectForKey:@"error"]];
                    //histan_NSLog(@"retError:%@",retError);
                    
                    if([retError isEqualToString:@"1"])//有错误，显示错误信息
                    {
                        HUD.mode = MBProgressHUDModeCustomView;
                        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
                        HUD.labelText = [retDict objectForKey:@"data"];
                        [HUD hide:YES afterDelay:1.5];
                        
                    }
                    else
                    {
                        if(HUD!=nil){
                            [HUD hide:YES];
                            [HUD removeFromSuperview];
                            [HUD release];
                            HUD=nil;
                        }
                        
                        if(comm_way==1){
                            
                            
                            
                            NSDictionary *tempditcs=(NSDictionary*)[retDict objectForKey:@"data"];
                            NSDictionary *ret1=[[NSDictionary alloc]initWithObjectsAndKeys:@"非常满意",@"name",[tempditcs objectForKey:@"comm_score1"],@"value",@"comm_score1",@"vkey", nil];
                            NSDictionary *ret2=[[NSDictionary alloc]initWithObjectsAndKeys:@"满        意",@"name",[tempditcs objectForKey:@"comm_score2"],@"value",@"comm_score2",@"vkey", nil];
                            NSDictionary *ret3=[[NSDictionary alloc]initWithObjectsAndKeys:@"一       般",@"name",[tempditcs objectForKey:@"comm_score3"],@"value",@"comm_score3",@"vkey", nil];
                            NSDictionary *ret4=[[NSDictionary alloc]initWithObjectsAndKeys:@"不   满  意",@"name",[tempditcs objectForKey:@"comm_score4"],@"value",@"comm_score4",@"vkey",nil];
                            PingOptionsArray=[[NSMutableArray alloc]initWithObjects:ret1,ret2,ret3,ret4, nil];
                            
                        }else{
                            
                            NSString *tempdStr=[retDict objectForKey:@"data"];
                            PingOptionsArray=[tempdStr componentsSeparatedByString:@"*"];
                        }
                        [PingOptionsArray retain];
                        [_uiTableView reloadData];
                        
                        
                    }
                    
                    
                }];
                
                
                
                [ASISOAPRequest setFailedBlock:^{
                    
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
                    HUD.labelText = @"加载数据失败、请检查网络";
                    [HUD hide:YES afterDelay:1.5];
                    
                }];
                
                //异步
                [ASISOAPRequest startAsynchronous];
                
            }else{
                
                
                if(HUD!=nil){
                    [HUD hide:YES];
                    [HUD removeFromSuperview];
                    [HUD release];
                    HUD=nil;
                }
                //如果不需要评分，则直接加载页面数据
                [_uiTableView reloadData];
            }
 
        }
        @catch (NSException *exception) {
            
            if(HUD!=nil){
                [HUD hide:YES];
                [HUD removeFromSuperview];
                [HUD release];
                HUD=nil;
            }
           // NSString *showStr=[NSString stringWithFormat:@"%@",retTaskDetailsData];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据解析异常" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        @finally {
            
        }
        
        
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
        if (pendLenght >4) {
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
    cell.textLabel.text = [typeArray objectAtIndex:row];
    int skillId=[[typeKeys objectAtIndex:row]intValue];
    cell.tag=skillId;
    [poplistview setTitle:@"请选择技术类别"];
    
    if ([_curSelectSkillTypeName isEqualToString:[typeArray objectAtIndex:row]]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

//行数
- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return [typeArray count];
}


#pragma mark - UIPopoverListViewDelegate 弹出窗口代理事件
//cell被选择后的操作
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    
    // NSInteger tag = poplistview.tag;
    UITableViewCell *cell = [poplistview.listView cellForRowAtIndexPath:indexPath];
    
    _curSelectSkillTypeName=cell.textLabel.text;
    //当前cell上的文字
    NSString *selectedText = cell.textLabel.text;
    
    UIButton *btn=(UIButton*)[self.view viewWithTag:-1001];
    [btn setTitle:selectedText forState:UIControlStateNormal];
    
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
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
        if (![fileID isEqualToString:@""]) {
            
            UIButton *btn=(UIButton*)[self.view viewWithTag:[fileID intValue]];
            [btn setBackgroundImage:[UIImage imageNamed:@"openfile"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"openfile_press"] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(OpenFileHub:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}


#pragma mark -- 每次显示之前的操作
-(void)viewWillAppear:(BOOL)animated
{
    @try {
        NSLog(@"%s",__func__);
        //检查附件是否有已经下载过
        for (int i=0; i<[Public_hub count]; i++) {
            NSDictionary *hubDict=(NSDictionary*)[Public_hub objectAtIndex:i];
            NSString *filename= [hubDict objectForKey:@"attach_name"];
            NSString *fileID= [hubDict objectForKey:@"id"];
            NSString *targetPath=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:filename];
            UIButton *btn=(UIButton*)[self.view viewWithTag:[fileID intValue]];
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
        
        //每次选择了要增加的文件后,也就是检查appdelegate中的搬运工有没有文件，如果有，将之以字典的形式添加到对应的源数据中
        
        //附件加载时的数据源
        NSMutableArray *hubArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[_resultArray count]; i++) {
            NSDictionary *itemDic = [_resultArray objectAtIndex:i];
            if ([[itemDic objectForKey:@"name"] isEqualToString:@"TaskDesc"]) {
                //找到了描述面板的字典
                hubArray = [itemDic objectForKey:@"content"];
                [hubArray retain];
                break;
            }
        }
        
        if (appDelegate.upFileNameArray == nil) {
            NSLog(@"******!!!!!!!! upFileNameArray == nil !!!!!");
        }
        
        //加入临时数据
        if ([appDelegate.upFileNameArray count] > 0) {
            //说明有选择文件,取出文件名
            for (NSString *fName in appDelegate.upFileNameArray) {
                //固定一个范围，在此范围内产生一个随机数，作为将要添加的附件的伪id，此id不能与已有附件id相同，最好是负数
                
                NSString *randomId;
                randomId = [NSString stringWithFormat:@"-%d",((arc4random()%101)+100)];
                NSLog(@"随机产生的伪id：%@",randomId);
                NSDictionary *hubArrayItemDic = [NSDictionary dictionaryWithObjectsAndKeys:fName,@"attach_name",randomId,@"id",@"0",@"size",@"0",@"type",@"",@"url", nil];
                [hubArray addObject:hubArrayItemDic];
            }
            [appDelegate.upFileNameArray removeAllObjects];
        }

        //2.重新加载视图
        [_uiTableView reloadData];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}



-(void)dealloc{
    
    if(ASISOAPRequest!=nil){
        [ASISOAPRequest clearDelegatesAndCancel];
        [ASISOAPRequest release];
    }
    [appDelegate.upFileNameArray removeAllObjects];
    appDelegate.upFileNameArray =nil;
    HUD=nil;
    _resultArray=nil;
    _uiTableView=nil;
    info=nil;
    poplistview=nil;
    _foreachLabelCount=nil;
    _curTaskTypeId=nil;
    typeArray=nil;
    typeKeys=nil;
    allTypeDic=nil;
    deptID=nil;
    _typeid=nil;
    _curSelectSkillTypeName=nil;
    action_edit=nil;
    action_solve=nil;
    action_commenmt=nil;
    action_entrust=nil;
    action_delete=nil;
    comm_way=nil;
    curSelectPingFengShuStr=nil;
    PingOptionsArray=nil;
    _datePicker=nil;
    _maskView=nil;
    Public_hub=nil;
    
    
    [super dealloc];
}

@end
