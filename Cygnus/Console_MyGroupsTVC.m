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
@property (nonatomic, strong) NSArray *myGroups;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *activeMapEditButton;
@property (nonatomic) BOOL activeMapsEditingMode;
@property (nonatomic) UIColor *defaultEditButtonColor;

@end

@implementation Console_MyGroupsTVC
@synthesize myGroups = _myGroups;
@synthesize activeMapEditButton = _activeMapEditButton;
@synthesize activeMapsEditingMode = _activeMapsEditingMode;
@synthesize defaultEditButtonColor = _defaultEditButtonColor;


- (void)setActiveMapsEditingMode:(BOOL)activeMapsEditingMode
{
    _activeMapsEditingMode = activeMapsEditingMode;
    self.activeMapEditButton.tintColor = (_activeMapsEditingMode) ? [UIColor redColor] : self.defaultEditButtonColor;
}

- (IBAction)switchEditingMode:(id)sender {
    [self setActiveMapsEditingMode:!_activeMapsEditingMode];
}


#pragma mark - Life cycle


- (void)viewWillAppear:(BOOL)animated
{
    self.myGroups = [[[ClientSessionManager currentUser] groups] allObjects];
    self.activeMapsEditingMode = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaultEditButtonColor = self.editButtonItem.tintColor;
}

- (void)viewDidUnload
{
    [self setActiveMapEditButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return (section) ? self.myGroups.count : 2;
    NSLog(@"Size of MyGroups Section - %@",self.myGroups.count);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section) ? @"Active Groups" : nil;
}

#define CREATE_GROUP_CELL_IDENTIFIER @"Console_CreateGroupCell"
#define GROUP_INVITATIONS_CELL_IDENTIFIER @"Console_GroupInvitationsCell"
#define GROUP_CELL_IDENTIFIER @"Console_GroupCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    if (indexPath.section) {
        cellIdentifier = GROUP_CELL_IDENTIFIER;
    } else if (indexPath.row) {
        cellIdentifier = GROUP_INVITATIONS_CELL_IDENTIFIER;
    } else {
        cellIdentifier = CREATE_GROUP_CELL_IDENTIFIER;

    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.section) {
        Group *group = [self.myGroups objectAtIndex:indexPath.row];
        cell.textLabel.text = [group name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d online members", group.members.count]; //TODO - Not accurate. ONLY FOR DEMO
        cell.accessoryType = ([[ClientSessionManager activeGroupsForCurrentUser] containsObject:group]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section) ? YES : NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    
     //newViewController = (Atlas_LoginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"Atlas_LoginVC"];
     [self.navigationController pushViewController:detailViewController animated:YES];
    */
    
    if (indexPath.section) {
        if (self.activeMapsEditingMode) {
            
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.accessoryType == UITableViewCellAccessoryNone) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                // Reflect selection in data model
                [ClientSessionManager addToActiveGroups:[self.myGroups objectAtIndex:indexPath.row]];
            } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [ClientSessionManager removeFromActiveGroups:[self.myGroups objectAtIndex:indexPath.row]];
            }
        } else {
            //transition to group description
        }
    } else {
        //transition to either create group or group invitations. 
    }
}

@end
