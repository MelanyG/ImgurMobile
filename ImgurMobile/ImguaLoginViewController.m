//
//  ImguaLoginViewController.m
//  ImgurMobile
//
//  Created by Melany on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImguaLoginViewController.h"
#import "ImguaAccessToken.h"
#import "imgurServerManager.h"
#import "ImgurUser.h"

@interface ImguaLoginViewController ()<UIWebViewDelegate>



@property (copy, nonatomic) ASLoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView* webView;
@property (assign, nonatomic) BOOL firstTimeAppear;

@end

@implementation ImguaLoginViewController

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
        self.firstTimeAppear = YES;    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:r];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
//    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                          target:self
//                                                                          action:@selector(actionCancel:)];
//    [self.navigationItem setRightBarButtonItem:item animated:NO];
    
    self.navigationItem.title = @"Login";
    
    NSString* urlString =
    @"https://api.imgur.com/oauth2/authorize?"
"client_id=b765b2f66708b7a&"
"response_type=token";
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    webView.delegate = self;
    
    [webView loadRequest:request];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        
        
        [[imgurServerManager sharedManager] authorizeUser:^(ImgurUser *user) {
            
            NSLog(@"AUTHORIZED!");
            NSLog(@"%@", user.accountUserName);
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    self.webView.delegate = nil;
}

#pragma mark - Actions

//- (void) actionCancel:(UIBarButtonItem*) item {
//    
//    if (self.completionBlock) {
//        self.completionBlock(nil);
//    }
//    
//    [self dismissViewControllerAnimated:YES
//                             completion:nil];
//    
//}

#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
       ImguaAccessToken* token = [[ImguaAccessToken alloc] init];
    
//#access_token=83cbcfabbe307897a21d062df1515fcad3d66765&expires_in=2419200&token_type=bearer&refresh_token=621ec2e692b00b4d8336aa21c06ae1ceca308a31&account_username=MostPerfectUser&account_id=31463385


 if ([[[request URL] description] rangeOfString:@"#access_token="].location != NSNotFound)
 {
        
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
                    token.token = [values lastObject];
                }
                else if ([key isEqualToString:@"expires_in"])
                {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                }
                else if ([key isEqualToString:@"account_username"]) {
                    
                    token.userName = [values lastObject];
                }
                else if ([key isEqualToString:@"account_id"]) {
                    
                    token.accountID = [values lastObject];
                }

            }
        }

        self.webView.delegate = nil;
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
        
        
        
        //[self dismissViewControllerAnimated:YES
        //                         completion:nil];
        
        return NO;
    }
    
    return YES;
}

@end
