//
//  HLSOFTNAVPOPVIEWController.h
//  histan
//
//  Created by lyh on 1/8/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNPopupView.h"
#import "SNPopupView+UsingPrivateMethod.h"
#import "DownLoadsController.h"

@interface HLSOFTNAVPOPVIEWController : NSObject<SNPopupViewModalDelegate>
{
    UIView *showSubMenu;
    SNPopupView *popup;
    UIViewController *curUIView;
}
-(void)initHLNAV:(UIViewController*)curView;
@end
