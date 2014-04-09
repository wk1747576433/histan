//
//  ASIHttpSoap.h
//  histan
//
//  Created by liu yonghua on 13-12-20.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "JSONKit.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
@interface ASIHttpSoapPacking : NSObject
{

}

- (ASIHTTPRequest *)getASISOAPRequest:(NSString *) weburl
                           NameSpace:(NSString *) xmlNS
                         webServiceFunctionName:(NSString *) wsName
                           wsParameters:(NSMutableArray *) wsParas;


-(NSString *)getReturnFromXMLString:(NSString *)xmlString;
-(NSDictionary *)getJsonDataDicWithJsonStirng:(NSString *)jsonString;
-(NSArray *)getArrayFromJsonString:(NSString *)jsonString;
-(NSDictionary *)getDicFromJsonString:(NSString *)jsonString;

@end
