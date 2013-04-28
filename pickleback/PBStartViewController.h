//
//  PBStartViewController.h
//  pickleback
//
//  Created by Marc Visent Menardia on 4/25/13.
//  Copyright (c) 2013 PB&Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBStartViewController : UIViewController <UIPickerViewDelegate>
{
	IBOutlet UIPickerView *pickerView;
    IBOutlet UILabel *timerCountLabel;
    IBOutlet UILabel *sessionStatsLabel;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *stopButton;
    NSArray *timerLabels;
    NSArray *timerValues;
}

@property (nonatomic, strong) IBOutlet UILabel *timerCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *sessionStatsLabel;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UIButton *stopButton;

- (void)decreaseTimerCount;
- (IBAction)startSession;
- (IBAction)stopSession;
- (void)resetTimer;
- (void)initTimer;

@end
