//
//  ServicesDetailsSubCell.h
//  histan
//
//  Created by lyh on 1/27/14.
//  Copyright (c) 2014 histan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicesDetailsSubCell : UITableViewCell
//增加工单编号和物流状态
@property (retain, nonatomic) IBOutlet UILabel *Services_serId;
@property (retain, nonatomic) IBOutlet UILabel *sendState;

@property (nonatomic,retain) IBOutlet UILabel *Services_buyTime; //购买时间
@property (retain, nonatomic) IBOutlet UILabel *Services_buyWay; //购买途径

@property (retain, nonatomic) IBOutlet UILabel *Services_Maintenance;//是否保修

@property (nonatomic,retain) IBOutlet UILabel *Services_sertype; //服务项目
@property (nonatomic,retain) IBOutlet UILabel *Services_cinvstd;  //产品型号
@property (nonatomic,retain) IBOutlet UILabel *Services_description;  //现象与要求
@property (nonatomic,retain) IBOutlet UIButton *Services_SuccessBtn;  //成功
@property (nonatomic,retain) IBOutlet UIButton *Services_FailedBtn;  //失败
@property (nonatomic,retain) IBOutlet UIButton *Services_FailedResultSelectText; //失败理由
@property (nonatomic,retain) IBOutlet UIButton *Services_ChangeDate; //改约日期按钮
@property (nonatomic,retain) IBOutlet UILabel *Services_ChangeDateLabel; //改约日期标签
@property (nonatomic,retain) IBOutlet UIButton *Services_ChangeDateWhait; //改约日期
@property (nonatomic,retain) IBOutlet UILabel *Services_FailedReasonLabel; //失败理由文字
@property (nonatomic,retain) IBOutlet UILabel *Services_ResultLabel; //结果文字
@property (nonatomic,retain) IBOutlet UIButton *Services_CancelSelect; //取消选择
@property (retain, nonatomic) IBOutlet UITextField *reasonTextField;

@property (retain, nonatomic) IBOutlet UIButton *Services_ResetBtn; //修改按钮
 
@end
