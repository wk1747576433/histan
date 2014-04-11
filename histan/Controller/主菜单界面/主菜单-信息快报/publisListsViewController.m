//
//  publisListsViewController.m
//  histan
//
//  Created by lyh on 1/21/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "publisListsViewController.h"

@interface publisListsViewController ()

@end

@implementation publisListsViewController

 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     
    appDelegate = HISTANdelegate;
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    self.navigationItem.title=appDelegate.CurPageTitile;
    //histan_NSLog(@"记录的公告类型id：%@",appDelegate.publishTypeId);
    appDelegate.noticeListArray = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, mainScreen_CGRect.size.height-40)];
    [self.view addSubview:_tableView];
    
    //调用获取公告信息方法
    [self performSelector:@selector(getNotices)];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //tanbleview 的选中取消效果
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
    if([_isRead isEqualToString:@"未读"]){
        //调用获取公告信息方法
        [self performSelector:@selector(getNotices)];
    }
     
}


#pragma mark -- 获取公告信息
-(void)getNotices
{
  //  appDelegate.noticeListArray=nil;
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"加载中..."];
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"code_no",appDelegate.publishTypeId,@"page",@"",@"pageSize",@"20",nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Notices wsParameters:wsParas];
    ////histan_NSLog(@"发送的路径：%@",);
    //异步
    [ASISOAPRequest startAsynchronous];
    
    //为了使代码更加简洁，使用代码块，而不是用回调方法
    //使用block就不用代理了
    [ASISOAPRequest setCompletionBlock:^{
        [HUD hide:YES];
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        //获取data字典,存入变量
        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
        //histan_NSLog(@"allDic：%@",allDic);
        NSDictionary *dataDic = [allDic objectForKey:@"data"];
        //histan_NSLog(@"dataDic：%@",dataDic);
        NSDictionary *listDic = [dataDic objectForKey:@"list"];
        //histan_NSLog(@"listDic：%@",listDic);
        [appDelegate.noticeListArray  removeAllObjects];
        for (id item in listDic) {
            [appDelegate.noticeListArray addObject:item];
        }
        [_tableView reloadData];
    }];
    
    //请求失败
    [ASISOAPRequest setFailedBlock:^{
        [HUD hide:YES];
        NSError *error = [ASISOAPRequest error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！您的网络目前可能不给力哦^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        //histan_NSLog(@"请求超时！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //histan_NSLog(@"appDelegate.noticeListArray count %d",[appDelegate.noticeListArray count]);
    return [appDelegate.noticeListArray count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"nitifyCell_%d",indexPath.row];
    publishDitealCell *cell=(publishDitealCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
   
    
    if (cell == nil ) {
       
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"publishDitealCell" owner:self options:nil];
        //第一个对象就是CustomCell了
        cell = [nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
       // cell = (publishDitealCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
       // cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
        @try {
            
            
            //得到当前行的数据
            NSDictionary *dict=[appDelegate.noticeListArray objectAtIndex:indexPath.row];
            //histan_NSLog(@"dict:%@",dict);
            
            NSString *isReadStr = [dict objectForKey:@"reader"];
            if ([isReadStr isEqualToString:@"已读"]) {
                UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"isread"]];
                [view setFrame:CGRectMake(0, 0, 40, 40)];
                cell.accessoryView = view;
                [view release];
            }
            else
            {
                UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noread"]];
                [view setFrame:CGRectMake(0, 0, 40, 40)];
                cell.accessoryView = view;
                [view release];
            }
            cell.idLabel.text = [dict objectForKey:@"notify_id"];
            cell.nameLabel.text =[dict objectForKey:@"subject"];
            cell.statusLabel.text = [NSString stringWithFormat:@"状态:%@",[dict objectForKey:@"reader"]] ;
            cell.publisherLabel.text = [NSString stringWithFormat:@"发布者:%@",[dict objectForKey:@"user_name"]];
            cell.publishTimeLabel.text = [NSString stringWithFormat:@"发布时间:%@", [dict objectForKey:@"send_time"]];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }

    }
     
    return  cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    publishDitealCell *cell = (publishDitealCell *)[tableView cellForRowAtIndexPath:indexPath];

    //当前信息的id
    appDelegate.infoId = cell.idLabel.text;
    //histan_NSLog(@"infoId === %@",cell.idLabel.text);
    //如果是未读状态的被点击就是已读了
    NSString *states = cell.statusLabel.text;
    //histan_NSLog(@"cell.statusLabel.text == %@",states);
    if ([states isEqualToString:@"状态:未读"]) {
        _isRead=@"未读";
        cell.statusLabel.text = @"状态:已读";
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"isread"]];
        [view setFrame:CGRectMake(0, 0, 40, 40)];
        cell.accessoryView = view;
        [view release];
        
        //调用已读公告方法
        [self performSelector:@selector(readTheNotify:) withObject:cell.idLabel.text afterDelay:0];
    }else{
        _isRead=@"Null";
    }
    
    //自定义返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem=backBtn;
    
    appDelegate.CurPageTitile = cell.nameLabel.text;
    
    publishDitealViewController *publishDitealVC = [[publishDitealViewController alloc] init];
    [self.navigationController pushViewController:publishDitealVC animated:YES];
    [publishDitealVC release];
}

#pragma mark -- 阅读公告信息
-(void)readTheNotify:(NSString *)notityId
{
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,@"notify_id",notityId,nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Read wsParameters:wsParas];
    ////histan_NSLog(@"发送的路径：%@",);
    //异步
    [ASISOAPRequest startAsynchronous];
    
    //使用block就不用代理了
    [ASISOAPRequest setCompletionBlock:^{
        [HUD hide:YES];
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
//        //获取data字典,存入变量
//        NSDictionary *allDic = [soapPacking getDicFromJsonString:returnString];
    }];
    
    //请求失败
    [ASISOAPRequest setFailedBlock:^{
        NSError *error = [ASISOAPRequest error];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求超时！您的网络目前可能不给力哦^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
        //histan_NSLog(@"阅读公告信息失败！您的网络目前可能不给力哦^_^ %@", [error localizedDescription]);
    }];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
