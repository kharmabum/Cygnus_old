//
//  CygnusManager.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SIM_MAP_TYPE_GROUP 0
#define SIM_MAP_TYPE_SHARED 1
#define SIM_MAP_TYPE_PRIVATE 2

#define CYGNUS_GROUP_MAP @"GroupMap"
#define CYGNUS_SHARED_MAP @"SharedMap"
#define CYGNUS_PRIVATE_MAP @"PrivateMap"

#define CYGNUS_MAP_ID @"uid"

@interface CygnusManager : NSObject
+ (void)loadSimulation;
+ (UIManagedDocument *)simulation;
+ (NSArray *)mapPinsForClient;

@end
