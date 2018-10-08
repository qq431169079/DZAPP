//
//  IpCameraClientAppDelegate.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "IpCameraClientAppDelegate.h"
#import "obj_common.h"
#import "CameraViewController.h"
#import "MyTabBarViewController.h"
//#import "CameraAddViewController.h"
#import "AboutViewController.h"
#import "libH264Dec.h"
#import "LoginViewController.h"

@implementation UINavigationController (supportedOrientation)

- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}

@end

@implementation IpCameraClientAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize startViewController;
@synthesize playViewController;
@synthesize playbackViewController;
@synthesize remotePlaybackViewController;
@synthesize DownVer;
@synthesize cameraViewController;
#define Ver @"CamAppVer"
//#define ServiceAddress @"http://cd.gocam.so/Updates/2000/VSTARCAM.xml"//品牌
#define ServiceAddress @"http://cd.ipcam.so/Updates/2000/OEM.xml"//中性
#define AppUrl @"itms-apps://itunes.apple.com/us/app/pnpcamera/id557459163?ls=1&mt=8"//中性
//#define AppUrl @"itms-apps://itunes.apple.com/us/app/vscam/id555961183?ls=1&mt=8"//品牌

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
   // self.window.rootViewController = [[UIViewController alloc]init];
    //hide the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        startViewController = [[StartViewController alloc] initWithNibName:@"StartView_iPadApp" bundle:nil];
//            }else{
//        startViewController = [[StartViewController alloc] initWithNibName:@"StartView" bundle:nil];
//    }

    
    m_pCameraListMgt = [[CameraListMgt alloc] init];
    m_pPicPathMgt = [[PicPathManagement alloc] init];
    m_pRecPathMgt = [[RecPathManagement alloc] init];
    
    m_pPPPPChannelMgt = new CPPPPChannelManagement();
    
    
    picViewController = [[PictureViewController alloc] init];
    picViewController.m_pCameraListMgt = m_pCameraListMgt;
    picViewController.m_pPicPathMgt = m_pPicPathMgt;
    
    
    recViewController = [[RecordViewController alloc] init];
    recViewController.m_pCameraListMgt = m_pCameraListMgt;
    recViewController.m_pRecPathMgt = m_pRecPathMgt;
    recViewController.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
    
    cameraViewController = [[CameraViewController alloc] init];
    cameraViewController.cameraListMgt = m_pCameraListMgt;
    cameraViewController.m_pPicPathMgt = m_pPicPathMgt;
    cameraViewController.m_pRecPathMgt = m_pRecPathMgt;
    cameraViewController.PicNotifyEventDelegate = picViewController;
    cameraViewController.RecordNotifyEventDelegate = recViewController;
    cameraViewController.pPPPPChannelMgt = m_pPPPPChannelMgt;
    

    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    MyTabBarViewController *myTabViewController = [[MyTabBarViewController alloc] init];
    self.loginVc = [[LoginViewController alloc] init];
    myTabViewController.viewControllers = [NSArray arrayWithObjects:cameraViewController, picViewController, recViewController, aboutViewController, nil];
    myTabViewController.tabBar.hidden = YES;
    myTabViewController.tabBar.alpha = 0.0;
    navigationController = [[MyNavigationController alloc] initWithRootViewController:cameraViewController];//myTabViewController];
    navigationController.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
//    [cameraViewController release];
//    [picViewController release];
//    [recViewController release];
    [aboutViewController release];
    [myTabViewController release];
    _UpdaUrl = AppUrl;
    _downLoadData = [[NSMutableData alloc] init];
    _DowntmpStr = [[NSMutableString alloc] init];
    
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
    
    self.window.rootViewController = navigationController;
  //  [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    st_PPPP_NetInfo1 netInfo;
    XQP2P_NetworkDetect(&netInfo, 0);
    PPPP_Initialize((CHAR*)"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL"
);
    
    XQP2P_Initialize((CHAR *)"HZLXSXIALKHYEIEJHUASLMHWEESUEKAUIHPHSWAOSTEMENSQPDLRLNPAPEPGEPERIBLQLKHXELEHHULOEGIAEEHYEIEK-$$", 0);
    //Reachability *r = [Reachability reachabilityWithHostName:@"www.aslibra.com"];
      /* NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"connection  %@",connection);
    [request release];
    [connection release];*/
    //[NSThread detachNewThreadSelector:@selector(secondThread:) toTarget:self withObject:nil];
   // [NSThread detachNewThreadSelector:@selector(XmlPa:) toTarget:self withObject:nil];
    
    

    //PPPP_Initialize((CHAR*)"EBGAECBCKIJGHAJAEGGBEPEPHJMLHFNMGDEDBACDBPINLNLFCEBCCGOAHOLCJLKPAHMELFDBOCMKBACAJBNJJD");
    //PPPP_Initialize((CHAR*)"AACCBGAAOHIADHJKBPHLFFALCBMEDJMMGOAGEKGFAFMMLPOACBEECOOIDCPMIBOMAHNPONHELIMOFFDKNLMAMHBBNNKPFFDCFHDICO ");
        
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDir = [paths objectAtIndex:0];
//    NSFileManager *_manager = [NSFileManager defaultManager];
//    NSArray *filelist = [_manager subpathsAtPath:documentsDir];
//    
//    for (NSString *str in filelist) {
//        NSLog(@"str: %@", str);
//    }    
//
    int nP2PVersion = PPPP_GetAPIVersion();
    
    NSLog(@"nP2PVersion: %d", nP2PVersion);
    
    return YES;
}

