//
//  DeviceSenderBLL.m
//  histan
//
//  Created by xiao wenping on 13-11-18.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import "DeviceSenderBLL.h"

@implementation DeviceSenderBLL


-(void)sendDeviceToPushServer:(NSString *)Token{
    
    
  //  NSURL *url=[NSURL URLWithString:@"http://www.baidu.com"];
   // ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:url];
   // [req setTimeOutSeconds:60];//超时秒数
   // [req setDelegate:self];
  //  [req setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
   //    [req setDidFinishSelector:@selector(requestDidSuccess:)];   
   // [req startAsynchronous];
    //[req startSynchronous];
     
//    NSError *rr=[req error];
//
//    if(!rr){
//        NSString *rsp=[req responseString];
//       UIAlertView *_al=[[UIAlertView alloc]initWithTitle:@"token222" message:rsp delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [_al show];
//   }else{
//       
//        UIAlertView *_al=[[UIAlertView alloc]initWithTitle:@"rr" message:[NSString stringWithFormat:@"%@",[rr localizedDescription]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [_al show];
//
//   }
    
    
    //
    NSString *retToken=[Token stringByReplacingOccurrencesOfString:@" " withString:@""];
    retToken=[retToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    retToken=[retToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    //开始请求
    NSURL *url=[NSURL URLWithString:@"http://121.34.248.172:8090/rest/iospush/registDeviceUser"];
    request=[ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request retain];
    //histan_NSLog(@"%@",retToken);
    
    //UIAlertView *_al=[[UIAlertView alloc]initWithTitle:@"retToken" message:[NSString stringWithFormat:@"%@,\n%@",Token,retToken] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    //     [_al show];
    
    [request setPostValue:retToken forKey:@"devicetoken"];  
    [request setPostValue:@"histan" forKey:@"username"];          
    [request setPostValue:@"deviceinfo" forKey:@"deviceinfo"];    
    [request setTimeOutSeconds:60];//超时秒数
    [request setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
    [request setDidFinishSelector:@selector(requestDidSuccess:)];
    
    [request startAsynchronous];//异步提交
    
    
    //开始请求
//    NSURL *url=[NSURL URLWithString:@"http://118.251.179.102:8090/rest/iospush/registDeviceUser"];
//    
//   // NSURL *url=[NSURL URLWithString:@"http://www.baidu.com"];
//    sendRequest=[ASIFormDataRequest requestWithURL:url];
//    [sendRequest setRequestMethod:@"POST"];
//    [sendRequest setDelegate:self];
//    [sendRequest retain];
//    
//    [sendRequest setPostValue:Token forKey:@"devicetoken"];  
//    [sendRequest setPostValue:@"ihadai" forKey:@"username"];          
//    [sendRequest setPostValue:@"deviceinfo" forKey:@"deviceinfo"];     
//    [sendRequest setTimeOutSeconds:60];//超时秒数
//    [sendRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
//    [sendRequest setDidFinishSelector:@selector(requestDidSuccess:)];
//    
//    [sendRequest startAsynchronous];//异步提交
    
    
}

//加载数据出错。
-(void)requestDidFailed:(ASIFormDataRequest*)request{
    
    //histan_NSLog(@"senddev error!");
   // UIAlertView *_al=[[UIAlertView alloc]initWithTitle:@"token" message:@"feedback error" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
   // [_al show];
}

//加载成功，现实到页面。
-(void)requestDidSuccess:(ASIFormDataRequest*)requestLoadSource{
    
 //   NSString *str=[NSString stringWithFormat:@"success:%@",[requestLoadSource responseString]];
    //自己写保存代码
  //  UIAlertView *_al=[[UIAlertView alloc]initWithTitle:@"token" message:str delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
  //  [_al show];
    
  //  //histan_NSLog(@"senddev ok! %@",str);
    
}


-(void)dealloc{
    @try {
        
    
    [request clearDelegatesAndCancel];
    [request cancel];
    [request release];
    [super release];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


@end
