//
//  PBStartViewController.m
//  pickleback
//
//  Created by Marc Visent Menardia on 4/25/13.
//  Copyright (c) 2013 PB&Co. All rights reserved.
//

#import "PBStartViewController.h"
#import "PBAppDelegate.h"
#import <UIKit/UIKit.h>
#import <stdlib.h>

@implementation PBStartViewController

@synthesize pickerView, timerCountLabel, startButton, stopButton, sessionStatsLabel;

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
    timerLabels = [[NSArray alloc] initWithObjects:@"5' reminders",@"1' reminders",@"15' reminders",@"30' reminders",@"1h reminders", nil];
    timerValues = [[NSArray alloc] initWithObjects:@"5",@"60",@"900",@"1800",@"3600", nil];
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:pickerView];
    PBAppDelegate* appDelegate = (PBAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.timerInitialSecondsLeft = 5;
    startButton.hidden = FALSE;
    stopButton.hidden = TRUE;
    pickerView.hidden = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    PBAppDelegate* appDelegate = (PBAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.sessionId == 0)
    {
        sessionStatsLabel.text = @"";
    } else
    {
        int secondsElapsed = [appDelegate.sessionStart timeIntervalSinceNow];
        NSLog(@"Seconds elapsed: %d", secondsElapsed);
        int hours = (-1) * secondsElapsed / 3600;
        int minutes = (-1) * (secondsElapsed % 3600) / 60;
        int seconds = (-1) * (secondsElapsed % 3600) % 60;
        sessionStatsLabel.text = [NSString stringWithFormat:@"You´ve had %d drinks in %02d:%02d:%02d", appDelegate.sessionDrinks, hours, minutes, seconds];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    PBAppDelegate* appDelegate = (PBAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.timerInitialSecondsLeft = [[timerValues objectAtIndex:row] intValue];
    appDelegate.timerSecondsLeft = [[timerValues objectAtIndex:row] intValue];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger numRows = 5;
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    if (component == 0)
    {
        title = [@"" stringByAppendingFormat:@"%@",[timerLabels objectAtIndex:row]];
    }
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


- (void)decreaseTimerCount
{
    PBAppDelegate* appDelegate = (PBAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.timerSecondsLeft > 0)
    {
        appDelegate.timerSecondsLeft -- ;
        int hours = appDelegate.timerSecondsLeft / 3600;
        int minutes = (appDelegate.timerSecondsLeft % 3600) / 60;
        int seconds = (appDelegate.timerSecondsLeft %3600) % 60;
        timerCountLabel.text = [NSString stringWithFormat:@"Time until next check-in: %02d:%02d:%02d", hours, minutes, seconds];
    } else
    {
        [self resetTimer];
    }
}

- (void)initTimer
{
    PBAppDelegate* appDelegate = (PBAppDelegate *)[[UIApplication sharedApplication] delegate];
    int timerSecondsLeft = appDelegate.timerInitialSecondsLeft;
    int hours = timerSecondsLeft / 3600;
    int minutes = (timerSecondsLeft % 3600) / 60;
    int seconds = (timerSecondsLeft % 3600) % 60;
    timerCountLabel.text = [NSString stringWithFormat:@"Time until next check-in: %02d:%02d:%02d", hours, minutes, seconds];
    timerCountLabel.numberOfLines = 2;
    appDelegate.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(decreaseTimerCount) userInfo:nil repeats:YES];
    NSDate *now = [NSDate date];
    NSLog(@"now is %@",now);
    appDelegate.timerStart = now;
    NSDate *scheduled = [now dateByAddingTimeInterval:timerSecondsLeft] ; //get x minute after
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *comp = [calendar components:unitFlags fromDate:scheduled];
    
    NSLog(@"scheduled is %@",scheduled);
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = scheduled;
    localNotif.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"EDT"];
    
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"How many drinks have you had?", nil),
                            timerSecondsLeft*60];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"pickleback!" forKey:@"1"];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];

}

- (IBAction)startTimer
{
    [self initTimer];
}

- (void)resetTimer
{
    PBAppDelegate* appDelegate = (PBAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.timer invalidate];
    appDelegate.timerSecondsLeft = appDelegate.timerInitialSecondsLeft;
    [self initTimer];
}

- (IBAction)startSession
{
    PBAppDelegate* appDelegate = (PBAppDelegate *)[[UIApplication sharedApplication] delegate];
    startButton.hidden = TRUE;
    stopButton.hidden = FALSE;
    pickerView.hidden = TRUE;
    appDelegate.sessionId = arc4random();
    appDelegate.sessionDrinks = 0;
    appDelegate.sessionStart = [NSDate date];
    NSLog(@"New Session!:%d",appDelegate.sessionId);
    [self initTimer];
}

- (IBAction)stopSession
{
    PBAppDelegate* appDelegate = (PBAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.timer invalidate];
    appDelegate.sessionId = 0;
    appDelegate.sessionDrinks = 0;
    timerCountLabel.text = @"Start a new session now!";
    sessionStatsLabel.text = @"";
    startButton.hidden = FALSE;
    stopButton.hidden = TRUE;
    pickerView.hidden = FALSE;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //   [timer release];
}




@end
