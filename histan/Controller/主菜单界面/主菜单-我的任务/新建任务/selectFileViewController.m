//
//  selectFileViewController.m
//  histan
//
//  Created by lyh on 1/12/14.
//  Copyright (c) 2014 Ongo. All rights reserved.
//



#import "selectFileViewController.h"

@interface selectFileViewController ()
{
    UIImagePickerController *imagepicker;
}

@property (assign, nonatomic) NSMutableArray *dirArray;
@property (assign, nonatomic) UIDocumentInteractionController *docInteractionController;

@end


@implementation selectFileViewController

@synthesize showView;
@synthesize fileNameLabel;
@synthesize fileSizeLabel;
@synthesize readTable;
@synthesize dirArray;
@synthesize docInteractionController;

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
    
      self.view.backgroundColor = [UIColor whiteColor];
      appDelegate = HISTANdelegate;
    
    //保存一张图片到设备document文件夹中 
//    UIImage *image = [UIImage imageNamed:@"menclickbg.png"];
//    NSData *jpgData = UIImageJPEGRepresentation(image,0.8);
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(docPath, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    //NSString *filePath = [documentsPath stringByAppendingPathComponent:@"menclickbg.png"]; //Add the file name
    //[jpgData writeToFile:filePath atomically:YES]; //Write the file
    

    //保存一份txt文件到设备document文件夹中 
//    char *saves = "just test!";
//    NSData *data = [[NSData alloc] initWithBytes:saves length:10];
//    filePath = [documentsPath stringByAppendingPathComponent:@"flsjflsjdfljsaldjflsjdlkfjaslkdjfkjdflsdkjfkj.doc"];
//    [data writeToFile:filePath atomically:YES];
//    
//    char *saves1 = "just test!";
//    NSData *data1 = [[NSData alloc] initWithBytes:saves1 length:10];
//    filePath = [documentsPath stringByAppendingPathComponent:@"code4app2.doc"];
//    [data1 writeToFile:filePath atomically:YES];
//    
//    char *saves2 = "just test!";
//    NSData *data2 = [[NSData alloc] initWithBytes:saves2 length:10];
//    filePath = [documentsPath stringByAppendingPathComponent:@"code4app3.txt"];
//    [data2 writeToFile:filePath atomically:YES];
//    
//    char *saves3 = "just test!";
//    NSData *data3= [[NSData alloc] initWithBytes:saves3 length:10];
//    filePath = [documentsPath stringByAppendingPathComponent:@"code4app4.txt"];
//    [data3 writeToFile:filePath atomically:YES];
    
	
}



#pragma mark -- 文件和相册切换按钮点击事件
-(void)swichBtnAction:(UISegmentedControl *)seg
{
    NSInteger Index = seg.selectedSegmentIndex;
    //histan_NSLog(@"Index %i", Index);
    switch (Index) {
        case 0:
            //显示文件列表
            [self performSelector:@selector(showFileList)];
            break;
        case 1:
            //弹出相册选择框
            [self performSelector:@selector(showPhotos)];
            break;
    }
}

