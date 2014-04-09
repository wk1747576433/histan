//
//  SystemSetViewController.m
//  histan
//
//  Created by lyh on 1/5/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//

#import "SystemSetViewController.h"

@interface SystemSetViewController ()

@end

@implementation SystemSetViewController

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
    //页面标题
    self.title=@"设置";
    
    //设置背景图片
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];
    // [bgImgView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    // bgImgView.userInteractionEnabled=YES; //启用可响应事件
    // [self.view addSubview:bgImgView];
    
    //添加 table view
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    [_tableview setBackgroundColor:[UIColor whiteColor]];
    [_tableview setBackgroundView:bgImgView];
    
    [self.view addSubview:_tableview];
    
    
    
    
    //在导航的顶部右侧加入 关于我们菜单
    UIBarButtonItem  *rightbutton_backindex=[[UIBarButtonItem alloc]init];
    rightbutton_backindex.target=self;
    rightbutton_backindex.action=@selector(goToAboutUsPage:);
    rightbutton_backindex.style=UIBarButtonItemStylePlain;
    rightbutton_backindex.title=@"关于";
    [rightbutton_backindex setTag:initTag+100];
    self.navigationItem.rightBarButtonItem=rightbutton_backindex;
    
}
-(void)goToAboutUsPage:(UIBarButtonItem*)sender{
    ABoutUsViewController *aboutus=[[ABoutUsViewController alloc]init];
    //[self.navigationController pushViewController:aboutus animated:YES];
    
    [aboutus setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal]; //翻转
    
    //  [self presentModalViewController:aboutus animated:YES];
    self.navigationItem.title=@"返回";
    [self.navigationController pushViewController:aboutus animated:YES];
    [aboutus release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//设置 tableview cell 的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


//设置第几个cell group 返回的 cell 个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    }else if(section ==1){
        return  2;
    }else  if(section ==2){
        return 1;
    }else  if(section ==3){
        return 1;
    }else{
        return 1;
    }
}

//设置有多少个 cell 组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int section=indexPath.section;
    int row=indexPath.row;
    static NSString *CellIdentifier=@"histan_Cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        cell.backgroundColor=[UIColor whiteColor];
    }
    
    UIImageView *zhuxiaobtnbg=[[UIImageView alloc]init];
    [zhuxiaobtnbg setImage:[UIImage imageNamed:@"zhuxiaobtnbg"]];
    zhuxiaobtnbg.frame=CGRectZero;
    
    UIImageView *zhuxiaobtnbg2=[[UIImageView alloc]init];
    [zhuxiaobtnbg2 setImage:[UIImage imageNamed:@"zhuxiaobtnbg2"]];
    zhuxiaobtnbg2.frame=CGRectZero;
    
    
    switch (section) {
            //        case 0:
            //
            //                cell.textLabel.text=@"修改密码";
            //                cell.tag=initTag+1;
            //            break;
        case 0:
            
            cell.textLabel.text=@"下载管理";
            cell.tag=initTag+2;
            break;
        case 1:
            if(row==0){
                cell.textLabel.text=@"检查更新";
                cell.tag=initTag+3;
                
                UILabel *uilabel=[[UILabel alloc]initWithFrame:CGRectMake(200, 10, 60,20)];
                NSString *CurrentVersion=[[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString*)kCFBundleVersionKey];;
                ////ZNV //histan_NSLog(@"%@",CurrentVersion);
                uilabel.text=[NSString stringWithFormat:@"V %@",CurrentVersion];
                [uilabel setFont:[UIFont systemFontOfSize:16]];
                [uilabel setTextColor:[UIColor redColor]];
                [cell.contentView addSubview:uilabel];
                
                
            }else if(row==1){
                cell.textLabel.text=@"清除缓存";
                cell.tag=initTag+4;
            }
            break;
        case 2:
            
            cell.backgroundColor=[UIColor clearColor];
            cell.contentView.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=@"注销当前登陆";
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.textColor=[UIColor whiteColor];
            cell.selectedBackgroundView=zhuxiaobtnbg2;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.backgroundView=zhuxiaobtnbg;
            cell.tag=initTag+5;
            
            break;
        default:
            break;
    }
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int tag= cell.tag;
    if (tag==initTag+1) {
        ChangPassWordViewController *changpass=[[ChangPassWordViewController alloc]init];
        self.navigationItem.title=@"返回";
        [self.navigationController pushViewController:changpass animated:YES];
        [changpass release];
        
    }else if(tag==initTag +2) //下载中心
    {
        self.navigationItem.title=@"返回";
        DownLoadsController  *downLoads  = [[DownLoadsController alloc]init];
        [self.navigationController pushViewController:downLoads animated:YES];
        [downLoads release];
    
    }else if(tag==initTag+3) //检查更新
    {
        
        GCDiscreetNotificationView *gcdNotificationView = [[GCDiscreetNotificationView alloc] initWithText:@"后台检测中..." showActivity:NO inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:self.view];
        [gcdNotificationView show:YES];
        [gcdNotificationView hideAnimatedAfter:1.5];
        [Harpy checkVersion:1];
   
    } else if(tag==initTag+4) //清除缓存
    {
        //开始清除
        [[NSFileManager defaultManager] removeItemAtPath:pathInCacheDirectory(@"com.xmly") error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:pathInCacheDirectory(@"com.xmly") withIntermediateDirectories:YES attributes:nil error:nil];
        
        //清除成功
        GCDiscreetNotificationView *gcdNotificationView = [[GCDiscreetNotificationView alloc] initWithText:@"清除成功" showActivity:NO inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:self.view];
        [gcdNotificationView show:YES];
        [gcdNotificationView hideAnimatedAfter:1.5];
         
                
    }else if(tag==initTag+5)
    {
        
        
        //提示，是否要还原系统配置。
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"您确定要注销当前登陆吗？"
                                      delegate:self
                                      cancelButtonTitle:@"取      消"
                                      destructiveButtonTitle:@"注      销"
                                      otherButtonTitles:nil, nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
        [actionSheet showFromRect:[tableView frame] inView:self.view animated:YES];
        
    }
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //ZNV //histan_NSLog(@"btntag:%d",buttonIndex);
    if(buttonIndex==0){
        
        //跳转到登陆页面
       LoginViewController  *loginController = [[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil]autorelease];
        [self.navigationController pushViewController:loginController animated:YES];
        [loginController release];
        
    }
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=@"设置";
}


-(void)dealloc{
    
    [super dealloc];
}

@end
