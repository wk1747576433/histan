//
//  WuLiuDetailsCell.m
//  histan
//
//  Created by lyh on 2/10/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "WuLiuDetailsCell.h"

@implementation WuLiuDetailsCell

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
    [_indexLabel release];
    [_cInvStdLabel release];
    [_iQuantityLabel release];
    [_successBtn release];
    [_failedBtn release];
    [_cancelBtn release];
    [_failedResonBtn release];
    [_retransDateBtn release];
    [_waitingBtn release];
    [_bottomView release];
    [super dealloc];
}
@end
