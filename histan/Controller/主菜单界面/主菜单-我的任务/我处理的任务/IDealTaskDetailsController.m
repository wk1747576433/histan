//
//  IDealTaskDetailsController.m
//  histan
//
//  Created by liu yonghua on 14-1-10.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import "IDealTaskDetailsController.h"

@implementation IDealTaskDetailsController
{
    //表示拍摄的照片是否已经保存
    BOOL isSaveImage;
    
}

@synthesize docInteractionController=_docInteractionController;
@synthesize curSolutionInputStr=_curSolutionInputStr;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate=HISTANdelegate;
    appDelegate.downloadDelegate=self;
    
    
    appDelegate.upFileNameArray = [[NSMutableArray alloc] init];
    
    _typeid=@"0";
    deptID=@"0";
    _curSelectSkillTypeName=@"";
    isSaveImage = FALSE;
    IsLoadOver=0;
    _curSolutionInputStr=[[NSString alloc]init];
    _curSolutionInputStr=@"请输入解决方案...";
    
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
    
    
    //histan_NSLog(@"%@",appDelegate.CurTaskId);
    NSString *pageTitle=@"任务详情";
    _foreachLabelCount=0;
    if([appDelegate.CurTaskTypeId isEqualToString:@"702"]){
        _curTaskTypeId=0;
        pageTitle=@"我处理-未完成-详情";
    }else if([appDelegate.CurTaskTypeId isEqualToString:@"703"]){
        _curTaskTypeId=1;
        pageTitle=@"我处理-未评价-详情";
    }else if([appDelegate.CurTaskTypeId isEqualToString:@"704"]){
        _curTaskTypeId=2;
        pageTitle=@"我处理-已评价-详情";
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
    
   // NSLog(@"view load");
    
}

