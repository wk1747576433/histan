//
//  IDealTaskTableViewCell.h
//  histan
//
//  Created by liu yonghua on 14-1-9.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDealTaskTableViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *TaskNumber;
@property (nonatomic,retain) IBOutlet UILabel *TaskName;
@property (nonatomic,retain) IBOutlet UILabel *TaskSubmiter;
@property (nonatomic,retain) IBOutlet UILabel *TaskSubmitDate;

@end
