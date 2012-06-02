//
//  ClientSettings.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClientSettings.h"
#import "CygnusManager.h"

#define CURRENT_USER_EMAIL @"currentUserEmail"
@implementation ClientSettings

static Person *_currentUser; 


+ (Person *)currentUser
{
    if (!_currentUser) {
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_EMAIL];
        [ClientSettings setCurrentUser:email];
    }
    return _currentUser;
}

+ (BOOL)setCurrentUser:(NSString*)email
{    
    if (_currentUser) [ClientSettings logout];    
    Person *user = [Person personFromEmail:email inManagedObjectContext:[[CygnusManager simulation] managedObjectContext]];
    if (user) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:email forKey:CURRENT_USER_EMAIL];
        [defaults synchronize];
        _currentUser = user;
        return YES;
    } else {
        //ERROR user not found
        return NO;
    }
}

+ (void)logout
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CURRENT_USER_EMAIL];
    _currentUser = nil;
}

@end
