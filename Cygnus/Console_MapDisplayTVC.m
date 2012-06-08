//
//  Console_MapDisplayTVC.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Console_MapDisplayTVC.h"
#import "CygnusManager.h"

@interface Console_MapDisplayTVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;
@end

@implementation Console_MapDisplayTVC

@synthesize mapTypeSegmentedControl = _mapTypeSegmentedControl;

- (void)viewWillAppear:(BOOL)animated
{
    self.mapTypeSegmentedControl.selectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_MAP_PREFERENCE] intValue];
    [super viewWillAppear:animated];
}
- (IBAction)mapTypeSelected:(UISegmentedControl *)sender 
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:sender.selectedSegmentIndex]forKey:CURRENT_USER_MAP_PREFERENCE];
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


@end
