//
//  ChangPassWordViewController.m
//  histan
//
//  Created by lyh on 1/6/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "ChangPassWordViewController.h"

@interface ChangPassWordViewController ()

@end

@implementation ChangPassWordViewController

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
    //页面标题
    self.title=@"修改密码";
    
    //设置背景图片
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];
    [bgImgView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgImgView.userInteractionEnabled=YES; //启用可响应事件
    [self.view addSubview:bgImgView];
    
    
    //添加按钮，文本框
    oldPassLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 70, 25)];
    oldPassLbl.font=[UIFont systemFontOfSize:16];
    oldPassLbl.backgroundColor=[UIColor clearColor];
    oldPassLbl.text=@"旧密码：";
    
    newPassLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, 70, 70, 25)];
    newPassLbl.font=[UIFont systemFontOfSize:16];
    newPassLbl.backgroundColor=[UIColor clearColor];
    newPassLbl.text=@"新密码：";
    
    
    oldPassTxt=[[UITextField alloc]initWithFrame:CGRectMake(80, 10, 220, 40)];
    oldPassTxt.background=[UIImage imageNamed:@"loginLable_bg"];
    oldPassTxt.borderStyle=UITextBorderStyleRoundedRect;
    oldPassTxt.secureTextEntry=YES;
    oldPassTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
    
    newPassTxt=[[UITextField alloc]initWithFrame:CGRectMake(80, 65, 220, 40)];
    newPassTxt.background=[UIImage imageNamed:@"loginLable_bg"];
    newPassTxt.borderStyle=UITextBorderStyleRoundedRect;
    newPassTxt.secureTextEntry=YES;
    newPassTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
    [self.view addSubview:newPassTxt];
    [self.view addSubview:oldPassTxt];
    [self.view addSubview:oldPassLbl];
    [self.view addSubview:newPassLbl];
    
    //注册一个隐藏键盘的方法
    UITapGestureRecognizer *_myTapGr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTppedHideKeyBorad:)];
    _myTapGr.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:_myTapGr];
}

//点击空白处隐藏键盘
-(void)viewTppedHideKeyBorad:(UITapGestureRecognizer*)tapGr{
    [newPassTxt resignFirstResponder];
    [oldPassTxt resignFirstResponder];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
