//
//  HLSOFTThread.m
//  histan
//
//  Created by liu yonghua on 14-1-11.
//  Copyright (c) 2014年 Ongo. All rights reserved.
//

#import "HLSOFTThread.h"

@implementation HLSOFTThread

static HLSOFTThread *defaultCacher=nil;
-(id)init
{
    if (defaultCacher) {
        return defaultCacher;
    }else
    {
        self =[super init];
        return self;
    }
}

+(HLSOFTThread*)defaultCacher
{
    if (!defaultCacher) {
        
        defaultCacher=[[super allocWithZone:nil]init];
    }
    return defaultCacher;
    
}

+ (id)allocWithZone:(NSZone *)zone
{
    
    return [self defaultCacher];
}


-(void)LoadIDealTaskCountShowBadge:(NSDictionary *)aDic{
    
    @try {
        
        
        
        UIView *view=[aDic objectForKey:@"view1"];
        NSString *StatisticsType=[aDic objectForKey:@"StatisticsType"];
        NSString *MenuId=[aDic objectForKey:@"MenuId"];
        if (view!=nil) {
            
            //参数数组
            HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
            
            //初始化参数数组（必须是可变数组）
            NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
            
            //实例化OSAPHTTP类
            ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
            //获得OSAPHTTP请求
            ASIHTTPRequest  *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Get_Statistics wsParameters:wsParas];
            [ASISOAPRequest retain];
            ASISOAPRequest.delegate=self;
            [ASISOAPRequest setTimeOutSeconds:120];//超时秒数
            [ASISOAPRequest startSynchronous];
            
            
            NSError *error = [ASISOAPRequest error];
            
            if (!error) {
                
                //histan_NSLog(@"加载数量成功！accok");
                
                //获取返回的json数据
                NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
                ////histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
                
                //获取data字典
                NSDictionary *statusDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
                //得到‘我处理的任务’和‘我提交的任务’状态数组
                
                //histan_NSLog(@"StatusArray:%@,StatisticsType:%@,MenuId:%@",statusDic,StatisticsType,MenuId);
                
                NSArray *StatusArray= [statusDic objectForKey:StatisticsType];
                
                
                [ASISOAPRequest clearDelegatesAndCancel];
                [ASISOAPRequest release];
                
                
                NSString *showBadge=@"0";
                if([MenuId isEqualToString:@"1"]){
                    showBadge=[StatusArray objectAtIndex:0];
                }
                //else if([MenuId isEqualToString:@"2"]){
                //                showBadge=[StatusArray objectAtIndex:1];
                //            }
                
                if([showBadge isEqualToString:@"0"]){
                    UIImageView *imgview=(UIImageView*)view;
                    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:imgview alignment:JSBadgeViewAlignmentTopRight];
                    [badgeView removeFromSuperview];
                }else{
                    
                    UIImageView *imgview=(UIImageView*)view;
                    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:imgview alignment:JSBadgeViewAlignmentTopRight];
                    badgeView.badgeText =  showBadge;
                }
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

//加载未读信息快报
-(void)LoadNoticeReadCountShowBadge:(NSDictionary *)aDic{
    
    @try {
        
        
        UIView *view=[aDic objectForKey:@"view1"];
        if (view!=nil) {
            
            //参数数组
            HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
            
            //初始化参数数组（必须是可变数组）
            NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
            
            //实例化OSAPHTTP类
            ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
            //获得OSAPHTTP请求
            ASIHTTPRequest  *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Notices_Read wsParameters:wsParas];
            [ASISOAPRequest retain];
            ASISOAPRequest.delegate=self;
            [ASISOAPRequest setTimeOutSeconds:120];//超时秒数
            [ASISOAPRequest startSynchronous];
            
            
            NSError *error = [ASISOAPRequest error];
            
            if (!error) {
                
                //histan_NSLog(@"加载数量成功！accok");
                
                //获取返回的json数据
                NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
                // //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
                
                //获取data字典
                NSDictionary *statusDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
                int allcount=0;
                for (NSDictionary *item in statusDic) {
                    allcount+=[[item objectForKey:@"num"] intValue];
                }
                
                //histan_NSLog(@"allcount:%d === %@",allcount,statusDic);
                
                [ASISOAPRequest clearDelegatesAndCancel];
                [ASISOAPRequest release];
                
                if(allcount==0){
                    UIImageView *imgview=(UIImageView*)view;
                    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:imgview alignment:JSBadgeViewAlignmentTopRight];
                    [badgeView removeFromSuperview];
                }else{
                    
                    UIImageView *imgview=(UIImageView*)view;
                    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:imgview alignment:JSBadgeViewAlignmentTopRight];
                    badgeView.badgeText =  [NSString stringWithFormat:@"%d",allcount];
                }
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}



-(void)LoadServiceCountShowBadge:(NSDictionary *)aDic{
    
    @try {
        
        UIView *view=[aDic objectForKey:@"view1"];
        // NSString *StatisticsType=[aDic objectForKey:@"StatisticsType"];
        NSString *MenuId=[aDic objectForKey:@"MenuId"];
        if (view!=nil) {
            
            //参数数组
            HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
            
            NSDate *nowDate = [NSDate date];
            NSString *curdate=[NSString stringWithFormat:@"%d",(int)[nowDate timeIntervalSince1970]];
            //初始化参数数组（必须是可变数组）
            NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"dDate",curdate,nil];
            
            //实例化OSAPHTTP类
            ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
            //获得OSAPHTTP请求
            ASIHTTPRequest  *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Service_List_Status_Count wsParameters:wsParas];
            [ASISOAPRequest retain];
            ASISOAPRequest.delegate=self;
            [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
            [ASISOAPRequest startSynchronous];
            
            
            
            NSError *error = [ASISOAPRequest error];
            
            if (!error) {
                
                //histan_NSLog(@"加载数量成功！accok");
                
                //获取返回的json数据
                NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
                ////histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
                
                //获取data字典
                NSDictionary *statusDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
                //histan_NSLog(@"statusDic:%@",statusDic);
                //NSArray *StatusArray= [statusDic objectForKey:StatisticsType];
                
                [ASISOAPRequest clearDelegatesAndCancel];
                [ASISOAPRequest release];
                //NSLog(@"%@",statusDic);
                for(NSDictionary *item in statusDic){
                    
                    //服务状态 1完成 0失败 2未服务
                    int flag=[[item objectForKey:@"flag"]intValue];
                    if(flag==2){
                        
                        NSString *showBadge=@"0";
                        if([MenuId isEqualToString:@"19"]){
                            showBadge=[NSString stringWithFormat:@"%@",[item objectForKey:@"flagNum"]];
                        }
                        
                        if([showBadge isEqualToString:@"0"]){
                            UIImageView *imgview=(UIImageView*)view;
                            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:imgview alignment:JSBadgeViewAlignmentTopRight];
                            [badgeView removeFromSuperview];
                        }else{
                            
                            UIImageView *imgview=(UIImageView*)view;
                            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:imgview alignment:JSBadgeViewAlignmentTopRight];
                            badgeView.badgeText =  showBadge;
                        }
                        break;
                        
                    }
                    
                }
                
                
            }
            
            
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


//加载物流中心今天的未完成的数量
-(void)LoadLogisticsCountShowBadge:(NSDictionary *)aDic{
    
    @try {
        
        UIView *view=[aDic objectForKey:@"view1"];
        // NSString *StatisticsType=[aDic objectForKey:@"StatisticsType"];
        NSString *MenuId=[aDic objectForKey:@"MenuId"];
        if (view!=nil) {
            
            //参数数组
            HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
            
            NSDate *nowDate = [NSDate date];
            NSString *curdate=[NSString stringWithFormat:@"%d",(int)[nowDate timeIntervalSince1970]];
            //初始化参数数组（必须是可变数组）
            NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"dDate",curdate,nil];
            
            //实例化OSAPHTTP类
            ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
            //获得OSAPHTTP请求
            ASIHTTPRequest  *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Outbound_List_Status_Count wsParameters:wsParas];
            [ASISOAPRequest retain];
            ASISOAPRequest.delegate=self;
            [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
            [ASISOAPRequest startSynchronous];
            
            
            
            NSError *error = [ASISOAPRequest error];
            
            if (!error) {
                
                //histan_NSLog(@"加载数量成功！accok");
                
                //获取返回的json数据
                NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
                ////histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
                
                //获取data字典
                NSDictionary *statusDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
                //histan_NSLog(@"statusDic:%@",statusDic);
                //NSArray *StatusArray= [statusDic objectForKey:StatisticsType];
                
                [ASISOAPRequest clearDelegatesAndCancel];
                [ASISOAPRequest release];
                //NSLog(@"%@",statusDic);
                
                
                
                for(NSDictionary *item in statusDic){
                    NSString *statusStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"status"]];
                    if([statusStr isEqualToString:@"1"]){
                        
                        
                        NSString *statusNumStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"statusNum"]];
                        
                        NSString *showBadge=@"0";
                        if([MenuId isEqualToString:@"18"]){
                            showBadge=statusNumStr;
                        }
                        
                        if([showBadge isEqualToString:@"0"]){
                            UIImageView *imgview=(UIImageView*)view;
                            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:imgview alignment:JSBadgeViewAlignmentTopRight];
                            [badgeView removeFromSuperview];
                        }else{
                            
                            UIImageView *imgview=(UIImageView*)view;
                            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:imgview alignment:JSBadgeViewAlignmentTopRight];
                            badgeView.badgeText =  showBadge;
                        }
                        break;
                        
                        
                    }
                    
                }
                
                
            }
            
            
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