#pragma mark -- 显示文件列表
-(void)showFileList
{
    
    //首先自定义navigationbar 加入“文件”，“相册”选择
    NSArray *swichArray = [[NSArray alloc] initWithObjects:@"文件",@"相册", nil];
    UISegmentedControl *swichBtn = [[UISegmentedControl alloc] initWithItems:swichArray];
    swichBtn.frame = CGRectMake(0, 0, 190, 30);
    swichBtn.segmentedControlStyle = UISegmentedControlStyleBar;
    swichBtn.momentary = NO;
    [self.navigationController.navigationBar addSubview:swichBtn];
    [swichBtn setFrame:CGRectMake(100, 7, 120, 30)];
    //添加事件
    [swichBtn addTarget:self action:@selector(swichBtnAction:) forControlEvents:UIControlEventValueChanged];
    [swichBtn setTag:-123456];
    [swichBtn release];
    [swichBtn setSelectedSegmentIndex:0];
    
    //确认选择按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setFrame:CGRectMake(230, 7, 80, 30)];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_bluebg"] forState:UIControlStateNormal];
    [submitBtn setContentMode:UIViewContentModeScaleToFill];
    [submitBtn setTitle:@"确认选择" forState:UIControlStateNormal];
    [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [submitBtn addTarget:self action:@selector(submitBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTag:-1234567];
    [self.navigationController.navigationBar addSubview:submitBtn];
    
    //histan_NSLog(@"%s",__func__);
    //显示文件列表
    NSFileManager *fileManager = [NSFileManager defaultManager];
	//在这里获取应用程序Documents文件夹里的文件及文件夹列表
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [NSString stringWithFormat:@"%@/%@",[documentPaths objectAtIndex:0],@"DownLoadFiles"];
	NSError *error = nil;
	NSArray *fileList = [[NSArray alloc] init];
	//fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
	fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
	
	//    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
	//	//histan_NSLog(@"------------------------%@",fileList);
	self.dirArray = [[NSMutableArray alloc] init];
	for (NSString *file in fileList)
	{
		[self.dirArray addObject:file];
	}
    //histan_NSLog(@"Every Thing in the dir:%@",fileList);
    
    
    
    /*
     *web缩略图高120，宽100，信息栏高120，宽200
     *文件列表就是剩下的啦
     */
    
    //缩略图背景
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 120)];
//    [bgView setBackgroundColor:[UIColor greenColor]];
//    
//    //缩略视图
//    showView = [[UIWebView alloc] initWithFrame:CGRectMake(1, 1, 98, 118)];
//    showView.scalesPageToFit = YES;
//    showView.delegate = self;
//    NSString *urlStr = docPath;
//    NSURL *fileURL = [NSURL fileURLWithPath:[urlStr stringByAppendingPathComponent:@"code4app.txt"]];
//    //histan_NSLog(@"fileURL------%@",fileURL);
//    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
//    [showView loadRequest:request];
//    
//    //文件名称显示label
//    fileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 5, 220, 30)];
//    [fileNameLabel setText:@"文件名称："];
//    
//    //文件大小显示label
//    fileSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, 220, 30)];
//    [fileSizeLabel setText:@"文件大小："];
    
    //确认选择按钮
//    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [submitBtn setFrame:CGRectMake(200, 75, 80, 40)];
//    [submitBtn setTitle:@"确认选择" forState:UIControlStateNormal];
//    [submitBtn addTarget:self action:@selector(submitBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    //文件列表table
    readTable = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 410)];
    readTable.delegate = self;
    readTable.dataSource = self;
    
    //添加到视图
    //[self.view addSubview:fileNameLabel];
    //[self.view addSubview:fileSizeLabel];
    //[self.view addSubview:submitBtn];
    [self.view addSubview:readTable];
    //[self.view addSubview:bgView];
    //[self.view addSubview:showView];
	
	[readTable reloadData];

    
    
}

#pragma mark -- 弹出相册选择
-(void)showPhotos
{
     //histan_NSLog(@"%s",__func__);
    //显示相片库
    imagepicker = [[UIImagePickerController alloc] init];
    
    imagepicker.delegate = self;
    
    imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagepicker.allowsEditing = YES;
    [self presentModalViewController:imagepicker animated:YES];
}

#pragma mark -- 照片选取框代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    HISTANAPPAppDelegate *appDelegate1 = HISTANdelegate;
    //先将图片存入本地，上传后再删除
    //1.存入图片（注意:存入路径暂时是documents下，整合后应该是下载目录下）
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *jpgData = UIImageJPEGRepresentation(image,0.8);

    //获取图片名称
    NSString *fileName = [[NSString alloc] init];
    if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
        fileName = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
        //ReferenceURL的类型为NSURL 无法直接使用  必须用absoluteString 转换，照相机返回的没有UIImagePickerControllerReferenceURL，会报错
        fileName = [self getFileName:fileName];
        [self performSelector:@selector(getFileName:) withObject:fileName];
    }
    else
    {
        fileName = [self performSelector:@selector(timeStampAsString)];
    }
    //保存到程序doc目录下，上传后再删除
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName]; //Add the file name
    [jpgData writeToFile:filePath atomically:YES]; //Write the file
      
    //2.将名称（带后缀名）存入“搬运工”
    [appDelegate1.upFileNameArray addObject:fileName];
    
    //收起选择器
    [picker dismissModalViewControllerAnimated:NO];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud setLabelText:[NSString stringWithFormat:@"您成功选择了图片：%@",fileName]];
//    [hud hide:YES afterDelay:2.0];
    
    //返回到新建页面
    [self.navigationController popViewControllerAnimated:YES];
}

// 完成选取
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

//获得图片名称（带后缀）
-(NSString *)getFileName:(NSString *)fileName
{
	NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
	NSString *suffix = [temp lastObject];	
	temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];	
	NSString *name = [temp lastObject];
	name = [name stringByAppendingFormat:@".%@",suffix];
	return name;
}

