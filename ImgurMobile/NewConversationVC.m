//
//  NewConversationVC.m
//  ImgurMobile
//
//  Created by alex4eetah on 3/6/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define IPHONE   UIUserInterfaceIdiomPhone


#import "NewConversationVC.h"
#import "imgurServerManager.h"

@interface NewConversationVC ()

@property (weak, nonatomic) IBOutlet UITextField *receiverNameField;

@property (weak, nonatomic) IBOutlet UITextView *messageField;

@property (assign, nonatomic) double OFFSET_FOR_KEYBOARD;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageViewHeighConstraint;

@property (weak, nonatomic) IBOutlet UIView *spacingView;

@property (strong, nonatomic) imgurServerManager *manager;

@end

@implementation NewConversationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [self adjustMessageHeight];
    
    self.navigationItem.title = @"New mesage";
}

- (void)adjustMessageHeight
{
    if (IDIOM == IPAD)
    {
        self.messageViewHeighConstraint.constant = self.view.frame.size.height * 0.4;
    }
    else if (IDIOM == IPHONE)
    {
        self.messageViewHeighConstraint.constant = self.view.frame.size.height * 0.1;
    }
}

- (void)keyboardWillChange:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    self.OFFSET_FOR_KEYBOARD = keyboardFrameBeginRect.size.height;
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide
{
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.messageField])
    {
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    if (self.messageField.isFirstResponder)
    {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        CGRect rect = self.view.frame;
        if (movedUp)
        {
            rect.origin.y -= self.OFFSET_FOR_KEYBOARD;
            rect.origin.y += self.spacingView.frame.size.height;
        }
        else
        {
            rect.origin.y += self.OFFSET_FOR_KEYBOARD;
            rect.origin.y -= self.spacingView.frame.size.height;
        }
        self.view.frame = rect;
        
        [UIView commitAnimations];
        
        
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.view endEditing:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self adjustMessageHeight];
}

- (imgurServerManager *)manager
{
    if (!_manager)
    {
        _manager = [imgurServerManager sharedManager];
    }
    return _manager;
}

- (IBAction)sendMessage:(UIButton *)sender
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.1;
    anim.repeatCount = 4;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.fromValue = [NSNumber numberWithFloat:-5.f];
    anim.toValue = [NSNumber numberWithFloat:5.f];
    
    if ([self.receiverNameField.text length] == 0)
    {
        [self.receiverNameField.layer addAnimation:anim forKey:@"wrongMove"];
    }
    else if ([self.messageField.text length] == 0)
    {
        [self.messageField.layer addAnimation:anim forKey:@"wrongMove"];
    }
    else
    {
        [self.manager createMessageWithUser:self.receiverNameField.text
                                    Message:self.self.messageField.text
                                 Completion:^(NSDictionary *dict)
         {
             if ([dict objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY])
             {
                 if ([[dict objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY] isEqualToString:@"unsupported URL"])
                     [self showAlertWithHeader:@"Wrong input" AndBody:@"Receiver name must consist of english laters and can't include white spaces"];
                 else
                     [self showAlertWithHeader:@"Error" AndBody:[dict objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY]];
                 
             }
             else if ([dict objectForKey:IMGUR_SERVER_MANAGER_STATUS_KEY])
             {
                 [self showAlertWithHeader:@"Wrong input" AndBody:[dict objectForKey:IMGUR_SERVER_MANAGER_STATUS_KEY]];
             }
             else
             {
                 [self.delegate reloadData];
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }];
    }
}

- (void)showAlertWithHeader:(NSString *)header AndBody:(NSString *)body
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:header
                                                                             message:body
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
