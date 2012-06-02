//
//  SharedMap+Cygnus.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharedMap.h"

@interface SharedMap (Cygnus)

//+ (SharedMap *)sharedMapFromPlistData:(NSDictionary*)sharedMap inManagedObjectContext:(NSManagedObjectContext*)context;

+ (SharedMap *)sharedMapFromUID:(NSNumber*)mapUID inManagedObjectContext:(NSManagedObjectContext*)context;
@end