#pragma mark -- 每次现实之前的操作
-(void)viewWillAppear:(BOOL)animated
{
    appDelegate=HISTANdelegate;
    //histan_NSLog(@"开始设置cell 的高度:%@",appDelegate.upFileNameArray);
    
    //    NSIndexPath *indexx=[NSIndexPath indexPathForRow:7 inSection:0];
    //    UITableViewCell *cell = [self tableView:_uiTableView cellForRowAtIndexPath:indexx];
    //    CGRect cellFrame = [cell frame];
    //    cellFrame.size.height=1000;
    //    cell.frame=cellFrame;
    
    //    if (IsLoadOver>0) {
    //        //histan_NSLog(@"IsLoadOver:YES");
    //
    //    }else{
    //        //histan_NSLog(@"IsLoadOver:NO");
    //    }
    
    @try {
        
        
        
        [_uiTableView reloadData];
        
        
        //        for (int i=0; i<[Public_hub count]; i++) {
        //            NSDictionary *hubDict=(NSDictionary*)[Public_hub objectAtIndex:i];
        //            NSString *filename= [hubDict objectForKey:@"attach_name"];
        //            NSString *fileID= [hubDict objectForKey:@"id"];
        //            NSString *targetPath=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:filename];
        //            UIButton *btn=(UIButton*)[self.view viewWithTag:[fileID intValue]];
        //            if([CommonHelper isExistFile:targetPath])//已经下载过一次该文件
        //            {
        //                [btn setBackgroundImage:[UIImage imageNamed:@"openfile"] forState:UIControlStateNormal];
        //                [btn setBackgroundImage:[UIImage imageNamed:@"openfile_press"] forState:UIControlStateHighlighted];
        //                [btn addTarget:self action:@selector(OpenFileHub:) forControlEvents:UIControlEventTouchUpInside];
        //
        //            }else{
        //                [btn setBackgroundImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        //                [btn setBackgroundImage:[UIImage imageNamed:@"down_press"] forState:UIControlStateHighlighted];
        //                [btn addTarget:self action:@selector(StartDownLoadHub:) forControlEvents:UIControlEventTouchUpInside];
        //            }
        //        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
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
    //histan_NSLog(@"cell.frame.size.height:%d ---  %f  --- %d",indexPath.row,cell.frame.size.height,[appDelegate.upFileNameArray count]);
    if (_curTaskTypeId==0 && [appDelegate.upFileNameArray count]>0 && indexPath.row ==6) {
        return TaskDescCellHeight+ [appDelegate.upFileNameArray count]*40;
    }
    return cell.frame.size.height;
    //    NSDictionary *dict = [_resultArray objectAtIndex:indexPath.row];
    //    UIFont *font = [UIFont systemFontOfSize:14];
    //    CGSize size = [[dict objectForKey:@"content"] sizeWithFont:font constrainedToSize:CGSizeMake(210.0f, 20000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
    //    return size.height+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier =[NSString stringWithFormat:@"cell_%d",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        //        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        //        label.tag = 1;
        //        label.lineBreakMode = UILineBreakModeWordWrap;
        //        label.highlightedTextColor = [UIColor whiteColor];
        //        label.numberOfLines = 0;
        //        label.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
        //        label.backgroundColor = [UIColor clearColor];
        //        [cell.contentView addSubview:label];
        //        [label release];
        
        //cell 的高度
        
        float curCellHeight=40;
        CGRect cellFrame = [cell frame];
        cellFrame.origin = CGPointMake(100, 2);
        
        
        NSDictionary *dict = [_resultArray objectAtIndex:indexPath.row];
        //histan_NSLog(@"indexPath.row:%d:%@",indexPath.row,dict);
        
        // //histan_NSLog(@"_foreachLabelCount:%d",_foreachLabelCount);
        
        if(indexPath.row<_foreachLabelCount){
            
            int textLabelWidth=235;
            if(_curTaskTypeId==2 && indexPath.row<5)
            {
                textLabelWidth=140;
            }
            
            
            UILabel *TaskTypeName_text1 = [[UILabel alloc] initWithFrame:CGRectMake(3, 2, 80, 21)];
            TaskTypeName_text1.highlightedTextColor = [UIColor whiteColor];
            TaskTypeName_text1.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
            TaskTypeName_text1.backgroundColor = [UIColor clearColor];
            TaskTypeName_text1.font=[UIFont systemFontOfSize:14.0f];
            TaskTypeName_text1.textAlignment=NSTextAlignmentRight;
            TaskTypeName_text1.text=[dict objectForKey:@"leftTitle"];
            [cell.contentView addSubview:TaskTypeName_text1];
            [TaskTypeName_text1 release];
            
            UILabel *TaskTypeName_text2 = [[UILabel alloc] initWithFrame:CGRectZero];
            TaskTypeName_text2.lineBreakMode = NSLineBreakByWordWrapping;
            TaskTypeName_text2.highlightedTextColor = [UIColor whiteColor];
            TaskTypeName_text2.numberOfLines = 0;
            // TaskTypeName_text2.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
            TaskTypeName_text2.backgroundColor = [UIColor clearColor];
            TaskTypeName_text2.font=[UIFont systemFontOfSize:14.0f];
            TaskTypeName_text2.textAlignment=NSTextAlignmentLeft;
            TaskTypeName_text2.text=[dict objectForKey:@"content"];
            [cell.contentView addSubview:TaskTypeName_text2];
            [TaskTypeName_text2 release];
            
            //  CGRect rect = CGRectInset(cellFrame, 2, 2);
            CGRect rect=CGRectMake(80, 4, textLabelWidth, TaskTypeName_text2.frame.size.height);
            TaskTypeName_text2.frame = rect;
            [TaskTypeName_text2 sizeToFit];
            curCellHeight=TaskTypeName_text2.frame.size.height+5;
            
            
            
            if ((_curTaskTypeId==0 && indexPath.row ==3) || (_curTaskTypeId==1 && indexPath.row ==4) || (_curTaskTypeId==2 && indexPath.row ==4)|| (_curTaskTypeId==2 && indexPath.row ==5)) {
                
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
        
        
        if([[dict objectForKey:@"name"] isEqualToString:@"TaskDesc"]){
            
            //histan_NSLog(@"infosssssss:");
            
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
            TaskDescContentsLabel.text=[info objectForKey:@"taskdesc"];
            CGRect rect=CGRectMake(3, 25, self.view.frame.size.width-30, TaskDescContentsLabel.frame.size.height);
            TaskDescContentsLabel.frame = rect;
            [TaskDescContentsLabel sizeToFit];
            
            [imgView1 addSubview:TaskDescContentsLabel];
            
            
            //得到附件记录
            NSArray *hub=[dict objectForKey:@"content"];
            
            UILabel *hubCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(3,TaskDescContentsLabel.frame.size.height+28, 280, 21)];
            
            hubCountLabel.font=[UIFont systemFontOfSize:12.0f];
            [imgView1 addSubview:hubCountLabel]; //添加控件到界面
            
            int hubHeight=0;//附件区域的高度
            int hubCount=0;//附件数量
            //显示附件
            int hub_forIndex_2=0; //记录当前附件的循环 index数
            int hubMarginTop_1=TaskDescContentsLabel.frame.size.height+28+23;
            int  curHubCellHeight_1=0;
            for (int i=0; i<[hub count]; i++) {
                NSDictionary *hubDict=(NSDictionary*)[hub objectAtIndex:i];
                if([[hubDict objectForKey:@"type"] isEqualToString:@"0"]){
                    hubCount++;
                    
                    UIImageView *hubCellImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, hubMarginTop_1, self.view.frame.size.width-40, 38)];
                    [hubCellImg setImage:[UIImage imageNamed:@"hubCellbg"]];
                    hubCellImg.userInteractionEnabled=YES;
                    
                    UILabel *cellLineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 2, self.view.frame.size.width-40, 30)];
                    cellLineLabel.backgroundColor=[UIColor whiteColor];
                    [hubCellImg addSubview:cellLineLabel];
                    [cellLineLabel release];
                    
                    UILabel *hubNameLblTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 2, self.view.frame.size.width-120,21)];
                    hubNameLblTitle.text=[hubDict objectForKey:@"attach_name"];
                    hubNameLblTitle.font=[UIFont systemFontOfSize:12.0f];
                    hubNameLblTitle.lineBreakMode = UILineBreakModeWordWrap;
                    hubNameLblTitle.highlightedTextColor = [UIColor whiteColor];
                    hubNameLblTitle.numberOfLines =0;
                    
                    CGRect rect2=CGRectMake(3, 2, self.view.frame.size.width-115, hubNameLblTitle.frame.size.height);
                    hubNameLblTitle.frame = rect2;
                    [hubNameLblTitle sizeToFit];
                    
                    UIButton *hubBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30-80,5, 65, 30)];
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
                    
                    curHubCellHeight_1=hubNameLblTitle.frame.size.height+4;
                    if (curHubCellHeight_1<38) {
                        curHubCellHeight_1=38;
                    }
                    if(hub_forIndex_2==0){
                        hubMarginTop_1=TaskDescContentsLabel.frame.size.height+50;
                    }else{
                        hubMarginTop_1+=curHubCellHeight_1;
                    }
                    hubHeight+=curHubCellHeight_1;
                    hubCellImg.frame=CGRectMake(5, hubMarginTop_1, self.view.frame.size.width-40,curHubCellHeight_1);
                    //  CALayer *bottomBorder = [CALayer layer];
                    //  float height=hubCellImg.frame.size.height-1.0f;
                    //  float width=hubCellImg.frame.size.width;
                    //  bottomBorder.frame = CGRectMake(0.0f, height, width, 1.0f);
                    //  bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
                    //  [hubCellImg.layer addSublayer:bottomBorder];
                    
                    
                    
                    [imgView1 addSubview:hubCellImg];
                    [hubCellImg addSubview:hubNameLblTitle];
                    [hubCellImg addSubview:hubBtn];
                    [hubCellImg release];
                    
                    hub_forIndex_2++;
                }
            }
            
            hubCountLabel.text=[NSString stringWithFormat:@"附件：%d 个",hubCount];
            
            ////histan_NSLog(@"hubHeight:%d",hubHeight);
            
            //设置任务描述面板的高度
            imgView1.frame=CGRectMake(5, 5, self.view.frame.size.width-30, TaskDescContentsLabel.frame.size.height+30+25+hubHeight);
            
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
            
            //得到第一个信息面板的高度，作为第二个面板的距离顶部距离
            //_cellHeightDesc+=5;
            
            
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
            if (action_solve==1){
                
                UITextView *textview=[[UITextView alloc]initWithFrame:CGRectMake(2, 23, imgView2.frame.size.width-4, 45)];
                textview.tag=initTag+987432;
                textview.delegate=self;
                textview.text=[[info objectForKey:@"solution_desc"] isEqualToString:@""]? _curSolutionInputStr:[info objectForKey:@"solution_desc"];
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
                    
                    CGRect rect2=CGRectMake(3, 2, self.view.frame.size.width-115, hubNameLblTitle.frame.size.height);
                    hubNameLblTitle.frame = rect2;
                    [hubNameLblTitle sizeToFit];
                    
                    UIButton *hubBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30-80,5, 65, 30)];
                    
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
            
            
            //1，必须先添加背景
            [cell.contentView addSubview:TasdDesc];
            
            //2，添加任务描述信息
            [TasdDesc addSubview:imgView1];
            [TasdDesc addSubview:imgView2];
            
            //当前cell 高度
            curCellHeight=imgView2.frame.size.height+_cellHeightDesc;
            
            //if(_curTaskTypeId==0){
            
            
            //如果是可以提交解决方案的，则显示拍照按钮
            if (action_solve==1 && _curTaskTypeId==0) {
                
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
                [takePhotoBtn addTarget:self action:@selector(takeCamera:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UIButton *takePictures=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70-20, curCellHeight, 65, 30)];
                [takePictures setBackgroundImage:[UIImage imageNamed:@"option_phont"] forState:UIControlStateNormal];
                [takePictures setBackgroundImage:[UIImage imageNamed:@"option_phont_press"] forState:UIControlStateHighlighted];
                [takePictures addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
                
                
                [TasdDesc addSubview:takePhotoBtn];
                [TasdDesc addSubview:takePictures];
                
                [takePictures release];
                [takePhotoBtn release];
                
                curCellHeight+=34;
            }
            //  }
            
            TaskDescCellHeight=curCellHeight+18; //设置 初始描述的高度。
            
            float apendHubHeight=0;
            if ([appDelegate.upFileNameArray count]>0) {
                
                float apendHubMarginTop=curCellHeight;
                //绘制上传附件列表
                for (int i = 0; i<[appDelegate.upFileNameArray count]; i++) {
                    //label与button的组合
                    
                    if (i>0) {
                        apendHubMarginTop+=42;
                    }
                    
                    apendHubHeight+=40;
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,apendHubMarginTop, TasdDesc.frame.size.width, 40)];
                    [label.layer setBorderWidth:1];
                    [label.layer setBorderColor:[[UIColor grayColor] CGColor]];
                    [label.layer setCornerRadius:2];
                    [label setUserInteractionEnabled:YES];
                    [label setTag:7788+i];
                    
                    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 4, 200, 30)];
                    [textLabel setText:[appDelegate.upFileNameArray objectAtIndex:i]];
                    [textLabel setFont:[UIFont systemFontOfSize:14.0]];
                    [textLabel setLineBreakMode:UILineBreakModeMiddleTruncation];
                    
                    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [openBtn setFrame:CGRectMake(205, 4, 30, 30)];
                    [openBtn setImage:[UIImage imageNamed:@"open_down.png"] forState:UIControlStateNormal];
                    [openBtn addTarget:self action:@selector(openBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [deleteBtn setTag:456987];
                    [deleteBtn setFrame:CGRectMake(248, 4, 30, 30)];
                    [deleteBtn setImage:[UIImage imageNamed:@"delete_down.png"] forState:UIControlStateNormal];
                    [deleteBtn addTarget:self action:@selector(deleteBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [label addSubview:textLabel];
                    [label addSubview:openBtn];
                    [label addSubview:deleteBtn];
                    
                    [TasdDesc addSubview:label];
                }
                
            }
            
            curCellHeight+=apendHubHeight;
            
            [TasdDesc release];
            [TaskDescContentsLabel release];
            
            //得到这个cell 的高度
            curCellHeight+=6;
            
            
            
            
            
            
            TasdDesc.frame=CGRectMake(10, 5, self.view.frame.size.width-20, curCellHeight);
            
            curCellHeight+=10;
            
        }else if([[dict objectForKey:@"name"] isEqualToString:@"TaskButton"]){
            
            
            
//              action_solve=1;
//              action_commenmt=1;
//              action_entrust=1;
//              action_delete=1;
            
            //if(_curTaskTypeId==0){
            
            float btnMarginLeft=self.view.frame.size.width-70-10;
            //可解决, 显示在最右侧
            if(action_solve ==1){
                
                UIButton *submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnMarginLeft, 2, 65, 30)];
                [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_commit_task"] forState:UIControlStateNormal];
                [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_commit_task_press"] forState:UIControlStateHighlighted];
                [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:submitBtn];
                [submitBtn release];
                
            }
            
            
            //可评价
            if(action_commenmt ==1){
                btnMarginLeft=btnMarginLeft-70;
                UIButton *commenmtBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnMarginLeft, 2, 65, 30)];
                [commenmtBtn setBackgroundImage:[UIImage imageNamed:@"evaluation"] forState:UIControlStateNormal];
                [commenmtBtn setBackgroundImage:[UIImage imageNamed:@"evaluation_press"] forState:UIControlStateHighlighted];
                [commenmtBtn addTarget:self action:@selector(action_commenmtAction:) forControlEvents:UIControlEventTouchUpInside];
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
            
            
            if (_curTaskTypeId ==0 &&  action_solve ==0) {
                
                UILabel *tiplabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 300, 23)];
                [tiplabel setText:@"提交人和处理人一样，无操作！"];
                [tiplabel setBackgroundColor:[UIColor clearColor]];
                tiplabel.font=[UIFont systemFontOfSize:12];
                tiplabel.textAlignment=NSTextAlignmentRight;
                [cell addSubview:tiplabel];
            }
            
            curCellHeight=80+5;
            //  }
            
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
            
            UILabel *TaskDescLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-30)/2-40, 1, 80, 21)];
            TaskDescLabel.text=@"任务评价";
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
            TaskDescContentsLabel.text=[NSString stringWithFormat:@"评价：%@",[info objectForKey:@"explanation"]];
            CGRect rect=CGRectMake(3, 25, self.view.frame.size.width-30, TaskDescContentsLabel.frame.size.height);
            TaskDescContentsLabel.frame = rect;
            [TaskDescContentsLabel sizeToFit];
            
            [imgView1 addSubview:TaskDescContentsLabel];
            //设置任务描述面板的高度
            imgView1.frame=CGRectMake(5, 5, self.view.frame.size.width-30, TaskDescContentsLabel.frame.size.height+30);
            
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
            
            curCellHeight=imgView1.frame.size.height+10+pingTimeHeight;
            TaskPingjia.frame=CGRectMake(10, 5, self.view.frame.size.width-20, curCellHeight);
            curCellHeight+=30;
        }
        
        //显示内容
        
        //如果是需要动态加载高度
        //if([[dict objectForKey:@"height"] isEqualToString:@"auto"]){
        //  if (curCellHeight > 46) {
        //    cellFrame.size.height = 50 + curCellHeight - 46;
        //}else{
        
        //}
        //}else{
        //cellFrame.size.height=[[dict objectForKey:@"height"] intValue]; //直接定义高度
        //  }
        
        //histan_NSLog(@"row:%d,value:%f",indexPath.row,curCellHeight);
        cellFrame.size.height=curCellHeight;
        [cell setFrame:cellFrame];
        
        
        //        if ([_resultArray count]-1==indexPath.row) {
        //            IsLoadOver=YES;
        //        }
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //当用户点击了确认后执行拨号
    if (buttonIndex == 0) {
        NSString *telStr = [NSString stringWithFormat:@"tel://%@",_thePhoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
    }
}


