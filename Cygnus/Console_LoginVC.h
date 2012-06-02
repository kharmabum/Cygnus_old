//
//  Console_LoginVC.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Console_LoginVC;

@protocol LoginViewControllerDelegate <NSObject>
- (void)loginViewController:(Console_LoginVC *)sender didloginUserWithEmail:(NSString*)email;

@optional
- (void)loginViewControllerDidCancel:(Console_LoginVC *)sender;
@end

@interface Console_LoginVC : UIViewController
@property (nonatomic, strong) NSString *email;
@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;
@end
