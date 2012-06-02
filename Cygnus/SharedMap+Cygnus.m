//
//  SharedMap+Cygnus.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharedMap+Cygnus.h"

@implementation SharedMap (Cygnus)

+ (SharedMap *)sharedMapFromUID:(NSNumber*)mapUID inManagedObjectContext:(NSManagedObjectContext*)context
{
    SharedMap *map = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SharedMap"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [mapUID intValue]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1) || ![matches count]) {
        // handle error
    } else {
        map = [matches lastObject];
    }
    return map;
    
}


@end
