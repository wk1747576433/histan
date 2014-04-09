//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"

@interface SVModalWebViewController ()

@property (nonatomic, strong) SVWebViewController *webViewController;

@end


@implementation SVModalWebViewController

@synthesize barsTintColor, availableActions, webViewController;

#pragma mark - Initialization


- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    
 
    self.webViewController =  [[SVWebViewController alloc] initWithURL:URL];
    if (self = [super initWithRootViewController:self.webViewController]) {
       // self.webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonClicked:)];
        
       // [self.webViewController.navigationItem.leftBarButtonItem setTitle:@"adf"];
       // [self.navigationItem.leftBarButtonItem setTitle:@"a"];

//znv项目配置
        //加入自定义的返回按钮
//        UIBarButtonItem *curleftbackbutton=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
//        //重写返回按钮
//        
//        UIButton  *leftbackbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
//        [leftbackbutton setTitle:@"首页" forState:UIControlStateNormal];
//        [leftbackbutton setBackgroundImage:[UIImage imageNamed:@"leftback_bg"] forState:UIControlStateNormal];
//        [leftbackbutton setBackgroundImage:[UIImage imageNamed:@"left_back_bg_2"] forState:UIControlStateHighlighted];
//        [leftbackbutton setTag:-1];
//        [leftbackbutton addTarget:self action:@selector(leftbackprepagebutton:) forControlEvents:UIControlEventTouchUpInside];
//        leftbackbutton.titleLabel.font=[UIFont boldSystemFontOfSize:12];
//        leftbackbutton.titleLabel.shadowColor=[UIColor blackColor];
//        leftbackbutton.titleLabel.shadowOffset= CGSizeMake(0, 1) ;
//        leftbackbutton.titleLabel.textAlignment=UITextAlignmentCenter;
//        [curleftbackbutton setCustomView:leftbackbutton];
//        [leftbackbutton release];
//        self.webViewController.navigationItem.leftBarButtonItem =curleftbackbutton;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.navigationBar.tintColor = self.toolbar.tintColor = self.barsTintColor;
}

- (void)setAvailableActions:(SVWebViewControllerAvailableActions)newAvailableActions {
    self.webViewController.availableActions = newAvailableActions;
}

@end
