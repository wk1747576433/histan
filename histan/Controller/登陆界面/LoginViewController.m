//
//  LoginViewController.m
//  histan
//
//  Created by liu yonghua on 13-12-27.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

@synthesize verLabel;
@synthesize userNameLable;
@synthesize userPwdLabel;
@synthesize rememberPwdBtn;
@synthesize userNameFiled;
@synthesize userPwdFiled;
@synthesize loginBtn;
@synthesize remindPassWordBtn;
@synthesize account_box=_account_box;
@synthesize showServiceBtn=_showServiceBtn;
@synthesize showServiceLabel=_showServiceLabel;
@synthesize showServiceScrollView=_showServiceScrollView;
@synthesize showDorpUIView=_showDorpUIView;

@synthesize showAccountBtn=_showAccountBtn;
@synthesize ShowAccount_box=_ShowAccount_box;
@synthesize showDorpUIView_showAccount=_showDorpUIView_showAccount;

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
    appDelegate.WebSevicesURL=@"";//初始化全局服务器地址
    
    //注册键盘出现和消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    [self.userNameFiled setDelegate:self];
    
    _showDorpScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 187, 100)];
    [_account_box addSubview:_showDorpScrollView];
    
    
    _showDorpScrollView_showAccount=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 187, 100)];
    [_ShowAccount_box  addSubview:_showDorpScrollView_showAccount];
    
    //设置“记住密码”按钮背景
    [self.rememberPwdBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_on"] forState:UIControlStateNormal];
    [self.rememberPwdBtn setTag:33];//用于标识是否记住密码状态（33表示选中，44表示未选中）
    
    
    
    // [_showServiceBtn addTarget:self action:@selector(dropDown:) forControlEvents:UIControlEventTouchUpInside];
    HISTANDataBaseContext *histanAccounts=[[HISTANDataBaseContext alloc]init];
    NSString *lastLoginUsername=  [histanAccounts Get_LastLoginUserName];
    [self  showCurUserNameInfos:lastLoginUsername];
    [histanAccounts release];
    /*
     *静态设置
     */
    //背景图设置
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    bgImageView.image = [UIImage imageNamed:@"login_bg"];
    [bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view insertSubview:bgImageView atIndex:0];
    [bgImageView release];
    
    
    //设置密码框
    [self.userPwdFiled setSecureTextEntry:YES];
    

    //方便测试，直接在文本框中显示测试账户
    // [self.userNameFiled setText:@"wujf"];
    // [self.userPwdFiled setText:@"w666666"];
    
    //设置登陆按钮图片样式
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"but_loging"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"but_loging_pressed"] forState:UIControlStateHighlighted];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    //加载当前软件版本
    NSString *CurrentVersion=[[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString*)kCFBundleVersionKey];
    verLabel.text=[NSString stringWithFormat:@"v%@",CurrentVersion];
    
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewInputDone:)];
//    //点击一下的时候触发
//    gesture.numberOfTapsRequired = 1;
//    //设置代理
//    gesture.delegate=self;
//    [self.view addGestureRecognizer:gesture];
//
    
    //加载服务器列表
    [self getWebServicesURLs];
    
    //10秒后开始调用这个方法 加载计时器
    [self performSelector:@selector(StartNsTimerToLoadServices) withObject:self afterDelay:10];
}

