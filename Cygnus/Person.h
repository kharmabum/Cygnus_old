//
//  Person.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, PrivateMap;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber * online;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) NSSet *privateMaps;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

- (void)addPrivateMapsObject:(PrivateMap *)value;
- (void)removePrivateMapsObject:(PrivateMap *)value;
- (void)addPrivateMaps:(NSSet *)values;
- (void)removePrivateMaps:(NSSet *)values;

@end
