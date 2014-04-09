//
//  PublicDownLoadsBLL.h
//  histan
//
//  Created by liu yonghua on 14-1-22.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import "FileModel.h"
#import "ALToastView.h"
#import "HISTANAPPAppDelegate.h"
#import "FileModel.h"

@interface PublicDownLoadsBLL : NSObject

-(NSMutableArray*)GetDownLOadFinishedListArrary;
//开始下载的方法
-(NSString*)DownLoadAction:(NSString *)fileName url:(NSString *)url fileSize:(NSString*)fileSize  fileID:(NSString*)fileID;

-(void)DeleteDownLoadFile_FileName:(NSString*)fileName;

@end
