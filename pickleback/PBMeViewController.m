//
//  PBMeViewController.m
//  pickleback
//
//  Created by Marc Visent Menardia on 5/6/13.
//  Copyright (c) 2013 PBCo. All rights reserved.
//

#import "PBMeViewController.h"
#import "PBAppDelegate.h"
#import "Datastore.h"


@interface PBMeViewController ()

@end

@implementation PBMeViewController

@synthesize countThisSession,countLastHour,countLastDay,countLastWeek,countLastMonth;

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

- (void)viewWillAppear:(BOOL)animated
{
    PBAppDelegate* appDelegate = (PBAppDelegate *)[[UIApplication sharedApplication] delegate];
    //Let's count drinks
    int countSession = 0;
    int count1h = 0;
    int count1d = 0;
    int count1w = 0;
    int count1m = 0;
    NSMutableArray *items = [[Datastore datastore] getSavedItems];
    for (NSDictionary *i in items) {
        //In this session
        if (appDelegate.sessionId == [[i objectForKey:@"sessionID"] intValue]) countSession = countSession + [[i objectForKey:@"count"] intValue];
        NSLog(@"Time:%@",[i objectForKey:@"time"]);
        //In last 4 hours
        int secondsElapsed = (-1)*[[i objectForKey:@"time"] timeIntervalSinceNow];
        //Crec que time no va... aquí hi ha algo raro amb els counts....
        NSLog(@"Seconds elapsed:%d",secondsElapsed);
        if (secondsElapsed < 60*60) count1h = count1h + [[i objectForKey:@"count"] intValue];
        //In last 24h
        if (secondsElapsed < 24*60*60) count1d = count1d + [[i objectForKey:@"count"] intValue];
        //In last week
        if (secondsElapsed < 7*24*60*60) count1w = count1w + [[i objectForKey:@"count"] intValue];
        //In last month
        if (secondsElapsed < 30*24*60*60) count1m = count1m + [[i objectForKey:@"count"] intValue];
        
    }
    countThisSession.text = [NSString stringWithFormat:@"%d in this session",countSession];
    countLastHour.text = [NSString stringWithFormat:@"%d in the last hour",count1h];
    countLastDay.text = [NSString stringWithFormat:@"%d in the last day",count1d];
    countLastWeek.text = [NSString stringWithFormat:@"%d in the last week",count1w];
    countLastMonth.text = [NSString stringWithFormat:@"%d in the last month",count1m];
    NSLog(@"You've had %d in this session",countSession);
    NSLog(@"You've had %d in the last hour",count1h);
    NSLog(@"You've had %d in the last day",count1d);
    NSLog(@"You've had %d in the last week",count1w);
    NSLog(@"You've had %d in the last month",count1m);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
