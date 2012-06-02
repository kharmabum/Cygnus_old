//
//  GroupMap+Cygnus.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupMap+Cygnus.h"

@implementation GroupMap (Cygnus)


+ (GroupMap *)groupMapFromUID:(NSNumber*)mapUID inManagedObjectContext:(NSManagedObjectContext*)context
{
    
    GroupMap *map = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GroupMap"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", mapUID];
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
