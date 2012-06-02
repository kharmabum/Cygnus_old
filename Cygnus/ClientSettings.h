//
//  ClientSettings.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person+Cygnus.h"

@interface ClientSettings : NSObject
+ (Person *)currentUser;
+ (BOOL)setCurrentUser:(NSString*)email;

@end
