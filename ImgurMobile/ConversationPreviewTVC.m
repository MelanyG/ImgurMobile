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
    
    [self reloadData];
    
    [self addNavButtonDeletionProcess:NO];
}

- (void)reloadData
{
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
}

- (void)addNavButtonDeletionProcess:(BOOL)deletionProcess
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
    
    UIImage *deleteImage;
    if (deletionProcess)
        deleteImage = [UIImage imageNamed:@"ok_icon"];
    else
        deleteImage = [UIImage imageNamed:@"delete_icon"];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:ImageRect];
    [deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
    [deleteButton addTarget:self
                      action:@selector(actionEdit:)
            forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *deleteBarButton = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    
    self.navigationItem.rightBarButtonItems = @[deleteBarButton, messageBarButton];
}

- (void) actionEdit:(UIBarButtonItem*) sender
{
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    if (self.tableView.editing)
    {
        [self addNavButtonDeletionProcess:YES];
    }
    else
    {
        [self addNavButtonDeletionProcess:NO];
    }
}


- (void)showNewMessageVC
{
    NewConversationVC *conversationVC = [[NewConversationVC alloc] init];
    conversationVC.delegate = self;
    [self.navigationController pushViewController:conversationVC animated:YES];
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
    cell.whenLabel.text = previewConversation.date;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSInteger index = indexPath.row;
        
        ImgurConversationPreview *preview = [self.conversationPreviewsArray objectAtIndex:index];
        
        NSInteger previewID = preview.conversationId;
        
        __weak typeof(self) weakSelf = self;
        [self.manager deleteConversationWithID:previewID Completion:^(NSDictionary *dict) 
        {
            if ([dict objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY])
            {
                
            }
            else if ([dict objectForKey:IMGUR_SERVER_MANAGER_STATUS_KEY])
            {
                
            }
            else
            {
                [weakSelf.tableView beginUpdates];
                [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
                NSMutableArray *temp = [self.conversationPreviewsArray mutableCopy];
                [temp removeObjectAtIndex:index];
                weakSelf.conversationPreviewsArray = temp;
                [weakSelf.tableView endUpdates];
            
                BOOL isEditing = self.tableView.editing;
                [self.tableView setEditing:!isEditing animated:YES];
                
                [self addNavButtonDeletionProcess:NO];
            }
        }];
    }
}

@end
