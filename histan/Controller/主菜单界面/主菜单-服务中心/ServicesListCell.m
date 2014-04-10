//
//  ServicesListCell.m
//  histan
//
//  Created by lyh on 1/26/14.
//  Copyright (c) 2014 histan. All rights reserved.
//

#import "ServicesListCell.h"

@implementation ServicesListCell

@synthesize Services_Address=_Services_Address;
@synthesize Services_CustomerName=_Services_CustomerName;
@synthesize Services_MobiePhone=_Services_MobiePhone;
@synthesize Services_Phone=_Services_Phone;
@synthesize Services_selectTimeBtn = _Services_selectTimeBtn;

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
    [_reqidLabel release];
    [_handlerLabel release];
    [super dealloc];
}
@end
