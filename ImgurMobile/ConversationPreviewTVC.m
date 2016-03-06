//
//  ConversationPreviewTVC.m
//  ImgurMobile
//
//  Created by alex4eetah on 3/4/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ConversationPreviewTVC.h"
#import "imgurServerManager.h"
#import "ImgurConversationPreview.h"
#import "PreviewTableViewCell.h"
#import "ConversationAndMessagingTVC.h"

@interface ConversationPreviewTVC ()

@property (strong, nonatomic) NSArray *conversationPreviewsArray;

@property (strong, nonatomic) imgurServerManager *manager;

@end

@implementation ConversationPreviewTVC

- (imgurServerManager *)manager
{
    if (!_manager)
    {
        _manager = [imgurServerManager sharedManager];
    }
    return _manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.manager getAllConversationsPreviewForCurrentUserCompletion:^(NSArray *resp)
    {
        if ([resp count] == 0)
            self.navigationItem.title = @"No Conversations";
        else
        {
            self.conversationPreviewsArray = resp;
            [self.tableView reloadData];
            self.navigationItem.title = @"Conversations";
        }
    }];
    [self addNavButton];
}

- (void)addNavButton
{
    CGRect ImageRect = CGRectMake(0, 0, 30, 30);
    
    UIImage *messageImage = [UIImage imageNamed:@"new_message"];
    UIButton *messageButton = [[UIButton alloc] initWithFrame:ImageRect];
    [messageButton setBackgroundImage:messageImage forState:UIControlStateNormal];
    [messageButton addTarget:self
                    action:@selector(showNewMessageVC)
          forControlEvents:UIControlEventTouchUpInside];
    [messageButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *messageBarButton = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    
    self.navigationItem.rightBarButtonItems = @[messageBarButton];
}

- (void)showNewMessageVC
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversationPreviewsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"PreviewTableViewCell";
    
    PreviewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(PreviewTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    ImgurConversationPreview *previewConversation = [self.conversationPreviewsArray objectAtIndex:index];
    
    cell.withWhomYouComunicate.text = previewConversation.receiverName;
    cell.messageLabel.text = previewConversation.lastMessage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    ImgurConversationPreview *previewConversation = [self.conversationPreviewsArray objectAtIndex:index];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConversationAndMessagingTVC * ConversationAMTVC = (ConversationAndMessagingTVC *)[sb instantiateViewControllerWithIdentifier:@"ConversationAndMessagingTVC"];
    
    ConversationAMTVC.currentConversationID = previewConversation.conversationId;
    ConversationAMTVC.currentConversationUserName = previewConversation.receiverName;
    
    [self.navigationController pushViewController:ConversationAMTVC animated:YES];
}

@end
