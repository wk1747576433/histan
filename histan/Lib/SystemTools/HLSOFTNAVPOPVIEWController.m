//
//  HLSOFTNAVPOPVIEWController.m
//  histan
//
//  Created by lyh on 1/8/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "HLSOFTNAVPOPVIEWController.h"

@interface HLSOFTNAVPOPVIEWController ()

@end

@implementation HLSOFTNAVPOPVIEWController

-(void)didDismissModal:(SNPopupView *)popupview{
    //histan_NSLog(@"didDismissModal.....");
}

-(void)initHLNAV:(UIViewController *)curView{
    
    curUIView =curView;
    
    UIBarButtonItem *buttonImage = [ [ UIBarButtonItem alloc ] initWithImage:
                                    [ UIImage imageNamed: @"rightdownslide" ]
        style: UIBarButtonItemStylePlain
     target: self
      action: @selector(ShowSubMenuAction:)];
    buttonImage.tag=-54321;
    curView.navigationItem.rightBarButtonItem=buttonImage;
    
    
    showSubMenu=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 63)];
    
    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn1 setTitle:@"下载中心" forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btn_bluebg1"] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btn_bluebg"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(goDownLoadsCenter:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3=[[UIButton alloc]initWithFrame:CGRectMake(0,33 , 60,30)];
    [btn3 setTitle:@"首页" forState:UIControlStateNormal];
    [btn3.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    [btn3 setBackgroundImage:[UIImage imageNamed:@"btn_bluebg"] forState:UIControlStateHighlighted];
    [btn3 addTarget:self action:@selector(backIndexPage:) forControlEvents:UIControlEventTouchUpInside];
    
    [showSubMenu addSubview:btn1];
    [showSubMenu addSubview:btn3];
    
    //[self.view addSubview:showSubMenu];
    
    
    //注册一个隐藏键盘的方法
    //UITapGestureRecognizer *_myTapGr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTppedHideKeyBorad:)];
    //_myTapGr.cancelsTouchesInView=NO;
    //[curView.view addGestureRecognizer:_myTapGr];

}
 

//点击空白处隐藏键盘
-(void)viewTppedHideKeyBorad:(UITapGestureRecognizer*)tapGr{
    if (popup != nil) {
        [popup dismiss:YES];
        popup = nil;
    }
}

//自定义返回上一页事件
-(void)leftbackprepagebutton:(id)sender{
     //histan_NSLog(@"leftbackprepagebutton");
    [curUIView.navigationController popViewControllerAnimated:YES];
}

-(void)backIndexPage:(id)send{
    if (popup != nil) {
        [popup dismiss:YES];
        popup = nil;
    }
    
    [curUIView.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)goDownLoadsCenter:(id)sender{
    if (popup != nil) {
        [popup dismiss:YES];
        popup = nil;
    }
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [curUIView.navigationItem setBackBarButtonItem:backBtn];
 
    DownLoadsController *downloadc=[[DownLoadsController alloc]init];
    [curUIView.navigationController pushViewController:downloadc animated:YES];
    [downloadc release];
    
    
}

-(void)ShowSubMenuAction:(UIBarButtonItem*)sender{

    if (popup == nil) {
        popup = [[SNPopupView alloc] initWithContentView:showSubMenu contentSize:CGSizeMake(60, 63)];
        [popup showFromBarButtonItem:sender inView:curUIView.view animated:YES];
       // [popup addTarget:self action:@selector(didTouchPopupView:)];
		[popup release];
		[popup setDelegate:self];
         
        sender.image=[ UIImage imageNamed: @"rightdownslide_2" ];
        
	}else{
        
        sender.image=[ UIImage imageNamed: @"rightdownslide" ];
         
        [popup dismiss:YES];
        popup = nil;
    }
    
}
 

 
@end
