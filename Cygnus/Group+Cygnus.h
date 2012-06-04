//
//  Group+Cygnus.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Group.h"

@interface Group (Cygnus)

+ (Group *)groupFromPlistData:(NSDictionary*)groupInfo inManagedObjectContext:(NSManagedObjectContext*)context;

+ (Group *)groupFromUID:(NSNumber*)groupUID inManagedObjectContext:(NSManagedObjectContext*)context;

@end
