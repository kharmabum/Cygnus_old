//
//  Group+Cygnus.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Group.h"

@interface Group (Cygnus)

+ (Group *)groupFromPlistData:(NSDictionary*)group inManagedObjectContext:(NSManagedObjectContext*)context;


@end