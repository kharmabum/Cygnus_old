//
//  MapPin+Cygnus.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapPin.h"

@interface MapPin (Cygnus)

+ (MapPin *)mapPinFromPlistData:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext*)context;


@end
