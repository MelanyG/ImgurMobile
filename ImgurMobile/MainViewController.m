//
//  MainViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "MainViewController.h"
#import "NotChalengingQueue.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NotChalengingQueue *queue = [[NotChalengingQueue alloc] init];
    
    dispatch_queue_t prodQueue = dispatch_queue_create("producer_queue", NULL);
    dispatch_async(prodQueue,
                   ^{
                       while (true)
                       {
                           int i = arc4random_uniform(1000);
                           [queue addObject:[NSNumber numberWithInt:i]];
                           NSLog(@"ADD----->%d", i);
                       }
                   });
    
    dispatch_queue_t consQueue = dispatch_queue_create("cons_queue", NULL);
    dispatch_async(consQueue,
                   ^{
                       while (true)
                       {
                           NSLog(@"GET----->%@", [queue getObject]);
                       }
                   });
    
    dispatch_queue_t cons2Queue = dispatch_queue_create("cons2_queue", NULL);
    dispatch_async(cons2Queue,
                   ^{
                       while (true)
                       {
                           NSLog(@"GET2----->%@", [queue getObject]);
                       }
                   });
    dispatch_queue_t cons3Queue = dispatch_queue_create("cons3_queue", NULL);
    dispatch_async(cons3Queue,
                   ^{
                       while (true)
                       {
                           NSLog(@"GET3----->%@", [queue getObject]);
                       }
                   });
    
    dispatch_queue_t cons4Queue = dispatch_queue_create("cons4_queue", NULL);
    dispatch_async(cons4Queue,
                   ^{
                       while (true)
                       {
                           NSLog(@"GET4----->%@", [queue getObject]);
                       }
                   });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
