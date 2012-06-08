//
//  Atlas_EntityListTVC.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Atlas_EntityListTVC.h"
#import "ClientSessionManager.h"
#import <CoreLocation/CoreLocation.h>

@interface Atlas_EntityListTVC ()
@property (strong, nonatomic) NSArray *activeMapPins;
@property (strong, nonatomic) NSMutableArray *nearbyActors;

@end

@implementation Atlas_EntityListTVC
@synthesize activeMapPins = _activeMapPins;
@synthesize nearbyActors = _nearbyActors;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Person *currentUser = [ClientSessionManager currentUser];
    self.activeMapPins = [[ClientSessionManager mapPinsForCurrentUser] allObjects];
    self.nearbyActors = [NSMutableArray array];
    
    NSLog(@"size of activePins - %d", self.activeMapPins.count);
    CLLocation *currentUserLocation = [[CLLocation alloc] initWithLatitude:[[currentUser latitude] doubleValue] longitude:[[currentUser latitude] doubleValue]];
    
    
    dispatch_queue_t detectNearbyActors = dispatch_queue_create("detect_nearby_actors", NULL);
    dispatch_async(detectNearbyActors, ^{
        for (Group *group in [ClientSessionManager activeGroupsForCurrentUser]) {
            for (Person *member in group.members) {
                if (member != currentUser) {
                    CLLocation *memberLocation = [[CLLocation alloc] initWithLatitude:[[member latitude] doubleValue] 
                                                                            longitude:[[member latitude] doubleValue]];
                    CLLocationDistance distance = [currentUserLocation distanceFromLocation:memberLocation];
                    if (distance < [currentUser.broadcastRange intValue] && distance < [member.broadcastRange intValue]) {
                        NSArray *actorData = [NSArray arrayWithObjects:member, distance, nil];
                        NSLog(@"in the deep - %@", actorData);

                        [self.nearbyActors addObject:actorData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
                        });
                    }
                }
            }
        }
    });
    dispatch_release(detectNearbyActors);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = (!section) ? self.nearbyActors.count : self.activeMapPins.count;
    NSLog(@"number of rows in section %d - %d", section, number);
    NSLog(@"%@",self.activeMapPins);
    NSLog(@"%@",[ClientSessionManager mapPinsForCurrentUser]);

    return number;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section) ? @"Places" : @"People";
}

#define ATLAS_LIST_LOCATION_CELL_IDENTIFIER         @"AtlasList_LocationCell"
#define ATLAS_LIST_PERSON_CELL_IDENTIFIER           @"AtlasList_PersonCell"


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    UITableViewCell *cell;

    NSURL *imgURL;
    if (!indexPath.section) {
        cellIdentifier = ATLAS_LIST_PERSON_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *actorData = [self.nearbyActors objectAtIndex:indexPath.row];
        Person *person = [actorData objectAtIndex:0];
        NSString *sharedGroupList = @"";
        NSMutableSet *sharedGroups = [NSMutableSet setWithSet:[[ClientSessionManager currentUser] groups]];
        [sharedGroups intersectsSet:person.groups];
        for (Group *group in sharedGroups) {
            NSString *format = ([sharedGroupList length]) ? @", %@": @"%@";
            [sharedGroupList stringByAppendingFormat:format, group.name];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",person.first_name, person.last_name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %f km", sharedGroupList, [actorData objectAtIndex:1]];
        imgURL = [NSURL URLWithString:person.imgURL];
    } else {
        cellIdentifier = ATLAS_LIST_LOCATION_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        MapPin *pin = [self.activeMapPins objectAtIndex:indexPath.row];
        //TODO - implement party notifier to inform attendence count, also add # of events on location label
        cell.textLabel.text = pin.location_name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", pin.map.name];
        imgURL = [NSURL URLWithString:pin.imgURL];
    }
    
    cell.imageView.hidden = NO;
    
    dispatch_queue_t tableCellImageFetcher = dispatch_queue_create("table_cell_image_fetcher", NULL);
    dispatch_async(tableCellImageFetcher, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imgURL];
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.tableView.visibleCells containsObject:cell]) {
                    cell.imageView.image = image;
                    cell.imageView.frame = CGRectMake(0, 0, 45, 45);
                    [cell setNeedsDisplay];
                }
            });
        }
    });
    dispatch_release(tableCellImageFetcher);
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     //newViewController = (Atlas_LoginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"Atlas_LoginVC"];
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    /*
    
    if (indexPath.section) {
        if (self.activeMapsEditingMode) {
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.imageView.image) {
                cell.imageView.image = nil;
                // Reflect selection in data model
                [ClientSessionManager removeFromActiveMaps:[self.myMaps objectAtIndex:indexPath.row]];
            } else {
                cell.imageView.image = self.activeMapIndictor;
                [ClientSessionManager addToActiveMaps:[self.myMaps objectAtIndex:indexPath.row]];
            }
        } else {
            //transition to Map detail viewcontroller
        }
    } else {
        //transition to create map
    }
     */
}

@end