- (void) XmlPa:(id)sender{
    NSURL* url = [NSURL URLWithString:ServiceAddress];
    NSXMLParser* xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    xmlparser.delegate = self;
    [xmlparser parse];
    [xmlparser release];
}

- (void) StartThread: (id) param
{
   
    //[NSThread detachNewThreadSelector:@selector(downloadInfoFromService:) toTarget:self withObject:nil];
    //usleep(1000000/2);
    
    NSString* verStr = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:Ver];
    NSString* nowVerStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] ;
    if ([DownVer isEqualToString:nowVerStr] || [DownVer isEqualToString:verStr]) {
//        st_PPPP_NetInfo NetInfo;
//        PPPP_NetworkDetect(&NetInfo, 0);
//        
//        [self performSelectorOnMainThread:@selector(switchView:) withObject:nil waitUntilDone:NO];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithString:DownVer] forKey:Ver];
        usleep(1000000*2);
        [self performSelectorOnMainThread:@selector(displayAlert:) withObject:nil waitUntilDone:YES];
    }
    
    
}
- (void) downloadInfoFromService:(id)sender{
//    NSURL* url = [NSURL URLWithString:@""];http://cd.gocam.so/Updates/2000/ver.xml
//    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
//    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    NSLog(@"connection  %@",connection);
//    [request release];
//    [connection release];
}

#pragma mark NSURLConnectionDataDelegate  NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_downLoadData setLength:0];
    //NSLog(@"connection");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_downLoadData appendData:data];
    //NSLog(@"recive");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"_downLoadData  %@",_downLoadData);
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData:_downLoadData];
    xmlParser.delegate = self;
    [xmlParser parse];
    [xmlParser release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //NSLog(@"down  Error");
}

#pragma mark NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"start");
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{

    NSLog(@"DownVer%@  _UpdaUrl%@   _DownUpdataContents%@",DownVer,_UpdaUrl,_DownUpdataContents);
    [NSThread detachNewThreadSelector:@selector(StartThread:) toTarget:self withObject:nil];


}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    [_DowntmpStr setString:@""];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"iosver"]) {
        DownVer = [NSString stringWithString:_DowntmpStr];
    }else if ([elementName isEqualToString:@"iosdownloadurl"]){
        _UpdaUrl = [NSString stringWithString:_DowntmpStr];
    }else if ([elementName isEqualToString:NSLocalizedStringFromTable(@"currentlanguage", @STR_LOCALIZED_FILE_NAME, nil)]){
        _DownUpdataContents = [NSString stringWithString:_DowntmpStr];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [_DowntmpStr appendString:string];
    NSLog(@"string  %@",string);
     //NSLog(@"DownVer%@  _UpdaUrl%@   _DownUpdataContents%@",DownVer,_UpdaUrl,_DownUpdataContents);
}

- (void) displayAlert:(id)sender{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"UpdatePrompt", @STR_LOCALIZED_FILE_NAME, nil) message:[NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"Discoveryofnewversion", @STR_LOCALIZED_FILE_NAME, nil),DownVer] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"TemporarilyUpdate", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"Update", @STR_LOCALIZED_FILE_NAME, nil), nil];
    [alert show];
    [alert release];
}

#pragma mark - 
#pragma  mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithString:DownVer] forKey:Ver];
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_UpdaUrl]];
    }else if (buttonIndex == 0){
        
        //[NSThread detachNewThreadSelector:@selector(secondThread:) toTarget:self withObject:nil];
    }
}

- (void) secondThread:(id)sender{
    usleep(1000000);
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
    
    [self performSelectorOnMainThread:@selector(switchView:) withObject:nil waitUntilDone:NO];

}

- (void) loginSuccessThread:(id)sender{
    
}

- (void) switchView: (id) param
{
    [self.startViewController.view removeFromSuperview];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //[self.window addSubview:cameraViewController.view];
    //navigationController.hidesBottomBarWhenPushed = YES;
    //cameraViewController.hidesBottomBarWhenPushed = YES;
    [self.window addSubview:navigationController.view];
    
    //navigationController.hidesBottomBarWhenPushed = NO;
    //navigationController.toolbarHidden = YES;
    //NSLog(@"%@",[self.window subviews]);
    //navigationController.hidesBottomBarWhenPushed = YES;
    //[self.window addSubview:cameraViewController.view];
    //NSLog(@"view class  %@",[navigationController.view class]);
}

