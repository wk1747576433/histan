//
//  DownLoadsCell.m
//  ZNVAPP
//
//  Created by xiao wenping on 13-11-1.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import "DownLoadsCell.h"

@implementation DownLoadsCell

@synthesize down_Button=_down_Button;
@synthesize down_Img=_down_Img;
@synthesize down_Progress=_down_Progress;
@synthesize down_Schedule=_down_Schedule;
@synthesize down_State=_down_State;
@synthesize down_Title=_down_Title;
@synthesize down_openfile=_down_openfile;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
