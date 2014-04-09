//
//  NewTasksController.m
//  histan
//
//  Created by liu yonghua on 14-1-4.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#define loding @"加载中..."

#import "NewTasksController.h"
#import <QuartzCore/QuartzCore.h>
#import "HISTANAPPAppDelegate.h"
#import "ASIHttpSoapPacking.h"
#import "ASIFormDataRequest.h"
#import "GTMBase64.h"
@implementation NewTasksController
{
    //部门列表
    NSArray *deptArray;
    
    //记录所有地区数据
    NSDictionary *allAreaDic;
    
    //记录所有城市
    NSArray *cityArray;
    
    //记录所有地区数组
    NSArray *areaArray;
    
    //记录所有任务类型数据
    NSDictionary *allTypeDic;
    
    //记录对应部门下的任务类型值
    NSMutableArray *typeArray;
    //记录字典中的键（key），也就是任务的id
    NSArray *typeKeys;
    
    //记录处理人
    NSArray *handersArray;
    
    //弹出选择框
    UIPopoverListView *poplistview;
    
    //需要暂时储存的参数
    NSString *deptID;        //所选部门id
    NSString *ifByArea;      //是否需要传地区参数（@“0”不需要，@“1”需要）
    NSString *typeID;        //项目类别id
    NSString *cityID;        //所选城市id
    NSString *taskID;         //新建任务成功后返回的任务id
    
    
    //初始时view的frame
    CGRect firstFrame;
    
    BOOL isSaveImage;
    
    //附件显示label的第一个的frame
    CGRect apendFrame;
    
    //记录选择的时间
    NSDate *selectedDate;
    
    //bottomView初始的frame
    CGRect bottomFrame;
    
    //scrollView初始的contentSize
    CGSize scrollSize;
    
    CGRect submitBtnFrame;
    
}
@synthesize textView;
@synthesize taskNameFiled;

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
    @try {
        
        
        
        [super viewDidLoad];
        appDelegate = HISTANdelegate;
        self.navigationItem.title=@"新建任务";
        
        CGRect r = [ UIScreen mainScreen ].applicationFrame;
        //NSLog(@"r.height = %f,r.width = %f,r.x = %f,r.y = %f",r.size.height,r.size.width,r.origin.x,r.origin.y);
        
        //初始化第一个附件显示label的frame
        apendFrame = CGRectMake(appendixLabel.frame.origin.x, appendixLabel.frame.origin.y + appendixLabel.frame.size.height-2, appendixLabel.frame.size.width, 38);
        
        [scrollView setAlwaysBounceVertical:YES];
        [scrollView setContentSize:CGSizeMake(320, topView.frame.size.height + zoneView.frame.size.height + bottomView.frame.size.height)];
        [self.taskNameFiled setDelegate:self];
        [self.textView setDelegate:self];
        
        //bottomView初始的frame
        bottomFrame = bottomView.frame;
        //scrollView初始的contentSize
        scrollSize = scrollView.contentSize;
        
        submitBtnFrame = submitBtn.frame;
        //histan_NSLog(@"初始的位置：x=%f,y=%f,w=%f,h=%f",submitBtnFrame.origin.x,submitBtnFrame.origin.y,submitBtnFrame.size.width,submitBtnFrame.size.height);
        
        isSaveImage = FALSE;
        deptID = nil;
        ifByArea = nil;
        typeID = nil;
        cityID = nil;
        taskID = nil;
        
        
        selectedDate = [NSDate date];
        //histan_NSLog(@"初始化的时间：%@",selectedDate);
        [selectedDate retain];
        NSString *dateStr = [[NSString stringWithFormat:@"%@",selectedDate] substringToIndex:10];
        //histan_NSLog(@"dateStr = %@",dateStr);
        [dateShowLabel setText:dateStr];
        
        UIButton *dataBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dataBgBtn setFrame:CGRectMake(dateShowLabel.frame.origin.x, dateShowLabel.frame.origin.y, dateShowLabel.frame.size.width, dateShowLabel.frame.size.height)];
        [dataBgBtn addTarget:self action:@selector(selectDateBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:dataBgBtn];
        
        
        appDelegate.upFileNameArray = [[NSMutableArray alloc] init];
        //附件选择
        [appendixLabel.layer setBorderWidth:0.5];
        [appendixLabel.layer setCornerRadius:5.0];
        //[appendixLabel setUserInteractionEnabled:YES];
        
        //添加手势，点击屏幕其他区域关闭键盘的操作
        //注意！添加了手势要用设置代理，用代理方法判断消息发送者来处理事件，否则所有其他事件都会被手势事件所屏蔽
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewInputDone:)];
        //点击一下的时候触发
        gesture.numberOfTapsRequired = 1;
        //设置代理
        gesture.delegate = self;
        [scrollView addGestureRecognizer:gesture];
        
        //分配内存
        deptArray=[[NSArray alloc]init];
        deptArray = nil;
        
        //任务描述框设置
        [textView setAutoresizingMask:UIViewAutoresizingNone];
        [textView setReturnKeyType:UIReturnKeyDefault];
        [textView.layer setCornerRadius:6.0];
        //[textView.layer setMasksToBounds:YES];
        [textView.layer setBorderWidth:0.5];
        [textView setText:@"请输入任务描述："];
        
        [appendixLabel setAutoresizingMask:UIViewAutoresizingNone];
        
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
        [self.view addSubview:_maskView];
        
        //记录初始view的frame
        firstFrame = self.view.frame;
        //弹出部门选择，先请求数据,用获取部门数据并弹出选择框的方法
        [self performSelector:@selector(loadDepts)];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


