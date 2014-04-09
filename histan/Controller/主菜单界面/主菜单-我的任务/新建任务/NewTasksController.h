//
//  NewTasksController.h
//  histan
//
//  Created by liu yonghua on 14-1-4.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
#import "selectFileViewController.h"
#import "JSNotifier.h"

@interface NewTasksController : UIViewController<UITextFieldDelegate,UIPopoverListViewDataSource,UIPopoverListViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UIDocumentInteractionControllerDelegate>
{
    
    HISTANAPPAppDelegate *appDelegate ;
    
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *topView;
    IBOutlet UIView *zoneView;
    IBOutlet UIView *bottomView;
    
    IBOutlet UIButton *deptNameBtn;
    IBOutlet UIButton *cityBtn;
    IBOutlet UIButton *areaBtn;
    IBOutlet UIButton *taskTypeBtn;
    IBOutlet UIButton *handerNameBtn;
    
    IBOutlet UILabel *appendixLabel;
    IBOutlet UILabel *dateShowLabel;
    IBOutlet UIButton *submitBtn;
    
    UITextView *textView;
    UITextField *taskNameFiled;
    
    //提示
    MBProgressHUD *HUD;//HUD层
    
    //日期选择器
    UIDatePicker *_datePicker;
    UIView *_maskView ;
    
    
}
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UITextField *taskNameFiled;

- (IBAction)selectBtnTaped:(id)sender;
- (IBAction)selectDateBtnTaped:(id)sender;
- (IBAction)PhotographBtnTaped:(id)sender;
- (IBAction)selectFromFileBtnTaped:(id)sender;
- (IBAction)submitBtnTaped:(id)sender;
//- (void)ViewAnimation:(UIView*)view willHidden:(BOOL)hidden;

@end
