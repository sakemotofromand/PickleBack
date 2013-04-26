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
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *stopButton;
    NSTimer *timer;
    int timerCount;
}
@property (nonatomic, strong) IBOutlet UILabel *timerCountLabel;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UIButton *stopButton;

- (void)increaseTimerCount;
- (IBAction)startTimer;
- (IBAction)stopTimer;

@end