//部门、地区、任务类型、处理人选择按钮点击事件
- (IBAction)selectBtnTaped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    //histan_NSLog(@"btn.tag ------%d",btn.tag);
    
    
    switch (btn.tag) {
        case 800:
            /*
             *选择部门
             */
            //设置弹出选择框的标识，用于识别应该加载什么数据
            [poplistview setTag:1314 +initTag];
            
            //每次选择时重置变量
            cityID = nil;
            typeID = nil;
            ifByArea = nil;
            [deptNameBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [taskTypeBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [handerNameBtn setTitle:@"请选择" forState:UIControlStateNormal];
            //1.同步加载数据
            [self performSelector:@selector(loadDepts)];
            break;
        case 801:
            //选择城市
            [poplistview setTag:1315 +initTag];
            
            typeID = nil;
            [cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [taskTypeBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [handerNameBtn setTitle:@"请选择" forState:UIControlStateNormal];
            
            if ([deptNameBtn.titleLabel.text isEqualToString:@"请选择"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择部门^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            //1.同步加载数据
            NSString *parameterStr = @"city";
            [self performSelector:@selector(getAllAreaData:) withObject:parameterStr];
            
            break;
        case 802:
            
            typeID = nil;
            [areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [taskTypeBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [handerNameBtn setTitle:@"请选择" forState:UIControlStateNormal];
            
            //选择地区
            //判断是否已经选择城市
            if (cityID == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择市^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            else
            {
                [poplistview setTag:1316+initTag];
                NSString *parameterStr2 = @"area";
                [self performSelector:@selector(getAllAreaData:) withObject:parameterStr2];
            }
            break;
        case 803:
            [taskTypeBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [handerNameBtn setTitle:@"请选择" forState:UIControlStateNormal];
            //选择任务类型
            if (deptID == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择部门^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            else
            {
                if (![zoneView isHidden] && cityID == nil) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择城市^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
                else
                {
                    [poplistview setTag:1317+initTag];
                    [self performSelector:@selector(getTypeAndShow)];
                }
            }
            
            break;
        case 804:
            [handerNameBtn setTitle:@"请选择" forState:UIControlStateNormal];
            //选择处理人
            //选择处理人之前要先选择部门和任务类型（如果需要传参数的话还要判断是否已经选择了地区）
            if (deptID == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择部门^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            else
            {
                if ([zoneView isHidden]==NO && [cityBtn.titleLabel.text isEqualToString:@"请选择"] ) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择城市^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
                else if([taskTypeBtn.titleLabel.text isEqualToString:@"请选择"] || typeID  == nil)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择任务类型^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                    
                }
                else
                {
                    [poplistview setTag:1318+initTag];
                    [self performSelector:@selector(getHandersAndShow)];
                }
                
            }
            
            break;
        default:
            break;
    }
}

//希望完成时间选择事件
- (IBAction)selectDateBtnTaped:(id)sender {
    CGRect r_cg = mainScreen_CGRect;
    
    CGRect newFrame = CGRectMake(0, r_cg.size.height-300, 320, 300);
    [UIView beginAnimations:@"showTHePiker" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
    
    
    
}

-(void)hiddenThePickerCancel:(UIBarButtonItem *)sender
{
    
    
}

-(void)hiddenThePicker:(UIBarButtonItem *)sender
{
    CGRect r_cg = mainScreen_CGRect;
    //收起键盘，并隐藏picker
    CGRect newFrame = CGRectMake(0, r_cg.size.height, 320, 300);
    [UIView beginAnimations:@"showTHePiker" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
    
}

//拍照按钮点击事件
- (IBAction)PhotographBtnTaped:(id)sender {
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

//选择文件按钮点击事件
- (IBAction)selectFromFileBtnTaped:(id)sender {
    
    if ([appDelegate.upFileNameArray count] > 0) {
        //大于0，坑定之前添加过此时数组个数的label,移除之
        
        for (int i = 0; i<[appDelegate.upFileNameArray count]; i++) {
            [[bottomView viewWithTag:5566+i] removeFromSuperview];
        }
        //恢复bottomView初始的frame
        [bottomView setFrame:bottomFrame];
        //恢复scrollView初始的contentSize
        [scrollView setContentSize:scrollSize];
        [submitBtn setFrame:submitBtnFrame];
    }
    
    
    
    //自定义返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    selectFileViewController *fileVC = [[selectFileViewController alloc] init];
    [self.navigationController pushViewController:fileVC animated:YES];
    [fileVC release];
    fileVC = nil;
}

//提交按钮点击事件
- (IBAction)submitBtnTaped:(id)sender {
    
    if (ifByArea == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择部门^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([ifByArea isEqualToString:@"0"])
    {
        //不需要判断地区
        if (typeID == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择任务类型^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        if ([handerNameBtn.titleLabel.text isEqualToString:@"请选择"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择处理人^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        if ([taskNameFiled.text isEqualToString:@" "] || [taskNameFiled.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"任务名不能为空^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
    }
    else
    {
        if (typeID == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择任务类型^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        if (cityID == nil || [areaBtn.titleLabel.text isEqualToString:@"请选择"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择市区^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        if ([handerNameBtn.titleLabel.text isEqualToString:@"请选择"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先选择处理人^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        if ([taskNameFiled.text isEqualToString:@" "] || [taskNameFiled.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"任务名不能为空^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //直接提交任务
    [HUD setLabelText:@"任务提交中..."];
    [self performSelector:@selector(submitTask)];
}

#pragma mark -- 提交没有附件时的任务
-(void)submitTask
{
    @try {
        
        
        //提交创建的任务.如果该界面已经存在了 taskID ，则只上传附件了。
        //histan_NSLog(@"taskID:%@",taskID);
        if(taskID ==nil){
            
            //准备所需参数
            NSString *taskName = taskNameFiled.text;
            NSString *taskDesc = textView.text;
            NSString *deptId = deptID;
            NSString *typeId = typeID;
            NSString *handler = handerNameBtn.titleLabel.text;
            //histan_NSLog(@"所选时间%@",selectedDate);
            //将时间转换为时间戳
            NSString *dateTime = [NSString stringWithFormat:@"%d",(int)[selectedDate timeIntervalSince1970]];
            ////histan_NSLog(@"shijianchuo =====%@",dateTime);
            NSString *area = @"";
            if ([ifByArea isEqualToString:@"1"]) {
                area = ifByArea;
            }
            //初始化参数数组（必须是可变数组）
            NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"taskname",taskName,@"taskdesc",taskDesc,@"deptid",deptId,@"typeid",typeId,@"handler",handler,@"wcomptime",dateTime,@"area",area,nil];
            
            // for (NSString *item in wsParas) {
            //     NSLog(@"提交任务时的参数：%@",item);
            // }
            
            //实例化OSAPHTTP类
            ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
            //获得OSAPHTTP请求
            ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_CreateTask_insert wsParameters:wsParas];
            ////histan_NSLog(@"发送的路径：%@",);
            //异步
            [ASISOAPRequest startAsynchronous];
            //    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //    [HUD setLabelText:@"附件上传中..."];
            [ASISOAPRequest setCompletionBlock:^{
                //连接成功
                //histan_NSLog(@"提交任务时返回的原始数据**************************%@",[ASISOAPRequest responseString]);
                //获取返回的json数据
                NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
                //histan_NSLog(@"提交任务时返回的数据：%@",returnString);
                NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
                NSString *error = [NSString stringWithFormat:@"%@", [dic objectForKey:@"error"]];
                //histan_NSLog(@"提交任务时返回的数据是%@",dic);
                //返回数据中有出错信息
                if ([error intValue] != 0) {
                    [HUD hide:YES];
                    NSString *errordata= (NSString *)[dic objectForKey:@"data"];
                    //histan_NSLog(@"出错信息：%@",errordata);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errordata delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
                //创建任务成功
                else
                {
                    //提示创建成功，并跳转回我的任务页面
                    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [HUD setLabelText:@"创建任务成功！"];
                    //保存任务id
                    taskID =[[dic objectForKey:@"data"] retain];
                    //histan_NSLog(@"taskID = %@",taskID);
                    //[taskID retain];
                    
                    //开始上传附件
                    //[HUD setLabelText:@"附件上传中..."];
                    [self performSelector:@selector(upLoadFiles) withObject:nil afterDelay:1.0];
                }
                
            }];
            
            [ASISOAPRequest setFailedBlock:^{
                [HUD hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传请求连接失败！！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }];
            
        }else{
            
            //开始上传附件
            [HUD setLabelText:@"附件上传中..."];
            [self performSelector:@selector(upLoadFiles) withObject:nil afterDelay:1.0];
        }
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}




//跳转回我的任务页面
-(void)jumpBack
{
    @try {
        [HUD removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
         
    } 
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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try {
        
        
        [picker dismissModalViewControllerAnimated:YES];
        //histan_NSLog(@"info = %@",info);
        
        //获取照片实例
        UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
        //初始化照片名
        NSString *fileName = [[NSString alloc] init];
        
        if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
            fileName = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
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
        NSData *jpgData = UIImageJPEGRepresentation(image,1.0);
        
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


#pragma mark -- 日期选择变化
-(void)valueChang:(UIDatePicker *)picker
{
    selectedDate = [picker date];
    [selectedDate retain];
    //histan_NSLog(@"selectedDate--%@",selectedDate);
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    dateShowLabel.text = dateString;
}

#pragma mark -- textfiled 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //histan_NSLog(@"%s",__func__);
    [self.taskNameFiled resignFirstResponder];
    return YES;
}

//输入框开始编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect r_cg = mainScreen_CGRect;
    //收起键盘，并隐藏picker
    CGRect newFrame = CGRectMake(0, r_cg.size.height, 320, 300);
    [UIView beginAnimations:@"showTHePiker" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
    
    //histan_NSLog(@"%s",__func__);
    CGRect frame = CGRectMake(0, -50, 320, r_cg.size.height);
    [UIView beginAnimations:nil context:nil];
    self.view.frame = frame;
    [UIView commitAnimations];
}

//输入框完成编辑
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //histan_NSLog(@"%s",__func__);
    CGRect r = mainScreen_CGRect;
    CGRect frame = CGRectMake(0, 0, 320, r.size.height);
    if (_IsIOS7_) {
        frame = CGRectMake(0, 64, 320,  r.size.height);
    }
    if (self.view.frame.origin.y == 0) {
        //histan_NSLog(@"当前view的y坐标为0");
    }
    else{
        [UIView beginAnimations:nil context:nil];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    
}


#pragma mark -- textView 代理方法
//输入框开始编辑
-(void)textViewDidBeginEditing:(UITextView *)atextView
{
    CGRect r_cg = mainScreen_CGRect;
    //收起键盘，并隐藏picker
    CGRect newFrame = CGRectMake(0, r_cg.size.height, 320, 300);
    [UIView beginAnimations:@"showTHePiker" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
    
    
    //文字输入视图开始编辑
    CGRect frame = CGRectMake(0, -120, 320, r_cg.size.height);
    [UIView beginAnimations:nil context:nil];
    self.view.frame = frame;
    [UIView commitAnimations];
    
    if ([textView.text isEqualToString:@"请输入任务描述："]) {
        textView.text = @"";
    }
}
//输入框完成编辑
-(void)textViewDidEndEditing:(UITextView *)atextView
{
    
    
    //histan_NSLog(@"%s",__func__);
    CGRect r = mainScreen_CGRect;
    CGRect frame = CGRectMake(0, 0, 320,  r.size.height);
    if (_IsIOS7_) {
        frame = CGRectMake(0, 64, 320,  r.size.height);
    }
    if (self.view.frame.origin.y == 0) {
        //histan_NSLog(@"当前view的y坐标为0");
    }
    else{
        [UIView beginAnimations:nil context:nil];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    if ([textView.text isEqualToString:@""] || textView.text == nil) {
        textView.text = @"请输入任务描述：";
    }
    
}



#pragma mark -- 点击其他任意位置收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //histan_NSLog(@"%s",__func__);
    //histan_NSLog(@"点击其他任意位置收起键盘");
    [self.taskNameFiled resignFirstResponder];
    [self.textView resignFirstResponder];
    
    
}


#pragma mark -- 隐藏textView的键盘
-(void)textViewInputDone:(UIBarItem *)sender
{
    
    CGRect r_cg = mainScreen_CGRect;
    //收起键盘，并隐藏picker
    CGRect newFrame = CGRectMake(0, r_cg.size.height, 320, 300);
    [UIView beginAnimations:@"showTHePiker" context:nil];
    [_maskView setFrame:newFrame];
    [UIView commitAnimations];
    
    //histan_NSLog(@"%s",__func__);
    //隐藏textview的键盘
    //histan_NSLog(@"TextView 的键盘显示状态:");
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
        //histan_NSLog(@"键盘已经隐藏");
    }
    
    
    //还要判断如果textFile的键盘是否隐藏，如果没有隐藏，将其隐藏
    if ([taskNameFiled isFirstResponder]) {
        [taskNameFiled resignFirstResponder];
    }
    
    UIView *pickerView = [self.view viewWithTag:321546];
    [pickerView removeFromSuperview];
    
}

#pragma mark -- 手势代理方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //在这里判断什么时候该执行或不执行这个手势事件
    if ([touch.view isKindOfClass:[UIButton class]] || touch.view.tag == 47890) {
        //histan_NSLog(@"这是点击按钮，请不要响应手势事件");
        [self.taskNameFiled resignFirstResponder];
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - UIPopoverListViewDataSource
//加载cell
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag = poplistview.tag;
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] autorelease];
    int row = indexPath.row;
    //NSLog(@"tag:%d",tag);
    if (1314+initTag == tag) {
        NSDictionary *itemDic = (NSDictionary *)[deptArray objectAtIndex:row];
        [poplistview setTitle:@"请选择部门"];
        cell.textLabel.text = [itemDic objectForKey:@"big_dept_name"];
    }else if(1315+initTag == tag){
        [poplistview setTitle:@"请选择市"];
        cell.textLabel.text = [cityArray objectAtIndex:row];
    }else if(1316+initTag ==tag){
        cell.textLabel.text = [areaArray objectAtIndex:row];
        [poplistview setTitle:@"请选择区"];
    }else if(1317+initTag ==tag){
        [poplistview setTitle:@"请选任务类型"];
        NSLog(@"typeArray:%@",typeArray);
        NSString *showTypeStr = [NSString stringWithFormat:@"%@-%@",[typeKeys objectAtIndex:row],[typeArray objectAtIndex:row]];
        cell.textLabel.text = showTypeStr;
    }else if(1318+initTag ==tag){
        cell.textLabel.text = [handersArray objectAtIndex:row];
        [poplistview setTitle:@"请选择处理人"];
    }
    
    return cell;
}

//行数
- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    @try {
        
        
        int tag = poplistview.tag;
        switch (tag) {
            case (1314+initTag):
                return [deptArray count];
                break;
            case 1315+initTag:
                return [cityArray count];
                //histan_NSLog(@"[cityArray count]%d",[cityArray count]);
                break;
            case 1316+initTag:
                return [areaArray count];
                break;
            case 1317+initTag:
                return [typeArray count];
                break;
            case 1318+initTag:
                return [handersArray count];
                break;
        }
        
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
        
        
        
        
        //histan_NSLog(@"%s : %d", __func__, indexPath.row);
        // your code here
        NSInteger tag = poplistview.tag;
        UITableViewCell *cell = [poplistview.listView cellForRowAtIndexPath:indexPath];
        NSLog(@"%@",cell.textLabel.text);
        //当前cell上的文字
        NSString *selectedText = cell.textLabel.text;
        switch (tag) {
            case 1314+initTag:
                [deptNameBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                for (NSDictionary *itemDic in  deptArray) {
                    if ([[itemDic objectForKey:@"big_dept_name"] isEqualToString:selectedText]) {
                        //记录所选部门id和是否需要地区
                        deptID = [itemDic objectForKey:@"deptid"];
                        //histan_NSLog(@"记录的所选部门id：%@",deptID);
                        ifByArea = [itemDic objectForKey:@"if_by_area"];
                        //histan_NSLog(@"记录的是否需要地区：%@",ifByArea);
                        
                        //判断是否需要地区
                        if ([ifByArea intValue] == 1) {
                            //需要调用获取地区的方法加载地区选择框
                            //1.显示地区选择view(动画后面再加)
                            //如果当前地区选择被隐藏
                            if ([zoneView isHidden]) {
                                //显示地区选项
                                [zoneView setHidden:NO];
                                //将bottomView下移遮
                                CGRect downFrame = CGRectMake(bottomView.frame.origin.x, (bottomView.frame.origin.y+zoneView.frame.size.height), bottomView.frame.size.width, bottomView.frame.size.height) ;
                                //刷新用于记录当前底部view的frame
                                bottomFrame = downFrame;
                                
                                //动画
                                [UIView beginAnimations:nil context:nil];
                                [bottomView setFrame:downFrame];
                                [UIView commitAnimations];
                            }
                            
                            
                            //2.调用获取数据和弹出选择框方法
                            //先获取所有地区数据（包括省，市，区）,然后在后面按条件加载相应省、市和区
                            //调用获取所有地区数据的方法，将返回结果记录到当前全局变量allAreaDic
                            NSString *parameterStr = @"city";
                            [self performSelector:@selector(getAllAreaData:) withObject:parameterStr];
                        }
                        else{
                            //1.隐藏地区选择view
                            //如果当前地区选择框是显示状态
                            if (![zoneView isHidden]) {
                                
                                //设置为隐藏
                                [zoneView setHidden:YES];
                                CGRect upFrame = CGRectMake(bottomView.frame.origin.x, (bottomView.frame.origin.y-zoneView.frame.size.height), bottomView.frame.size.width, bottomView.frame.size.height) ;
                                bottomFrame = upFrame;
                                [UIView beginAnimations:nil context:nil];
                                [bottomView setFrame:upFrame];
                                [UIView commitAnimations];
                            }
                            //2.不用弹出地区选择框了  要调用弹出任务类型选择框方法
                            [self performSelector:@selector(getTypeAndShow)];
                        }
                    }
                    else
                    {
                        //什么都不做
                    }
                }
                
                break;
            case 1315+initTag:
                //显示所选项（得到了城市名）
                [cityBtn setTitle:selectedText forState:UIControlStateNormal];
                
                //根据城市名称找到对应的ID保存
                NSArray *allKeys = nil;
                NSArray *allCitys = nil;
                
                NSDictionary *citysDic = [allAreaDic objectForKey:@"c2"];
                allKeys = [citysDic allKeys];
                allCitys = [citysDic allValues];
                
                for (int i = 0; i < [citysDic count]; i++) {
                    NSString *cityName = [allCitys objectAtIndex:i];
                    if ([cityName isEqualToString:cityBtn.titleLabel.text]) {
                        //记录所选城市的id
                        cityID = [allKeys objectAtIndex:i];
                        //histan_NSLog(@"所选城市:%@的id为:%@",cityName,cityID);
                        ////histan_NSLog(@"到此已经记录的部门id：%@   是否需要传地区参数：%@ ",deptID,ifByArea);
                    }
                }
                
                //调用显示对应城市的地区，城市的id参数已经记录在全局变量cityID
                NSString *parameterStr = @"area";
                [self performSelector:@selector(getAllAreaData:) withObject:parameterStr];
                break;
            case 1316+initTag:
                [areaBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                
                //相继弹出任务类别选择框
                [self performSelector:@selector(getTypeAndShow)];
                
                break;
            case 1317+initTag:
                [taskTypeBtn  setTitle:cell.textLabel.text forState:UIControlStateNormal];
                //记录所选项目类型id
                NSString *btnText = taskTypeBtn.titleLabel.text;
                //转化成数组，以“-”为截断处
                NSArray *textArray = [btnText componentsSeparatedByString:@"-"];
                typeID = [textArray objectAtIndex:0];
                ////histan_NSLog(@"看看这个数组的第一个对象：%@",[textArray objectAtIndex:0]);
                
                //相继弹出处理人选择框
                [self performSelector:@selector(getHandersAndShow)];
                break;
            case 1318+initTag:
                [handerNameBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                
                //使任务名称输入框获得焦点
                [taskNameFiled becomeFirstResponder];
                break;
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}


#pragma mark -- 加载部门列表
-(void)loadDepts
{
    @try {
        
        
        
        //初始化参数数组（必须是可变数组）
        NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
        
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Get_Dept wsParameters:wsParas];
        ////histan_NSLog(@"发送的路径：%@",);
        
        [ASISOAPRequest startAsynchronous];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:loding];
        
        //使用block就不用代理了
        [ASISOAPRequest setCompletionBlock:^{
            
            //移除hud
            [HUD hide:YES];
            
            //获取返回的json数据
            NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
            NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
            NSString *error = (NSString *)[dic objectForKey:@"error"];
            //histan_NSLog(@"dic 的数据是%@",dic);
            
            if ([error intValue] != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败,可能是网络问题,请重试" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            else
            {
                //获取列表
                deptArray = (NSArray *)[dic objectForKey:@"data"];
                //必须引用计数加一
                [deptArray retain];
                ////histan_NSLog(@"已经储存部门数据！！！deptArray -------------%@",[deptArray objectAtIndex:0]);
                
                //弹出选择框
                //初始化弹出框
                CGFloat xWidth = self.view.bounds.size.width - 20.0f;
                CGFloat yHeight = [deptArray count]*40+40;
                //如果数据较多，固定弹出选择框的高度
                if (yHeight > 400) {
                    yHeight = 440;
                }
                CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
                poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
                [poplistview setTag:initTag+1314];//设置标识
                poplistview.delegate = self;
                poplistview.datasource = self;
                poplistview.listView.scrollEnabled = TRUE;
                poplistview.listView.showsVerticalScrollIndicator = NO;
                
                [poplistview show];
            }
        }];
        
        [ASISOAPRequest setFailedBlock:^{
            
            //NSError *error = [ASISOAPRequest error];
            //移除hud
            [HUD hide:YES];
            //histan_NSLog(@"error %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

#pragma mark -- 获取所有地区数据，并记录
-(void)getAllAreaData:(NSString *)cityOrArea
{
    @try {
        
        
        
        //初始化参数数组（必须是可变数组）
        NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
        
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASIHTTPRequest *ASISOAPRequestForZone = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Get_Area wsParameters:wsParas];
        ////histan_NSLog(@"发送的路径：%@",);
        
        
        //异步请求
        [ASISOAPRequestForZone startAsynchronous];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:loding];
        
        [ASISOAPRequestForZone setCompletionBlock:^{
            //移除hud
            [HUD hide:YES];
            
            //获取返回的json数据
            NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequestForZone responseString]];
            NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
            NSString *error = (NSString *)[dic objectForKey:@"error"];
            //histan_NSLog(@"dic 的数据是%@",dic);
            
            if ([error intValue] != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败,可能是网络问题,请重试" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                
            }
            else
            {
                
                @try {
                    
                    
                    
                    //记录返回的所有地区数据
                    allAreaDic = (NSDictionary *)[dic objectForKey:@"data"];
                    [allAreaDic retain];
                    //histan_NSLog(@"返回的所有地区数据:%@",allAreaDic);
                    
                    //获取所有市
                    NSDictionary *cityDic = [allAreaDic objectForKey:@"c2"];
                    ////histan_NSLog(@"c2:%@",cityDic);
                    
                    //记录所有城市
                    cityArray = [cityDic allValues];
                    [cityArray retain];
                    //histan_NSLog(@"城市数组中的数据：%@",cityArray);
                    
                    /*
                     *根据参数和城市是否为空判断是加载城市还是地区
                     */
                    if ([cityOrArea isEqualToString:@"city"]) {
                        //要求显示城市
                        
                        //初始化弹出框
                        CGFloat xWidth = self.view.bounds.size.width - 20.0f;
                        CGFloat yHeight = [cityArray count]*40+40;
                        //如果数据较多，固定弹出选择框的高度
                        if (yHeight > 400) {
                            yHeight = 440;
                        }
                        CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
                        poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
                        [poplistview setTag:initTag+1315];//设置标识
                        poplistview.delegate = self;
                        poplistview.datasource = self;
                        poplistview.listView.scrollEnabled = TRUE;
                        poplistview.listView.showsVerticalScrollIndicator = NO;
                        [poplistview show];
                        
                    }
                    else
                    {
                        //显示地区
                        //根据之前选择的城市ID（cityID）准备对应的地区数据
                        ////histan_NSLog(@"cityID-----%@",cityID);
                        NSString *keyhead = @"a";
                        NSString *keyStr = [keyhead stringByAppendingString:cityID];
                        id key = keyStr;
                        NSDictionary *areaDic = [allAreaDic objectForKey:key];
                        areaArray = [areaDic allValues];
                        [areaArray retain];
                        
                        //初始化弹出框
                        CGFloat xWidth = self.view.bounds.size.width - 20.0f;
                        CGFloat yHeight = [areaArray count]*40+40;
                        //如果数据较多，固定弹出选择框的高度
                        if (yHeight > 400) {
                            yHeight = 440;
                        }
                        CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
                        poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
                        [poplistview setTag:initTag+1316];//设置标识
                        poplistview.delegate = self;
                        poplistview.datasource = self;
                        poplistview.listView.scrollEnabled = TRUE;
                        poplistview.listView.showsVerticalScrollIndicator = NO;
                        [poplistview show];
                    }
                    
                }
                @catch (NSException *exception) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器没有返回数据！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
                @finally {
                    
                }
            }
        }];
        
        [ASISOAPRequestForZone setFailedBlock:^{
            //NSError *error = [ASISOAPRequestForZone error];
            //移除hud
            [HUD hide:YES];
            
            //histan_NSLog(@"error %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }];
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#pragma mark -- 获取所有任务类型数据并显示对应部门下的任务选择框
-(void)getTypeAndShow
{
    @try {
        
        
        //初始化参数数组（必须是可变数组）
        NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Get_Type wsParameters:wsParas];
        ////histan_NSLog(@"发送的路径：%@",);
        
        //异步请求
        [ASISOAPRequest startAsynchronous];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:loding];
        
        [ASISOAPRequest setCompletionBlock:^{
            [HUD hide:YES];
            //获取返回的json数据
            
            NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
            NSLog(@"The all:%@",returnString);
            NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
            NSString *error = (NSString *)[dic objectForKey:@"error"];
            NSLog(@"dic 的数据是%@",dic);
            
            if ([error intValue] != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败,可能是网络问题,请重试" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            else
            {
                @try {
                    
                    
                    //记录返回的所有任务类型数据
                    allTypeDic = (NSDictionary *)[dic objectForKey:@"data"];
                    [allTypeDic retain];
                    NSLog(@"返回的所有任务类型:%@",allTypeDic);
                    
                    //histan_NSLog(@"此时的部门id：%@",deptID);
                    //获取对应部门id下的任务类型
                    NSDictionary *typeDic = [allTypeDic objectForKey:deptID];
                    [typeDic retain];
                    NSLog(@"获取对应部门下的任务为:%@",typeDic);
                    
                    //记录到对应部门下的类型数组
                    //单独取出的键和值的顺序和字典中的存放顺序不一样，需要对存放的数组进行排序处理，并键值对应
                    //先将键取出排序,再取出相应值顺序放入数组
                    NSComparator cmptr = ^(id obj1, id obj2){
                        if ([obj1 integerValue] > [obj2 integerValue]) {
                            return (NSComparisonResult)NSOrderedDescending;
                        }
                        
                        if ([obj1 integerValue] < [obj2 integerValue]) {
                            return (NSComparisonResult)NSOrderedAscending;
                        }
                        return (NSComparisonResult)NSOrderedSame;
                    };
                    //1.取出键值
                    NSArray *tempKeys = [[NSArray alloc] init];
                    tempKeys = (NSArray *)[typeDic allKeys];
                    //2.排序
                    typeKeys = [[NSMutableArray alloc] init];
                    typeKeys = [tempKeys sortedArrayUsingComparator:cmptr];
                    [typeKeys retain];
                    //根据排序好的键取出值放入数组
                    typeArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [typeKeys count]; i++) {
                        NSString *key = [typeKeys objectAtIndex:i];
                        
                        [typeArray addObject:[typeDic objectForKey:key]];
                    }
                    [typeArray retain];
                    
                    NSLog(@"对应部门下类型数据：%@",typeArray);
                    NSLog(@"key值为：%@",typeKeys);
                    
                    if ([typeArray count]<1) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有该部门下的任务" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        [alert show];
                        [alert release];
                    }
                    else
                    {
                        //初始化弹出框
                        CGFloat xWidth = self.view.bounds.size.width - 20.0f;
                        CGFloat yHeight = [typeArray count]*40+40;
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
                @catch (NSException *exception) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器没有返回数据！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
                @finally {
                    
                }
            }
        }];
        
        [ASISOAPRequest setFailedBlock:^{
            //NSError *error = [ASISOAPRequest error];
            //移除hud
            [HUD hide:YES];
            
            //histan_NSLog(@"error %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }];
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}



#pragma mark -- 获取处理人，并弹出选择框
-(void)getHandersAndShow
{
    @try {
        
        //初始化参数数组（必须是可变数组）
        NSMutableArray *wsParas = nil;
        if ([ifByArea isEqualToString:@"0"] || ifByArea == nil) {
            //不需要传地区参数
            wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"deptid",deptID,@"typeid",typeID,nil];
        }
        else
        {
            NSString *shen = @"广东省";
            NSString *city = cityBtn.titleLabel.text;
            NSString *area = areaBtn.titleLabel.text;
            NSString *areaStr = [NSString stringWithFormat:@"%@*%@*%@",shen,city,area];
            wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"deptid",deptID,@"typeid",typeID,@"area",areaStr, nil];
        }
        
        // for(int i=0;i<[wsParas count];i++)
        // {
        //histan_NSLog(@"wsParas:%@",[wsParas objectAtIndex:i]);
        // }
        
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Get_Hand wsParameters:wsParas];
        ////histan_NSLog(@"发送的路径：%@",);
        
        
        [ASISOAPRequest startAsynchronous];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:loding];
        
        [ASISOAPRequest setCompletionBlock:^{
            [HUD hide:YES];
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
                @try {
                    
                    
                    //获取列表
                    NSString *handsStr;
                    handsStr = [dic objectForKey:@"data"];
                    //histan_NSLog(@"看看处理人数据！！！handsStr -------------%@",handsStr);
                    //将字符串化成数组
                    handersArray = [handsStr componentsSeparatedByString:@","];
                    [handersArray retain];
                    
                    //给处理人赋默认值
                    [handerNameBtn setTitle:[handersArray objectAtIndex:0] forState:UIControlStateNormal];
                    
                    //弹出选择框
                    //初始化弹出框
                    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
                    CGFloat yHeight = [handersArray count]*40+40;
                    //如果数据较多，固定弹出选择框的高度
                    if (yHeight > 400) {
                        yHeight = 440;
                    }
                    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
                    poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
                    [poplistview setTag:initTag+1318];//设置标识
                    poplistview.delegate = self;
                    poplistview.datasource = self;
                    poplistview.listView.scrollEnabled = TRUE;
                    poplistview.listView.showsVerticalScrollIndicator = NO;
                    [poplistview show];
                    
                }
                @catch (NSException *exception) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器没有返回数据！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
                @finally {
                    
                }
            }
        }];
        
        [ASISOAPRequest setFailedBlock:^{
            //NSError *error = [ASISOAPRequest error];
            //移除hud
            [HUD hide:YES];
            
            //histan_NSLog(@"error %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求失败！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }];
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


#pragma mark -- 循环上传文件
-(void)upLoadFiles
{
    @try {
        
        
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
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
            //不用上传文件，跳转回新建页面
            [HUD setLabelText:@"新建任务成功！"];
            [HUD hide:YES afterDelay:1.5];
            [self performSelector:@selector(jumpBack) withObject:nil afterDelay:1.0];
        }
        
    }
    @catch (NSException *exception) {
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        //不用上传文件，跳转回新建页面
        [HUD setLabelText:@"添加失败！"];
        [HUD hide:YES afterDelay:1.5];
    }
    @finally {
        
    }
}
//上传单个文件 fileName文件名  contents 文件内容（加密后）
-(void)upLoadOne:(NSString *)fileName fileContent:(NSString *)contents
{
    @try {
        
        //histan_NSLog(@"%s",__func__);
        
        //初始化参数数组（必须是可变数组）
        NSMutableArray *wsParas = nil;
        wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"bustype",@"1",@"filename",fileName,@"content",contents,@"tasked",taskID,@"step",@"0",nil];
        
        //for (NSString *item in  wsParas) {
        //histan_NSLog(@"参数数组项：%@",item);
        //}
        
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_File_Upload wsParameters:wsParas];
        
        //异步
        [ASISOAPRequest retain];
        [ASISOAPRequest setTimeOutSeconds:500]; //超时时间
        [ASISOAPRequest startAsynchronous];
        //使用block就不用代理了
        [ASISOAPRequest setCompletionBlock:^{
            //[HUD hide:YES];
            //histan_NSLog(@"上传文件时：  responsString-----------------%@",[ASISOAPRequest responseString]);
            //获取返回的json数据
            NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
            //histan_NSLog(@"上传文件时调用getReturnFromXMLString方法返回的数据：%@",returnString);
            //获取返回内容为字典
            NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
            NSLog(@"获取返回内容为字典 ：%@",allDic);
            NSString *error = [allDic objectForKey:@"error"];
            //histan_NSLog(@"获取返回error ：%@",error);
            if ([error intValue] == 1) {
                [HUD hide:YES];
                //histan_NSLog(@"上传失败！！！");
                //抛出错误并停止流程
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[allDic objectForKey:@"data"]  delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            else if([error intValue] == 2)
            {
                [HUD hide:YES];
                //histan_NSLog(@"上传超时！！！");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传附件超时！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            else if([error intValue] == 0)
            {
                //histan_NSLog(@"上传成功！！！");
                //如果最后一个附件都上传成功了就返回新建页
                if (fileName == [appDelegate.upFileNameArray lastObject]) {
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
                    HUD.labelText =@"附件上传成功！";
                    [HUD hide:YES afterDelay:1.5];
                    [self performSelector:@selector(jumpBack) withObject:nil afterDelay:1.8];
                }
            }
            else
            {
                [HUD hide:YES];
                //本地错误
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传失败，请检查网络！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            
        }];
        
        //请求失败
        [ASISOAPRequest setFailedBlock:^{
            [HUD setLabelText:@"网络超时！ 上传文件失败！"];
            [HUD hide:YES afterDelay:2.0];
            //NSError *error = [ASISOAPRequest error];
            //histan_NSLog(@"request failed!!!  error:%@",error);
        }];
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

//获取指定文件名的内容并加密
-(NSString *)getContentByFileName:(NSString *)fileName
{
    @try {
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
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


//每次显示界面时
-(void)viewWillAppear:(BOOL)animated
{
    @try {
        
        
        //每次加载列表之前先移除之前的列表
        
        //    if ([appDelegate.upFileNameArray count] > 0) {
        //        //histan_NSLog(@"上传列表的值：%@",appDelegate.upFileNameArray);
        //        for (int i = 0; i<[appDelegate.upFileNameArray count]; i++) {
        //            //添加到附件数组，appDelegate.upFileNameArray相当于一个搬运工一样，每次搬回来都要清空
        //            [appDelegate.upFileNameArray addObject:[appDelegate.upFileNameArray objectAtIndex:i]];
        //        }
        //
        //    }
        //    else
        //    {
        //
        //    }
        
        for (int i = 0; i<[appDelegate.upFileNameArray count]; i++) {
            [[bottomView viewWithTag:5566+i] removeFromSuperview];
        }
        
        if ([appDelegate.upFileNameArray count] > 0) {
            //绘制列表到界面
            [self performSelector:@selector(drawUpFileList)];
            
        }
        else
        {
            //恢复bottomView初始的frame
            [bottomView setFrame:bottomFrame];
            //恢复scrollView初始的contentSize
            [scrollView setContentSize:scrollSize];
            [submitBtn setFrame:submitBtnFrame];
            //histan_NSLog(@"初始的位置：x=%f,y=%f,w=%f,h=%f",submitBtnFrame.origin.x,submitBtnFrame.origin.y,submitBtnFrame.size.width,submitBtnFrame.size.height);
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
        NSInteger index = [sender superview].tag-5566;
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


#pragma mark -- UIDocumentInteractionController 的代理方法

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}




//删除附件操作
-(void)deleteBtnTaped:(UIButton *)sender
{
    @try {
        
        
        //histan_NSLog(@"label tag %d",[sender superview].tag);
        //histan_NSLog(@"%s",__func__);
        //histan_NSLog(@"数组的值 %@",appDelegate.upFileNameArray);
        NSInteger index = [sender superview].tag-5566;
        //移除列表
        for (int i = 0; i<[appDelegate.upFileNameArray count]; i++) {
            [[bottomView viewWithTag:5566+i] removeFromSuperview];
        }
        
        @try {
            
            //NSLog(@"appDelegate.upFileNameArray:%@",appDelegate.upFileNameArray);
            //删除文件照相文件
            NSFileManager *fileManager=[NSFileManager defaultManager];
            if ([[appDelegate.upFileNameArray objectAtIndex:index ] hasPrefix:@"photo_"]) {
                NSString *path_exsi=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[appDelegate.upFileNameArray objectAtIndex:index ]]];
                if([CommonHelper isExistFile:path_exsi])//存在文件，则删除
                {
                    [fileManager removeItemAtPath:path_exsi error:nil];
                }
                
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        //删除数据源appDelegate.upFileNameArray中的对应项，然后再重绘附件列表
        [appDelegate.upFileNameArray removeObjectAtIndex:index];
        
        //恢复bottomView初始的frame
        [bottomView setFrame:bottomFrame];
        //恢复scrollView初始的contentSize
        [scrollView setContentSize:scrollSize];
        [submitBtn setFrame:submitBtnFrame];
        //重新添加
        [self performSelector:@selector(drawUpFileList)];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

//绘制上传附件列表
-(void)drawUpFileList
{   //histan_NSLog(@"%s",__func__);
    //histan_NSLog(@"数组的值 %@",appDelegate.upFileNameArray);
    //绘制上传附件列表
    @try {
        
        
        
        CGRect bgr = [ UIScreen mainScreen ].applicationFrame;
        float framebgHeight=bgr.size.height;
        float scrollHeight=framebgHeight;//scrollView.contentSize.height;
        
        for (int i = 0; i<[appDelegate.upFileNameArray count]; i++) {
            
            
            @try {
                
                
                
                //label与button的组合
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(apendFrame.origin.x, apendFrame.origin.y + (i*apendFrame.size.height), apendFrame.size.width, apendFrame.size.height)];
                [label.layer setBorderWidth:1];
                [label.layer setBorderColor:[[UIColor grayColor] CGColor]];
                [label.layer setCornerRadius:2];
                [label setUserInteractionEnabled:YES];
                [label setTag:5566+i];
                
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
                [bottomView addSubview:label];
                
                [bottomView setFrame:CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y, bottomView.frame.size.width, bottomView.frame.size.height + 38)];
                [submitBtn setFrame:CGRectMake(submitBtn.frame.origin.x, 288 +38*(i+1), submitBtn.frame.size.width, submitBtn.frame.size.height)];
                
                scrollHeight+=40;
                
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        
        [scrollView setContentSize:CGSizeMake(320, scrollHeight)];
        //自动滚动到底部
        [scrollView setContentOffset:CGPointMake(0, scrollHeight - scrollView.bounds.size.height)];
        
    }
    @catch  (NSException *exception) {
        
    }
    @finally {
        
    }
}






- (void)viewDidUnload
{
    @try {
        
        
        [poplistview release];
        poplistview = nil ;
        [scrollView release];
        scrollView = nil;
        [topView release];
        topView = nil;
        [zoneView release];
        zoneView = nil;
        [bottomView release];
        bottomView = nil;
        [self setTextView:nil];
        [deptNameBtn release];
        deptNameBtn = nil;
        [cityBtn release];
        cityBtn = nil;
        [areaBtn release];
        areaBtn = nil;
        [taskTypeBtn release];
        taskTypeBtn = nil;
        [handerNameBtn release];
        handerNameBtn = nil;
        [taskNameFiled release];
        taskNameFiled = nil;
        [deptNameBtn release];
        deptNameBtn = nil;
        [topView release];
        topView = nil;
        [deptNameBtn release];
        deptNameBtn = nil;
        [self setTaskNameFiled:nil];
        [dateShowLabel release];
        dateShowLabel = nil;
        [appendixLabel release];
        appendixLabel = nil;
        [submitBtn release];
        submitBtn = nil;
        [super viewDidUnload];
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    NSLog(@"NewTask dealloc");
    [appDelegate.upFileNameArray removeAllObjects];
    appDelegate.upFileNameArray =nil;
    
    [scrollView release];
    [topView release];
    [zoneView release];
    [bottomView release];
    [textView release];
    [deptNameBtn release];
    [cityBtn release];
    [areaBtn release];
    [taskTypeBtn release];
    [handerNameBtn release];
    [taskNameFiled release];
    [dateShowLabel release];
    [appendixLabel release];
    [submitBtn release];
    [super dealloc];
}

@end
