//
//  PrivateMap+Cygnus.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrivateMap.h"

@interface PrivateMap (Cygnus)
//+ (PrivateMap *)privateMapFromPlistData:(NSDictionary*)privateMap inManagedObjectContext:(NSManagedObjectContext*)context;

+ (PrivateMap *)privateMapFromUID:(NSNumber*)mapUID inManagedObjectContext:(NSManagedObjectContext*)context;

@end
