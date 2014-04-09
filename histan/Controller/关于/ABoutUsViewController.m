//
//  ABoutUsViewController.m
//  histan
//
//  Created by lyh on 1/5/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "ABoutUsViewController.h"

@interface ABoutUsViewController ()

@end

@implementation ABoutUsViewController

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
    //设置背景图片
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];
    [bgImgView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgImgView.userInteractionEnabled=YES; //启用可响应事件
    [self.view addSubview:bgImgView];
    
    
    UIImageView *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 155)];
    [logoImg setImage:[UIImage imageNamed:@"index_top_image"]];
    [self.view addSubview:logoImg];
    
    
    //加载当前软件版本
    NSString *CurrentVersion=[[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString*)kCFBundleVersionKey];
    
    UILabel *verLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, 30)];
    verLabel.textAlignment=NSTextAlignmentCenter;
    verLabel.textColor=[UIColor whiteColor];
    verLabel.font=[UIFont boldSystemFontOfSize:16];
    verLabel.text=[NSString stringWithFormat:@"v%@",CurrentVersion];
    [self.view addSubview:verLabel];
    
    
    //    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, self.view.frame.size.height-160)];
    //    _scrollView.BackgroundColor=[UIColor clearColor];
    //    [self.view addSubview:_scrollView];
    //
    _textView=[[[UITextView alloc]initWithFrame:CGRectMake(27, 190, self.view.frame.size.width-54, self.view.frame.size.height-200)]autorelease];
    _textView.BackgroundColor=[UIColor clearColor];
    _textView.editable=NO;
    _textView.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_textView];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"加载中..."];
    
    appDelegate = HISTANdelegate;
   
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_About wsParameters:wsParas];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载
    
    
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    
    ////histan_NSLog(@"retainCount:%d",[hlnav retainCount]);
    
}


//加载数据出错。
-(void)requestDidFailed:(ASIHTTPRequest*)request{
    //histan_NSLog(@"cuowu");
    
    if(HUD!=nil){
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText = @"网络连接错误，请检查网络！";
        [HUD hide:YES afterDelay:2];
        
    }
}

//加载成功，现实到页面。
-(void)requestDidSuccess:(ASIHTTPRequest*)requestLoadSource{
    
    [HUD hide:YES];
    
    //histan_NSLog(@"ok");
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获取返回的json数据
    NSString *returnString = [soapPacking getReturnFromXMLString:[requestLoadSource responseString]];
    NSLog(@"返回的数据:%@",returnString);
    NSDictionary *dic = [soapPacking getDicFromJsonString:returnString];
    NSString *error = (NSString *)[dic objectForKey:@"error"];
    //histan_NSLog(@"dic 的数据是%@",dic);
    if ([error intValue] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败" delegate:self cancelButtonTitle:@"I know" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        
        NSString *str=@"";
        NSDictionary *retAboutData=[dic objectForKey:@"data"];
        
        //获取列表
        NSArray *keys=[retAboutData allKeys];
        for(int i=0;i<[keys count];i++){
            NSString *key=[keys objectAtIndex:i];
            NSLog(@"%@",[retAboutData objectForKey:key]);
            str=[NSString stringWithFormat:@"%@\n%@",str,[retAboutData objectForKey:key]];
        }
        
        
        _textView.text=str;
        
        
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [ASISOAPRequest clearDelegatesAndCancel];
    [ASISOAPRequest release];
    if(HUD!=nil){
    [HUD release];
    }
    //histan_NSLog(@"dealloc:%s",__func__);
    [_scrollView release];
    [_textView release];
    [super release];
}

@end
