//
//  NotChalengingQuee.m
//  ImgurMobile
//
//  Created by Roman Stasiv on 2/22/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "NotChalengingQueue.h"
#import "Node.h"
#import "pthread.h"


@interface NotChalengingQueue ()
{
    pthread_mutex_t lock;
    pthread_cond_t cl;
}
@property (strong, nonatomic) Node *first, *last;
//@property pthread_mutex_t lock;
//@property pthread_cond_t cl;
@end


@implementation NotChalengingQueue

-(id)init
{
    if (self = [super init])
    {
        self.first = nil;
        self.last = nil;
        pthread_mutex_init(&lock, NULL);
        pthread_cond_init(&cl, NULL);
    }
    return self;
}

-(void)addObject: (id) object
{
    pthread_mutex_lock(&lock);
    Node * tempNode = [[Node alloc] init];
    tempNode.data = object;
    
    if (self.last)
    {
        self.last.next = tempNode;
        self.last = tempNode;
    }
    if (self.first == nil)
    {
        self.first = self.last = tempNode;
    }
    
    pthread_cond_signal(&cl);
    pthread_mutex_unlock(&lock);
}

-(id)getObject
{
    pthread_mutex_lock(&lock);
    
    while(self.first == nil)
    {
        NSDate *waitStart = [NSDate date];
        pthread_cond_wait(&cl, &lock);
        static float waitTime = 0;
        waitTime += [waitStart timeIntervalSinceNow]*-1;
        NSLog(@"%f",waitTime);
    }
    
    id data = self.first.data;
    
    self.first = self.first.next;
    
    
    pthread_mutex_unlock(&lock);
    return data;
}


@end