-(void)showCurUserNameInfos:(NSString *)UserName{
    //加载记住的用户名
    // NSDictionary *rd=[[NSDictionary alloc]initWithObjectsAndKeys:UserName,@"UserName",PassWord,@"PassWord",IsRemindPassWord,@"IsRemindPassWord", nil];
    NSMutableArray *allUserInfs=[[NSMutableArray alloc]init];
    HISTANDataBaseContext *histanAccounts=[[HISTANDataBaseContext alloc]init];
    allUserInfs= [histanAccounts Get_AllUserInfs];
    
    //移除所有选中
    for(UIView *btn in _showDorpScrollView_showAccount.subviews){
        if ([btn isKindOfClass:[UIButton class]]) {
            //移除该Button
            [btn removeFromSuperview];
        }
    }
    //histan_NSLog(@"%@",allUserInfs);
    
    //初始化密码框
    userPwdFiled.text=@"";
    
    int ci=0;
    for (NSDictionary *item in allUserInfs) {
        
        
        UIButton *addressbtn=[[UIButton alloc]initWithFrame:CGRectMake(5,ci*30+6, 175, 25)];
        addressbtn.frame=CGRectMake(5,ci*30+6, 175, 25);
        [addressbtn setTitle:[item objectForKey:@"UserName"] forState:UIControlStateNormal];
        [addressbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addressbtn.titleLabel.textAlignment=NSTextAlignmentLeft;
        //addressbtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 30);
        //addressbtn.backgroundColor=[UIColor blueColor];
        [addressbtn setBackgroundImage:[UIImage imageNamed:@"login_dropdown_bg"] forState:UIControlStateHighlighted];
        
        [addressbtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        addressbtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_showDorpScrollView_showAccount addSubview:addressbtn];
        [addressbtn setTag:initTag+300+ci];
        
        
        
        
        //添加改变用户的事件
        [addressbtn addTarget:self action:@selector(selectAccount:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *deleteuserbtn=[[UIButton alloc]initWithFrame:CGRectMake(145,0, 30, 25)];
        [deleteuserbtn setImage:[UIImage imageNamed:@"delete_16"] forState:UIControlStateNormal];
        
        [addressbtn addSubview:deleteuserbtn];
        //添加改变用户的事件
        [deleteuserbtn addTarget:self action:@selector(deleteAccount:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if([[item objectForKey:@"UserName"]isEqualToString:UserName]){
            
            //文本框显示这个用户名
            userName=UserName;
            userNameFiled.text=userName;
            //列表勾选
            
            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(120, 2, 20, 20)];
            [img setImage:[UIImage imageNamed:@"btn_check_on_normal"]];
            [addressbtn addSubview:img];
            [img release];
            
            
            //如果是记住密码，则加载密码
            if([[item objectForKey:@"IsRemindPassWord"] isEqualToString:@"1"]){
                
                [self.rememberPwdBtn setTag:33];
                [self.rememberPwdBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_on"] forState:UIControlStateNormal];  
                userPwdFiled.text=[item objectForKey:@"PassWord"];
                
            }else{
                [self.rememberPwdBtn setTag:44];
                [self.rememberPwdBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_off"] forState:UIControlStateNormal];
                userPwdFiled.text=@"";
            }
            
            
            
            
        }
        ci++;
    }
    
    [_showDorpScrollView_showAccount setContentSize:CGSizeMake(_showDorpScrollView_showAccount.frame.size.width, ci*36)];
    
    [histanAccounts release];
    [allUserInfs release];
}

-(void)deleteAccount:(UIButton*)sender{
    //histan_NSLog(@"deleteAccount");
    
    UIButton *ubtn=(UIButton*)[sender superview];
    deleteUserName= ubtn.titleLabel.text;
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"确定删除？" message:@"您确定删除该条记录吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //histan_NSLog(@"%d",buttonIndex);
    if(buttonIndex==0){
        
        HISTANDataBaseContext *histanAccounts=[[HISTANDataBaseContext alloc]init];
        [histanAccounts Delete_UserInfoByUserName:deleteUserName];
        
       
         NSString *lastLoginUsername=  [histanAccounts Get_LastLoginUserName];
        [self  showCurUserNameInfos:lastLoginUsername];
        [histanAccounts release];
        
    }
}

#pragma mark --选择用户事件
-(void)selectAccount:(UIButton *)sender{
    
    userName =sender.titleLabel.text;
    
    HISTANDataBaseContext *histanAccounts=[[HISTANDataBaseContext alloc]init];
    [self  showCurUserNameInfos:userName];
    [histanAccounts release];
    
    [self hideAccountBox_Account];
}

-(void)StartNsTimerToLoadServices{
    //启动一个计时器，目的是为了app一开始没有联网，每隔5秒自动加载一次 getWebServicesURLs 方法
    _timer= [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(getWebServicesURLs) userInfo:nil repeats:YES];
    
}

- (IBAction)dropDown:(id)sender {
    if ([sender isSelected]) {
        
        [self hideAccountBox];
        
    }else
    {
        
        [self showAccountBox];
        
    }
    
}

- (IBAction)dropDown_Account:(id)sender {
    if ([sender isSelected]) {
        
        [self hideAccountBox_Account];
        
    }else
    {
        
        [self showAccountBox_Account];
        
    }
    
}

- (void)viewDidUnload
{
    [self setVerLabel:nil];
    [self setUserNameFiled:nil];
    [self setUserPwdFiled:nil];
    [self setUserNameLable:nil];
    [self setUserPwdLabel:nil];
    [self setRememberPwdBtn:nil];
    [self setLoginBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -- 页面加载之前的配置
-(void)viewWillAppear:(BOOL)animated
{
    
    //在登陆页面，navigationbar不显示
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    //histan_NSLog(@"%s",__func__);
}



#pragma mark -- 键盘消失和出现时的方法
//键盘出现时调用
-(void)keyboardShow
{
    //添加动画,要执行的操作要包裹在UIView的beginAnimations和commitAnimations之间
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"selfViewUpAnimation" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0, -200, self.view.frame.size.width, self.view.frame.size.height);
    [self.view setFrame:rect];
    
    [UIView commitAnimations];
}

//键盘消失时调用
-(void)keyboardHide
{
    
   
    
    //添加动画,要执行的操作要包裹在UIView的beginAnimations和commitAnimations之间
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"selfViewDownAnimation" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view setFrame:rect];
    
    [UIView commitAnimations];
}

//点击任意处收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameFiled resignFirstResponder];
    [self.userPwdFiled resignFirstResponder];
    
  //NSLog(@"dd");
    
    if ([_showServiceBtn isSelected]) {
        
        [self hideAccountBox];
        
    }
    
    if ([_showAccountBtn isSelected]) {
        
        [self hideAccountBox_Account];
        
    }
    
}

#pragma mark -- 输入用户名后获取保存的密码
//如果第一个文本框（Tag值为10）编辑完毕，检查是否有保存该账号的密码
//如果有保存，则显示，并设置”保存密码“为选中
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //histan_NSLog(@"文本框编辑结束");
    UITextField *userNameField = (UITextField *)textField;
    if (userNameFiled.tag == 10) {
        userName=    userNameField.text;
       
        HISTANDataBaseContext *histanAccounts=[[HISTANDataBaseContext alloc]init];
        [self  showCurUserNameInfos:userName];
        [histanAccounts release];
         
    }else
    {
        //不做处理
    }
    
   
    
}



#pragma mark -- http请求
-(void)startSOAPrequest
{
    //服务器地址
    NSString *URL = appDelegate.WebSevicesURL;
    //调用的方法名
    NSString *wsFunctionLogin_IOS = API_User_Login_IOS;
    //命名空间
    NSString *nameSpace = xmlNameSpace;
    //参数数组
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"username",userName,@"pwd",UserPwd, nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:URL NameSpace:nameSpace webServiceFunctionName:wsFunctionLogin_IOS wsParameters:wsParas];
    ////histan_NSLog(@"发送的路径：%@",);
    
    //设置代理（使用block就不用代理）
    //[ASISOAPRequest setDelegate:self];
    
    //为了使代码更加简洁，使用代码块，而不是用回调方法
    //使用block就不用代理了
    [ASISOAPRequest setCompletionBlock:^{
        
        ////histan_NSLog(@"responsString-----------------%@",[ASISOAPRequest responseString]);
        
        //登陆成功后保存SID，跳转界面至主菜单
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        NSDictionary *retDict=[soapPacking getDicFromJsonString:returnString];
        //将字典中key为data的对象取出来
        NSDictionary *dataDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
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
            //            //histan_NSLog(@"%@",[retDict objectzForKey:@"data"]);
        }
        else //登陆成功，加载菜单
        {
            
            //记住密码
            NSString *IsRemindPassword=@"0";
            if (self.rememberPwdBtn.tag == 33) {
          
                IsRemindPassword=@"1";
                
            }
            HISTANDataBaseContext *histanAccount=[[HISTANDataBaseContext alloc]init];
            [histanAccount InsertOrUpdate_UserInfoByUserName:userName PassWord:userPwdFiled.text IsRemindPassWord:IsRemindPassword];
            
            //设置最后一次登陆的服务器路径
            [histanAccount ReSet_LastLoginServiceUrl:appDelegate.WebSevicesURL];
          
            //设置这次登陆用户
            [histanAccount ReSet_LastLoginUserName:userName];
            [histanAccount release];
            
            
            //保存用户名和sid
            appDelegate.UserName = [dataDic objectForKey:@"username"];;
            appDelegate.SID = [dataDic objectForKey:@"sid"];
            appDelegate.PValue= [dataDic objectForKey:@"p"];
            ////histan_NSLog(@"全局变量appDelegaate.SID的值：%@",appDelegate.SID);
            
            //获取菜单信息并储存
            //[self performSelector:@selector(getMenusArray)];
            //显示登陆成功字样
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
            HUD.labelText =@"登陆成功！";;
            [HUD hide:YES afterDelay:1];
            [self performSelector:@selector(gotoTheRootView) withObject:self afterDelay:0.8];
            
        }
        
        
    }];
    
    
    
    [ASISOAPRequest setFailedBlock:^{
        
        NSError *error = [ASISOAPRequest error];
        
        //histan_NSLog(@"登陆失败！ %@", [error localizedDescription]);
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText = @"登陆失败、请检查网络";
        [HUD hide:YES afterDelay:1.5];
        
    }];
    
    
    
    //同步
    //[ASISOAPRequest startSynchronous];
    //异步
    [ASISOAPRequest startAsynchronous];
    /*
     *{"error":0,"data":{"sid":"MxjHm OQvoJt\/oDDdJMU30qCMJG6AUS\/xxOzC WEO5YkRzfAxlow9w==","version":"1.3","p":"1688;5f6b576a4ddd1b0a4c0ecf6d8e473a10"}}
     */
    
    
}

-(void)gotoTheRootView{
    //跳转到主菜单
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark -- 获取菜单数组
-(void)getMenusArray
{
    
    //设置参数数组
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID, nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Menus wsParameters:wsParas];
    
    //为了使代码更加简洁，使用代码块，而不是用回调方法
    //使用block就不用代理了
    [ASISOAPRequest setCompletionBlock:^{
        
        ////histan_NSLog(@"responsString-----------------%@",[ASISOAPRequest responseString]);
        
        //获得返回的数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        //将字典中key为data的对象转化为数组（NSArray）
        //然后遍历这个数组，将数组中的每一个对象转化为字典类型，主要就是要用这些字典
        //也可以只要准备好data的数组，需要用数据的地方再用循环将data数组中的对象用字典提取出来）
        appDelegate.MenusArray = (NSArray *)[soapPacking getJsonDataDicWithJsonStirng:returnString];
        NSLog(@"release在登陆窗体中，跳转之前 appDelegate.MenusArray---%@",appDelegate.MenusArray);
        
        if (HUD!=nil) {
            //隐藏HUD
            [HUD removeFromSuperview];
        }
        
        //跳转到主菜单
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }];
    
    [ASISOAPRequest setFailedBlock:^{
        NSError *error = [ASISOAPRequest error];
        //histan_NSLog(@"获取菜单失败！ %@", [error localizedDescription]);
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText = @"获取菜单失败、请检查网络";
        [HUD hide:YES afterDelay:1.5];
        
    }];
    
    [ASISOAPRequest startAsynchronous];//开始异步请求
    
    
}


#pragma mark -- 获取服务器地址列表
-(void)getWebServicesURLs
{
    //histan_NSLog(@"加载：getWebServicesURLs ：%@",appDelegate.WebSevicesURL);
    if(appDelegate.WebSevicesURL ==nil || [appDelegate.WebSevicesURL isEqualToString:@""]){
        
    }else{
        
        //histan_NSLog(@"appDelegate.WebSevicesURL 已经存在了值不需要加载了！");
        [_timer invalidate];
        return;
    }
    
    if (jsnotify!=nil) {
        [jsnotify hide];
        jsnotify=nil;
        
        [jsnotify release];
    }
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    jsnotify = [[JSNotifier alloc]initWithTitle:@"正在获取服务器列表..."];
    jsnotify.accessoryView = activityIndicator;
    [jsnotify show];
    
    
    //设置参数数组
    //NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID, nil];
    
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASIHTTPRequest *ASISOAPRequest_GetWebServices = [soapPacking getASISOAPRequest:webURL_Host NameSpace:xmlNameSpace webServiceFunctionName:API_Get_Servers wsParameters:nil];
    
    //为了使代码更加简洁，使用代码块，而不是用回调方法
    //使用block就不用代理了
    [ASISOAPRequest_GetWebServices setCompletionBlock:^{
        
        //获得返回的数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest_GetWebServices responseString]];
        NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        //将字典中key为data的对象转化为数组（NSArray）
        //然后遍历这个数组，将数组中的每一个对象转化为字典类型，主要就是要用这些字典
        //也可以只要准备好data的数组，需要用数据的地方再用循环将data数组中的对象用字典提取出来）
        NSDictionary *retDict=(NSDictionary*)[soapPacking getDicFromJsonString:returnString];
        NSString *retError=[NSString stringWithFormat:@"%@",[retDict objectForKey:@"error"]];
        //histan_NSLog(@"retError:%@",retError);
        
        if([retError isEqualToString:@"1"])//有错误，显示错误信息
        {
            
            
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
            HUD.labelText = [retDict objectForKey:@"data"];
            [HUD hide:YES afterDelay:1.5];
            //            //histan_NSLog(@"%@",[retDict objectForKey:@"data"]);
            
            
        }
        else //获取成功
        {
            
            _WebServiceArray = (NSArray *)[retDict objectForKey:@"data"];
            int ci=0;
            for (NSDictionary *item in _WebServiceArray) {
                
                //默认加载第一个地址
                //改变当前系统的服务器路径
                NSDictionary *dict=(NSDictionary*)[_WebServiceArray objectAtIndex:0];
                _showServiceLabel.text=[NSString stringWithFormat:@"服务器：%@",[dict objectForKey:@"name"]];
                
                //赋值
                [self fuzhi:[dict objectForKey:@"address"]];
                
                //移除所有选中
                for(UIView *btn in _showDorpScrollView.subviews){
                    if ([btn isKindOfClass:[UIButton class]]) {
                        //移除该Button 下的 uiimage
                        for(UIView *img in btn.subviews){
                            if ([img isKindOfClass:[UIImageView class]]) {
                                //移除该Button 下的 uiimage
                                [img removeFromSuperview];
                            }
                        }
                        
                    }
                }

                
                
                // UIButton *addressbtn=[[UIButton buttonWithType:UIButtonTypeCustom]init];
                UIButton *addressbtn=[[UIButton alloc]initWithFrame:CGRectMake(5,ci*30+6, 175, 25)];
                addressbtn.frame=CGRectMake(5,ci*30+6, 175, 25);
                [addressbtn setTitle:[item objectForKey:@"name"] forState:UIControlStateNormal];
                [addressbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                addressbtn.titleLabel.textAlignment=UITextAlignmentRight;
                //addressbtn.backgroundColor=[UIColor blueColor];
                [addressbtn setBackgroundImage:[UIImage imageNamed:@"login_dropdown_bg"] forState:UIControlStateHighlighted];
                
                [addressbtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                addressbtn.titleLabel.font=[UIFont systemFontOfSize:14];
                [_showDorpScrollView addSubview:addressbtn];
                [addressbtn setTag:initTag+ci];
                
                //添加点击事件
                [addressbtn addTarget:self action:@selector(selectServices:) forControlEvents:UIControlEventTouchUpInside];
                
                HISTANDataBaseContext *histanData=[[HISTANDataBaseContext alloc]init];
                NSString *LastLoginServiceUrl=  [histanData  Get_LastLoginServiceUrl];
                [histanData release];
                if([LastLoginServiceUrl isEqualToString:@""] || LastLoginServiceUrl == nil || LastLoginServiceUrl ==NULL){
                    if(ci==0){
                        _showServiceLabel.text=[NSString stringWithFormat:@"服务器：%@",[item objectForKey:@"name"]];
                        [self fuzhi:[item objectForKey:@"address"]];
                        
                        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(150, 2.5, 20, 20)];
                        [img setImage:[UIImage imageNamed:@"btn_check_on_normal"]];
                        [addressbtn addSubview:img];
                        [img release];
                        
                    }
                }else{
                    NSString *uurrll=[NSString stringWithFormat:@"http://%@",[item objectForKey:@"address"]];
                    if([uurrll isEqualToString:LastLoginServiceUrl]){
                        _showServiceLabel.text=[NSString stringWithFormat:@"服务器：%@",[item objectForKey:@"name"]];
                        [self fuzhi:[item objectForKey:@"address"]];
                        
                        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(150, 2.5, 20, 20)];
                        [img setImage:[UIImage imageNamed:@"btn_check_on_normal"]];
                        [addressbtn addSubview:img];
                        [img release];
                        
                    }
                }
                
                
                
                ci++;
                //histan_NSLog(@"%@",item);
                ////histan_NSLog(@"%@:%@",[item objectForKey:@"name"],[item objectForKey:@"address"]);
                
            }
            
            [_WebServiceArray retain];
            //设置box内容高度
            _showDorpScrollView.contentSize=CGSizeMake(187, 36*ci);
            
            
            jsnotify.accessoryView=  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NotifyCheck"]];
            jsnotify.title=@"获取服务器列表成功！";
            [jsnotify hideIn:1];
            
        }
        
        
        
    }];
    
    [ASISOAPRequest_GetWebServices setFailedBlock:^{
        //histan_NSLog(@"[ASISOAPRequest_GetWebServices setFailedBlock==========");
        
        //        if (HUD==nil) {
        //            HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
        //        }
        NSLog(@"%@",[ASISOAPRequest_GetWebServices responseStatusMessage]);
        jsnotify.accessoryView=  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NotifyX"]];
        jsnotify.title=@"获取失败，请检查网络！";
        [jsnotify hideIn:1.5];
        
        //        HUD.mode = MBProgressHUDModeCustomView;
        //        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        //        HUD.labelText = @"获取服务器列表失败、请检查网络";
        //        [HUD hide:YES afterDelay:1.5];
        
    }];
    
    [ASISOAPRequest_GetWebServices startAsynchronous];//开始异步请求
    
    
}

-(void)fuzhi:(NSString *)address{
    
    //如果address 没有 http:// 则自动添加，如果有则不变
    if(![address hasPrefix:@"http://"]){
        address=[NSString stringWithFormat:@"http://%@",address];
    }
    //histan_NSLog(@"%@",address);
    
    
    appDelegate.WebSevicesURL=address;
}

#pragma mark -- 选择服务器按钮事件
-(void)selectServices:(UIButton*)sender{
    
    [self performSelector:@selector(hideAccountBox)];
    
    //改变当前系统的服务器路径
    int arrayIndex=sender.tag-initTag;
    NSDictionary *dict=(NSDictionary*)[_WebServiceArray objectAtIndex:arrayIndex];
    _showServiceLabel.text=[NSString stringWithFormat:@"服务器：%@",[dict objectForKey:@"name"]];
    
    //赋值
    [self fuzhi:[dict objectForKey:@"address"]];
    
    //移除所有选中
    for(UIView *btn in _showDorpScrollView.subviews){
        if ([btn isKindOfClass:[UIButton class]]) {
            //移除该Button 下的 uiimage
            for(UIView *img in btn.subviews){
                if ([img isKindOfClass:[UIImageView class]]) {
                    //移除该Button 下的 uiimage
                    [img removeFromSuperview];
                }
            }
            
        }
    }
    
    
    //改变选中状态
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(150, 2.5, 20, 20)];
    [img setImage:[UIImage imageNamed:@"btn_check_on_normal"]];
    [sender addSubview:img];
    [img release];
    
    
}

#pragma mark -- 记住密码选择按钮事件
- (IBAction)rememberPwdBtnClick:(id)sender {
    //改变按钮状态
    if (self.rememberPwdBtn.tag == 33) {
        
        //点击时为选中状态，将改变为未选中状态
        [self.rememberPwdBtn setTag:44];
        [self.rememberPwdBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_off"] forState:UIControlStateNormal];
    }
    else
    {
        //点击时为未选中状态，将改变为选中状态
        [self.rememberPwdBtn setTag:33];
        [self.rememberPwdBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_on"] forState:UIControlStateNormal];
    }
    
}

#pragma mark -- 登陆按钮点击事件
- (IBAction)loginBtnClick:(id)sender {
    
    //histan_NSLog(@"WebSevicesURL:%@",appDelegate.WebSevicesURL);
    if(appDelegate.WebSevicesURL==nil || [appDelegate.WebSevicesURL isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择服务器！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    //非法输入判断
    if ([self.userNameFiled.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    if ([self.userPwdFiled.text isEqualToString:@""] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    //输入无误后执行登陆操作
    
    //开始登陆操作
    //1,隐藏键盘
    [self.userNameFiled resignFirstResponder];
    [self.userPwdFiled resignFirstResponder];
    
    //2，获取输入的用户名和密码
    userName = self.userNameFiled.text;
    NSString *tempPwd = self.userPwdFiled.text;
    
    //密码用base64加密
    //先化为NSData类型
    NSData *pwdData = [tempPwd dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encryptPwd = [[NSString alloc] initWithData:[GTMBase64 encodeData:pwdData] encoding:NSUTF8StringEncoding];
    ////histan_NSLog(@"base64加密后的字符串：%@",encryptPwd);
    UserPwd = encryptPwd;
    
   
    
    //显示正在登陆HUD
    //方式1.直接在View上show
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
    
    //常用的设置
    //小矩形的背景色
    //        HUD.color = [UIColor blueColor];//这儿表示无背景
    //显示的文字
    HUD.labelText = @"登陆中...";
    //细节文字
    //HUD.detailsLabelText = @"Test detail";
    //是否有庶罩
    HUD.dimBackground = YES;
    //[HUD hide:YES afterDelay:2];
    
    
    //调用登录方法
    [self performSelector:@selector(startSOAPrequest)];
    
    //调用获取菜单方法API_Menus
    //[self performSelector:@selector(getmenus)];
    /*所获取的数据的样本
     {"error":0,"data":[{"needp":"0","menuid":"1","appname":"我的任务","link":"","apppic":"http://121.34.248.172:20130/general/ft_root/appset/image/cb53ac5e3d819e61.jpg"},{"needp":"0","menuid":"2","appname":"我的业务","link":"","apppic":"http://121.34.248.172:20130/general/ft_root/appset/image/b52587643e3ff1b8.jpg"},{"needp":"0","menuid":"3","appname":"信息快报","link":"","apppic":"http://121.34.248.172:20130/general/ft_root/appset/image/b1037c35be3cdc0f.jpg"},{"needp":"1","menuid":"11","appname":"销售报单","link":"http://121.34.248.172:20130/pda/sales/","apppic":"http://121.34.248.172:20130/general/ft_root/appset/image/c9d82976dce3ef75.jpg"}]}
     */
    
}

#define ANIMATION_DURATION 0.3f


-(void)showAccountBox
{
    
    
    [_showServiceBtn setSelected:YES];
    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(_showDorpUIView.center.x, _showDorpUIView.center.y)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(_showDorpUIView.center.x, _showDorpUIView.center.y+_account_box.frame.size.height)]];
    [move setDuration:ANIMATION_DURATION];
    [_showDorpUIView.layer addAnimation:move forKey:nil];
    
    
    [_account_box setHidden:NO];
    
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.2, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    CABasicAnimation *center=[CABasicAnimation animationWithKeyPath:@"position"];
    [center setFromValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y-_account_box.bounds.size.height/2)]];
    [center setToValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y)]];
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,center, nil]];
    [group setDuration:ANIMATION_DURATION];
    [_account_box.layer addAnimation:group forKey:nil];
    
    
    
    [_showDorpUIView setCenter:CGPointMake(_showDorpUIView.center.x, _showDorpUIView.center.y+_account_box.frame.size.height)];
    
}
-(void)hideAccountBox
{
    [_showServiceBtn setSelected:NO];
    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(_showDorpUIView.center.x, _showDorpUIView.center.y)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(_showDorpUIView.center.x, _showDorpUIView.center.y-_account_box.frame.size.height)]];
    [move setDuration:0.2];
    [_showDorpUIView.layer addAnimation:move forKey:nil];
    
    [_showDorpUIView setCenter:CGPointMake(_showDorpUIView.center.x, _showDorpUIView.center.y-_account_box.frame.size.height)];
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.2, 1.0)]];
    
    //  CABasicAnimation *center=[CABasicAnimation animationWithKeyPath:@"position"];
    //  [center setFromValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y)]];
    //  [center setToValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y-_account_box.bounds.size.height/2)]];
    
    // CAAnimationGroup *group=[CAAnimationGroup animation];
    // [group setAnimations:[NSArray arrayWithObjects:scale,center, nil]];
    // [group setDuration:ANIMATION_DURATION];
    // [_account_box.layer addAnimation:group forKey:nil];
    
    _account_box.hidden=YES;
    //  [_account_box performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.1];
}



