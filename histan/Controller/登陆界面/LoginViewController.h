//
//  LoginViewController.h
//  histan
//
//  Created by liu yonghua on 13-12-27.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HISTANAPPAppDelegate.h"
#import "GTMBase64.h"
#import "ASIFormDataRequest.h"
#import "ASIHttpSoapPacking.h"
#import "MBProgressHUD.h"
#import "SFHFKeychainUtils.h"
#import "HISTANAPPViewController.h"
#import "MBProgressHUD.h"
#import "JSNotifier.h"
#import "HISTANDataBaseContext.h"


@interface LoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    HISTANAPPAppDelegate *appDelegate;
    JSNotifier *jsnotify;
    
    //暂存用户名和密码
    NSString *userName;
    NSString *UserPwd;
    MBProgressHUD *HUD;//HUD层
    
    UILabel *verLabel;
    UILabel *userNameLable;
    UILabel *userPwdLabel;
    UIButton *rememberPwdBtn;
    UITextField *userNameFiled;
    UITextField *userPwdFiled;
    UIButton *loginBtn;
    UIButton *loginBtnClick;
    
    ASIHTTPRequest *ASISOAPRequest;
    UIScrollView *_showDorpScrollView;
    NSArray *_WebServiceArray;
    
    UIScrollView *_showDorpScrollView_showAccount; //显示用户名的下拉集合
    
    NSTimer *_timer;
    
    NSString *deleteUserName; //删除的用户
}
@property (retain, nonatomic) IBOutlet UIButton *remindPassWordBtn;
@property (retain, nonatomic) IBOutlet UILabel *verLabel;
@property (retain, nonatomic) IBOutlet UILabel *userNameLable;
@property (retain, nonatomic) IBOutlet UILabel *userPwdLabel;
@property (retain, nonatomic) IBOutlet UIButton *rememberPwdBtn;
@property (retain, nonatomic) IBOutlet UITextField *userNameFiled;
@property (retain, nonatomic) IBOutlet UITextField *userPwdFiled;
@property (retain, nonatomic) IBOutlet UIButton *loginBtn;

@property (retain, nonatomic) IBOutlet UIButton *showServiceBtn;
@property (retain, nonatomic) IBOutlet UILabel *showServiceLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *showServiceScrollView;
@property (retain, nonatomic) IBOutlet UIView *showDorpUIView;
@property (retain, nonatomic) IBOutlet UIImageView *account_box;

@property (retain, nonatomic) IBOutlet UIView *showDorpUIView_showAccount;
@property (retain, nonatomic) IBOutlet UIButton *showAccountBtn; //显示记录的登陆用户名
@property (retain, nonatomic) IBOutlet UIImageView *ShowAccount_box; //显示北京图片


- (IBAction)rememberPwdBtnClick:(id)sender;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction)dropDown:(id)sender;
- (IBAction)dropDown_Account:(id)sender ;
-(void)getWebServicesURLs;
-(void)fuzhi:(NSString*)address;

-(void)showCurUserNameInfos:(NSString*)UserName;
-(void)selectAccount:(UIButton*)sender;

@end
