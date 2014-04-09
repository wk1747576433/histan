//
//  HISTANAPPViewController.m
//  histan
//
//  Created by liu yonghua on 13-12-27.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//
#define bottomMenusHieght 65


#import "HISTANAPPViewController.h"


@implementation HISTANAPPViewController
{
    UIViewController *loginController;//用于标识登陆页面是否已经被销毁
    float menuSubViewsWidth;
    float menuSubViewsHieght;
}
@synthesize subViewControlls = _subViewControlls;


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
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
    }
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    //设置背景图片
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];
    [bgImgView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgImgView.userInteractionEnabled=YES; //启用可响应事件
    [self.view addSubview:bgImgView];
    
    CGRect bgr = [ UIScreen mainScreen ].applicationFrame;
    float framebgHeight=bgr.size.height;
    
    //主菜单视图
    menusScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, framebgHeight - bottomMenusHieght-44)];
    [menusScrollView setTag:initTag+1];
    [bgImgView addSubview:menusScrollView];
    // [menusScrollView setBackgroundColor:[UIColor blackColor]];
    
    //[bgImgView release];
    
    loginController = nil;
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
    
    ////histan_NSLog(@"self.view.frame.size.height:%f",self.view.frame.size.height);
    
    //底部菜单视图
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,framebgHeight-bottomMenusHieght-44, self.view.frame.size.width-44, bottomMenusHieght)];
    [bottomView setBackgroundColor:[UIColor redColor]];
    [bottomView setTag:1002];
    
    UIButton *bottomBtn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn_1.frame=CGRectMake(0, 0, 160, bottomMenusHieght);
    [bottomBtn_1 setBackgroundImage:[UIImage imageNamed:@"main_bottom_bg_1"] forState:UIControlStateNormal];
    
    UIButton *bottomBtn_2= [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn_2 setBackgroundImage:[UIImage imageNamed:@"main_bottom_bg_2"] forState:UIControlStateNormal];
    bottomBtn_2.frame=CGRectMake(160, 0, 160, bottomMenusHieght);
    [bottomBtn_1 setTag:-1];
    [bottomBtn_2 setTag:-2];
    //底部按钮点击事件。
    [bottomBtn_2 addTarget:self action:@selector(bottomMenuBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn_1 addTarget:self action:@selector(bottomMenuBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:bottomBtn_1];
    [bottomView addSubview:bottomBtn_2];
    [self.view addSubview:bottomView];
    
    //如果没有用户登陆
    if ([appDelegate.UserName isEqualToString:@""] || appDelegate.UserName == nil) {
        
        //跳转到登陆页面
        loginController = [[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil]autorelease];
        [self.navigationController pushViewController:loginController animated:YES];
        [loginController release];
    }
    
    
    //先移除所有元素
    for (UIView *item in [menusScrollView subviews]) {
        
        [item removeFromSuperview];
    }
    
}

#pragma mark -- 加载菜单到界面的方法
-(void)loadMenus
{
    @try {
        //histan_NSLog(@"%s",__func__);
        HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        
        //先移除所有元素
        for (UIView *item in [menusScrollView subviews]) {
            
            [item removeFromSuperview];
        }
        
        
        /*
         *已下判断换行方法是错误的，请龙兄改正一下 https://itunes.apple.com/cn/app/hai-shi-tong/id796971080?l=en&mt=8
         */
        
        int i = 0;
        float x = 0;
        float y = 0;
        float width = (self.view.frame.size.width / 3);
        float height = (self.view.frame.size.width / 3);
        float currentSumWith = 0;
        float currentSumHieght = 0;
        
        //循环读取菜单项
        for (NSDictionary *menusItem in appDelegate.MenusArray) {
            
            currentSumWith = width * i;
            if (currentSumWith >= self.view.frame.size.width) {
                //该换行了
                currentSumHieght += height;
                currentSumWith = 0;
                i=0;
            }
            
            
            
            x = currentSumWith;
            ////histan_NSLog(@"x====%f ",x);
            y = currentSumHieght;
            ////histan_NSLog(@"y====%f ",y);
            
            //从网址获取菜单的图片
            NSString *imgUrl=[NSString stringWithFormat: @"%@",[menusItem objectForKey:@"apppic"]];
            //NSData *imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            
            UIButton *menusItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [menusItemBtn setFrame:CGRectMake(x, y, width, height)];
            NSInteger idInt = [[menusItem objectForKey:@"menuid"] integerValue];
            [menusItemBtn setTag:(idInt + initTag)];
            
            [menusItemBtn setBackgroundImage:[UIImage imageNamed:@"menclickbg"] forState:UIControlStateHighlighted];
            
            //添加点击事件menusTap
            [menusItemBtn addTarget:self action:@selector(menusTap:) forControlEvents:UIControlEventTouchUpInside];
            // UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imgData]];
            UIImageView *img = [[UIImageView alloc] init];
            [img setFrame:CGRectMake(23, 10, 60, 60)];
            
            
            NSURL *imgpath=[NSURL URLWithString:imgUrl];
            if (hasCachedImage(imgpath)) {
                
                [img setImage:[UIImage imageWithContentsOfFile:pathForURL(imgpath)]];
                
            }else
            {
                
                [img setImage:[UIImage imageNamed:@"loadbg"]];
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:imgpath,@"url",img,@"imageView",@"60",@"imageWidth",@"60",@"imageHeight",nil];
                [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dic];
            }
            
            //设置我的任务图片视图的tag，便于下面方法获取对象
            //如果是“我的任务” 则显示出我处理的任务条数【下面的方法有调用，此处注释】
            if (idInt==1) {
                img.tag=-9999999;
                NSDictionary *gothedic=[NSDictionary dictionaryWithObjectsAndKeys:img,@"view1",[NSString stringWithFormat:@"%d",idInt],@"MenuId",@"handler",@"StatisticsType",nil];
                [NSThread detachNewThreadSelector:@selector(LoadIDealTaskCountShowBadge:) toTarget:[HLSOFTThread defaultCacher] withObject:gothedic];
            }if (idInt==3) {
                img.tag=-9999998;
                NSDictionary *gothedic=[NSDictionary dictionaryWithObjectsAndKeys:img,@"view1",nil];
                [NSThread detachNewThreadSelector:@selector(LoadNoticeReadCountShowBadge:) toTarget:[HLSOFTThread defaultCacher] withObject:gothedic];
            }if (idInt ==19) {
                img.tag=-9999997;
                NSDictionary *gothedic=[NSDictionary dictionaryWithObjectsAndKeys:img,@"view1",[NSString stringWithFormat:@"%d",idInt],@"MenuId",nil];
                [NSThread detachNewThreadSelector:@selector(LoadServiceCountShowBadge:) toTarget:[HLSOFTThread defaultCacher] withObject:gothedic];
            }if (idInt ==18) {
                img.tag=-9999996;
                NSDictionary *gothedic=[NSDictionary dictionaryWithObjectsAndKeys:img,@"view1",[NSString stringWithFormat:@"%d",idInt],@"MenuId",nil];
                [NSThread detachNewThreadSelector:@selector(LoadLogisticsCountShowBadge:) toTarget:[HLSOFTThread defaultCacher] withObject:gothedic];
            }
            
            
            [menusItemBtn addSubview:img];
            UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 86, 20)];
            [textLable setText:[menusItem objectForKey:@"appname"]];
            [textLable setTextAlignment:NSTextAlignmentCenter];
            [textLable setFont:[UIFont fontWithName:@"System" size:12.00]];
            [textLable setBackgroundColor:[UIColor clearColor]];
            [menusItemBtn addSubview:textLable];
            
            [menusScrollView addSubview:menusItemBtn];
            
            
            i++;
        }
        
        [menusScrollView setContentSize:CGSizeMake(self.view.frame.size.width, currentSumHieght+height+50)];
        
    }
    @catch (NSException *exception) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器没有返回菜单数据，请重新登陆获取菜单信息！"  delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    @finally {
        
    }
    
}



