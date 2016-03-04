//
//  AppDelegate.m
//  ImgurMobile
//
//  Created by Melany on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "AppDelegate.h"
#import "imgurServerManager.h"
#import "imgurJSONParser.h"
#import "NotChalengingQueue.h"
#import "ImgurConversationPreview.h"
#import "ImgurPagedConversation.h"
#import "ConversationAndMessagingTVC.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*NotChalengingQueue *queue = [[NotChalengingQueue alloc] init];
    imgurServerManager *manager = [[imgurServerManager alloc] init];
    [manager getPhotosForPage:0 Section:hot Sort:viral Window:all Completion:^(NSDictionary *resp)
     {
         [queue addObject:resp];
         
         NSLog(@"%@",[queue getObject]);
     }];*/
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.token = [ImgurAccessToken sharedToken];
//    self.token.userName = [defaults objectForKey:@"userName"];
//    self.token.token = [defaults objectForKey:@"access_token"];
//    self.token.refresh_token = [defaults objectForKey:@"refresh_token"];
//    self.token.accountID = [defaults objectForKey:@"account_id"];
//    self.token.expirationDate = [defaults objectForKey:@"expires_in"];
    
  /*  NotChalengingQueue *queue = [[NotChalengingQueue alloc] init];
    imgurServerManager *manager = [imgurServerManager sharedManager];
    
    [manager getPhotosForPage:0 Section:hot Sort:viral Window:all Completion:^(NSDictionary *resp)
     {
         if ([resp objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY])
         {
             //get error
         }
         else if ([resp objectForKey:IMGUR_SERVER_MANAGER_STATUS_KEY])
         {
             //get statuscode
         }
         else
         {
             [queue addObject:resp];
             
             NSLog(@"%@",[queue getObject]);
         }
     }];*/

   
    
   /* imgurServerManager *manager = [imgurServerManager sharedManager];
    
    [manager getComentsForId:@"CUs0622" IsAlbum:NO Completion:^(NSDictionary *resp)
    {
        
    }];*/
    
    /*imgurServerManager *manager = [imgurServerManager sharedManager];
     
     [manager getAllConversationsPreviewForCurrentUserCompletion:^(NSArray *resp)
     {
     ImgurConversationPreview *prev = [resp firstObject];
     [manager getConversationWithID:prev.conversationId ForPage:1 Completion:^(ImgurPagedConversation *resp) {
     NSLog(@"%@",resp);
     }];
     }];*/
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
