//
//  WuLiuDetailsCell.h
//  histan
//
//  Created by lyh on 2/10/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WuLiuDetailsCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *indexLabel;//序号
@property (retain, nonatomic) IBOutlet UILabel *cInvStdLabel;//型号
@property (retain, nonatomic) IBOutlet UILabel *iQuantityLabel;//数量
@property (retain, nonatomic) IBOutlet UIButton *successBtn;//成功按钮
@property (retain, nonatomic) IBOutlet UIButton *failedBtn;//失败按钮
@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;//取消选择按钮
@property (retain, nonatomic) IBOutlet UIButton *failedResonBtn;//失败原因选择按钮
@property (retain, nonatomic) IBOutlet UIButton *retransDateBtn;//该送日期选择按钮
@property (retain, nonatomic) IBOutlet UIButton *waitingBtn;//待定按钮
@property (retain, nonatomic) IBOutlet UIView *bottomView;


@end
