//
//  DownLoadsCell.h
//  ZNVAPP
//
//  Created by xiao wenping on 13-11-1.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadsCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UIImageView *down_Img;
@property (nonatomic,retain) IBOutlet UILabel *down_Title;
@property (nonatomic,retain) IBOutlet UILabel *down_Schedule;
@property (nonatomic,retain) IBOutlet UILabel *down_State;
@property (nonatomic,retain) IBOutlet UIButton *down_Button;
@property (nonatomic,retain) IBOutlet UIProgressView *down_Progress;
@property (nonatomic,retain) IBOutlet UIButton *down_openfile;


@end