-(void)showAccountBox_Account
{
    
    
    [_showAccountBtn setSelected:YES];
    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(_showDorpUIView_showAccount.center.x, _showDorpUIView_showAccount.center.y)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(_showDorpUIView_showAccount.center.x, _showDorpUIView_showAccount.center.y+_ShowAccount_box.frame.size.height)]];
    [move setDuration:ANIMATION_DURATION];
    [_showDorpUIView_showAccount.layer addAnimation:move forKey:nil];
    
    
    [_ShowAccount_box setHidden:NO];
    
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.2, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    CABasicAnimation *center=[CABasicAnimation animationWithKeyPath:@"position"];
    [center setFromValue:[NSValue valueWithCGPoint:CGPointMake(_ShowAccount_box.center.x, _ShowAccount_box.center.y-_account_box.bounds.size.height/2)]];
    [center setToValue:[NSValue valueWithCGPoint:CGPointMake(_ShowAccount_box.center.x, _ShowAccount_box.center.y)]];
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,center, nil]];
    [group setDuration:ANIMATION_DURATION];
    [_ShowAccount_box.layer addAnimation:group forKey:nil];
    
    
    
    [_showDorpUIView_showAccount setCenter:CGPointMake(_showDorpUIView_showAccount.center.x, _showDorpUIView_showAccount.center.y+_ShowAccount_box.frame.size.height)];
    
}
-(void)hideAccountBox_Account
{
    [_showAccountBtn setSelected:NO];
    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(_showDorpUIView_showAccount.center.x, _showDorpUIView_showAccount.center.y)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(_showDorpUIView_showAccount.center.x, _showDorpUIView_showAccount.center.y-_account_box.frame.size.height)]];
    [move setDuration:0.2];
    [_showDorpUIView_showAccount.layer addAnimation:move forKey:nil];
    
    [_showDorpUIView_showAccount setCenter:CGPointMake(_showDorpUIView_showAccount.center.x, _showDorpUIView_showAccount.center.y-_ShowAccount_box.frame.size.height)];
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.2, 1.0)]];
    
    //  CABasicAnimation *center=[CABasicAnimation animationWithKeyPath:@"position"];
    //  [center setFromValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y)]];
    //  [center setToValue:[NSValue valueWithCGPoint:CGPointMake(_account_box.center.x, _account_box.center.y-_account_box.bounds.size.height/2)]];
    
    // CAAnimationGroup *group=[CAAnimationGroup animation];
    // [group setAnimations:[NSArray arrayWithObjects:scale,center, nil]];
    // [group setDuration:ANIMATION_DURATION];
    // [_account_box.layer addAnimation:group forKey:nil];
    
    _ShowAccount_box.hidden=YES;
    //  [_account_box performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.1];
}

- (void)dealloc {
    
    //清除当前网络请求
    [ASISOAPRequest clearDelegatesAndCancel];
    [ASISOAPRequest release];
    
    //histan_NSLog(@"LoginView dealloc");
    
    [verLabel release];
    [userNameFiled release];
    [userPwdFiled release];
    [userNameLable release];
    [userPwdLabel release];
    [rememberPwdBtn release];
    [loginBtn release];
    [HUD release];
    [super release];
}
@end
