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

@property (assign, nonatomic) double FONT_SIZE;
@property (assign, nonatomic) double MESSAGE_WIDTH;

@property (strong, nonatomic) ImgurAccessToken *accessToken;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextView *messageInputField;

@property (weak, nonatomic) IBOutlet UILabel *currentPageLabel;

@property (strong, nonatomic) imgurServerManager *manager;

@property (strong, nonatomic) ImgurPagedConversation *conversation;

@property (assign, nonatomic) double OFFSET_FOR_KEYBOARD;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomConstraint;

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
    self.FONT_SIZE = 14;
    self.MESSAGE_WIDTH = self.view.frame.size.width - 110;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self reloadData];
    self.navigationItem.title = self.conversation.receiverName;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadData
{
    __weak typeof(self) weakSelf = self;
    [self.manager getConversationWithID:self.currentConversationID
                                ForPage:1
                             Completion:^(ImgurPagedConversation *resp)
     {
         weakSelf.conversation = resp;
         weakSelf.messageInputField.text = nil;
         weakSelf.currentPageLabel.text = [NSString stringWithFormat:@"%ld page",self.conversation.page - 1];
         [weakSelf.tableView reloadData];
     }];
}

- (void)updateData
{
    self.currentPageLabel.text = [NSString stringWithFormat:@"%ld page",self.conversation.page - 1];
    [self.tableView reloadData];
}

- (void)keyboardWillChange:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    self.OFFSET_FOR_KEYBOARD = keyboardFrameBeginRect.size.height;
    [self animateChangingOfConstraint:self.inputViewBottomConstraint ToValue:self.OFFSET_FOR_KEYBOARD WithDuration:0];
}

-(void)keyboardWillHide
{
    [self animateChangingOfConstraint:self.inputViewBottomConstraint ToValue:0 WithDuration:0.8];
}

- (void)animateChangingOfConstraint:(NSLayoutConstraint *)constraint ToValue:(CGFloat)value WithDuration:(double)duration
{
    constraint.constant = value;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:duration animations:^
     {
         [self.view layoutIfNeeded];
     }];
}

- (IBAction)previousPage:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    [self.manager getConversationWithID:self.currentConversationID
                                ForPage:self.conversation.page
                             Completion:^(ImgurPagedConversation *resp)
     {
         if ([resp.messages count] == 0)
             return;
         
         weakSelf.conversation = resp;
         [weakSelf updateData];
     }];
}

- (IBAction)nextPage:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    [self.manager getConversationWithID:self.currentConversationID
                                ForPage:self.conversation.page - 2
                             Completion:^(ImgurPagedConversation *resp)
     {
         weakSelf.conversation = resp;
         [weakSelf updateData];
     }];
}

- (IBAction)sendMessage:(UIButton *)sender
{
    if ([self.messageInputField.text length] != 0)
    [self.manager createMessageWithUser:self.currentConversationUserName
                                Message:self.messageInputField.text
                             Completion:^(NSDictionary *dict) 
    {
        [self reloadData];
    }];
    else
    {
        CAKeyframeAnimation* colorAnim = [CAKeyframeAnimation animationWithKeyPath:@"borderColor"];
        NSArray* colorValues = [NSArray arrayWithObjects:(id)[UIColor greenColor].CGColor,
                                (id)[UIColor redColor].CGColor, (id)[UIColor blueColor].CGColor,  nil];
        colorAnim.values = colorValues;
        colorAnim.calculationMode = kCAAnimationPaced;
        
        [self.messageInputField.layer addAnimation:colorAnim forKey:@"colorAnim"];
    }
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
    
    if ([self.accessToken.accountID isEqualToString:[NSString stringWithFormat:@"%ld", (long)messageOwnerId]])//current user's message
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
        ((MessageFromTableViewCell *)cell).fromLabel.text = [message objectForKey:@"FromUserName"];
    }
    else if ([cell isKindOfClass:[MessageInTableViewCell class]])
    {
        ((MessageInTableViewCell *)cell).messageLabel.text = [message objectForKey:@"message"];
        ((MessageInTableViewCell *)cell).fromLabel.text = [message objectForKey:@"FromUserName"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger index = indexPath.row;
    
    NSDictionary *messageDict = [self.conversation.messages objectAtIndex:index];
    
    NSString *message = [messageDict objectForKey:@"message"];
    
    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:self.FONT_SIZE] constrainedToSize:CGSizeMake(self.MESSAGE_WIDTH, 20000000000)];
    
    CGFloat height = MAX(size.height + 45, 100);
    
    return height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    return NO;
}

@end
