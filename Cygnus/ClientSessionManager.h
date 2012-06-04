//
//  ClientSessionManager.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person+Cygnus.h"
#import "Group+Cygnus.h"
#import "Map+Cygnus.h"
#import "GroupMap+Cygnus.h"
#import "SharedMap+Cygnus.h"
#import "MapPin+Cygnus.h"

@interface ClientSessionManager : NSObject
+ (Person *)currentUser;
+ (BOOL)setCurrentUser:(NSString*)email;
+ (void)logoutCurrentUser;
// contain NSManagedObjects

+ (NSSet *)mapPinsForCurrentUser;
+ (NSSet *)activeGroupsForCurrentUser;
+ (NSSet *)activeMapsForCurrentUser;

+ (void)addToActiveGroups:(Group*)group;
+ (void)removeFromActiveGroups:(Group*)group;
+ (void)addToActiveMaps:(Map*)map;
+ (void)removeFromActiveMaps:(Map*)map;
@end
