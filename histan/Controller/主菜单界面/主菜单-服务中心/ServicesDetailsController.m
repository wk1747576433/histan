//
//  ServicesDetailsController.m
//  histan
//
//  Created by lyh on 1/27/14.
//  Copyright (c) 2014 histan. All rights reserved.
//

#import "ServicesDetailsController.h"

@interface ServicesDetailsController ()

@end

@implementation ServicesDetailsController

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
    
    
    appDelegate=HISTANdelegate;
    
    self.navigationItem.title=@"服务详情";
    if ([appDelegate.CurTaskTypeId isEqualToString:@"1"]) {
        self.navigationItem.title=@"未服务详情";
    }else  if ([appDelegate.CurTaskTypeId isEqualToString:@"2"]) {
        self.navigationItem.title=@"成功详情";
    }else  if ([appDelegate.CurTaskTypeId isEqualToString:@"3"]) {
        self.navigationItem.title=@"失败详情";
    }
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];
    
    //添加 table view
    _uiTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44) style:UITableViewStylePlain];
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
    
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    //注意！添加了手势要用设置代理，用代理方法判断消息发送者来处理事件，否则所有其他事件都会被手势事件所屏蔽
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewInputDone:)];
    //点击一下的时候触发
    gesture.numberOfTapsRequired = 1;
    //设置代理
    gesture.delegate=self;
    [_uiTableView addGestureRecognizer:gesture];
    
    //实例化失败原因选择列表
    _popoerView = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, 10, 300, 420)];
    _popoerView.delegate = self;
    _popoerView.datasource = self;
    [_popoerView setTitle:@"失败原因"];
    _popoerView.listView.scrollEnabled = TRUE;
    _popoerView.listView.showsVerticalScrollIndicator = NO;
    [_popoerView retain];
    
    CGRect r_cg = mainScreen_CGRect;
    
    
    //添加一个日期选择器，先隐藏
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0,r_cg.size.height, r_cg.size.width, 300)];
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
    
    
    //加载数据
    [self performSelector:@selector(LoadServiceDetails)];
    
}




