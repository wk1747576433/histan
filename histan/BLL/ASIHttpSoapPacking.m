//
//  ASIHttpSoap.m
//  histan
//
//  Created by liu yonghua on 13-12-20.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import "ASIHttpSoapPacking.h"
@implementation ASIHttpSoapPacking
/*
 //Mark: 生成SOAP1.1版本的ASIHttp请求
 参数 webURL：                远程WebService的地址，不含*.asmx
 参数 webServiceFile：        远程WebService的访问文件名，如service.asmx
 参数 xmlNS：                    远程WebService的命名空间
 参数 webServiceName：        远程WebService的名称
 参数 wsParameters：            调用参数数组，形式为[参数1名称，参数1值，参数2名称，参数2值⋯⋯]，如果没有调用参数，此参数为nil
 */
- (ASIHTTPRequest *)getASISOAPRequest:(NSString *) weburl
                           NameSpace:(NSString *) xmlNS
                         webServiceFunctionName:(NSString *) wsName
                           wsParameters:(NSMutableArray *) wsParas
{
    //1、初始化SOAP消息体,
    NSString * soapMsgBody1 = [[NSString alloc] initWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"  "
                               "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"  "
                               "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                               "<soap:Body>"
                               "<%@     xmlns=\"%@\">", wsName, xmlNS];
    NSString * soapMsgBody2 = [[NSString alloc] initWithFormat:
                               @"</%@>"
                               "</soap:Body>"
                               "</soap:Envelope>", wsName];
    
    //2、生成SOAP调用参数
    NSString * soapParas = [[NSString alloc] init];
    soapParas = @"";
    if (![wsParas isEqual:nil]) {
        int i = 0;
        for (i = 0; i < [wsParas count]; i = i + 2) {
            soapParas = [soapParas stringByAppendingFormat:@"<%@>%@</%@>\n",
                         [wsParas objectAtIndex:i],
                         [wsParas objectAtIndex:i+1],
                         [wsParas objectAtIndex:i]];
        }
    }
    
    //3、生成SOAP消息
    NSString * soapMsg = [soapMsgBody1 stringByAppendingFormat:@"%@%@", soapParas, soapMsgBody2];
    
   //  NSLog(@"source:%@",soapMsg);
    //请求发送到的路径
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", weburl]];
    //histan_NSLog(@"请求发送到的路径%@",url);
    
    //NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    ASIHTTPRequest * theRequest = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    //[theRequest addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
    //[theRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [theRequest addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@", xmlNS, wsName]];
    
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest setRequestMethod:@"POST"];
    [theRequest appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    return theRequest;
}



/**
 *	@brief	过滤返回数据中的xml元素，得到纯返回数据(json数据)
 *
 *	@param 	xmlString 	请求所返回的xml格式数据
 *
 *	@return	返回纯json格式的数据
 */
-(NSString *)getReturnFromXMLString:(NSString *)xmlString

{  
    NSString *resp = xmlString;
    NSString *jsonString =@"获取<return>标签中的值失败";
    //1.
    //resp=[resp stringByReplacingOccurrencesOfString:@"xmlns" withString:@"noNSxml"];
    ////histan_NSLog(@"%@",resp);
    //2.
    DDXMLDocument *xmlDoc=[[DDXMLDocument alloc]initWithXMLString:resp options:0 error:nil];
    
    //3.获取<return>节点中的数据
    NSArray *jsonArray=[xmlDoc nodesForXPath:@"//return" error:nil];
    if(jsonArray.count==0){
        //没有数据
    }else{
        DDXMLElement *ret = (DDXMLElement *)[jsonArray objectAtIndex:0];
        jsonString = [ret stringValue];
        ////histan_NSLog(@"jsonString 是什么？＝＝%@",jsonString);
        
    }
    return jsonString;
}


/**
 *	@brief	根据NSString类型的json格式的数据，解析为数组对象返回
 *
 *	@param 	jsonString 	需要转化的NSString类型的json格式字符串
 *
 *	@return	 将”data“中的数据取出作为一个字典对象返回
 */
-(NSDictionary *)getJsonDataDicWithJsonStirng:(NSString *)jsonString
{
    NSDictionary *retArray = nil;
    NSString *jsonStr = jsonString;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    //NSDictionary  *jsonDictionary  = [[CJSONDeserializer  deserializer ]  deserializeAsDictionary : jsonData   error : &error ];
    
    if (error != nil) {
        retArray = nil;//如果解析错误，返回的数组为nil
        //histan_NSLog(@"json解析错误！！！");
    }
    //将整个返回的数据中的“data”所包含的数据转化成数组返回
    retArray = (NSDictionary *)[jsonDictionary objectForKey:@"data"];
    return retArray;
}


/**
 *	@brief	将json格式的字符串转化为数组
 *
 *	@param 	jsonString 	将要转化的json格式的字符串
 *
 *	@return	转化之后的数组
 */
-(NSArray *)getArrayFromJsonString:(NSString *)jsonString

{
    NSArray *retArray = nil;
    NSString *jsonStr = jsonString;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
     //NSDictionary  *jsonDictionary  = [[CJSONDeserializer  deserializer ]  deserializeAsDictionary : jsonData   error : &error ];
    if (error != nil) {
        retArray = nil;//如果解析错误，返回的数组为nil
        //histan_NSLog(@"json解析错误！！！");
    }
    //直接将整个数据化成数组类型的数据返回
    retArray = (NSArray *)jsonDictionary;
    return retArray;

}

/**
 *	@brief	将json格式的字符串转化为字典
 *
 *	@param 	jsonString 	将要转化的json格式的字符串
 *
 *	@return	转化之后的字典
 */
-(NSDictionary *)getDicFromJsonString:(NSString *)jsonString
{
    @try {

        //JSONDecoder *jd=[[JSONDecoder alloc] init];
        NSString *jsonStr = jsonString;
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        //NSDictionary *ret2 = [jd objectWithUTF8String:(const unsigned char *)[jsonStr UTF8String] length:(unsigned int)[jsonStr length]];
        NSError *error = nil;
       // NSDictionary *ret2 = [jd objectWithData: jsonData error:&error];
         
        NSDictionary  *ret2  = [[CJSONDeserializer  deserializer ]  deserializeAsDictionary : jsonData   error : &error ];
        
        //histan_NSLog(@"ret2:%@",ret2);
        if (error != nil) {
            //histan_NSLog(@"%@",[error debugDescription]);
        }
        return ret2;
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
         
    }
    
        
//    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
//    if (error != nil) {
//        jsonDictionary = nil;//如果解析错误，返回的数组为nil
//        //histan_NSLog(@"json解析错误！！");
//        
//    }
   // return jsonDictionary;

}


@end
