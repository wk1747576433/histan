//
//  ServicesListCell.h
//  histan
//
//  Created by lyh on 1/26/14.
//  Copyright (c) 2014 histan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicesListCell : UITableViewCell
{
    
}

@property (nonatomic,retain) IBOutlet UILabel *Services_CustomerName;
@property (nonatomic,retain) IBOutlet UILabel *Services_MobiePhone;
@property (nonatomic,retain) IBOutlet UILabel *Services_Phone;
@property (nonatomic,retain) IBOutlet UILabel *Services_Address;
//记录当前显示列表对象的诉求id，方便修改时间段操作,隐藏
@property (retain, nonatomic) IBOutlet UILabel *reqidLabel;

@property (retain, nonatomic) IBOutlet UIButton *Services_selectTimeBtn;
@end
