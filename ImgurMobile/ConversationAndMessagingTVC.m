//
//  ConversationAndMessagingTVC.m
//  ImgurMobile
//
//  Created by alex4eetah on 3/4/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ConversationAndMessagingTVC.h"
#import "imgurServerManager.h"
#import "ImgurPagedConversation.h"
#import "MessageFromTableViewCell.h"
#import "MessageInTableViewCell.h"
#import "ImgurAccessToken.h"

@interface ConversationAndMessagingTVC ()

@property (strong, nonatomic) ImgurAccessToken *accessToken;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *messageInputField;

@property (weak, nonatomic) IBOutlet UITextField *receiverInputField;

@property (strong, nonatomic) imgurServerManager *manager;

@property (strong, nonatomic) ImgurPagedConversation *conversation;

@end

@implementation ConversationAndMessagingTVC

- (imgurServerManager *)manager
{
    if (!_manager)
    {
        _manager = [imgurServerManager sharedManager];
    }
    return _manager;
}

- (ImgurAccessToken *)accessToken
{
    if (!_accessToken)
    {
        _accessToken = [ImgurAccessToken sharedToken];
    }
    return _accessToken;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.manager getConversationWithID:self.currentConversationID
                                ForPage:1
                             Completion:^(ImgurPagedConversation *resp)
    {
        self.conversation = resp;
        [self.tableView reloadData];
    }];
}

- (IBAction)sendMessage:(UIButton *)sender
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversation.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* fromIdentifier = @"MessageFromTableViewCell";
    static NSString* inIdentifier = @"MessageInTableViewCell";
    
    NSInteger index = indexPath.row;
    
    NSDictionary *message = [self.conversation.messages objectAtIndex:index];
    NSInteger messageOwnerId = [[message objectForKey:@"FromUserID"] integerValue];
    
    if ([self.accessToken.accountID isEqualToString:[NSString stringWithFormat:@"%d", messageOwnerId]])//current user's message
    {
        MessageFromTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:fromIdentifier];
        [self configureCell:cell WithDictionary:message atIndexPath:indexPath];
        return cell;
    }
    else
    {
        MessageInTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:inIdentifier];
        [self configureCell:cell WithDictionary:message atIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)configureCell:(UITableViewCell *)cell WithDictionary:(NSDictionary *)message atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MessageFromTableViewCell class]])
    {
        ((MessageFromTableViewCell *)cell).messageLabel.text = [message objectForKey:@"message"];
    }
    else if ([cell isKindOfClass:[MessageInTableViewCell class]])
    {
        ((MessageInTableViewCell *)cell).messageLabel.text = [message objectForKey:@"message"];
    }
}


@end
