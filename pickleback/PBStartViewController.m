//
//  PBStartViewController.m
//  pickleback
//
//  Created by Marc Visent Menardia on 4/25/13.
//  Copyright (c) 2013 PB&Co. All rights reserved.
//

#import "PBStartViewController.h"

@implementation PBStartViewController

@synthesize pickerView, timerCountLabel, startButton, stopButton;

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
    [super viewDidLoad];
   // UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 80, 320, 200)];
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:pickerView];
    //timerCount = 0;
    if(timerCount > 0)
    {
        startButton.hidden = TRUE;
        stopButton.hidden = FALSE;
        pickerView.hidden = TRUE;
    } else
    {
        startButton.hidden = FALSE;
        stopButton.hidden = TRUE;
        pickerView.hidden = FALSE;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    // Handle the selection
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
    title = [@"" stringByAppendingFormat:@"%d",row];
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


- (void)increaseTimerCount
{
    timerCountLabel.text = [NSString stringWithFormat:@"%d", timerCount++];
}

- (IBAction)startTimer
{
    timerCount = 0;
    startButton.hidden = TRUE;
    stopButton.hidden = FALSE;
    pickerView.hidden = TRUE;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
    
}

- (IBAction)stopTimer
{
    [timer invalidate];
    timerCount = 0;
    timerCountLabel.text = @"";
    startButton.hidden = FALSE;
    stopButton.hidden = TRUE;
    pickerView.hidden = FALSE;
    //   [timer release];
}


@end
