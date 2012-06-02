//
//  GroupMap.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Map.h"

@class Group;

@interface GroupMap : Map

@property (nonatomic, retain) Group *group;

@end
