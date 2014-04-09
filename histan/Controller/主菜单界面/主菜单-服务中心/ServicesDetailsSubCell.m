//
//  ServicesDetailsSubCell.m
//  histan
//
//  Created by lyh on 1/27/14.
//  Copyright (c) 2014 histan. All rights reserved.
//

#import "ServicesDetailsSubCell.h"

@implementation ServicesDetailsSubCell

@synthesize Services_cinvstd=_Services_cinvstd;
@synthesize Services_description=_Services_description;
@synthesize Services_buyTime=_Services_buyTime;
@synthesize Services_sertype=_Services_sertype;
@synthesize Services_FailedBtn=_Services_FailedBtn;
@synthesize Services_FailedResultSelectText=_Services_FailedResultSelectText;
@synthesize Services_SuccessBtn=_Services_SuccessBtn;
@synthesize Services_FailedReasonLabel=_Services_FailedReasonLabel;
@synthesize Services_ResultLabel=_Services_ResultLabel;
@synthesize Services_ChangeDate=_Services_ChangeDate;
@synthesize Services_ChangeDateWhait=_Services_ChangeDateWhait;
@synthesize Services_CancelSelect=_Services_CancelSelect;
@synthesize Services_ChangeDateLabel=_Services_ChangeDateLabel;
@synthesize Services_buyWay = _Services_buyWay;
@synthesize Services_Maintenance = _Services_Maintenance;

@synthesize Services_ResetBtn=_Services_ResetBtn;
 
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
    [_reasonTextField release];
    [_Services_serId release];
    [_sendState release];
    [_Services_buyWay release];
    [_Services_Maintenance release];
    [super dealloc];
}
@end
