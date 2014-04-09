//
//  IDealTaskTableViewCell.m
//  histan
//
//  Created by liu yonghua on 14-1-9.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import "IDealTaskTableViewCell.h"


@implementation IDealTaskTableViewCell

@synthesize TaskName=_TaskName;
@synthesize TaskNumber=_TaskNumber;
@synthesize TaskSubmiter=_TaskSubmiter;
@synthesize TaskSubmitDate=_TaskSubmitDate;

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
