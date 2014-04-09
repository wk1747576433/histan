//
//  publishDitealCell.m
//  histan
//
//  Created by lyh on 1/21/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "publishDitealCell.h"

@implementation publishDitealCell
@synthesize idLabel =_idLabel;
@synthesize nameLabel = _nameLabel;
@synthesize publisherLabel = _publisherLabel;
@synthesize publishTimeLabel = _publishTimeLabel;
@synthesize statusLabel = _statusLabel;

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
    [_idLabel release];
    [_nameLabel release];
    [_statusLabel release];
    [_publisherLabel release];
    [_publishTimeLabel release];
    [super dealloc];
}
@end
