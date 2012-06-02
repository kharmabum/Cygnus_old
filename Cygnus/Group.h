//
//  Group.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GroupMap, Person, SharedMap;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSSet *sharedMaps;
@property (nonatomic, retain) GroupMap *groupMap;
@property (nonatomic, retain) NSSet *members;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addSharedMapsObject:(SharedMap *)value;
- (void)removeSharedMapsObject:(SharedMap *)value;
- (void)addSharedMaps:(NSSet *)values;
- (void)removeSharedMaps:(NSSet *)values;

- (void)addMembersObject:(Person *)value;
- (void)removeMembersObject:(Person *)value;
- (void)addMembers:(NSSet *)values;
- (void)removeMembers:(NSSet *)values;

@end
