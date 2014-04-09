//
//  ChangPassWordViewController.h
//  histan
//
//  Created by lyh on 1/6/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangPassWordViewController : UIViewController
{
    UIButton *submitBtn; //提交按钮
    UILabel *oldPassLbl;//旧密码
    UILabel *newPassLbl;//新密码
    UITextField *oldPassTxt; //旧密码文本框
    UITextField *newPassTxt; //新密码文本框
}
@end