//随机给图片取名
-(NSString *)timeStampAsString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YMdms"];
    NSString *locationString = [df stringFromDate:nowDate];
    NSString *fileName = [NSString stringWithFormat:@"photo_%@%@",locationString,@".png"];
    return fileName;
}

#pragma mark -- 确定选择按钮点击事件
-(void)submitBtnTaped:(UIButton *)sender
{
    //返回新建任务页
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark -- 获取所选文件大小
// fileName 为文件名称  返回nsstring k为单位
-(NSString *)getSizeForFileName:(NSString *)fileName
{
    NSFileManager* manager = [NSFileManager defaultManager];
    //拼接路径
    NSString *path = [docPath stringByAppendingPathComponent:fileName];
    long long lSize = [[manager attributesOfItemAtPath:path error:nil] fileSize];
    //以k为单位
    float fSize = lSize/(1024.0);
    NSString *sizeStr = [NSString stringWithFormat:@"%f K",fSize];
    return sizeStr;
}



#pragma mark -- uitableview 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dirArray count];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


//cell加载
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellName = [NSString stringWithFormat:@"%d",indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
        
        BOOL IsSelectFile=NO;
        for(int i=0;i<[appDelegate.upFileNameArray count];i++){
            if ([[self.dirArray objectAtIndex:indexPath.row] isEqualToString:appDelegate.upFileNameArray[i]]) {
                IsSelectFile=YES;
            }
        }
        
        if(IsSelectFile) 
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
             
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }

	NSURL *fileURL= nil;
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:indexPath.row]];
	fileURL = [NSURL fileURLWithPath:path];
	cell.textLabel.text = [self.dirArray objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
    [cell.textLabel setLineBreakMode:UILineBreakModeMiddleTruncation];
	return cell;

}


//cell选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        //移除文件名
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *upFileName = cell.textLabel.text;
        [appDelegate.upFileNameArray removeObject:upFileName];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //记录文件名
        NSString *upFileName = cell.textLabel.text;
        [appDelegate.upFileNameArray addObject:upFileName];
    }
    //histan_NSLog(@"indexPath.row=====%d",indexPath.row);
    //NSString *filename =cell.textLabel.text;
    
//    showView = [[UIWebView alloc] initWithFrame:CGRectMake(1, 1, 98, 118)];
//    showView.scalesPageToFit = YES;
//    showView.delegate = self;
//    NSString *urlStr = docPath;
//    NSURL *fileURL = [NSURL fileURLWithPath:[urlStr stringByAppendingPathComponent:filename]];
//    //histan_NSLog(@"fileURL------%@",fileURL);
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
//    [showView loadRequest:request];
//
//    [self.view addSubview:showView];
//    
//    NSString *nameLableText = [NSString stringWithFormat:@"文件名称: %@",filename];
//    [fileNameLabel setText:nameLableText];
//    
//    NSString *sizeStr = [NSString stringWithFormat:@"文件大小：%@",[self performSelector:@selector(getSizeForFileName:) withObject:cell.textLabel.text]];
//    [fileSizeLabel setText:sizeStr];
    
}


#pragma mark - UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}



#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    //    NSInteger numToPreview = 0;
    //
    //	numToPreview = [self.dirArray count];
    //
    //    return numToPreview;
	return [self.dirArray count];
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
	[previewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"click.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSURL *fileURL = nil;
    NSIndexPath *selectedIndexPath = [readTable indexPathForSelectedRow];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:selectedIndexPath.row]];
	fileURL = [NSURL fileURLWithPath:path];
    return fileURL;
}

//-(void)dealloc
//{
//    //histan_NSLog(@"%s",__func__);
//    
//    //从navigationbar上移除seg 和 确认按钮
//    [[self.navigationController.navigationBar viewWithTag:-123456] removeFromSuperview];
//    [[self.navigationController.navigationBar viewWithTag:-1234567] removeFromSuperview];
//    //[super dealloc];
//}
-(void)viewWillAppear:(BOOL)animated
{
    //histan_NSLog(@"%s",__func__);
    [self performSelector:@selector(showFileList)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //histan_NSLog(@"%s",__func__);
    [[self.navigationController.navigationBar viewWithTag:-123456] removeFromSuperview];
    [[self.navigationController.navigationBar viewWithTag:-1234567] removeFromSuperview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
