//
//  GroupMap+Cygnus.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "GroupMap.h"

@interface GroupMap (Cygnus)

+ (GroupMap *)groupMapFromPlistData:(NSDictionary*)groupMap inManagedObjectContext:(NSManagedObjectContext*)context;

@end
