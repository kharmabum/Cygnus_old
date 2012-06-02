//
//  PrivateMap+Cygnus.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrivateMap+Cygnus.h"

@implementation PrivateMap (Cygnus)

+ (PrivateMap *)privateMapFromUID:(NSNumber*)mapUID inManagedObjectContext:(NSManagedObjectContext*)context
{
    
    PrivateMap *map = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PrivateMap"];
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
