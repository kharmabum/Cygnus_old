//
//  CygnusManager.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person+Cygnus.h"

// SIMULATION IMPORT

#define SIM_MAP_TYPE_GROUP                      0
#define SIM_MAP_TYPE_SHARED                     1
#define SIM_MAP_TYPE_PRIVATE                    2

#define CYGNUS_GROUP_MAP                        @"GroupMap"
#define CYGNUS_SHARED_MAP                       @"SharedMap"
#define CYGNUS_PRIVATE_MAP                      @"PrivateMap"

// USER SETTINGS

#define CURRENT_USER_EMAIL                      @"currentUserEmail"
#define CURRENT_USER_ACTIVE_GROUPS              @"currentUserActiveGroups"
#define CURRENT_USER_ACTIVE_MAPS                @"currentUserActiveMaps"
#define CURRENT_USER_MAP_PREFERENCE             @"currentUserMapPreference"

#define CURRENT_USER_BEACON_ENABLED             @"beacon_enabled"
#define CURRENT_USER_BEACON_FREQUENCY           @"beacon_frequency"
#define CURRENT_USER_BEACON_RANGE               @"beacon_range"

// MAP CONSTANTS

#define MAP_TYPE_STANDARD                       0
#define MAP_TYPE_HYBRID                         1
#define MAP_TYPE_SATELLITE                      2

#define MAP_PIN_VIEW_LOCATION_DEFAULT                   @"locViewDefault"
#define MAP_PIN_VIEW_LOCATION_CANEDIT                   @"locViewEditable"

#define MAP_PIN_VIEW_EVENT_DEFAULT                      @"eventViewDefault"
#define MAP_PIN_VIEW_EVENT_CANEDIT                      @"eventViewEditable"

#define MAP_PIN_VIEW_PARTY_DEFAULT                      @"partyViewDefault"
#define MAP_PIN_VIEW_PARTY_CANEDIT                      @"partyViewEditable"

#define MAP_PIN_VIEW_BEACON_INACTIVE                    @"beaconInactiveView"
#define MAP_PIN_VIEW_BEACON_ACTIVE                      @"beaconActiveView"
#define MAP_PIN_VIEW_BEACON_FOLLOW                      @"beaconFollowView"

@interface CygnusManager : NSObject

+ (void)loadSimulation;
+ (UIManagedDocument *)simulation;
+ (void)saveUserSettings;
+ (NSArray *)mapPinsForUser:(Person*)User;

@end