#pragma mark -- 调用照相机
-(void)takeCamera:(UIButton *)sender
{
    //执行拍照操作
    isSaveImage = TRUE;
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.delegate =self;
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

#pragma mark -- 照相机 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)infos
{
    [picker dismissModalViewControllerAnimated:YES];
    // //histan_NSLog(@"info = %@",infos);
    
    //获取照片实例
    UIImage *image = [[infos objectForKey:UIImagePickerControllerOriginalImage] retain];
    //初始化照片名
    NSString *fileName = [[NSString alloc] init];
    
    if ([infos objectForKey:UIImagePickerControllerReferenceURL]) {
        fileName = [[infos objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
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
    //保存到程序doc目录下，上传后再删除
    
    //压缩图片
    CGSize imagesize = image.size;//相片的尺寸
    //限制尺寸
    float ImgMaxWidth = [appDelegate1.upLoadImgMaxWidth floatValue];
    float ImgMaxSize = [appDelegate1.upLoadImgMaxSize floatValue];
    
    //如果图片宽度大于ImgMaxHeight，则调整尺寸
    if (imagesize.width > ImgMaxWidth) {
        //调整尺寸
        imagesize.width = ImgMaxWidth;
        imagesize.height = (imagesize.height*ImgMaxWidth/imagesize.width);
        
        //对图片大小进行压缩
        image = [self imageWithImage:image scaledToSize:imagesize];
    }
    //否则直接进行内容大小压缩（递归压缩，至大小小于400）
    NSData *jpgData = UIImageJPEGRepresentation(image,0.5);

    NSString *filePath = [docPath stringByAppendingPathComponent:fileName]; //Add the file name
    [jpgData writeToFile:filePath atomically:YES]; //Write the file
    //histan_NSLog(@"程序文档目录下的路径:%@",filePath);
    //将名称（带后缀名）存入“搬运工”
    [appDelegate1.upFileNameArray addObject:fileName];
    
    //存入相册
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    //保存图片名
    [myDefault setValue:fileName forKey:@"fileName"];
    if (isSaveImage) //判定，避免重复保存
    {
        //保存到相册
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[image CGImage]
                                  orientation:(ALAssetOrientation)[image imageOrientation]
                              completionBlock:nil];
        [library release];
    }
    [image release];
    isSaveImage = FALSE;
    
    [_uiTableView reloadData];
    //[self viewWillAppear:YES];
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

#pragma mark -- 选择文件按钮点击事件
-(void)takePicture:(UIButton *)sender
{
    //自定义返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    selectFileViewController *fileVC = [[selectFileViewController alloc] init];
    [self.navigationController pushViewController:fileVC animated:YES];
    [fileVC release];
    fileVC = nil;
}







#pragma mark -- 评价按钮事件
-(void)action_commenmtAction:(UIButton*)sender{
    
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

#pragma mark -- 提交按钮事件
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
    
    //如果有附件，先上传附件，再提交主记录数据
    //    if(){
    //
    //    }
    
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
        
        
        if ([appDelegate.upFileNameArray count]>0) {
            //开始上传附件
            [HUD setLabelText:@"附件上传中..."];
            [self performSelector:@selector(upLoadFiles) withObject:nil afterDelay:1.0];
            
        }else{
            //记录返回的所有任务类型数据
            NSString *retStr = [dic objectForKey:@"data"];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
            HUD.labelText =retStr;
            [HUD hide:YES afterDelay:1.5];
            [self performSelector:@selector(BackPrePage) withObject:self afterDelay:1];
        }
        
        
        
    }
}
-(void)BackPrePage{
    
    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark -- textView 代理方法
//输入框开始编辑
-(void)textViewDidBeginEditing:(UITextView *)atextView
{
    
    CGRect r_cg=mainScreen_CGRect;
    //histan_NSLog(@"%s",__func__);
    
    //文字输入视图开始编辑
    CGRect frame = CGRectMake(0, -166, 320, r_cg.size.height);
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
    CGRect r_cg=mainScreen_CGRect;
    //histan_NSLog(@"%s",__func__);
    CGRect frame = CGRectMake(0, 0, 320, r_cg.size.height);
    if (_IsIOS7_) {
        frame = CGRectMake(0, 64, 320, r_cg.size.height);
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
        atextView.text = @"请输入解决方案...";
    }
    
    //  _curSolutionInputStr=atextView.text; //重新赋值
    
    _curSolutionInputStr=  [[NSString stringWithFormat:@"%@",atextView.text] retain];
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
    
    
    // NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:ALLButton_1011,@"button1",ALLButton_1013,@"button2",ALLButton_1014,@"button3",@"handler",@"StatisticsType",nil];
    //[NSThread detachNewThreadSelector:@selector(LoadHnadOrSubmitStatistics:) toTarget:[HLSOFTThread defaultCacher] withObject:dic];
    
    
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

#pragma mark -- 详情数据加载成功
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
    NSString *returnString =[soapPacking getReturnFromXMLString:[requestLoadSource responseString]];
    //  NSString *str1=[[requestLoadSource responseString] stringByReplacingOccurrencesOfString:@"&#13;" withString:@""];
    NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
    NSString *error = (NSString *)[dic objectForKey:@"error"];
    //histan_NSLog(@"LoadTaskDetailsByTaskId_IsShowHud: 的数据是%@",dic);
    if ([error intValue] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！您的网络目前可能不给力哦^_^" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        
        NSDictionary *retTaskDetailsData=[dic objectForKey:@"data"];
        
        @try {
            
            Public_hub=[retTaskDetailsData objectForKey:@"hub"]; //附件列表
            NSDictionary *action=[retTaskDetailsData objectForKey:@"action"];//操作权限
            info=[retTaskDetailsData objectForKey:@"info"];//信息
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
            action_edit=[[action objectForKey:@"edit"]intValue];
            action_solve=[[action objectForKey:@"solve"]intValue];
            action_commenmt=[[action objectForKey:@"commenmt"]intValue];
            action_entrust=[[action objectForKey:@"entrust"]intValue];
            
            NSString *taskName=[NSString stringWithFormat:@"%@(%@)",[info objectForKey:@"taskname"],[info objectForKey:@"taskid"]];
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
           
            
            
            NSDictionary *dict10 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskdealPeopleName",@"name",@"auto",@"height",dealPeopleName,@"content",@"处理人：",@"leftTitle", nil];
            
            NSDictionary *dict11 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskSubmitTime",@"name",@"auto",@"height",[HLSoftTools GetDataTimeStrByIntDate:[info objectForKey:@"completetime"] DateFormat:@"yyyy-MM-dd"],@"content",@"完成时间：",@"leftTitle", nil];
            
            NSDictionary *dict14 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskOver",@"name",@"auto",@"height",@"over",@"content",@"NO",@"leftTitle", nil];
            
            
            _resultArray=[[NSMutableArray alloc]init];
            if (_curTaskTypeId==0) {
                _resultArray = [NSMutableArray arrayWithObjects:dict1,dict2,dict3,dict4,dict5,dict6,dict7,dict8, nil];
                _foreachLabelCount=6;
            }else if (_curTaskTypeId==1){
                _resultArray = [NSMutableArray arrayWithObjects:dict1,dict9,dict2,dict3,dict4,dict5,dict6,dict7,dict8, nil];
                _foreachLabelCount=7;
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
                pingfensLabel.textAlignment=NSTextAlignmentCenter;
                [pingfens addSubview:pingfensLabel];
                
                [_uiTableView addSubview:pingfens];
                [pingfensLabel release];
                [pingfens release];
            }
            
            NSDictionary *dict12 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskDesc",@"name",@"auto",@"height",[info objectForKey:@"taskdesc"],@"content",@"",@"leftTitle",nil];
            NSDictionary *dict13 = [NSDictionary dictionaryWithObjectsAndKeys:@"TaskEntrust",@"name",@"auto",@"height",@"无",@"content",@"",@"leftTitle",[info objectForKey:@"deptid"],@"deptid",[info objectForKey:@"typeid"],@"typeid",[info objectForKey:@"area"],@"area",nil];
            //转交界面显示内容
            appDelegate.IdealTaskEntrust=[NSMutableArray arrayWithObjects:dict1,dict2,dict3,dict4,dict5,dict6,dict12,dict13,dict8, nil];
            [appDelegate.IdealTaskEntrust retain];
            [_resultArray retain];
            
            [_uiTableView reloadData];
        }
        @catch (NSException *exception) {
           // NSString *showStr=[NSString stringWithFormat:@"%@",retTaskDetailsData];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据解析异常！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        @finally {
            
        }
        
        
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


#pragma mark -- 附件列表中删除和打开操作方法
//打开附件操作
-(void)openBtnTaped:(UIButton *)sender
{
    @try {
        //histan_NSLog(@"%s",__func__);
        NSInteger index =sender.superview.tag-7788;
        
        
        NSString *fName = [appDelegate.upFileNameArray objectAtIndex:index];
        //histan_NSLog(@"点击的文件名：%@",fName);
        
        //根据获得的文件名用阅读器打开
        NSString *path = [docPath stringByAppendingPathComponent:fName];
        NSURL *url = [NSURL fileURLWithPath:path];
        //histan_NSLog(@"filePath   ---  %@",path);
        UIDocumentInteractionController *docVC = [UIDocumentInteractionController interactionControllerWithURL:url];
        docVC.delegate = self;
        [docVC presentPreviewAnimated:YES];
    }
    @catch (NSException *exception) {
        JSNotifier *jsnotify = [[JSNotifier alloc]initWithTitle:@"文件已损坏，不能打开！"];
        jsnotify.accessoryView =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info_icon"]];
        [jsnotify showFor:1.5];
    }
    @finally {
        
    }
    
    
}


//删除附件操作
-(void)deleteBtnTaped:(UIButton *)sender
{
    NSInteger index = [sender superview].tag-7788;
    
    //删除数据源apendArray中的对应项，然后再重绘附件列表
    [appDelegate.upFileNameArray removeObjectAtIndex:index];
    
    [_uiTableView reloadData];
}


#pragma mark -- 循环上传文件，如果发送成功返回yes，否则返回no
-(void)upLoadFiles
{
    
    //如果用户选择了附件上传就上传附件，否则不上传，直接跳转至新建页面
    if ([appDelegate.upFileNameArray count] > 0) {
        [HUD setLabelText:@"附件上传中..."];
        //histan_NSLog(@"%s",__func__);
        for (int i = 0; i<[appDelegate.upFileNameArray count]; i ++) {
            
            //获取fileName和contents参数
            NSString *fileName = [appDelegate.upFileNameArray objectAtIndex:i];
            NSString *contents = [self performSelector:@selector(getContentByFileName:) withObject:fileName];
            @try {
                //循环发送文件
                [self performSelector:@selector(upLoadOne:fileContent:) withObject:fileName withObject:contents];
            }
            @catch (NSException *exception) {
                //如果有异常则返回NO
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
        //不用上传文件，跳转回新建页面
        [HUD setLabelText:@"操作成功！"];
        [self performSelector:@selector(jumpBack) withObject:nil afterDelay:1.0];
    }
}
//上传单个文件 fileName文件名  contents 文件内容（加密后）
-(void)upLoadOne:(NSString *)fileName fileContent:(NSString *)contents
{
    //histan_NSLog(@"%s",__func__);
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas = nil;
    wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"bustype",@"1",@"filename",fileName,@"content",contents,@"tasked",appDelegate.CurTaskId,@"step",@"1",nil];
    
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
            //如果最后一个附件都上传成功了就返回新建页
            if (fileName == [appDelegate.upFileNameArray lastObject]) {
                
                [HUD setLabelText:@"附件上传成功！"];
                [HUD hide:YES afterDelay:0.8];
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
                    
                    //调用非附件的修改
                    [self performSelector:@selector(BackPrePage) withObject:self afterDelay:1];
                    //[self performSelector:@selector(jumpBack) withObject:nil afterDelay:1.8];
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
    //histan_NSLog(@" The filePath  *********%@",filePath);
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSData *contentData = [NSData dataWithContentsOfURL:url];
    //histan_NSLog(@"The contentData **********%@",contentData);
    //将内容加密
    contents = [[NSString alloc] initWithData:[GTMBase64 encodeData:contentData] encoding:NSUTF8StringEncoding];
    //返回加密后的字符串
    return contents;
}


-(void)dealloc{
    //NSLog(@"IdealTaskDetails dealloc");
    
    [appDelegate.upFileNameArray removeAllObjects];
    appDelegate.upFileNameArray=nil;
    _resultArray=nil;
    if(ASISOAPRequest!=nil){
        [ASISOAPRequest clearDelegatesAndCancel];
        [ASISOAPRequest release];
    }
    
    
    _uiTableView=nil;
    info=nil;
    poplistview=nil;
    
    //记录可以循环的 label 行数
    _foreachLabelCount=nil;
    
    //当前详情页现实任务类别（0：未处理 1：未评价 2：已评价）
    _curTaskTypeId=nil;
    
    //UIButton *
    //记录对应部门下的任务类型值
    typeArray=nil;
    //记录字典中的键（key），也就是任务的id
    typeKeys=nil;
    //记录所有任务类型数据
    allTypeDic=nil;
    
    deptID=nil; //部门ID
    _typeid=nil;//项目Id
    
    //记录当前选择的技术类别Id 和 名称
    _curSelectSkillTypeName=nil;
    
    action_edit=nil; //1可修改 0不可修改
    action_solve=nil;//1可解决 0不可解决
    action_commenmt=nil;//1可评价 0不可评价
    action_entrust=nil;//1可转交 0不可转交
    action_delete=nil;//1可删除 0不可删除
    
    Public_hub=nil;//记录附件列表
    
    [super dealloc];
}




@end
