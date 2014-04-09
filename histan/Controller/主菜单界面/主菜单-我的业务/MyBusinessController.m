//
//  MyBusinessController.m
//  histan
//
//  Created by liu yonghua on 13-12-30.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import "MyBusinessController.h"

@implementation MyBusinessController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //加入导航右侧返回首页和下载中心按钮【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    HISTANAPPAppDelegate *appDelegate = HISTANdelegate;

    self.navigationItem.title= appDelegate.CurPageTitile;
    
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 300, 100)];
    lbl.font=[UIFont systemFontOfSize:18];
    lbl.text=@"建设中...";
    lbl.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:lbl];
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