- (void) switchRemotePlaybackView: (RemotePlaybackViewController*)_remotePlaybackViewController;
{
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    
    self.remotePlaybackViewController = _remotePlaybackViewController ;

    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.window addSubview:remotePlaybackViewController.view];
}

- (void) switchPlaybackView: (PlaybackViewController*)_playbackViewController
{
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    
    self.playbackViewController = _playbackViewController ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.window addSubview:playbackViewController.view];
}

- (void) switchPlayView:(PlayViewController *)_playViewController
{
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    self.window.rootViewController = nil;
   // NSLog(@"playView  %@",[_playViewController class]);
    self.playViewController = _playViewController ;
    self.playViewController.m_pPicPathMgt = m_pPicPathMgt;
    self.playViewController.m_pRecPathMgt = m_pRecPathMgt;
    self.playViewController.PicNotifyDelegate = picViewController;
    self.playViewController.RecNotifyDelegate = recViewController;
    //self.playViewController.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.window setRootViewController:_playViewController];
}

- (void) switchBack
{
    for (UIView *view in [self.window subviews]) {
        [view removeFromSuperview];
    }
    if (self.window.rootViewController != nil) {
        self.window.rootViewController = nil;        
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [self.window addSubview:navigationController.view];
    
    if (self.playViewController != nil) {
        self.playViewController = nil;
    } 
    if (self.playbackViewController != nil) {
        self.playbackViewController = nil;
    }

    if (self.remotePlaybackViewController != nil) {
        self.remotePlaybackViewController = nil;
    }
    
    if (spliteScreenVc != nil) {
        spliteScreenVc = nil;
    }
}

- (void) switchSpliteScreen:(Split_screenViewController*)_split{
    for (UIView* view in [self.window subviews]){
        [view removeFromSuperview];
    }
    self.window.rootViewController = nil;
    
    spliteScreenVc  = _split;//[[Split_screenViewController alloc] init];
    spliteScreenVc.cameraListMgt = m_pCameraListMgt;
    spliteScreenVc.ppppChannelMgt = m_pPPPPChannelMgt;
    [self.window setRootViewController:spliteScreenVc];
    
    if (self.playViewController != nil) {
        self.playViewController = nil;
    }
    if (self.playbackViewController != nil) {
        self.playbackViewController = nil;
    }
    
    if (self.remotePlaybackViewController != nil) {
        self.remotePlaybackViewController = nil;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    //NSLog(@"applicationWillResignActive");
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    //NSLog(@"applicationDidEnterBackground");
    
    if (playViewController != nil) {
        [playViewController StopPlay:1];
    }
    
    if (playbackViewController != nil) {
        [playbackViewController StopPlayback];
    }
    
    if (remotePlaybackViewController != nil) {
        [remotePlaybackViewController StopPlayback];
    }
    if (spliteScreenVc != nil) {
        [spliteScreenVc back:nil];
    }
    [cameraViewController StopPPPP];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
//    NSLog(@"applicationWillEnterForeground");

    [cameraViewController StartPPPPThread];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    //NSLog(@"applicationDidBecomeActive");    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    //NSLog(@"applicationWillTerminate");
    
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    //NSLog(@"applicationDidReceiveMemoryWarning");
}

- (void)dealloc 
{
    //NSLog(@"IpCameraClientAppDelegate dealloc");
    self.window = nil;
    self.startViewController = nil;
    self.navigationController = nil;
    self.playViewController = nil;
    self.remotePlaybackViewController = nil;
    self.playbackViewController = nil;
    spliteScreenVc = nil;
    if (self.loginVc != nil) {
        [self.loginVc release];
        self.loginVc = nil;
    }
    if (cameraViewController != nil) {
        [cameraViewController release];
        cameraViewController = nil;
    }
    PPPP_DeInitialize();
    if(m_pCameraListMgt != nil){
        [m_pCameraListMgt release];
        m_pCameraListMgt = nil;
    }
    if (picViewController != nil) {
        [picViewController release];
        picViewController = nil;
    }
    if (recViewController != nil) {
        [recViewController release];
        recViewController = nil;
    }
    if (_downLoadData != nil) {
        [_downLoadData release];
        _downLoadData = nil;
    }
    if (_DowntmpStr != nil) {
        [_DowntmpStr release];
        _DowntmpStr = nil;
    }
    SAFE_DELETE(m_pPPPPChannelMgt);
    [super dealloc];
}

+(BOOL)is43Version{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    // NSLog(@"version=%f",version);
    BOOL b=NO;
    if (version<4.5) {
        
        b=YES;
    }
    return b;
}


@end
