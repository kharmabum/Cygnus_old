//
//  Person+Cygnus.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@interface Person (Cygnus)

+ (Person *)personFromPlistData:(NSDictionary*)personInfo inManagedObjectContext:(NSManagedObjectContext*)context;

+ (Person *)personFromUID:(NSNumber*)personUID inManagedObjectContext:(NSManagedObjectContext*)context;

+ (Person *)personFromEmail:(NSString*)email inManagedObjectContext:(NSManagedObjectContext*)context;

@end
