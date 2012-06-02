//
//  Event+Cygnus.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@interface Event (Cygnus)

+ (Event *)eventFromPlistData:(NSDictionary*)event inManagedObjectContext:(NSManagedObjectContext*)context;

@end
