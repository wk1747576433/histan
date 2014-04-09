//
//  InfoPaperController.m
//  histan
//
//  Created by liu yonghua on 13-12-30.
//  Copyright (c) 2013年 Ongo. All rights reserved.
//

#import "InfoPaperController.h"

@implementation InfoPaperController
{
    
}
@synthesize typeDic=_typeDic;
@synthesize typeIdArray = _typeIdArray;
@synthesize typeNameArray = _typeNameArray;
@synthesize totalArray = _totalArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = HISTANdelegate;
    //加入导航右侧返回首页和下载中心按钮,【不能 release】
    HLSOFTNAVPOPVIEWController *hlnav=[[HLSOFTNAVPOPVIEWController alloc]init];
    [hlnav initHLNAV:self];
    
    self.typeDic = [[NSDictionary alloc] init];
    _typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _typeTableView.dataSource = self;
    _typeTableView.delegate = self;
    //设置界面标题
    self.navigationItem.title=appDelegate.CurPageTitile;
    [self.view addSubview:_typeTableView];
    [self performSelector:@selector(numTotal)];
}

#pragma mark -- 获取公告类型
-(void)getPublishType
{
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Notice_Type wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess_getPublishType:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载
    
}


//加载成功，现实到页面。
-(void)requestDidSuccess_getPublishType:(ASIHTTPRequest*)requestLoadSource{
    @try {
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        
        //获取data字典,存入变量
        self.typeDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
        
        //得到公告类型数组
        NSMutableArray *typeNames=[[NSMutableArray alloc] init];
        NSMutableArray *typeIds = [[NSMutableArray alloc] init];
        for (NSDictionary *item in self.typeDic) {
            [typeIds addObject: [item objectForKey:@"code_no"]];
            [typeNames addObject:[item objectForKey:@"code_name"]];
        }
        self.typeIdArray = typeIds;
        self.typeNameArray = typeNames;
        //histan_NSLog(@"公告类型：%@",self.typeNameArray);
        [_typeTableView reloadData];
        [HUD hide:YES];
    }
    @catch (NSException *exception) {
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText = @"服务器没有返回数据！";
        [HUD hide:YES afterDelay:2];
    }
    @finally {
        
    }
}


#pragma mark -- 统计公告未读和总数量
-(void)numTotal
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"加载中..."];
    //初始化参数数组（必须是可变数组）
    NSMutableArray *wsParas=[[NSMutableArray alloc] initWithObjects:@"SID",appDelegate.SID,nil];
    //实例化OSAPHTTP类
    ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
    //获得OSAPHTTP请求
    ASISOAPRequest = [soapPacking getASISOAPRequest:appDelegate.WebSevicesURL NameSpace:xmlNameSpace webServiceFunctionName:API_Notices_Read wsParameters:wsParas];
    [wsParas release];
    
    [ASISOAPRequest retain];
    ASISOAPRequest.delegate=self;
    [ASISOAPRequest setTimeOutSeconds:60];//超时秒数
    [ASISOAPRequest setDidFailSelector:@selector(requestDidFailed:)];//加载出错的方法。
    [ASISOAPRequest setDidFinishSelector:@selector(requestDidSuccess_numTotal:)];//加载成功的方法
    [ASISOAPRequest startAsynchronous];//异步加载
    
    
    
}


//加载数据出错。
-(void)requestDidFailed:(ASIHTTPRequest*)request{
    
    if(HUD!=nil){
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText = @"网络连接错误，请检查网络！";
        [HUD hide:YES afterDelay:2];
        
    }
}

//加载成功，现实到页面。
-(void)requestDidSuccess_numTotal:(ASIHTTPRequest*)requestLoadSource{
    @try {
        //实例化OSAPHTTP类
        ASIHttpSoapPacking *soapPacking = [[ASIHttpSoapPacking alloc] init];
        //获取返回的json数据
        NSString *returnString = [soapPacking getReturnFromXMLString:[ASISOAPRequest responseString]];
        //histan_NSLog(@"调用getReturnFromXMLString方法返回的数据：%@",returnString);
        
        //获取data字典,存入变量
        NSDictionary *dataDic = [soapPacking getJsonDataDicWithJsonStirng:returnString];
        //histan_NSLog(@"统计公告信息数据字典：%@",dataDic);
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (id item in dataDic) {
            [tempArray addObject:item];
        }
        //记录统计数据
        self.totalArray = tempArray;
        //[dataDic release];
        [HUD hide:YES];
        [self performSelector:@selector(getPublishType)];
        
    }
    @catch (NSException *exception) {
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckmarkX"]] autorelease];
        HUD.labelText = @"服务器没有返回数据！";
        [HUD hide:YES afterDelay:2];
    }
    @finally {
        
    }
}

#pragma mark -- tableView 代理
//设置显示多少行tableviewcell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.typeIdArray count];
}

//加载数据
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellName = [NSString stringWithFormat:@"%d",indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    [cell.imageView setImage:[UIImage imageNamed:@"business_analysisico.png"]];
    //histan_NSLog(@"公告名称数组其中一个值：%@",[self.typeNameArray objectAtIndex:indexPath.row]);
    NSString *nameStr = [self.typeNameArray objectAtIndex:indexPath.row];
    int nameStrLength = [nameStr length];
    NSDictionary *dic = (NSDictionary *)[self.totalArray objectAtIndex:indexPath.row];
    NSString *numStr1 =[NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]] ;
    int numStr1Length = [numStr1 length];
    NSString *numStr2 = [dic objectForKey:@"whole"];
    
    NSString *textStr = [NSString stringWithFormat:@"%@(%@/%@)",nameStr,numStr1,numStr2];
    NSMutableAttributedString *endString = [[NSMutableAttributedString alloc] initWithString:textStr];
    
    [endString setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(nameStrLength+1,numStr1Length)];
    [cell.textLabel setAttributedText:endString];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma mark -- cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //histan_NSLog(@"id数据：%@",self.typeIdArray);
    NSString *typeId = nil;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *text = cell.textLabel.text;
    NSArray *textArray = [text componentsSeparatedByString:@"("];
    NSString *name  = [textArray objectAtIndex:0];
    //histan_NSLog(@"name:%@",name);
    for (int i = 0; i<[self.typeNameArray count]; i++) {
        NSString *aName = [self.typeNameArray objectAtIndex:i];
        if ([name isEqualToString:aName]) {
            typeId = [self.typeIdArray objectAtIndex:i];
        }
    }
    
    //自定义返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem=backBtn;
    
    appDelegate.publishTypeId = typeId;
    appDelegate.CurPageTitile = name;
    publisListsViewController *publishListVC = [[publisListsViewController alloc] init];
    [self.navigationController pushViewController:publishListVC animated:YES];
}




-(void)viewWillAppear:(BOOL)animated{
    [_typeTableView deselectRowAtIndexPath:[_typeTableView indexPathForSelectedRow] animated:YES];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    @try {
        
        NSLog(@"InfoPage Dealloc");
        if(ASISOAPRequest !=nil){
            //[ASISOAPRequest cancel];
            [ASISOAPRequest clearDelegatesAndCancel];
            [ASISOAPRequest release];
        }
        // ASISOAPRequest=nil;
        _typeTableView=nil;
        _typeDic=nil;
        _typeIdArray=nil;
        _typeNameArray=nil;
        _totalArray=nil;
        
        if (HUD!=nil) {
            [HUD release];
        }
        
        [super release];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
