//
//  PBSettingsViewController.m
//  pickleback
//
//  Created by Marc Visent Menardia on 4/25/13.
//  Copyright (c) 2013 PB&Co. All rights reserved.
//

#import "PBSettingsViewController.h"


@implementation PBSettingsViewController

@synthesize timerCountLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)launchFeedback {
    [TestFlight openFeedbackView];
}

@end
