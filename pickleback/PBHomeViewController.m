//
//  PBHomeViewController.m
//  pickleback
//
//  Created by Marc Visent Menardia on 4/25/13.
//  Copyright (c) 2013 PB&Co. All rights reserved.
//

#import "PBHomeViewController.h"


@implementation PBHomeViewController

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

- (void)increaseTimerCount
{
    timerCountLabel.text = [NSString stringWithFormat:@"%d", timerCount++];
}

- (IBAction)startTimer
{
    timerCount = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
    
}

- (IBAction)stopTimer
{
    [timer invalidate];
 //   [timer release];
}

@end
