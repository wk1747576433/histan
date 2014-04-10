//
//  WuLiuCell.m
//  histan
//
//  Created by lyh on 1/25/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "WuLiuCell.h"

@implementation WuLiuCell

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

- (void)dealloc {
    [_numIdLabel release];
    [_codeIdLabel release];
    [_timeLabel release];
    [_nameLbel release];
    [_phoneLabel release];
    [_addressLabel release];
    [_timeBtn release];
    [_phoneLabel2 release];
    [_driverLabel release];
    [super dealloc];
}
@end
