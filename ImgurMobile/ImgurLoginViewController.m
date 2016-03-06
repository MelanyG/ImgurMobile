//
//  ImgurLoginViewController.m
//  ImgurMobile
//
//  Created by Melany on 2/20/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImgurLoginViewController.h"
#import "ImgurAccessToken.h"
#import "imgurServerManager.h"
#import "ImgurUser.h"

static BOOL firstTimeAppear;

NSString* const LoginNotification = @"LoginUpdated";

@interface ImgurLoginViewController ()<UIWebViewDelegate>

@property (copy, nonatomic) ASLoginCompletionBlock completionBlock;
@property (strong, nonatomic) UIWebView* webView;
//@property (assign, nonatomic) BOOL firstTimeAppear;
@property (strong, nonatomic) NSURLRequest* request;



@end

@implementation ImgurLoginViewController

- (id) initWithCompletionBlock:(ASLoginCompletionBlock) completionBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //firstTimeAppear = YES;
    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
    self.token = [ImgurAccessToken sharedToken];
    

    
    self.webView = [[UIWebView alloc] initWithFrame:r];
    
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.webView];
    self.webView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+44, self.view.frame.size.width, self.view.frame.size.height-44);
    
    //self.webView = webView;
      // UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    //do something like background color, title, etc you self
    //[self.view addSubview:navbar];

      //  UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
      //                                                                        target:self
      //                                                                        action:@selector(actionCancel:)];
      //  [self.navigationItem setRightBarButtonItem:item animated:YES];

    
    //self.navigationItem.title = @"Login";
        NSString* urlString =
    @"https://api.imgur.com/oauth2/authorize?"
    "client_id=b765b2f66708b7a&"
    "response_type=token";
    
    NSURL* url = [NSURL URLWithString:urlString];
    
  self.request = [NSURLRequest requestWithURL:url];
    
    
    self.webView.delegate = self;
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.webView loadRequest:self.request];
//    if (!firstTimeAppear) {
//        firstTimeAppear = YES;
    
        
//        [[imgurServerManager sharedManager] authorizeUser:^(imgurUser *user) {
//         
//            NSLog(@"AUTHORIZED!");
//            NSLog(@"%@", user.account_id);
//        }];
        
 //   }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    self.webView.delegate = nil;
}



#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    //ImgurAccessToken* token = [[ImgurAccessToken alloc] init];
    
    //#access_token=83cbcfabbe307897a21d062df1515fcad3d66765&expires_in=2419200&token_type=bearer&refresh_token=621ec2e692b00b4d8336aa21c06ae1ceca308a31&account_username=MostPerfectUser&account_id=31463385
  if(firstTimeAppear)
  {
          [self dismissViewControllerAnimated:YES
                             completion:nil];
  }
    else if(!self.token.token)
    {
    if ([[[request URL] description] rangeOfString:@"#access_token="].location != NSNotFound)
    {
      
        //firstTimeAppear = YES;
            
            NSLog(@"%@", [request URL]);
            NSString* query = [[request URL] description];
            NSArray* array = [query componentsSeparatedByString:@"#"];
            if ([array count] > 1)
            {
                query = [array lastObject];
            }
            
            NSArray* pairs = [query componentsSeparatedByString:@"&"];
            for (NSString* pair in pairs)
            {
                NSArray* values = [pair componentsSeparatedByString:@"="];
                if ([values count] == 2)
                {
                    NSString* key = [values firstObject];
                    if ([key isEqualToString:@"access_token"])
                    {
                        self.token.token = [values lastObject];
                    }
                    else if ([key isEqualToString:@"refresh_token"])
                    {
                        self.token.refresh_token = [values lastObject];
                    }
                    else if ([key isEqualToString:@"expires_in"])
                    {
                        NSDate *mydate = [NSDate date];
                        //NSTimeInterval interval = [[values lastObject] doubleValue];
                        NSTimeInterval secondsInEightHours = 12 * 60 * 60;
                        self.token.expirationDate  = [mydate dateByAddingTimeInterval:secondsInEightHours];
                        NSLog(@"Exp: %@", self.token.expirationDate);
                    }
                    else if ([key isEqualToString:@"account_username"])
                    {
                        
                        self.token.userName = [values lastObject];
                    }
                    else if ([key isEqualToString:@"account_id"]) {
                        
                        self.token.accountID = [values lastObject];
                    }
                }
            }
            
            self.token.dayOfLogin  =  [NSDate date];
            NSLog(@"day of login: %@", self.token.dayOfLogin);
            self.webView.delegate = nil;
            if (self.completionBlock)
            {
                self.completionBlock(self.token);
            }
            // Store the data
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:self.token.userName forKey:@"userName"];
            [defaults setObject:self.token.token forKey:@"access_token"];
            [defaults setObject:self.token.refresh_token forKey:@"refresh_token"];
            [defaults setObject:self.token.accountID forKey:@"account_id"];
            [defaults setObject:self.token.expirationDate forKey:@"expires_in"];
            [defaults setObject:self.token.dayOfLogin forKey:@"dayOfLogin"];
            
            NSLog(@"Updated User is:%@", self.token.userName);
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification
                                                            object:nil
                                                          userInfo:nil];
        [self dismissViewControllerAnimated:YES
                                     completion:nil];
            return NO;
        }
    }

    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //[self.webView removeFromSuperview];
    NSLog(@"finish");
}


#pragma mark - Actions

- (IBAction)backButtonSelected:(id)sender
{
    
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}

- (IBAction)cancelButtonSelected:(id)sender
{
    
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end