-(void)LoadHnadOrSubmitStatistics:(NSDictionary *)aDic{
    
    
    @try {
        
        
        UIView *view1=[aDic objectForKey:@"button1"];
        UIView *view2=[aDic objectForKey:@"button2"];
        UIView *view3=[aDic objectForKey:@"button3"];
        
        
        //参数数组
        HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        
        //初始化参数数组（必须是可变数组）
        NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
        
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASIHTTPRequest  *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Get_Statistics wsParameters:wsParas];
        [ASISOAPRequest retain];
        ASISOAPRequest.delegate=self;
        [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
        [ASISOAPRequest startSynchronous];
        
        
        
        NSError *error = [ASISOAPRequest error];
        
        if (!error) {
            
            //histan_NSLog(@"加载数量成功！accok");
            
            //获取返回的json数据
            NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
            ////histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
            
            //获取data字典
            NSDictionary *statusDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
            //得到‘我处理的任务’和‘我提交的任务’状态数组
            NSString *StatisticsType=[aDic objectForKey:@"StatisticsType"];
            
            NSArray *StatusArray= [statusDic objectForKey:StatisticsType];
            
            
            [ASISOAPRequest clearDelegatesAndCancel];
            [ASISOAPRequest release];
            
            
            //判断view是否还存在
            if (view1!=nil)
            {
                UIButton *showButton1=(UIButton*)view1; //需要显示文字的按钮1
                NSArray *textArray = [showButton1.titleLabel.text componentsSeparatedByString:@"("];
                NSString *newTitle=[[textArray objectAtIndex:0] stringByAppendingFormat:@"(%@)",[StatusArray objectAtIndex:0]];
                [showButton1 setTitle:newTitle forState:UIControlStateNormal];
                 
            }
            
            if (view2!=nil)
            {
                UIButton *showButton2=(UIButton*)view2; //需要显示文字的按钮1
                NSArray *textArray = [showButton2.titleLabel.text componentsSeparatedByString:@"("];
                NSString *newTitle=[[textArray objectAtIndex:0] stringByAppendingFormat:@"(%@)",[StatusArray objectAtIndex:1]];
                [showButton2 setTitle:newTitle forState:UIControlStateNormal];
                
            }
            
            if (view3!=nil)
            {
                UIButton *showButton3=(UIButton*)view3; //需要显示文字的按钮1
                NSArray *textArray = [showButton3.titleLabel.text componentsSeparatedByString:@"("];
                NSString *newTitle=[[textArray objectAtIndex:0] stringByAppendingFormat:@"(%@)",[StatusArray objectAtIndex:2]];
                [showButton3 setTitle:newTitle forState:UIControlStateNormal];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


//按日期获取服务统计
-(void)LoadService_List_Status_Count:(NSDictionary *)aDic{
    
    
    @try {
        
        
        UIView *view1=[aDic objectForKey:@"button1"];
        UIView *view2=[aDic objectForKey:@"button2"];
        UIView *view3=[aDic objectForKey:@"button3"];
        
        
        //参数数组
        HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        
        //初始化参数数组（必须是可变数组）
        NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"dDate",[aDic objectForKey:@"dDate"],nil];
        
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASIHTTPRequest  *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Service_List_Status_Count wsParameters:wsParas];
        [ASISOAPRequest retain];
        ASISOAPRequest.delegate=self;
        [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
        [ASISOAPRequest startSynchronous];
        
        
        
        NSError *error = [ASISOAPRequest error];
        
        if (!error) {
            
            //histan_NSLog(@"加载数量成功！accok");
            
            //获取返回的json数据
            NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
            ////histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
            
            //获取data字典
            NSDictionary *statusDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
            //histan_NSLog(@"statusDic:%@",statusDic);
            //NSArray *StatusArray= [statusDic objectForKey:StatisticsType];
            
            [ASISOAPRequest clearDelegatesAndCancel];
            [ASISOAPRequest release];
            
            for(NSDictionary *item in statusDic){
                
                //服务状态 1完成 0失败 2未服务
                int flag=[[item objectForKey:@"flag"]intValue];
                if(flag==0){
                    if (view3!=nil)
                    {
                        UIButton *showButton3=(UIButton*)view3; //需要显示文字的按钮1
                        NSArray *textArray = [showButton3.titleLabel.text componentsSeparatedByString:@"("];
                        NSString *newTitle=[[textArray objectAtIndex:0] stringByAppendingFormat:@"(%@)",[item objectForKey:@"flagNum"]];
                        [showButton3 setTitle:newTitle forState:UIControlStateNormal];
                    }
                }else if(flag==1){
                    if (view2!=nil)
                    {
                        UIButton *showButton2=(UIButton*)view2; //需要显示文字的按钮1
                        NSArray *textArray = [showButton2.titleLabel.text componentsSeparatedByString:@"("];
                        NSString *newTitle=[[textArray objectAtIndex:0] stringByAppendingFormat:@"(%@)",[item objectForKey:@"flagNum"]];
                        [showButton2 setTitle:newTitle forState:UIControlStateNormal];
                        
                    }
                }else if(flag==2){
                    
                    if (view1!=nil)
                    {
                        UIButton *showButton1=(UIButton*)view1; //需要显示文字的按钮1
                        NSArray *textArray = [showButton1.titleLabel.text componentsSeparatedByString:@"("];
                        NSString *newTitle=[[textArray objectAtIndex:0] stringByAppendingFormat:@"(%@)",[item objectForKey:@"flagNum"]];
                        [showButton1 setTitle:newTitle forState:UIControlStateNormal];
                        
                    }
                }
                
            }
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}



//按日期获取服务统计
-(void)LoadLogisticsCenter_Status_Count:(NSDictionary *)aDic{
    
    @try {
        
        
        
        
        UIView *view1=[aDic objectForKey:@"button1"];
        UIView *view2=[aDic objectForKey:@"button2"];
        UIView *view3=[aDic objectForKey:@"button3"];
        
        
        //参数数组
        HISTANAPPAppDelegate *appDelegate = HISTANdelegate;
        
        //初始化参数数组（必须是可变数组）
        NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"dDate",[aDic objectForKey:@"dDate"],nil];
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获得OSAPHTTP请求
        ASIHTTPRequest *ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Outbound_List_Status_Count wsParameters:wsParas];
        [ASISOAPRequest retain];
        
        ASISOAPRequest.delegate=self;
        [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
        [ASISOAPRequest startSynchronous];
        
        NSError *error = [ASISOAPRequest error];
        
        if (!error) {
            
            //histan_NSLog(@"加载数量成功！accok");
            
            //获取返回的json数据
            NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
            ////histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
            
            //获取data字典
            NSDictionary *statusDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
            //histan_NSLog(@"statusDic:%@",statusDic);
            //NSArray *StatusArray= [statusDic objectForKey:StatisticsType];
            
            [ASISOAPRequest clearDelegatesAndCancel];
            [ASISOAPRequest release];
            
            //NSLog(@"%@",statusDic);
            for(NSDictionary *item in statusDic){
                
                
                NSString *statusStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"status"]];
                NSString *statusNumStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"statusNum"]];
                
                //服务状态 1完成 0失败 2未服务
                
                if([statusStr isEqualToString:@"3"]){
                    if (view3!=nil)
                    {
                        UIButton *showButton3=(UIButton*)view3; //需要显示文字的按钮1
                        NSArray *textArray = [showButton3.titleLabel.text componentsSeparatedByString:@"("];
                        NSString *newTitle=[[textArray objectAtIndex:0] stringByAppendingFormat:@"(%@)",statusNumStr];
                        [showButton3 setTitle:newTitle forState:UIControlStateNormal];
                    }
                }else if([statusStr isEqualToString:@"2"]){
                    if (view2!=nil)
                    {
                        UIButton *showButton2=(UIButton*)view2; //需要显示文字的按钮1
                        NSArray *textArray = [showButton2.titleLabel.text componentsSeparatedByString:@"("];
                        NSString *newTitle=[[textArray objectAtIndex:0] stringByAppendingFormat:@"(%@)",statusNumStr];
                        [showButton2 setTitle:newTitle forState:UIControlStateNormal];
                        
                    }
                }else if([statusStr isEqualToString:@"1"]){
                    
                    if (view1!=nil)
                    {
                        UIButton *showButton1=(UIButton*)view1; //需要显示文字的按钮1
                        NSArray *textArray = [showButton1.titleLabel.text componentsSeparatedByString:@"("];
                        NSString *newTitle=[[textArray objectAtIndex:0] stringByAppendingFormat:@"(%@)",statusNumStr];
                        [showButton1 setTitle:newTitle forState:UIControlStateNormal];
                        
                    }
                }
                
            }
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}



@end
