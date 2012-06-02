//
//  AuxMap+Cygnus.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "AuxMap.h"

@interface AuxMap (Cygnus)

+ (AuxMap *)auxMapFromPlistData:(NSDictionary*)auxMap inManagedObjectContext:(NSManagedObjectContext*)context;

@end