#pragma mark -- 隐藏textView的键盘
-(void)textViewInputDone:(UIBarItem *)sender
{
    for (UIView *item in [_uiTableView subviews]) {
        for (UIView *item2 in [item subviews]) {
            for (UIView *item3 in [item2 subviews]) {
                if ([item3 isKindOfClass:[UITextField class]]) {
                    UITextField *tt=(UITextField*)item3;
                    [tt resignFirstResponder];
                }
            }
        }
    }
    
    
    
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
//    NSLog(@"cell 加载 the _resultArray:%@",_resultArray);
//    NSLog(@"cell 加载 the dict:%@",dict);
    
    //上半部分信息
    if (indexPath.row<7) {
        
        UITableViewCell *cell= [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        CGRect cellFrame = [cell frame];
        cellFrame.origin = CGPointMake(100, 2);
        
        int textLabelWidth=235;
        
        UILabel *TaskTypeName_text1 = [[UILabel alloc] initWithFrame:CGRectMake(3, 2, 80, 21)];
        TaskTypeName_text1.highlightedTextColor = [UIColor whiteColor];
        TaskTypeName_text1.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
        TaskTypeName_text1.backgroundColor = [UIColor clearColor];
        TaskTypeName_text1.font=[UIFont systemFontOfSize:14.0f];
        TaskTypeName_text1.textAlignment=NSTextAlignmentCenter;
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
        [TaskTypeName_text2 release];
        
        //  CGRect rect = CGRectInset(cellFrame, 2, 2);
        CGRect rect=CGRectMake(80, 4, textLabelWidth, TaskTypeName_text2.frame.size.height);
        TaskTypeName_text2.frame = rect;
        [TaskTypeName_text2 sizeToFit];
        curCellHeight=TaskTypeName_text2.frame.size.height+5;
        
        if (indexPath.row==1) {
            
            TaskTypeName_text2.text=[dict objectForKey:@"content"];
            [TaskTypeName_text2 setTextColor:[UIColor redColor]];
        }
        
        if (indexPath.row==4 || indexPath.row==5) {
            
            curCellHeight=25;
            
            if (![[dict objectForKey:@"content"] isEqualToString:@"无"]) {
                TaskTypeName_text2.text=@"";
                
                NSString *strss=[dict objectForKey:@"content"];
                NSLog(@"%@",strss);
                NSMutableAttributedString *lastString22 = [[NSMutableAttributedString alloc] initWithString:strss];
                [lastString22 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, strss.length)];
                [lastString22 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, strss.length)];
                [TaskTypeName_text2 setAttributedText:lastString22];
                TaskTypeName_text2.userInteractionEnabled = YES;
                //添加一个button相应事件
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(0, 0, textLabelWidth, 21)];
                [btn addTarget:self action:@selector(callThePhoneNum:) forControlEvents:UIControlEventTouchUpInside];
                TaskTypeName_text2.userInteractionEnabled = YES;
                [TaskTypeName_text2 addSubview:btn];
                
                
                

            }else{
                TaskTypeName_text2.text=[dict objectForKey:@"content"];
            }
            
//        }else if (indexPath.row == 4|| indexPath.row == 5) {
//            //业务员及电话、促销员及电话
//            NSString *phoneNum = [dict objectForKey:@"content"];
//            if ([phoneNum isEqualToString:@"无"] || [phoneNum isEqualToString:@""]) {
//                TaskTypeName_text2.text=phoneNum;
//            }else{
//                NSMutableAttributedString *lastString = [[NSMutableAttributedString alloc] initWithString:phoneNum];
//                //histan_NSLog(@"%d",phoneNum.length);
//                //获取括号内的字符，如果 大于 3位，则添加拨打电话事件。
//                
//                int pstartLenght= [phoneNum rangeOfString:@"("].location+1;
//                int pendLenght= [phoneNum rangeOfString:@")"].location -pstartLenght;
//                if (pendLenght >4) {
//                    [lastString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(pstartLenght, pendLenght)];
//                    [lastString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(pstartLenght, pendLenght)];
//                    [TaskTypeName_text2 setAttributedText:lastString];
//                    TaskTypeName_text2.userInteractionEnabled = YES;
//                    //添加一个button相应事件
//                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                    [btn setFrame:CGRectMake(0, 0, textLabelWidth, 21)];
//                    [btn addTarget:self action:@selector(callThePhoneNum:) forControlEvents:UIControlEventTouchUpInside];
//                    [TaskTypeName_text2 addSubview:btn];
//                }
//                else
//                {
//                    TaskTypeName_text2.text = phoneNum;
//                }
//            }
        }
        else{
            
            TaskTypeName_text2.text=[dict objectForKey:@"content"];
            
        }
        
        
        //如果是最后一个，则添加一个服务详情头部。
        if(indexPath.row==6){
            UIImageView *imgView_Headbg=[[UIImageView alloc]initWithFrame:CGRectMake(4, curCellHeight+3, self.view.frame.size.width-9, 21)];
            [imgView_Headbg setImage:[UIImage imageNamed:@"solution_hand_bg"]];
            UILabel *TaskDescLabel=[[UILabel alloc]initWithFrame:CGRectMake(4, 1, imgView_Headbg.frame.size.width, 21)];
            TaskDescLabel.text=@"服务详情";
            TaskDescLabel.backgroundColor=[UIColor clearColor];
            TaskDescLabel.font=[UIFont systemFontOfSize:14];
            TaskDescLabel.textColor=[UIColor whiteColor];
            TaskDescLabel.textAlignment=NSTextAlignmentCenter;
            [imgView_Headbg addSubview:TaskDescLabel];
            
            [cell.contentView addSubview:imgView_Headbg];
            
            curCellHeight= curCellHeight+3+25-5;
        }
        
        //NSLog(@"curCellHeight:%f",curCellHeight);
        cellFrame.size.height=curCellHeight;
        [cell setFrame:cellFrame];
        return cell;
        
    }else if(indexPath.row== ([_resultArray count]-1)){
        
        
        
        UITableViewCell *cell= [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        CGRect cellFrame = [cell frame];
        cellFrame.origin = CGPointMake(100, 2);
        
        if ([appDelegate.CurTaskTypeId isEqualToString:@"1"]) {
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UIButton *submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70-10, 5, 65, 30)];
            [submitBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
            [submitBtn setBackgroundImage:[UIImage imageNamed:@"save_press"] forState:UIControlStateHighlighted];
            [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:submitBtn];
            [submitBtn release];
        }
        
        
        
        
        curCellHeight=53+8;
        
        cellFrame.size.height=curCellHeight;
        [cell setFrame:cellFrame];
        return cell;
        
    }else{
        ServicesDetailsSubCell   *cell=(ServicesDetailsSubCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil){
            NSArray *nib= [[NSBundle mainBundle]loadNibNamed:@"ServicesDetailsSubCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        NSDictionary *item=(NSDictionary*)[dict objectForKey:@"content"];
        
        CGRect cellFrame = [cell frame];
        cellFrame.origin = CGPointMake(100, 2);
        
        
        cell.Services_description.lineBreakMode = NSLineBreakByWordWrapping;
        cell.Services_description.numberOfLines =0;
        
        cell.Services_buyTime.text=[HLSoftTools GetDataTimeStrByIntDate:[item objectForKey:@"buytime"] DateFormat:@"yyyy-MM-dd"];
        cell.Services_sertype.text=[item objectForKey:@"sertype"];
        cell.Services_description.text=@"";//[item objectForKey:@"description"];
        cell.Services_cinvstd.text=[item objectForKey:@"cinvstd"];
        
        [cell.Services_ResetBtn addTarget:self action:@selector(ReSetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //cell.Services_sertype.text=@"安装";
        
        //2014-03-03：增加了工单编号（serid）；物流状态（sendstate,sendtime）
        cell.Services_serId.text = [item objectForKey:@"serid"];
        
        //注意：安装状态只有在sertype（服务项目为“安装”）的时候才显示
        if ([cell.Services_sertype.text isEqualToString:@"安装"]) {
            NSString *state = [item objectForKey:@"sendstate"];
            if (state.length > 0) {
                cell.sendState.text = [NSString stringWithFormat:@"%@/%@",state,[item objectForKey:@"sendtime"]];
            }
            else
            {
                cell.sendState.text = @"未完成";
            }
        }
        
        
        //增加了购买途径、是否保修()
        cell.Services_buyWay.text = [item objectForKey:@"buyfrom"];
        
        //如果是“否”，则为红色
        NSString *isFree = [item objectForKey:@"isfree"];
        if ([isFree isEqualToString:@"否"]) {
            cell.Services_Maintenance.text = isFree;
            [cell.Services_Maintenance setTextColor:[UIColor redColor]];
        }
        else
        {
            cell.Services_Maintenance.text = isFree;
        }
        
        
        //给按钮绑定事件
        [cell.Services_FailedBtn addTarget:self action:@selector(FailedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.Services_SuccessBtn addTarget:self action:@selector(SuccessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.Services_ChangeDateWhait addTarget:self action:@selector(ChangeDateWhaitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.Services_CancelSelect addTarget:self action:@selector(CancelSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.Services_ChangeDate addTarget:self action:@selector(retransDateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.Services_FailedBtn.tag=-1;
        cell.Services_SuccessBtn.tag=-2;
        
        [cell.Services_FailedResultSelectText addTarget:self action:@selector(failedReasonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([appDelegate.CurTaskTypeId isEqualToString:@"1"]) {
            
            
            
        }else{
            //开启这里之后，在失败状态下，选择失败原因按钮没有了背景图
//            [cell.Services_FailedResultSelectText setBackgroundImage:nil forState:UIControlStateNormal];
//            [cell.Services_FailedResultSelectText setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//            cell.Services_FailedResultSelectText.layer.borderColor=[[UIColor grayColor]CGColor];
//            cell.Services_FailedResultSelectText.layer.borderWidth=1;
            
            cell.Services_ResetBtn.hidden=NO;
            
            
        }
        
        
        
        //描述
        UILabel *descriptionLblTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 2, self.view.frame.size.width-110,21)];
        descriptionLblTitle.text=[item objectForKey:@"description"];
        descriptionLblTitle.font=[UIFont systemFontOfSize:12.0f];
        descriptionLblTitle.lineBreakMode = UILineBreakModeWordWrap;
        [descriptionLblTitle setBackgroundColor:[UIColor clearColor]];
        descriptionLblTitle.numberOfLines =0;
        CGRect rect2=CGRectMake(cell.Services_description.frame.origin.x, cell.Services_description.frame.origin.y, cell.Services_description.frame.size.width, descriptionLblTitle.frame.size.height);
        descriptionLblTitle.frame = rect2;
        [descriptionLblTitle sizeToFit];
        [cell addSubview:descriptionLblTitle];
        
        
        //隐藏 失败理由控件
        cell.Services_FailedResultSelectText.hidden=YES;
        cell.Services_ChangeDate.hidden=YES;
        cell.Services_ChangeDateLabel.hidden=YES;
        //cell.Services_ChangeDateWhait.hidden=YES;
        cell.Services_FailedReasonLabel.hidden=YES;
        
        
        //设置描述以下的控件距离顶部高度。
        float Services_ResultLabel=cell.Services_ResultLabel.frame.origin.y;
        float Services_SuccessBtn=cell.Services_SuccessBtn.frame.origin.y;
        float Services_FailedBtn=cell.Services_FailedBtn.frame.origin.y;
        float Services_FailedReasonLabel=cell.Services_FailedReasonLabel.frame.origin.y;
        float Services_FailedResultSelectText=cell.Services_FailedResultSelectText.frame.origin.y;
        float Services_ChangeDate=cell.Services_ChangeDate.frame.origin.y;
        float Services_ChangeDateLabel=cell.Services_ChangeDateLabel.frame.origin.y;
        float Services_ChangeDateWhait=cell.Services_ChangeDateWhait.frame.origin.y;
        float Services_CancelSelect=cell.Services_CancelSelect.frame.origin.y;
        
        float Services_ResetBtn=cell.Services_ResetBtn.frame.origin.y;
        
        int cindex=[[dict objectForKey:@"index"]intValue];
        [cell setTag:cindex];//设置tag ，方便获取 集合数据
        //histan_NSLog(@"cindex:%d",cindex);
        NSDictionary *subDict=[_servicesContentArray objectAtIndex:cindex];
        
        //得到描述的高度，然后往下挤挤
        float descriptionLabelHeight=descriptionLblTitle.frame.size.height;
        
        if (descriptionLabelHeight>21) {
            
            cell.Services_ResultLabel.frame=CGRectMake(cell.Services_ResultLabel.frame.origin.x, Services_ResultLabel+descriptionLabelHeight-20, cell.Services_ResultLabel.frame.size.width, cell.Services_ResultLabel.frame.size.height);
            
            cell.Services_FailedBtn.frame=CGRectMake(cell.Services_FailedBtn.frame.origin.x, Services_FailedBtn+descriptionLabelHeight-20, cell.Services_FailedBtn.frame.size.width, cell.Services_FailedBtn.frame.size.height);
            
            cell.Services_SuccessBtn.frame=CGRectMake(cell.Services_SuccessBtn.frame.origin.x, Services_SuccessBtn+descriptionLabelHeight-20, cell.Services_SuccessBtn.frame.size.width, cell.Services_SuccessBtn.frame.size.height);
            
            cell.Services_FailedReasonLabel.frame=CGRectMake(cell.Services_FailedReasonLabel.frame.origin.x, Services_FailedReasonLabel+descriptionLabelHeight-20, cell.Services_FailedReasonLabel.frame.size.width, cell.Services_FailedReasonLabel.frame.size.height);
            
            cell.Services_FailedResultSelectText.frame=CGRectMake(cell.Services_FailedResultSelectText.frame.origin.x, Services_FailedResultSelectText+descriptionLabelHeight-20, cell.Services_FailedResultSelectText.frame.size.width, cell.Services_FailedResultSelectText.frame.size.height);
            
            //
            cell.Services_CancelSelect.frame=CGRectMake(cell.Services_CancelSelect.frame.origin.x, Services_CancelSelect+descriptionLabelHeight-20, cell.Services_CancelSelect.frame.size.width, cell.Services_CancelSelect.frame.size.height);
            
            cell.Services_ChangeDateWhait.frame=CGRectMake(cell.Services_ChangeDateWhait.frame.origin.x, Services_ChangeDateWhait+descriptionLabelHeight-20 +3, cell.Services_ChangeDateWhait.frame.size.width, cell.Services_ChangeDateWhait.frame.size.height);
            
            cell.Services_ChangeDateLabel.frame=CGRectMake(cell.Services_ChangeDateLabel.frame.origin.x, Services_ChangeDateLabel+descriptionLabelHeight-20 +3, cell.Services_ChangeDateLabel.frame.size.width, cell.Services_ChangeDateLabel.frame.size.height);
            
            cell.Services_ChangeDate.frame=CGRectMake(cell.Services_ChangeDate.frame.origin.x, Services_ChangeDate+descriptionLabelHeight-20+3, cell.Services_ChangeDate.frame.size.width, cell.Services_ChangeDate.frame.size.height);
            
            cell.Services_ResetBtn.frame=CGRectMake(cell.Services_ResetBtn.frame.origin.x,Services_ResetBtn+descriptionLabelHeight-25, cell.Services_ResetBtn.frame.size.width, cell.Services_ResetBtn.frame.size.height);
            
            
            curCellHeight=185+descriptionLabelHeight-20;
        }else{
            //设置当前cell 高度
            curCellHeight=185;
        }
        
        //NSLog(@"r:%@",[subDict objectForKey:@"result"]);
        
        if([[subDict objectForKey:@"result"] isEqualToString:@"null"] || [[subDict objectForKey:@""] isEqualToString:@"null"] || [[subDict objectForKey:@"result"] isEqualToString:@""]) //没有选中 成功 或者 失败
        {
            NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[item objectForKey:@"id"],@"id",@"null",@"result",@"null",@"resulttext",[NSString stringWithFormat:@"%f",curCellHeight],@"height",@"null",@"changedate",@"0",@"iswhait", nil];
            [_servicesContentArray replaceObjectAtIndex:cindex withObject:scItem]; //用于替换数组中的某个对象
            
        }else{
            
            
            if ([[subDict objectForKey:@"result"] isEqualToString:@"0"]) {
                if ([appDelegate.CurTaskTypeId  isEqualToString:@"1"]) {
                    curCellHeight=[[subDict objectForKey:@"height"]floatValue]+10;
                }else{
                    curCellHeight=[[subDict objectForKey:@"height"]floatValue]+descriptionLabelHeight+15;
                }
                
                [cell.Services_FailedBtn setImage:[UIImage imageNamed:@"ping_radio_16"] forState:UIControlStateNormal];
                cell.Services_FailedReasonLabel.hidden=NO;
                cell.Services_FailedResultSelectText.hidden=NO;
                cell.Services_ChangeDate.hidden=NO;
                cell.Services_ChangeDateLabel.hidden=NO;
                //cell.Services_ChangeDateWhait.hidden=NO;
                
                cell.Services_ChangeDateWhait.frame=CGRectMake(213,  cell.Services_ChangeDateWhait.frame.origin.y,  cell.Services_ChangeDateWhait.frame.size.width, cell.Services_ChangeDateWhait.frame.size.height);
                [cell.Services_ChangeDateWhait setImage:[UIImage imageNamed:@"ping_checked1_16"] forState:UIControlStateNormal];
                //判断是否为待定状态
                if([[subDict objectForKey:@"iswhait"] isEqualToString:@"1"]){
//                    cell.Services_ChangeDate.hidden=YES;
//                    [cell.Services_ChangeDateWhait setImage:[UIImage imageNamed:@"ping_checked_16"] forState:UIControlStateNormal];
//                    cell.Services_ChangeDateWhait.frame=CGRectMake(cell.Services_ChangeDateWhait.frame.origin.x-140, cell.Services_ChangeDateWhait.frame.origin.y, cell.Services_ChangeDateWhait.frame.size.width, cell.Services_ChangeDateWhait.frame.size.height);
                }
                
                if ([[subDict objectForKey:@"resulttext"] isEqualToString:@"null"] || [[subDict objectForKey:@"resulttext"] isEqualToString:@""]) {
                    [cell.Services_FailedResultSelectText setTitle:@"选择失败原因" forState:UIControlStateNormal];
                    
                }else{
                    [cell.Services_FailedResultSelectText setTitle:[subDict objectForKey:@"resulttext"] forState:UIControlStateNormal];
                }
                
                if ([[subDict objectForKey:@"changedate"] isEqualToString:@"null"]) {
                    [cell.Services_ChangeDate setTitle:@"选择日期" forState:UIControlStateNormal];
                    
                }else{
                    [cell.Services_ChangeDate setTitle:[HLSoftTools GetDataTimeStrByIntDate:[subDict objectForKey:@"changedate"] DateFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
                }
                
            }else{
                
                if ([[subDict objectForKey:@"resulttext"] isEqualToString:@"null"] ||  [[subDict objectForKey:@"resulttext"] isEqualToString:@""]) {
                    [cell.Services_FailedResultSelectText setTitle:@"选择失败原因" forState:UIControlStateNormal];
                }
                if ([[subDict objectForKey:@"changedate"] isEqualToString:@"null"] || [[subDict objectForKey:@"changedate"] isEqualToString:@""]) {
                    [cell.Services_ChangeDate setTitle:@"选择日期" forState:UIControlStateNormal];
                }
                
                //
                [cell.Services_SuccessBtn setImage:[UIImage imageNamed:@"ping_radio_16"] forState:UIControlStateNormal];
                //隐藏 失败理由控件
                cell.Services_FailedResultSelectText.hidden=YES;
                cell.Services_ChangeDate.hidden=YES;
                cell.Services_ChangeDateLabel.hidden=YES;
                cell.Services_ChangeDateWhait.hidden=YES;
                //cell.Services_FailedReasonLabel.hidden=YES;
            }
            
            
        }
        
        // //histan_NSLog(@"_servicesContentArray:%@",_servicesContentArray);
        //NSLog(@"curCellHeight:%f",curCellHeight);
        
        cellFrame.size.height=curCellHeight;
        [cell setFrame:cellFrame];
        
        //cell.contentView.backgroundColor=[UIColor whiteColor];
        //cell.contentView.frame=CGRectMake(5, 0, 300, curCellHeight);
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


#pragma mark --重置按钮事件
-(void)ReSetBtnClick:(UIButton*)sender{
    
    ServicesDetailsSubCell *subCell;
    if (_IsIOS7_) {
        subCell= (ServicesDetailsSubCell*)sender.superview.superview.superview;
    }else{
        subCell= (ServicesDetailsSubCell*)[[sender superview]superview];
    }
    _curIndexInArray=subCell.tag;
    IsEditClicknum=1;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定修改该纪录吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"asdf");
    //    if (_servicesContentArray.count ==0 || IsEditClicknum== 0) {
    //        return;
    //    }
    
    
    //histan_NSLog(@"IsEditClicknum:%d",IsEditClicknum);
    
    if(buttonIndex==0){
        
        
        if (IsEditClicknum ==0) {
            //histan_NSLog(@"thePhontNum:%@",_thePhoneNum);
            NSString *telStr = [NSString stringWithFormat:@"tel://%@",_thePhoneNum];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
            
        }else{
            
            
            
            NSDictionary *subDict=[_servicesContentArray objectAtIndex:_curIndexInArray];
            NSString *showTipsText=@"提醒";
            BOOL IsFalse=NO;
            if([[subDict objectForKey:@"result"] isEqualToString:@"null"]){
                
                showTipsText=@"请选择服务结果！";
                IsFalse=YES;
                
            }else{
                
                //如果是 失败，判断是否选择了 理由
                if([[subDict objectForKey:@"result"] isEqualToString:@"0"]){
                    
                    if([[subDict objectForKey:@"resulttext"] isEqualToString:@"null"] || [[subDict objectForKey:@"resulttext"] isEqualToString:@""]){
                        
                        showTipsText=@"请选择失败原因！";
                        IsFalse=YES;
                        
                        //如果是 待定，就不需要判断是否选择时间了。
                    } else   if([[subDict objectForKey:@"iswhait"] isEqualToString:@"0"]){
                        if([[subDict objectForKey:@"changedate"] isEqualToString:@"null"] || [[subDict objectForKey:@"changedate"] isEqualToString:@""]){
                            showTipsText=@"请选择改约日期！" ;
                            IsFalse=YES;
                            
                        }
                    }
                }
                
            }
            
            
            //开始加载
            HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
            
            if(IsFalse==YES){
                
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
                HUD.labelText =showTipsText;
                // [HUD show:YES];
                [HUD hide:YES afterDelay:1.5];
                return;
            }
            
            
            //显示的文字
            HUD.labelText = @"修改中...";
            //是否有庶罩
            //HUD.dimBackground = YES;
            NSString *rname=[subDict objectForKey:@"resulttext"];
            if ([[subDict objectForKey:@"result"] isEqualToString:@"1"]) {
                rname=@"";
            }
            
            //初始化参数数组（必须是可变数组）
            NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"id",[subDict objectForKey:@"id"],@"flag",[subDict objectForKey:@"result"],@"rname",rname,@"changedate",[subDict objectForKey:@"changedate"],nil];
            
            //实例化OSAPHTTP类
            ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
            //获得OSAPHTTP请求
            ASISOAPRequest  = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Reset_Service wsParameters:wsParas];
            [wsParas release];
            
            [ASISOAPRequest retain];
            ASISOAPRequest.delegate=self;
            [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
            [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
            [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess_ReSet:)];//加载成功的方法
            [ASISOAPRequest startAsynchronous];//异步加载
            
        }
    }
    IsEditClicknum=0;
}


//加载成功，现实到页面。
-(void)requestDidSuccess_ReSet:(ASIHTTPRequest*)requestLoadSource{
    
    @try {
        
        
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        //histan_NSLog(@"returnString:%@",[ASISOAPRequest responseString]);
        NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
        NSString *error = (NSString *)[dic objectForKey:@"error"];
        
        if ([error intValue] != 0) {
            
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
            HUD.labelText =[dic objectForKey:@"data"];
            [HUD hide:YES afterDelay:2];
        }
        else
        {
            
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
            HUD.labelText =@"操作成功！";
            [HUD hide:YES afterDelay:1];
            
            
        }
        
    }
    @catch (NSException *exception) {
        
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText =@"没有返回数据！";
        [HUD hide:YES afterDelay:2];
        
    }
    @finally {
        
    }
    
}

#pragma mark --取消选择按钮事件
-(void)CancelSelectBtnClick:(UIButton*)sender{
    
    ServicesDetailsSubCell *subCell;
    if (_IsIOS7_) {
        subCell= (ServicesDetailsSubCell*)sender.superview.superview.superview;
    }else{
        subCell= (ServicesDetailsSubCell*)[[sender superview]superview];
    }
    int cindex=subCell.tag;
    NSDictionary *subDict=[_servicesContentArray objectAtIndex:cindex];
    
    
    NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",@"null",@"result",@"",@"resulttext",@"125",@"height",@"null",@"changedate",@"0",@"iswhait", nil];
    [_servicesContentArray replaceObjectAtIndex:cindex withObject:scItem]; //用于替换数组中的某个对象
    [_uiTableView reloadData];
}

#pragma mark --待定按钮事件
-(void)ChangeDateWhaitBtnClick:(UIButton*)sender{
    ServicesDetailsSubCell *subCell;
    if (_IsIOS7_) {
        subCell= (ServicesDetailsSubCell*)sender.superview.superview.superview;
    }else{
        subCell= (ServicesDetailsSubCell*)[[sender superview]superview];
    }
    int cindex=subCell.tag;
    NSDictionary *subDict=[_servicesContentArray objectAtIndex:cindex];
    NSString *iswhait=@"0";
    
    sender.frame=CGRectMake(213, subCell.Services_ChangeDateWhait.frame.origin.y, subCell.Services_ChangeDateWhait.frame.size.width, subCell.Services_ChangeDateWhait.frame.size.height);
    subCell.Services_ChangeDate.hidden=NO;
    [sender setImage:[UIImage imageNamed:@"ping_checked1_16"] forState:UIControlStateNormal];
    if([[subDict objectForKey:@"iswhait"] isEqualToString:@"0"]){
        iswhait=@"1";
        subCell.Services_ChangeDate.hidden=YES;
        [sender setImage:[UIImage imageNamed:@"ping_checked_16"] forState:UIControlStateNormal];
        sender.frame=CGRectMake(subCell.Services_ChangeDateWhait.frame.origin.x-140, subCell.Services_ChangeDateWhait.frame.origin.y, subCell.Services_ChangeDateWhait.frame.size.width, subCell.Services_ChangeDateWhait.frame.size.height);
    }else{
        CGRect r_cg = mainScreen_CGRect;
        
        _curIndexInArray =cindex;
        //设置显示日期的按钮
        _curClickBtn = subCell.Services_ChangeDate;
        //显示日期选择视图_maskView
        //histan_NSLog(@"_maskView frame:%f",_maskView.frame.origin.y);
        CGRect newFrame = CGRectMake(0,r_cg.size.height-300, 320,300);
        [UIView beginAnimations:@"showTHePiker" context:nil];
        [_maskView setFrame:newFrame];
        [UIView commitAnimations];
    }
    
    
    
    
    NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",[subDict objectForKey:@"result"],@"result",[subDict objectForKey:@"resulttext"],@"resulttext",[subDict objectForKey:@"height"],@"height",@"",@"changedate",iswhait,@"iswhait", nil];
    [_servicesContentArray replaceObjectAtIndex:cindex withObject:scItem]; //用于替换数组中的某个对象
    //histan_NSLog(@"_servicesContentArray22:%@",_servicesContentArray);
}


#pragma mark --未成功按钮事件
-(void)FailedBtnClick:(UIButton*)sender{
    
    ServicesDetailsSubCell *subCell;
    if (_IsIOS7_) {
        subCell= (ServicesDetailsSubCell*)sender.superview.superview.superview;
    }else{
        subCell= (ServicesDetailsSubCell*)[[sender superview]superview];
    }
    
    int cindex=subCell.tag;
    NSDictionary *subDict=[_servicesContentArray objectAtIndex:cindex];
    
    NSString *resultStr=sender.tag==-1?@"0":@"1";
    
    if([[subDict objectForKey:@"result"] isEqualToString:@"0"] && [resultStr isEqualToString:@"0"])//第二次点击同一个状态
    {
        return;
    }
    
    //设置当前cell 的高度
    float height1=[[subDict objectForKey:@"height"]floatValue]+60;
    NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",resultStr,@"result",[subDict objectForKey:@"resulttext"],@"resulttext", [NSString stringWithFormat:@"%f",height1],@"height",[subDict objectForKey:@"changedate"],@"changedate",[subDict objectForKey:@"iswhait"],@"iswhait", nil];
    [_servicesContentArray replaceObjectAtIndex:cindex withObject:scItem]; //用于替换数组中的某个对象
    
    [_uiTableView reloadData];
    [_uiTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark --服务成功按钮事件
-(void)SuccessBtnClick:(UIButton*)sender{
    
    ServicesDetailsSubCell *subCell;
    if (_IsIOS7_) {
        subCell= (ServicesDetailsSubCell*)sender.superview.superview.superview;
    }else{
        subCell= (ServicesDetailsSubCell*)[[sender superview]superview];
    }
    int cindex=subCell.tag;
    NSDictionary *subDict=[_servicesContentArray objectAtIndex:cindex];
    
    NSString *resultStr=sender.tag==-1?@"0":@"1";
    
    if([[subDict objectForKey:@"result"] isEqualToString:@"1"] && [resultStr isEqualToString:@"1"])//第二次点击同一个状态
    {
        return;
    }
    
    //NSLog(@"h1:%@",[subDict objectForKey:@"height"]);
    
    //设置当前cell 的高度
    float height1=[[subDict objectForKey:@"height"]floatValue]-60;
    if([[subDict objectForKey:@"result"] isEqualToString:@"null"] || [[subDict objectForKey:@"result"] isEqualToString:@""]){
        height1=[[subDict objectForKey:@"height"]floatValue];
    }
    
    //NSLog(@"h2:%f",height1);
    
    
    NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",resultStr,@"result",[subDict objectForKey:@"resulttext"],@"resulttext", [NSString stringWithFormat:@"%f",height1],@"height",[subDict objectForKey:@"changedate"],@"changedate",[subDict objectForKey:@"iswhait"],@"iswhait", nil];
    [_servicesContentArray replaceObjectAtIndex:cindex withObject:scItem]; //用于替换数组中的某个对象
    
    [_uiTableView reloadData];
    // [_uiTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -- 提交按钮事件
-(void)submitBtnAction:(UIButton*)sender{
    
    //判断是否都勾选了服务结果
    BOOL IsFalse=NO;
    for (NSDictionary *item in _servicesContentArray) {
        if([[item objectForKey:@"result"] isEqualToString:@"null"]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有记录未选择服务结果，请选择！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            IsFalse=YES;
            break;
        }else{
            
            //如果是 失败，判断是否选择了 理由
            if([[item objectForKey:@"result"] isEqualToString:@"0"]){
                
                if([[item objectForKey:@"resulttext"] isEqualToString:@"null"] || [[item objectForKey:@"resulttext"] isEqualToString:@""]){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有失败记录未选择失败理由，请选择！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                    IsFalse=YES;
                    break;
                    
                    
                }
                
                
                //如果是 待定，就不需要判断是否选择时间了。
                if([[item objectForKey:@"iswhait"] isEqualToString:@"0"]){
                    if([[item objectForKey:@"changedate"] isEqualToString:@"null"] || [[item objectForKey:@"changedate"] isEqualToString:@""]){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有失败记录未选择改约日期，请选择！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        [alert show];
                        [alert release];
                        IsFalse=YES;
                        break;
                    }
                }
            }
            
        }
        
    }
    
    
    //如果有提示，则不执行以下代码
    if(IsFalse==YES){
        return;
    }
    
    //  NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",resultStr,@"result",@"null",@"resulttext", [NSString stringWithFormat:@"%f",height1],@"height",@"null",@"changedate",@"0",@"iswhait", nil];
    //拼接 json
    NSString *jsonStr=@"";
    for (NSDictionary *item in _servicesContentArray) {
        if ([[item objectForKey:@"result"] isEqualToString:@"0"]) {
            NSString *changedate=@"";
            if ([[item objectForKey:@"iswhait"] isEqualToString:@"0"]) {
                changedate=[item objectForKey:@"changedate"];
            }else{
                
            }
            NSString *failedString = [NSString stringWithFormat:@"{\"id\":%@,\"flag\":%@,\"rname\":\"%@\",\"changedate\":\"%@\"}",[item objectForKey:@"id"],[item objectForKey:@"result"],[item objectForKey:@"resulttext"],changedate];
            jsonStr =[NSString stringWithFormat:@"%@,%@",jsonStr,failedString];
        }else{
            NSString *failedString = [NSString stringWithFormat:@"{\"id\":%@,\"flag\":%@}",[item objectForKey:@"id"],[item objectForKey:@"result"]];
            jsonStr =[NSString stringWithFormat:@"%@,%@",jsonStr,failedString];
        }
        
    }
    
    //histan_NSLog(@"jsonstr:%@",jsonStr);
    jsonStr=[jsonStr substringFromIndex:1];
    jsonStr=[NSString stringWithFormat:@"[%@]",jsonStr];
    //NSLog(@"jsonstr:%@",jsonStr);
    
    //隐藏导航条
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //    //开始加载
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    //    //显示的文字
    HUD.labelText = @"提交中...";
    //    //是否有庶罩
    HUD.dimBackground = YES;
    //
    //    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"itemJson",jsonStr,nil];
    
    //    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //    //获得OSAPHTTP请求
    ASISOAPRequest  = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Serivces_Outbound wsParameters:wsParas];
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
    
}

#pragma mark -- 服务详情
-(void)LoadServiceDetails{
    
    //获取上个页面（服务列表中点击的对象）
    NSDictionary *dict=appDelegate.ServicesDictionary;
    
    //开始加载
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    //显示的文字
    HUD.labelText = @"加载中...";
    //是否有庶罩
    //HUD.dimBackground = YES;
    NSLog(@"当前状态参数（0：未服务；1：成功；2：失败）：%@",appDelegate.CurTaskTypeId);
    //初始化参数数组（必须是可变数组）
//    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"reqid",[dict objectForKey:@"reqid"], @"reservetime",[dict objectForKey:@"reservetime"],nil];
    
    
    //将日期转化为int试试
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    NSString *dateStr1 = [dict objectForKey:@"reservedate"];
    NSLog(@"返回的预约时间：%@",dateStr1);
    NSString *dateStr2 = [dateStr1 stringByTrimmingCharactersInSet:set];
    NSString *dateStr3 = [HLSoftTools GetdateTimeLong:dateStr2];
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"reqid",[dict objectForKey:@"reqid"],@"reservetime",dateStr3,nil];
    
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest  = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Serivces_Info wsParameters:wsParas];
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
#pragma mark -- 详情加载成功
-(void)requestDidSuccess:(ASIHTTPRequest*)requestLoadSource{
    
    NSLog(@"%@",[requestLoadSource responseString]);
    
    @try {
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
            NSArray *detailsDict = [dic objectForKey:@"data"];
            
            //增加了“服务日期”
            NSDictionary *dict0 = [NSDictionary dictionaryWithObjectsAndKeys:@"reservedate",@"name",@"auto",@"height",[[appDelegate.ServicesDictionary objectForKey:@"reservedate"] isEqualToString:@""]?@"无":[appDelegate.ServicesDictionary objectForKey:@"reservedate"],@"content",@"服务日期：",@"leftTitle", nil];
            
            //增加了“首次预约”
            NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"first_reqdate",@"name",@"auto",@"height",[[appDelegate.ServicesDictionary objectForKey:@"first_reqdate"] isEqualToString:@""]?@"无":[appDelegate.ServicesDictionary objectForKey:@"first_reqdate"],@"content",@"首次预约：",@"leftTitle", nil];
            
            
            
            //增加“处理人”
            NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"handler",@"name",@"auto",@"height",[[appDelegate.ServicesDictionary objectForKey:@"handler"] isEqualToString:@""]?@"无":[appDelegate.ServicesDictionary objectForKey:@"handler"],@"content",@"服务人员：",@"leftTitle", nil];
            
            
            NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"cusname",@"name",@"auto",@"height",[[appDelegate.ServicesDictionary objectForKey:@"cusname"] isEqualToString:@""]?@"无":[appDelegate.ServicesDictionary objectForKey:@"cusname"],@"content",@"顾   　客：",@"leftTitle", nil];
            NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"cusmobile",@"name",@"auto",@"height",[[appDelegate.ServicesDictionary objectForKey:@"cusmobile"] isEqualToString:@""]?@"无":[appDelegate.ServicesDictionary objectForKey:@"cusmobile"],@"content",@"电   　话：",@"leftTitle", nil];
            NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"cusphone",@"name",@"auto",@"height",[[appDelegate.ServicesDictionary objectForKey:@"cusphone"] isEqualToString:@""]?@"无":[appDelegate.ServicesDictionary objectForKey:@"cusphone"],@"content",@"座   　机：",@"leftTitle", nil];

            NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"cusaddr",@"name",@"auto",@"height",[[appDelegate.ServicesDictionary objectForKey:@"cusaddr"] isEqualToString:@""]?@"无":[appDelegate.ServicesDictionary objectForKey:@"cusaddr"],@"content",@"地   　址：",@"leftTitle", nil];
            
            
            
            //先添加到集合
            _resultArray = [NSMutableArray arrayWithObjects:dict0,dict1,dict2,dict3,dict4,dict5,dict6,nil];
            
            //实例化服务详情集合
            _servicesContentArray=[[NSMutableArray alloc]init];
            
            int i=0;
            for (NSDictionary *item in detailsDict) {
                //histan_NSLog(@"item2:%@",item);
                NSDictionary *dictItem = [NSDictionary dictionaryWithObjectsAndKeys:@"cusdetails",@"name",@"auto",@"height",item,@"content",@"服务列表",@"leftTitle",[NSString stringWithFormat:@"%d",i],@"index",nil];
                [_resultArray addObject:dictItem];
                
                if ([appDelegate.CurTaskTypeId isEqualToString:@"1"]  ) {
                    
                    //添加服务内容记录
                    NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[item objectForKey:@"id"],@"id",@"null",@"result",@"null",@"resulttext",@"125",@"height",@"null",@"changedate",@"0",@"iswhait", nil];
                    [_servicesContentArray addObject:scItem];
                    
                }else{
                    
                    if([[item objectForKey:@"flag"] isEqualToString:@"0"]){
                        
                        NSString *iswhait=@"0";
                        NSString *changedates=[item objectForKey:@"changedate"];
                        //histan_NSLog(@"aa:%@",changedates);
                        if([changedates isEqualToString:@"1900-01-01"] || [changedates isEqualToString:@""]){
                            changedates=@"";
                            iswhait=@"1";
                        }else{
                            changedates=  [HLSoftTools GetdateTimeLong:[item objectForKey:@"changedate"]];
                        }
                        
                        //添加服务内容内容记录
                        NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[item objectForKey:@"id"],@"id",@"0",@"result",[item objectForKey:@"rname"],@"resulttext",@"220",@"height",changedates,@"changedate",iswhait,@"iswhait", nil];
                        [_servicesContentArray addObject:scItem];
                        
                    }else{
                        //添加服务内容内容记录
                        NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[item objectForKey:@"id"],@"id",@"1",@"result",@"null",@"resulttext",@"185",@"height",@"null",@"changedate",@"0",@"iswhait", nil];
                        [_servicesContentArray addObject:scItem];
                    }
                }
                
                
                
                i++;
            }
            
            NSDictionary *dict7 = [NSDictionary dictionaryWithObjectsAndKeys:@"showButtons",@"name",@"auto",@"height",@"showButtons",@"content",@"按钮组：",@"leftTitle", nil];
            [_resultArray addObject:dict7];
            
            NSLog(@"%@",_resultArray);
            
            [_resultArray retain];
            [_servicesContentArray retain];
            [_uiTableView reloadData];
            
        }
        
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该顾客数据不存在！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    @finally {
        
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
        [HUD hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"data"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        //记录返回的所有任务类型数据
        // NSString *retStr = [dic objectForKey:@"data"];
        
        //        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        //        [activityIndicator startAnimating];
        //       // JSNotifier *notify = [[JSNotifier alloc]initWithTitle:retStr];
        //       // notify.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NotifyCheck"]];
        ////[notify showFor:2];
        
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
        HUD.labelText =@"操作成功！";
        [HUD hide:YES afterDelay:1];
        
        appDelegate.opeationSuccessNeedReloadPage=@"1";
        
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
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
    
    //    IDealTaskController  *fourth=[[IDealTaskController alloc]init];
    //    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    //    UINavigationController *nav0=(UINavigationController *)window.rootViewController;
    //    UIViewController *viewController=[nav0.viewControllers objectAtIndex:1];
    //    [viewController.navigationController pushViewController:fourth animated:YES];
    
    //[self.parentViewController dismissModalViewControllerAnimated:YES];
    
}


#pragma mark -- textfiled 代理方法
//输入框开始编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //histan_NSLog(@"%s",__func__);
    
    //文字输入视图开始编辑
    CGRect frame = CGRectMake(0, -170, 320, self.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    self.view.frame = frame;
    [UIView commitAnimations];
    
    
}
//输入框完成编辑
-(void)textFieldDidEndEditing:(UITextView *)atextView
{
    //histan_NSLog(@"%s",__func__);
    CGRect frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    if (self.view.frame.origin.y == 0) {
        //histan_NSLog(@"当前view的y坐标为0");
    }
    else{
        [UIView beginAnimations:nil context:nil];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    
}


#pragma mark -- 失败原因选项按钮点击事件（弹出选择列表）
-(void)failedReasonBtnClick:(UIButton *)sender
{
    //先记录被编辑对象对应在——productArray中的下标,然后弹出选择框
    //获取下标
    
    if (_IsIOS7_) {
        _curIndexInArray = sender.superview.superview.superview.tag;
        
    }else{
        _curIndexInArray = sender.superview.superview.tag;
        
    }
    
    //记录当前选择按钮
    _curClickBtn = (UIButton *)sender;
    [_curClickBtn retain];
    
    if (_failedReasonArray == nil) {
        //获取失败原因
        [self performSelector:@selector(getReason)];
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
    CGRect r_cg = mainScreen_CGRect;
    
    
    if (_IsIOS7_) {
        _curIndexInArray = sender.superview.superview.superview.tag;
        
    }else{
        _curIndexInArray = sender.superview.superview.tag;
        
    }
    
    //设置当前被点击的按钮
    _curClickBtn = sender;
    //显示日期选择视图_maskView
    //histan_NSLog(@"_maskView frame:%f",_maskView.frame.origin.y);
    CGRect newFrame = CGRectMake(0, r_cg.size.height-300, r_cg.size.width, 300);
    [UIView beginAnimations:@"showTHePiker" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
}

#pragma mark -- 点击确认选择时间按钮的点击事件
-(void)doneItemBtnClick:(UIBarButtonItem *)sender
{
    CGRect r_cg = mainScreen_CGRect;
    
    //收起键盘，并隐藏picker
    CGRect newFrame = CGRectMake(0, r_cg.size.height, r_cg.size.width, _maskView.frame.size.height);
    [UIView beginAnimations:@"hiedThePikerView" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
    
    //记录所选日期
    NSDate *_selectDate = _datePicker.date;
    //histan_NSLog(@"所选的日期为：%@",_selectDate);
    
    //将所选时间转换为yyyy-MM-dd格式显示在按钮上
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *confromTimespStr = [formatter stringFromDate:_selectDate];
    [_curClickBtn setTitle:confromTimespStr forState:UIControlStateNormal];
    
    //时间类型转换成int（时间戳）
    NSString *dateTime = [NSString stringWithFormat:@"%d",(int)[_selectDate timeIntervalSince1970]];
    //histan_NSLog(@"shijianchuo =====%@",dateTime);
    
    NSDictionary *subDict = [_servicesContentArray objectAtIndex:_curIndexInArray];
    //histan_NSLog(@"被替换前：%@",subDict);
    //替换
    
    NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",[subDict objectForKey:@"result"],@"result",[subDict objectForKey:@"resulttext"],@"resulttext",[subDict objectForKey:@"height"],@"height",dateTime,@"changedate",[subDict objectForKey:@"iswhait"],@"iswhait", nil];
    
    [_servicesContentArray replaceObjectAtIndex:_curIndexInArray withObject:scItem]; //用于替换数组中的某个对象
    //histan_NSLog(@"被替换hou：%@",scItem);
    //histan_NSLog(@"被替换hou2：%@",_servicesContentArray);
    
}



#pragma mark -- 获取失败原因
-(void)getReason
{
    
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"加载中..."];
    [HUD show:YES];
    
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"type",@"3",nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest_fileReason = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Send_Fail_Reason wsParameters:wsParas];
    //异步
    [ASISOAPRequest_fileReason startAsynchronous];
    
    [ASISOAPRequest_fileReason setCompletionBlock:^{
        [HUD hide:YES];
        
        
        @try {
            
            //获取返回的json数据
            NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest_fileReason responseString]];
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
            [_popoerView show];
        }
        @catch (NSException *exception) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器不存在服务失败理由！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        @finally {
            
        }
        
    }];
    
    //请求失败
    [ASISOAPRequest_fileReason setFailedBlock:^{
        [HUD hide:YES];
        NSError *error = [ASISOAPRequest error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！您的网络目前可能不给力哦^_^" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        //histan_NSLog(@"请求超时！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
    }];
    
}


#pragma mark - UIPopoverListViewDataSource
//加载UIPopoverListViewcell
-(UITableViewCell*)popoverListView:(UIPopoverListView *)popoverListView cellForIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier =[NSString stringWithFormat:@"Pcell_%d",indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier];
    int row = indexPath.row;
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    NSString *text = [NSString stringWithFormat:@"%@",[[_failedReasonArray objectAtIndex:row] objectForKey:@"rname"]];
    
    //histan_NSLog(@"失败原因:%@",[[_failedReasonArray objectAtIndex:row] objectForKey:@"rname"]);
    //histan_NSLog(@"cell:%@",cell);
    cell.textLabel.text = text;
    NSDictionary *subDict = [_servicesContentArray objectAtIndex:_curIndexInArray];
    if ([[subDict objectForKey:@"resulttext"] isEqualToString:text]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
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
    
    //    NSString *rId;
    //    for (NSDictionary *itemDic in _failedReasonArray) {
    //        if ([[itemDic objectForKey:@"rname"] isEqualToString:selectedText]) {
    //            //记录失败原因id
    //            rId =[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"rid"]];
    //            [rId retain];
    //        }
    //    }
    
    //取得对应dic
    NSDictionary *subDict = [_servicesContentArray objectAtIndex:_curIndexInArray];
    //histan_NSLog(@"%@",subDict);
    NSDictionary *scItem = [NSDictionary dictionaryWithObjectsAndKeys:[subDict objectForKey:@"id"],@"id",[subDict objectForKey:@"result"],@"result",selectedText,@"resulttext",[subDict objectForKey:@"height"],@"height",[subDict objectForKey:@"changedate"],@"changedate",[subDict objectForKey:@"iswhait"],@"iswhait", nil];
    
    [_servicesContentArray replaceObjectAtIndex:_curIndexInArray withObject:scItem]; //用于替换数组中的某个对象
    
    //histan_NSLog(@"%@",_servicesContentArray);
}



#pragma mark -- 手势代理方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //在这里判断什么时候该执行或不执行这个手势事件
    if ([touch.view isKindOfClass:[UIButton class]] || [touch.view isKindOfClass:[UITextField class]]) {
        
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
    NSLog(@"ServiceDetails dealloc");
    [ASISOAPRequest clearDelegatesAndCancel];
    [ASISOAPRequest release];
    [HUD release];
    HUD=nil;
    _resultArray=nil;
    _uiTableView=nil;
    _servicesContentArray=nil;
    poplistview=nil;
    _foreachLabelCount=nil;
    _failedReasonArray=nil;
    _popoerView=nil;
    _datePicker=nil;
    _maskView=nil;
    _curClickBtn=nil;
    _curIndexInArray=nil;
    IsEditClicknum=nil;
    _thePhoneNum=nil;
    
    appDelegate.CurTaskId=nil;
    appDelegate.CurTaskTypeId=nil;
    appDelegate.ServicesDictionary=nil;
    
    [super dealloc];
}
@end
