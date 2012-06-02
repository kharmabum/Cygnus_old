//
//  Map+Cygnus.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Map.h"

@interface Map (Cygnus)

+ (Map *)mapFromPlistData:(NSDictionary*)map inManagedObjectContext:(NSManagedObjectContext*)context;

@end
