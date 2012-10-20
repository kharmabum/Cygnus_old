//
//  Console_MyGroupsTVC.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Console_MyGroupsTVC.h"
#import "ClientSessionManager.h"

@interface Console_MyGroupsTVC ()
@property (nonatomic, strong) NSMutableOrderedSet *myGroups;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *activeGroupsEditButton;
@property (nonatomic) BOOL activeGroupsEditingMode;
@property (nonatomic, strong) UIColor *defaultEditButtonColor;

@end

@implementation Console_MyGroupsTVC
@synthesize myGroups = _myGroups;
@synthesize activeGroupsEditButton = _activeGroupsEditButton;
@synthesize activeGroupsEditingMode = _activeGroupsEditingMode;
@synthesize defaultEditButtonColor = _defaultEditButtonColor;

- (void)setactiveGroupsEditingMode:(BOOL)activeGroupsEditingMode
{
    _activeGroupsEditingMode = activeGroupsEditingMode;
    self.activeGroupsEditButton.tintColor = (_activeGroupsEditingMode) ? [UIColor redColor] : self.defaultEditButtonColor;
}

- (IBAction)switchEditingMode:(UIBarButtonItem *)sender {
    [self setactiveGroupsEditingMode:!_activeGroupsEditingMode];
}

#pragma mark - Life cycle


- (void)viewWillAppear:(BOOL)animated
{
    self.myGroups =  [[NSMutableOrderedSet alloc] initWithSet: [[ClientSessionManager currentUser] groups]];
    [self.myGroups minusSet:[NSSet setWithArray:[[ClientSessionManager activeGroupsForCurrentUser] array]]];
    [self setactiveGroupsEditingMode:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaultEditButtonColor = self.editButtonItem.tintColor;
}

- (void)viewDidUnload
{
    [self setActiveGroupsEditButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return 1;
    } else if (section == 1) {
        return [[ClientSessionManager activeGroupsForCurrentUser] count];
    } else {
        return [self.myGroups count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return nil;
    } else if (section == 1) {
        return @"Active Groups";
    } else {
        return @"My Groups";
    }
}

#define CREATE_GROUP_CELL_IDENTIFIER        @"Console_CreateGroupCell"
#define GROUP_CELL_IDENTIFIER               @"Console_GroupCell"


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    UITableViewCell *cell;
    
    if (!indexPath.section) {
        cellIdentifier = CREATE_GROUP_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    } else {
        Group *group;
        cellIdentifier = GROUP_CELL_IDENTIFIER;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (indexPath.section == 1) {
            group = [[ClientSessionManager activeGroupsForCurrentUser] objectAtIndex:indexPath.row];
        } else {
            group = [self.myGroups objectAtIndex:indexPath.row];
        }
        cell.textLabel.text = [group name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d online members", group.members.count]; //TODO - Not accurate. ONLY FOR DEMO    
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    
     //newViewController = (Atlas_LoginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"Atlas_LoginVC"];
     [self.navigationController pushViewController:detailViewController animated:YES];
    */
    
    if (indexPath.section) {
        if (self.activeGroupsEditingMode) {
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
            if (indexPath.section == 1) {
                Group *group  = [[ClientSessionManager activeGroupsForCurrentUser]objectAtIndex:indexPath.row];
                [ClientSessionManager removeFromActiveGroups:group];
                [self.myGroups addObject:group];
            } else {
                Group *group  = [self.myGroups objectAtIndex:indexPath.row];
                [self.myGroups removeObject:group];
                [ClientSessionManager addToActiveGroups:group];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            //transition to group description
        }
    } else {
        //transition to either create group or group invitations. 
    }
}

@end
