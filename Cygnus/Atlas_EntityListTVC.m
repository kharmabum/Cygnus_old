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
@property (strong, nonatomic) NSOrderedSet *activeMapPins;
@property (strong, nonatomic) NSMutableArray *nearbyActors;
@property (strong, nonatomic) NSMutableArray *actorDistances;


@end

@implementation Atlas_EntityListTVC
@synthesize activeMapPins = _activeMapPins;
@synthesize nearbyActors = _nearbyActors;
@synthesize actorDistances = _actorDistances;

- (NSMutableArray*)nearbyActors
{
    if (!_nearbyActors) _nearbyActors = [NSMutableArray array];
    return _nearbyActors;
}

- (NSMutableArray*)actorDistances
{
    if (!_actorDistances) _actorDistances = [NSMutableArray array];
    return _actorDistances;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    Person *currentUser = [ClientSessionManager currentUser];
    self.activeMapPins = [ClientSessionManager mapPinsForCurrentUser];                            
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];

    
    CLLocation *currentUserLocation = [[CLLocation alloc] initWithLatitude:[[currentUser latitude] doubleValue] longitude:[[currentUser latitude] doubleValue]];
    dispatch_queue_t detectNearbyActors = dispatch_queue_create("detect_nearby_actors", NULL);
    dispatch_async(detectNearbyActors, ^{
        for (Group *group in [ClientSessionManager activeGroupsForCurrentUser]) {
            for (Person *member in group.members) {
                if (member != currentUser && ![self.nearbyActors containsObject:member]) {
                    CLLocation *memberLocation = [[CLLocation alloc] initWithLatitude:[[member latitude] doubleValue] 
                                                                            longitude:[[member latitude] doubleValue]];
                    CLLocationDistance distance = [currentUserLocation distanceFromLocation:memberLocation];
                    if (distance <= [currentUser.broadcastRange intValue] && distance <= [member.broadcastRange intValue]) {
                        [self.nearbyActors addObject:member];
                        [self.actorDistances addObject:[NSNumber numberWithDouble:distance]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                        });
                    }
                }
            }
        }
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return (!section) ? [self.nearbyActors count] : [self.activeMapPins count];
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

    //NSURL *imgURL;
    if (!indexPath.section) {
        cellIdentifier = ATLAS_LIST_PERSON_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        Person *person = [self.nearbyActors objectAtIndex:indexPath.row];
        NSString *sharedGroupList = @"";
        NSMutableSet *sharedGroups = [NSMutableSet setWithSet:[[ClientSessionManager currentUser] groups]];
        [sharedGroups intersectsSet:person.groups];
        for (Group *group in sharedGroups) {
            NSString *format = ([sharedGroupList length]) ? @", %@": @"%@";
            sharedGroupList = [sharedGroupList stringByAppendingFormat:format, group.name];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",person.first_name, person.last_name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.2f km", [[self.actorDistances objectAtIndex:indexPath.row] doubleValue]];
        //imgURL = [NSURL URLWithString:person.imgURL];
    } else {
        cellIdentifier = ATLAS_LIST_LOCATION_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        MapPin *pin = [self.activeMapPins objectAtIndex:indexPath.row];
        //TODO - implement party notifier to inform attendence count, also add # of events on location label
        cell.textLabel.text = pin.location_name;
        
        
        
        Person *currentUser = [ClientSessionManager currentUser];
        CLLocation *currentUserLocation = [[CLLocation alloc] initWithLatitude:[[currentUser latitude] doubleValue] longitude:[[currentUser latitude] doubleValue]];
        CLLocation *pinLocation = [[CLLocation alloc] initWithLatitude:[[pin latitude] doubleValue] 
                                                                longitude:[[pin latitude] doubleValue]];
        CLLocationDistance distance = [currentUserLocation distanceFromLocation:pinLocation];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.2f km", distance];
        
        
        
        //imgURL = [NSURL URLWithString:pin.imgURL];
    }
    
    /*
    cell.imageView.frame = CGRectMake(0, 0, 45, 45);
    dispatch_queue_t tableCellImageFetcher = dispatch_queue_create("table_cell_image_fetcher", NULL);
    dispatch_async(tableCellImageFetcher, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imgURL];
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
                    cell.imageView.image = cell.imageView.highlightedImage = image;
                }
            });
        }
    });
    dispatch_release(tableCellImageFetcher);*/
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
