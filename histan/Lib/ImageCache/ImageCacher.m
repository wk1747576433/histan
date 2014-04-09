//
//  ImageCacher.m
//  AAPinChe
//
//  Created by Reese on 13-4-3.
//  Copyright (c) 2013年 Himalayas Technology&Science Company CO.,LTD-重庆喜玛拉雅科技有限公司. All rights reserved.
//  单例类f

#import "ImageCacher.h"


@implementation ImageCacher
@synthesize typeFix=_typeFix;

static ImageCacher *defaultCacher=nil;
-(id)init
{
    if (defaultCacher) {
        return defaultCacher;
    }else
    {
        self =[super init];
        [self setFlip];
        return self;
    }
}

+(ImageCacher*)defaultCacher
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


-(void) setFade
{
    _typeFix=kCATransitionFade;
    
}

-(void) setCube
{
   _typeFix=@"cube";
}

-(void) setFlip
{
   _typeFix= @"oglFlip";
}




- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

-(void)cacheImage:(NSDictionary*)aDic
{
    NSURL *aURL=[aDic objectForKey:@"url"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    if (image==nil) {
        return;
    }
    //CGSize origImageSize= [image size];
    
    //得到传入的图片宽度和高度
    int imageWidth=[[aDic objectForKey:@"imageWidth"] intValue];
    int imageHeight=[[aDic objectForKey:@"imageHeight"] intValue];
    
    
    CGRect newRect;
    newRect.origin= CGPointZero;
    //拉伸到多大
    newRect.size.width=imageWidth;
    newRect.size.height=imageHeight;

    //缩放倍数
    //float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
   
    UIGraphicsBeginImageContext(newRect.size);

   
    CGRect projectRect;
    projectRect.size.width =imageWidth;//ratio * origImageSize.width;
    projectRect.size.height=imageHeight;//ratio * origImageSize.height;
    projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
    projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;
    
    

    
    [image drawInRect:projectRect];
    

    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();

    
   
    //压缩比例
    
    NSData *smallData=UIImagePNGRepresentation(small);
    
    
    
    if (smallData) {
        [fileManager createFileAtPath:pathForURL(aURL) contents:smallData attributes:nil];
    }
    
    UIView *view=[aDic objectForKey:@"imageView"];
    
    
    //判断view是否还存在 如果tablecell已经移出屏幕会被回收 那么什么都不用做，下次滚到该cell 缓存已存在 不需要执行此方法
    if (view!=nil) {
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        //kCAMediaTimingFunctionEaseInEaseOut
        [transtion setType:_typeFix];
        [transtion setSubtype:kCATransitionFromRight];
        //kCATransitionFromRight
        [view.layer addAnimation:transtion forKey:@"transtionKey"];
        
        
       [(UIImageView*)view setImage:small];
    }
    UIGraphicsEndImageContext();
    
}


-(void)cacheImageForButtonBackImg:(NSDictionary *)aDic
{
    NSURL *aURL=[aDic objectForKey:@"url"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    if (image==nil) {
        return;
    }
    //CGSize origImageSize= [image size];
    
    CGRect newRect;
    newRect.origin= CGPointZero;
    
    
    //得到传入的图片宽度和高度
    int imageWidth=[[aDic objectForKey:@"imageWidth"] intValue];
    int imageHeight=[[aDic objectForKey:@"imageHeight"] intValue];
    
    
    //拉伸到多大
    newRect.size.width=imageWidth;
    newRect.size.height=imageHeight;
    
    
    //缩放倍数
    //float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    
    
    
    UIGraphicsBeginImageContext(newRect.size);
  
    
    CGRect projectRect;
    projectRect.size.width =imageWidth;//ratio * origImageSize.width;
    projectRect.size.height=imageHeight;//ratio * origImageSize.height;
    projectRect.origin.x= (newRect.size.width -projectRect.size.width)/1.0;
    projectRect.origin.y= (newRect.size.height-projectRect.size.height)/1.0;
    
    
    
    
    [image drawInRect:projectRect];
    
    
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    //压缩比例
    
    NSData *smallData=UIImagePNGRepresentation(small);//UIImageJPEGRepresentation(small, 0.1);
    
    
    
    if (smallData) {
        [fileManager createFileAtPath:pathForURL(aURL) contents:smallData attributes:nil];
    }
    
    UIView *view=[aDic objectForKey:@"imageView"];
    
    
    //判断view是否还存在 如果tablecell已经移出屏幕会被回收 那么什么都不用做，下次滚到该cell 缓存已存在 不需要执行此方法
    if (view!=nil) {
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        //kCAMediaTimingFunctionEaseInEaseOut
        [transtion setType:_typeFix];
        [transtion setSubtype:kCATransitionFromRight];
        //kCATransitionFromRight
        [view.layer addAnimation:transtion forKey:@"transtionKey"];
        
        
        [(UIButton*)view setBackgroundImage:small forState:UIControlStateNormal];
    }
    UIGraphicsEndImageContext();
    
}


-(void)cacheImageAuto:(NSDictionary*)aDic
{
    NSURL *aURL=[aDic objectForKey:@"url"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    if (image==nil) {
        return;
    }
    CGSize origImageSize= [image size];
    
    //得到传入的图片宽度和高度
    int imageWidth=[[aDic objectForKey:@"imageWidth"] intValue];
    int imageHeight=[[aDic objectForKey:@"imageHeight"] intValue];
    
    
    CGRect newRect;
    newRect.origin= CGPointZero;
    //拉伸到多大
    newRect.size.width=imageWidth;
    newRect.size.height=imageHeight;
    
    //缩放倍数
     float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    
    UIGraphicsBeginImageContext(newRect.size);
    
    
    CGRect projectRect;
    projectRect.size.width =ratio * origImageSize.width;
    projectRect.size.height=ratio * origImageSize.height;
    projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
    projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;
    
    
    
    
    [image drawInRect:projectRect];
    
    
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    //压缩比例
    
    //NSData *smallData=UIImageJPEGRepresentation(small, 0);
    NSData *smallData=UIImagePNGRepresentation(small);
    
    
    if (smallData) {
        [fileManager createFileAtPath:pathForURL(aURL) contents:smallData attributes:nil];
    }
    
    UIView *view=[aDic objectForKey:@"imageView"];
    
    
    //判断view是否还存在 如果tablecell已经移出屏幕会被回收 那么什么都不用做，下次滚到该cell 缓存已存在 不需要执行此方法
    if (view!=nil) {
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        //kCAMediaTimingFunctionEaseInEaseOut
        [transtion setType:_typeFix];
        [transtion setSubtype:kCATransitionFromRight];
        //kCATransitionFromRight
        [view.layer addAnimation:transtion forKey:@"transtionKey"];
        
        
        [(UIImageView*)view setImage:small];
    }
    UIGraphicsEndImageContext();
    
}

//缓存产品详情的图片
-(void)cacheProductDetailsImage:(NSDictionary*)aDic
{
    NSURL *aURL=[aDic objectForKey:@"url"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    if (image==nil) {
        return;
    }
    CGSize origImageSize= [image size];
    
    //得到传入的图片宽度和高度
    int imageWidth=origImageSize.width; //[[aDic objectForKey:@"imageWidth"] intValue];
    int imageHeight=origImageSize.height;//[[aDic objectForKey:@"imageHeight"] intValue];
    
    
    CGRect newRect;
    newRect.origin= CGPointZero;
    //拉伸到多大
    newRect.size.width=imageWidth;
    newRect.size.height=imageHeight;
    
    //缩放倍数
    //float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    
    UIGraphicsBeginImageContext(newRect.size);
    
    
    CGRect projectRect;
    projectRect.size.width =imageWidth;//ratio * origImageSize.width;
    projectRect.size.height=imageHeight;//ratio * origImageSize.height;
    projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
    projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;
    
    
    
    
    [image drawInRect:projectRect];
    
    
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    //压缩比例
    
    //NSData *smallData=UIImageJPEGRepresentation(small,0);
    NSData *smallData=UIImagePNGRepresentation(small);
    
    
    if (smallData) {
        [fileManager createFileAtPath:pathForURL(aURL) contents:smallData attributes:nil];
    }
    
    UIView *view=[aDic objectForKey:@"imageView"];
    
    
    //判断view是否还存在 如果tablecell已经移出屏幕会被回收 那么什么都不用做，下次滚到该cell 缓存已存在 不需要执行此方法
    if (view!=nil) {
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        //kCAMediaTimingFunctionEaseInEaseOut
        [transtion setType:_typeFix];
        [transtion setSubtype:kCATransitionFromRight];
        //kCATransitionFromRight
        [view.layer addAnimation:transtion forKey:@"transtionKey"];
        
        
        [(UIImageView*)view setImage:small];
    }
    UIGraphicsEndImageContext();
    
}

@end
