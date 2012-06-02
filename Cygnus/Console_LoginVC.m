//
//  Console_LoginVC.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Console_LoginVC.h"

@interface Console_LoginVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *loginPromptLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cygnusImageView;

@end

@implementation Console_LoginVC

@synthesize email = _email;
@synthesize loginPromptLabel = _loginPromptLabel;
@synthesize emailTextField = _emailTextField;
@synthesize cygnusImageView = _cygnusImageView;
@synthesize delegate = _delegate;

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.email = self.emailTextField.text;
    [self.delegate loginViewController:self didloginUserWithEmail:self.email];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.emailTextField.text length]) {
        [self.emailTextField resignFirstResponder];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.emailTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailTextField.delegate = self;
}

- (void)viewDidUnload
{
    [self setEmailTextField:nil];
    [self setLoginPromptLabel:nil];
    [self setCygnusImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

/*
 - (IBAction)cancel
 {
 if ([self.delegate respondsToSelector:@selector(askerViewControllerDidCancel:)]) {
 [self.delegate askerViewControllerDidCancel:self];
 } else {
 [self.presentingViewController dismissModalViewControllerAnimated:YES];
 }
 }*/


@end
