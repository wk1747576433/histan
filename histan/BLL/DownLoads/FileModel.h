//
//  MusicModel.h
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface FileModel : NSObject {
    
}

@property (nonatomic)BOOL  IsFirstLoad;//是否是第一次从数据库加载出来的。
@property (nonatomic,retain)NSString*IsDownLoad;//是否下载完成。
@property(nonatomic,retain)NSString *fileImages;//图片路径
@property(nonatomic,retain)NSString *fileTitle;//标题
@property(nonatomic,retain)NSString *fileID;
@property(nonatomic,retain)NSString *fileName;//文件名
@property(nonatomic,retain)NSString *fileSize;
@property(nonatomic)BOOL isFistReceived;
//是否是第一次接受数据，如果是则不累加第一次返回的数据长度，之后变累加
@property(nonatomic,retain)NSString *fileReceivedSize;
@property(nonatomic,retain)NSMutableData *fileReceivedData;//接受的数据
@property(nonatomic,retain)NSString *fileURL;
@property(nonatomic)BOOL isDownloading;//是否正在下载
@property(nonatomic)BOOL isP2P;//是否是p2p下载



@end
