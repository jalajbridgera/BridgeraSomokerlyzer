//
//  StepOneViewController.h
//  NiCODep
//
//  Created by JAMES DENSEM on 16/09/2011.
//  Copyright 2011 BIOMEDICAL COMPUTING LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import "TimeReading.h"
//#import "CustomBedfontButton.h"
//#import "CustomBedfontLabel.h"

@protocol DeviceInputStepOneViewControllerDelegate;

@class RIOInterface;

@interface CommunicateDeviceViewController : NSObject < AVAudioPlayerDelegate, UIAlertViewDelegate>{
    
    //images of the coloured bars
    

    
//    IBOutlet UIView *ppmScaleWrapper;
//
//    IBOutlet UIButton *startListenBtn;
//    IBOutlet UIButton *retest;
//
//    IBOutlet UILabel *audioRouteLabel;
//    IBOutlet UILabel *ppmLabel;
//    IBOutlet UIView *beginMessage;
//    IBOutlet UILabel *scalinglabel;
//    IBOutlet UILabel *countdownLabel;
//
//    IBOutlet UILabel *thirtyOnePlusLabel;
//    IBOutlet UILabel *breathTestTitleLabel;
//    IBOutlet UILabel *deviceStatusLabel;
//    IBOutlet UILabel *ppmReadingLabel;
//
//    UIView *breatheInMessage;
//    UILabel *breatheInMessageLabel;
    
    BOOL deviceMode;
    BOOL isListening;
    RIOInterface *rioRef;
    
    float currentFrequency;
    NSString *prevChar;
    
    NSMutableArray *recordings;
    float lastPeakRecording;
    
    AVAudioPlayer    *appSoundPlayer;
    
    //background square
    
    IBOutlet UILabel *reading;
    
    //continue
//    IBOutlet CustomBedfontButton *continueBtn;
    
    //the slider bar for selecting pmm reading
    UISlider *vertSlider;
    
    IBOutlet UIBarItem *testNew;
    
    int selectedLvl;
    float readingValue;
    
    int manualPPMReadingPrecise ;
    int scaling ;
    
    int countdown;
    BOOL begun;
    BOOL ignoreReadings;
    float beforeRecordingCurrentFrequency;
    
    NSMutableArray *initialOffsetRecordings;
    BOOL addToInitialOffset;
    
}
+ (void) initializeLibrary:(int)devicePin;

@property (nonatomic, strong) UISlider  *vertSlider;
@property (nonatomic, strong) UILabel *reading;
@property (nonatomic, strong) UIButton *continueBtn;
@property (nonatomic, strong) UIBarItem *testNew;
@property (nonatomic, strong) UIButton *deviceBtn;

@property (nonatomic, readwrite)  NSURL *soundFileURL;
@property(nonatomic, retain) RIOInterface *rioRef;
@property(nonatomic, readwrite) float currentFrequency;
@property(assign) BOOL isListening;
@property(nonatomic, retain) UIButton *startListenBtn;
@property (nonatomic, readwrite)    AVAudioPlayer *appSoundPlayer;

@property (nonatomic,retain) UILabel *ppmLabel;
@property (nonatomic,retain) UILabel *audioRouteLabel;

@property (readwrite) BOOL playing;
@property (readwrite) BOOL interruptedOnPlayback;
@property (nonatomic, retain) UIView *beginMessage;
@property (nonatomic, retain) NSTimer *beginTimer;
@property (nonatomic, retain) NSTimer *enableContinueTimer;

@property (nonatomic, retain) NSTimer *disableButtonTimer;
@property (nonatomic, retain) UIAlertView *connectedDeviceAlert;

@property (nonatomic, strong)  IBOutlet UIImageView *squareRoundedQuestion;

//event listener for an movement on the slider

-(void)vertSliderAction:(id)sender;
//setsup the slider in code
-(void)setupSlider;

//pass messages to step 2
-(IBAction)continueToStepTwo:(id)sender;

//restart test
-(IBAction) startNewTest:(id)sender;

//-(IBAction)startTest:(id)sender;

//force slider thumb to the centre of a range
-(IBAction)setSliderToCentre:(id)sender;

-(IBAction)useDevice:(id)sender;


#pragma mark Listener Controls
- (IBAction)toggleListening:(id)sender;

- (void)startListener;
- (void)stopListener;

- (void)frequencyChangedWithValue:(float)newFrequency;
- (void)updateFrequencyLabel;

-(void)playFrequency;

-(IBAction)resetValues:(id)sender;

-(NSString *)audioRouteAvailable;

-(void)audioRouteChanged;

//-(IBAction) startNewTest:(id)sender;

-(IBAction)startCountDown:(id)sender;

@end

@protocol DeviceInputStepOneViewControllerDelegate <NSObject>

-(void)ppmReadingFromDevice:(int)ppmReading;

@end

