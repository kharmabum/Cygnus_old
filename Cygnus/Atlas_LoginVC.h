//
//  Atlas_LoginVC.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Atlas_LoginVC;

@protocol LoginViewControllerDelegate <NSObject>
- (void)loginViewController:(Atlas_LoginVC *)sender didloginUserWithEmail:(NSString*)email;

@optional
- (void)loginViewControllerDidCancel:(Atlas_LoginVC *)sender;
@end

@interface Atlas_LoginVC : UIViewController
@property (nonatomic, strong) NSString *email;
@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;
@end
