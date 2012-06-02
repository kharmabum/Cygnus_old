//
//  Group.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AuxMap, GroupMap, Person;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSSet *auxMaps;
@property (nonatomic, retain) GroupMap *groupMap;
@property (nonatomic, retain) NSSet *members;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addAuxMapsObject:(AuxMap *)value;
- (void)removeAuxMapsObject:(AuxMap *)value;
- (void)addAuxMaps:(NSSet *)values;
- (void)removeAuxMaps:(NSSet *)values;

- (void)addMembersObject:(Person *)value;
- (void)removeMembersObject:(Person *)value;
- (void)addMembers:(NSSet *)values;
- (void)removeMembers:(NSSet *)values;

@end