#pragma mark -- 菜单项点击事件menusTap
-(void)menusTap:(UIButton *)sender
{
    @try {
        
        
        
        HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        
        
        NSInteger btnTag = sender.tag;
        //相应的菜单选项的id
        NSInteger btnRefrenceId = (btnTag - initTag);
        
        //histan_NSLog(@"id为%d的菜单项被点击",btnRefrenceId);
        
        //自定义返回按钮
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
        
        //判断当前点击的菜单的 link 是否为空
        NSString *link=@"";
        for (NSDictionary *menusItem in appDelegate.MenusArray) {
            NSInteger idInt = [[menusItem objectForKey:@"menuid"] integerValue];
            if (btnRefrenceId== idInt) {
                link=[menusItem objectForKey:@"link"];
                appDelegate.CurPageTitile=[menusItem objectForKey:@"appname"];
                appDelegate.upLoadImgMaxWidth = [NSString stringWithFormat:@"%@",[menusItem objectForKey:@"resolution"]];
                appDelegate.upLoadImgMaxSize = [NSString stringWithFormat:@"%@",[menusItem objectForKey:@"size"]];
                NSLog(@"maxheight:%@; maxsize:%@",appDelegate.upLoadImgMaxWidth,appDelegate.upLoadImgMaxSize);
                break;
            }
        }
        
        
        NSString *goLink=[NSString stringWithFormat:@"%@?P=%@",link,appDelegate.PValue,appDelegate.SID];
        //histan_NSLog(@"link:%@",goLink);
        
        if([link isEqualToString:@""]){
            
            if (btnRefrenceId==1) {
                //我的任务
                MyTaskController *view = [[MyTaskController alloc] init];
                [self.navigationItem setBackBarButtonItem:backBtn];
                [self.navigationController pushViewController:view animated:YES];
                [view release];
            }else if(btnRefrenceId==2){
                //我的业务
                MyBusinessController *view = [[MyBusinessController alloc] init];
                [self.navigationItem setBackBarButtonItem:backBtn];
                [self.navigationController pushViewController:view animated:YES];
                [view release];
            }else if(btnRefrenceId==3){
                //信息快报
                InfoPaperController *view = [[InfoPaperController alloc] init];
                [self.navigationItem setBackBarButtonItem:backBtn];
                [self.navigationController pushViewController:view animated:YES];
                [view release];
            }else  if(btnRefrenceId==19){
                //服务中心
                ServicesCenterViewController *serviceview = [[ServicesCenterViewController alloc] init];
                [self.navigationItem setBackBarButtonItem:backBtn];
                [self.navigationController pushViewController:serviceview animated:YES];
                [serviceview release];
            }else  if(btnRefrenceId==18){
                //物流中心
                LogisticsCenterViewController *logisticsCenterVC = [[LogisticsCenterViewController alloc] init];
                [self.navigationItem setBackBarButtonItem:backBtn];
                [self.navigationController pushViewController:logisticsCenterVC animated:YES];
                [logisticsCenterVC release];
            }
            
            
            
            
        }else{
            
            NSURL *weiboUrl=[NSURL URLWithString:goLink];
            SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:weiboUrl];
            [self.navigationItem setBackBarButtonItem:backBtn];
            [self.navigationController pushViewController:webViewController animated:YES];
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

#pragma mark -- 底部菜单项点击事件
-(void)bottomMenuBtnTaped:(UIButton *)sender
{
    //histan_NSLog(@"%s",__func__);
    //histan_NSLog(@"底部tag为%d菜单项点击",sender.tag);
    //根据tag判断跳转的页面
    if (sender.tag == -1) {
        SystemSetViewController *systemsetview=[[SystemSetViewController alloc]init];
        self.navigationItem.title=@"返回";
        [self.navigationController pushViewController:systemsetview animated:YES];
        [systemsetview release];
    }else if (sender.tag== -2) {
        
        ABoutUsViewController *aboutview=[[ABoutUsViewController alloc]init];
        self.navigationItem.title=@"返回";
        [self.navigationController pushViewController:aboutview animated:YES];
        [aboutview release];
    }
}


#pragma mark -- 每次页面显示之前的配置
-(void)viewWillAppear:(BOOL)animated
{
    @try {
        
        //histan_NSLog(@"%s",__func__);
        HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        /*
         *静态设置
         */
        self.navigationController.navigationBarHidden = NO;
        
        /*viewWillAppear方法每次显示之前都会调用，用登陆界面是否存在作为判断条件，
         *使加载菜单的操作只在登陆成功之后（登陆成功后loginController等于nil）加载一次菜单
         */
        self.navigationItem.title =[NSString stringWithFormat:@"%@,欢迎您",appDelegate.UserName];
        
        if (loginController != nil) {
            //histan_NSLog(@"登陆页面不等于nil，要将其等于nil后进行菜单显示");
            loginController = nil;
            //加载菜单到界面(将整个加载到界面的操作为一个方法，在这里调用)
            [self performSelector:@selector(getMenusArray)];
        }
        else
        {
            [self performSelector:@selector(getMenusArray)];
            //histan_NSLog(@"登陆页面已不存在，不用做什么吧...");
        }
        
        //重新加载数量
        // UIImageView *imgview=(UIImageView*)[self.view viewWithTag:-9999999];
        // NSDictionary *gothedic=[NSDictionary dictionaryWithObjectsAndKeys:imgview,@"view1",@"1",@"MenuId",@"handler",@"StatisticsType",nil];
        // [NSThread detachNewThreadSelector:@selector(LoadIDealTaskCountShowBadge:) toTarget:[HLSOFTThread defaultCacher] withObject:gothedic];
        
    }
    @catch (NSException *exception) {
        
        // go to  loginview
        //如果没有用户登陆
        
        //跳转到登陆页面
        loginController = [[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil]autorelease];
        [self.navigationController pushViewController:loginController animated:YES];
        [loginController release];
        
    }
    @finally {
        
    }
    
}



#pragma mark -- 获取菜单数组
-(void)getMenusArray
{
    @try {

        if(gcdNotifiView!=nil){
            [gcdNotifiView removeFromSuperview];
        }
        gcdNotifiView = [[GCDiscreetNotificationView alloc] initWithText:@"菜单加载中...！" showActivity:YES inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:self.view];
        [gcdNotifiView show:YES];
        
        HISTANAPPAppDelegate *appDelegate=HISTANdelegate;
        //设置参数数组
        NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID, nil];
        
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Menus wsParameters:wsParas];
        
        //为了使代码更加简洁，使用代码块，而不是用回调方法
        //使用block就不用代理了
        [ASISOAPRequest setCompletionBlock:^{
            
            ////histan_NSLog(@"responsString-----------------%@",[ASISOAPRequest responseString]);
            
            //获得返回的数据
            NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
            ////histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
            //将字典中key为data的对象转化为数组（NSArray）
            //然后遍历这个数组，将数组中的每一个对象转化为字典类型，主要就是要用这些字典
            //也可以只要准备好data的数组，需要用数据的地方再用循环将data数组中的对象用字典提取出来）
            appDelegate.MenusArray = (NSArray *)[soapPacking getJsonDataDicWithJsonStirng:returnString];
            NSLog(@"release在登陆窗体中，跳转之前 appDelegate.MenusArray---%@",appDelegate.MenusArray);
            
            if (gcdNotifiView!=nil) {
                //隐藏HUD
                [gcdNotifiView hide:YES];
            }
            
            
            //加载
            [self performSelector:@selector(loadMenus)];
            
        }];
        
        [ASISOAPRequest setFailedBlock:^{
            //  NSError *error = [ASISOAPRequest error];
            //histan_NSLog(@"获取菜单失败！ %@", [error localizedDescription]);
            
            
            if (IsLoadFailed==NO) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不稳定，获取菜单失败！请重新加载！"  delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新加载", nil];
                [alert show];
                [alert release];
            }else{
                IsLoadFailed=YES;
            }
            
        }];
        
        [ASISOAPRequest startAsynchronous];//开始异步请求
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

//点击重新加载按钮
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        IsLoadFailed=NO;
        if(gcdNotifiView!=nil){
            [gcdNotifiView hide:YES];
        }
        [self performSelector:@selector(getMenusArray)];
    }
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

@end
