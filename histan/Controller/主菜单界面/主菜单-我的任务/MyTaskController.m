//
//  MyTaskController.m
//  histan
//
//  Created by liu yonghua on 13-12-30.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import "MyTaskController.h"
#import "HISTANAPPAppDelegate.h"
#import "ASIHttpSoapPacking.h"
#import "NewTasksController.h"

@implementation MyTaskController
{
    //我处理的任务
    int myTask_hand_notCompleted;               //我处理的任务未完成数量
    int myTask_hand_conpletedNotAppraisal;      //我处理的任务完成但未评价数量
    int myTask_hand_completed;                  //我处理的任务已经完成数量
    
    //我提交的任务
    int myTask_submit_notCompleted;             //我提交的任务未完成数量
    int myTask_submit_conpletedNotAppraisal;    //我提交的任务完成但未评价数量
    int myTask_submit_completed;                //我提交的任务已经完成数量
    
}
@synthesize theNewTaskVC = _theNewTaskVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
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
    //histan_NSLog(@"%s",__func__);
    [super viewDidLoad];
    
    appDelegate = HISTANdelegate;
    self.navigationItem.title=appDelegate.CurPageTitile;
    
    myTask_hand_notCompleted = 0;               //未完成数量
    myTask_hand_conpletedNotAppraisal = 0;      //完成但未评价数量
    myTask_hand_completed = 0;                  //已经完成数量
    
    //我提交的任务
    myTask_submit_notCompleted = 0;             //我提交的任务未完成数量
    myTask_submit_conpletedNotAppraisal = 0;    //我提交的任务完成但未评价数量
    myTask_submit_completed = 0;                //我提交的任务已经完成数量
}

//每次显示我的任务页面时请求和更新数据
-(void)viewWillAppear:(BOOL)animated
{
    //histan_NSLog(@"%s",__func__);
    //调用API_Get_Statistics函数获取“我的任务”状态
    [self performSelector:@selector(getMyTask_StatusSOAPrequest)];
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


#pragma mark -- 分类统计“我的任务”请求
-(void)getMyTask_StatusSOAPrequest
{
    @try {
        
        
        //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //[HUD setLabelText:@"加载中..."];
        
        //初始化参数数组（必须是可变数组）
        NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
        
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Get_Statistics wsParameters:wsParas];
        ////histan_NSLog(@"发送的路径：%@",);
        
        
        //为了使代码更加简洁，使用代码块，而不是用回调方法
        //使用block就不用代理了
        [ASISOAPRequest retain];
        [ASISOAPRequest setCompletionBlock:^{
            @try {
                
           
            // [HUD hide:YES];
            ////histan_NSLog(@"responsString-----------------%@",[ASISOAPRequest responseString]);
            
            //获取返回的json数据
            NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
            ////histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
            
            //获取data字典
            NSDictionary *statusDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
            
            //得到‘我处理的任务’和‘我提交的任务’状态数组
            NSArray *handStatusArray= [statusDic objectForKey:@"handler"];
            NSArray *submitStatusArray = [statusDic objectForKey:@"submitter"];
            
            NSMutableArray *counts = [NSMutableArray arrayWithArray:handStatusArray];
            for (id item in submitStatusArray) {
                [counts addObject:item];
            }
            
            //记录到全局变量
            appDelegate.MyTaskStatus = counts ;
            
            //显示到界面
            for (int i = 0; i < [counts count]; i++) {
                UILabel *label = (UILabel *)[self.view viewWithTag:710+i];
                NSString *text = label.text;
                NSArray *textArray = [text componentsSeparatedByString:@"（"];
                label.text = [textArray objectAtIndex:0];
                [label setText:[label.text stringByAppendingFormat:@"（%@）",[counts objectAtIndex:i]]];
            }
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
        }];
        
        //请求失败
        [ASISOAPRequest setFailedBlock:^{
           
            HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
            //显示的文字
            HUD.labelText = @"请求超时！请检查网络！";
            [HUD hide:YES afterDelay:1];
            
        }];
        
        //同步
        //[ASISOAPRequest startSynchronous];
        //异步
        [ASISOAPRequest startAsynchronous];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}



#pragma mark -- 菜单项btn点击事件
- (IBAction)btnTaped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger btnTag = btn.tag;
    //根据tag值跳转页面
    
    //自定义返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    //记录当前选中的任务类别ID
    appDelegate.CurTaskTypeId=[NSString stringWithFormat:@"%d",btnTag];
    
    if(btnTag==701){
        //新建任务 701
        appDelegate.CurPageTitile=@"新建任务";
        
        NewTasksController *newTaskView = [[NewTasksController alloc] init];
        [self.navigationController pushViewController:newTaskView animated:YES];
        [newTaskView release];
        //newTaskView=nil;
        
        
    }else if( btnTag ==702 || btnTag ==703|| btnTag==704){
        //我处理的任务--未完成 702
        //我处理的任务--完成未评价 703
        //我处理的任务--完成已评价 704
        
        appDelegate.CurPageTitile=@"我处理的任务"; //页面要显示的标题
        
        IDealTaskController *idealTaskView=[[IDealTaskController alloc]init];
        [self.navigationController pushViewController:idealTaskView animated:YES];
        [idealTaskView release];
        
    }else if( btnTag ==705 || btnTag ==706|| btnTag==707){
        
        //我提交的任务--未完成  705
        //我提交的任务--完成未评价  706
        //我提交的任务--完成已评价  707
        appDelegate.CurPageTitile=@"我提交的任务"; //页面要显示的标题
        
        IDealTaskController *idealTaskView=[[IDealTaskController alloc]init];
        [self.navigationController pushViewController:idealTaskView animated:YES];
        [idealTaskView release];
        
        //        ISubmitTaskController *isubmitView=[[ISubmitTaskController alloc]init];
        //        [self.navigationController pushViewController:isubmitView animated:YES];
        //        [isubmitView release];
    }else if(btnTag == 708){
        //我的绩效 708
        appDelegate.CurPageTitile=@"我的绩效"; //页面要显示的标题
        
        MyPerformanceController *myperformanceView=[[MyPerformanceController alloc]init];
        [self.navigationController pushViewController:myperformanceView animated:YES];
        [myperformanceView release];
    }
    
    
    
    
}

-(void)dealloc{
    @try {
        
        
        //NSLog(@"mytask relea");
        //清除当前网络请求
        //[ASISOAPRequest clearDelegatesAndCancel];
        //[ASISOAPRequest release];
        
        [super release];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
