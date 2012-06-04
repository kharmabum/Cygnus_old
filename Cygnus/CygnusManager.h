//
//  CygnusManager.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person+Cygnus.h"

#define SIM_MAP_TYPE_GROUP      0
#define SIM_MAP_TYPE_SHARED     1
#define SIM_MAP_TYPE_PRIVATE    2

#define CYGNUS_GROUP_MAP        @"GroupMap"
#define CYGNUS_SHARED_MAP       @"SharedMap"
#define CYGNUS_PRIVATE_MAP      @"PrivateMap"

#define CYGNUS_MAP_ID           @"uid"

#define CURRENT_USER_EMAIL          @"currentUserEmail"
#define CURRENT_USER_ACTIVE_GROUPS  @"currentUserActiveGroups"
#define CURRENT_USER_ACTIVE_MAPS    @"currentUserActiveMaps"
#define CURRENT_USER_MAP_PREFERENCE @"currentUserMapPreference"

#define MAP_TYPE_STANDARD   0
#define MAP_TYPE_HYBRID     1
#define MAP_TYPE_SATELLITE  2

@interface CygnusManager : NSObject

+ (void)loadSimulation;
+ (UIManagedDocument *)simulation;
+ (NSArray *)mapPinsForUser:(Person*)User;

@end
