//
//  StepOneViewController.m
//  NiCODep
//
//  Created by JAMES DENSEM on 16/09/2011.
//  Copyright 2011 BIOMEDICAL COMPUTING LTD. All rights reserved.
//

#import "StepOneViewController.h"
//#import "StepTwoViewController.h"
//#import "ReportV2ViewController.h"

#import "RIOInterface.h"
#import <QuartzCore/QuartzCore.h>

@implementation StepOneViewController
{
    UIView *timerView;
    UILabel *timerCountdownLabel;
    UIImageView *breathingImageView;
    BOOL overrideConnectedDevice ;
}

@synthesize vertSlider;
@synthesize reading;
//@synthesize continueBtn;
@synthesize testNew;

//@synthesize lvl1ImgView, lvl2ImgView, lvl3ImgView, lvl4ImgView, lvl5ImgView, lvl6ImgView, lvl7ImgView, deviceBtn;

@synthesize currentFrequency,startListenBtn,rioRef,isListening, appSoundPlayer, playing, interruptedOnPlayback, soundFileURL,ppmLabel,audioRouteLabel, beginMessage, beginTimer,disableButtonTimer, connectedDeviceAlert,enableContinueTimer;

@synthesize beginTestHorzontalLeftConstraint, beginTestHorizontalRightConstraint, beginTestVerticalSpaceBottomConstraint;

//@synthesize redImgSelected, redImgDeselected, yellowSelected, yellowDeselected;

@synthesize squareRoundedQuestion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    overrideConnectedDevice = NO;
//    self.navigationController.navigationBarHidden = YES;
    [ppmLabel setHidden:YES];
    
    ignoreReadings = YES;
    addToInitialOffset = NO;
    
    countdown = 18;
    
    deviceMode = YES;
    
    self.title = @"Step 1 PPM Reading";
    
    // setup the imae view tags incase we need them
//    [lvl7ImgView setTag:7];
//    [lvl6ImgView setTag:6];
//    [lvl5ImgView setTag:5];
//    [lvl4ImgView setTag:4];
//    [lvl3ImgView setTag:3];
//    [lvl2ImgView setTag:2];
//    [lvl1ImgView setTag:1];
    
    selectedLvl = 0;
    
    [self setupSlider];
    
    vertSlider.value = readingValue;
    
    [self vertSliderAction:nil];
    
    rioRef = [RIOInterface sharedInstance];
   
    
    scaling = 700;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *key = @"scaling";
    if([defaults valueForKey:key])
    {
        scaling = [[defaults valueForKey:key] intValue];
    }
    if(scaling <280  || scaling >1120)
    {
        scaling = 700;
    }
  //  [scalinglabel setText:[NSString stringWithFormat:@"%lu",(long unsigned)scaling]];
    
    if(deviceMode)
    {
        [self vertSliderAction:nil];
    }
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) { // if iOS 7
//        self.edgesForExtendedLayout = UIRectEdgeNone; // layout adjustements
//    }
    [self setupApplicationAudio];
    
   // [continueBtn setStateEnabled:NO];
    
//    int screenWidth = [[UIScreen mainScreen]bounds].size.width ;
//    int screenHeight = [[UIScreen mainScreen]bounds].size.height ;
//
//    int messageWidth = screenWidth -20;
//    int screenPosition = screenHeight /2 -20;
//    if(screenPosition > (screenHeight -335))
//    {
//        screenPosition = screenHeight -345;
//    }
//    screenPosition = screenHeight -345;
//    [beginMessage setBackgroundColor:[UIColor colorWithRed:110.0f/255.0f green:200.0f/255.0f blue:210.0f/255.0f alpha:1.0f]];
//    breatheInMessage = [[UIView alloc] initWithFrame:CGRectMake(screenWidth /2 -(messageWidth/2), 60, messageWidth, screenHeight - 60)];
//    breatheInMessage.clipsToBounds = YES;
//    breatheInMessage.layer.cornerRadius = 8.0f;
//    [breatheInMessage setBackgroundColor:[UIColor bedfontDarkBlue]];
    
    //    breatheInMessage.layer.borderColor=[[UIColor colorWithRed:0.0f green:118.0f/255.0f blue:152.0f/255.0f alpha:1.0f]CGColor];
    //    breatheInMessage.layer.borderWidth= 1.0f;
//    breatheInMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,196, breatheInMessage.frame.size.width - 10,breatheInMessage.frame.size.height - 221) ];
//    breatheInMessageLabel.textAlignment = NSTextAlignmentCenter;
//    breatheInMessageLabel.textColor = [UIColor whiteColor];
//    breatheInMessageLabel.backgroundColor = [UIColor clearColor];
//    breatheInMessageLabel.text = TranslatedString(@"Inhale and hold your breath", nil);
//    breatheInMessageLabel.font = [UIFont fontWithName:@"Insignia LT" size:27.0];
//    breatheInMessageLabel.numberOfLines = 5;
    //[breatheInMessageLabel sizeToFit];
    
    
//    UIImage *breathInImage = [UIImage imageNamed:@"breath_in"];
//    breathingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(breatheInMessage.frame.size.width /2 -101, 0, 202, 191)];
//    [breathingImageView setImage:breathInImage];
//    [breatheInMessage addSubview:breathingImageView];
//
//
//    int spaceBetweenImageAndBottom = breatheInMessage.frame.size.height-( breathingImageView.frame.size.height + breathingImageView.frame.origin.y);
//    int timerLabelHeight = 50;
//    int timerImageViewheight = 81;
//
//    int timerViewHeight = timerLabelHeight + timerImageViewheight +10;
//
//    int timerViewYPos = breathingImageView.frame.origin.y + breathingImageView.frame.size.height +10 +((spaceBetweenImageAndBottom - timerViewHeight)/2);
//
//    timerView = [[UIView alloc] initWithFrame:CGRectMake(breatheInMessage.frame.size.width /2 -101, timerViewYPos, 202, spaceBetweenImageAndBottom)];
//
//    UIImage *timerImage = [UIImage imageNamed:@"timer"];
//    UIImageView *timerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0,timerView.frame.size.width  , timerImageViewheight)];
//    [timerImageView setImage:timerImage];
//
//    [timerView addSubview:timerImageView];
//
//    timerCountdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(timerView.frame.size.width /2 -101, timerImageView.frame.origin.y + timerImageView.frame.size.height +10, 202, timerLabelHeight)];
//    timerCountdownLabel.textAlignment = NSTextAlignmentCenter;
//    timerCountdownLabel.textColor = [UIColor whiteColor];
//    timerCountdownLabel.backgroundColor = [UIColor clearColor];
//    timerCountdownLabel.text = @"";
//    timerCountdownLabel.font = [UIFont fontWithName:@"Insignia LT" size:27.0];
    
 //   [timerView addSubview:timerCountdownLabel];
    
 //   timerView.hidden = YES;
    
//    [breatheInMessage addSubview:timerView];
    
    //[breatheInMessageLabel setCenter:breatheInMessage.center];
    
//    [breatheInMessage addSubview:breatheInMessageLabel];
//    [self.view addSubview:breatheInMessage];
    
  //  breatheInMessage.hidden = YES;
    
    [self playFrequency];
    // Do any additional setup after loading the view from its nib.
    
   // deviceBtn.stateEnabled = NO;
    
    [self resetDeviceButtonTimer];
    
//    self.view.backgroundColor = [UIColor bedfontDarkBlue];
//
//    breathTestTitleLabel.text = TranslatedString(@"Breath Test", nil);
//    deviceStatusLabel.text =TranslatedString(@"Device Status:", nil);
//    audioRouteLabel.text = TranslatedString(@"Unplugged", nil);
//    ppmReadingLabel.text =TranslatedString(@"PPM Reading", nil);
    
    //    twentySixToThirty.text =[NSString stringWithFormat:@"31 %@ ",@"ppm"];
    //    twentyOneToTwentyFive.text =[NSString stringWithFormat:@"31 %@ ",@"ppm"];
    //    sixteenToTwenty.text =[NSString stringWithFormat:@"31 %@  ",@"ppm"];
    //    elevenToFifteen.text =[NSString stringWithFormat:@"31 %@ ",@"ppm"];
    //    sevenToTen.text =[NSString stringWithFormat:@"31 %@ ",@"ppm"];
    //    zeroToSix.text =[NSString stringWithFormat:@"31 %@ ",@"ppm"];
    //[deviceBtn setTitle:TranslatedString(@"Begin Test", nil) forState:UIControlStateNormal ];
   // [continueBtn setTitle:TranslatedString(@"Continue", nil) forState:UIControlStateNormal ];
    
//    UILabel *ppm1 =   [[UILabel alloc] init];
//    [self setLabel:ppm1 withFrame:thirtyOnePlusLabel.frame];
//
//    UILabel *ppm2 =   [[UILabel alloc] init];
//    [self setLabel:ppm2 withFrame:twentySixToThirty.frame];
//
//
//    UILabel *ppm3 =   [[UILabel alloc] init];
//    [self setLabel:ppm3 withFrame:twentyOneToTwentyFive.frame];
//
//
//    UILabel *ppm4 =   [[UILabel alloc] init];
//    [self setLabel:ppm4 withFrame:sixteenToTwenty.frame];
//
//
//    UILabel *ppm5 =   [[UILabel alloc] init];
//    [self setLabel:ppm5 withFrame:elevenToFifteen.frame];
//
//
//    UILabel *ppm6 =   [[UILabel alloc] init];
//    [self setLabel:ppm6 withFrame:sevenToTen.frame];
//
//
//    UILabel *ppm7 =   [[UILabel alloc] init];
//    [self setLabel:ppm7 withFrame:zeroToSix.frame];
    
//    [ppmScaleWrapper addSubview:ppm1];
//    [ppmScaleWrapper addSubview:ppm2];
//    [ppmScaleWrapper addSubview:ppm3];
//    [ppmScaleWrapper addSubview:ppm4];
//    [ppmScaleWrapper addSubview:ppm5];
//    [ppmScaleWrapper addSubview:ppm6];
//    [ppmScaleWrapper addSubview:ppm7];
    //[continueBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:deviceBtn
    //                                                          attribute:NSLayoutAttributeBottom
    //                                                          relatedBy:NSLayoutRelationEqual
    //                                                             toItem:self.view
    //                                                          attribute:NSLayoutAttributeBottom
    //                                                         multiplier:1.0
    //                                                           constant:32.0]];
    //
    //
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:deviceBtn
    //                                                          attribute:NSLayoutAttributeLeading
    //                                                          relatedBy:NSLayoutRelationEqual
    //                                                             toItem:self.view
    //                                                          attribute:NSLayoutAttributeLeading
    //                                                         multiplier:1.0
    //                                                           constant:20.0]];
    //
    //
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:deviceBtn
    //                                                          attribute:NSLayoutAttributeTrailing
    //                                                          relatedBy:NSLayoutRelationEqual
    //                                                             toItem:self.view
    //                                                          attribute:NSLayoutAttributeTrailing
    //                                                         multiplier:1.0
    //                                                           constant:20.0]];
    
    
    
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.continueBtn
    //                                                          attribute:NSLayoutAttributeBottom
    //                                                          relatedBy:NSLayoutRelationEqual
    //                                                             toItem:self.view
    //                                                          attribute:NSLayoutAttributeBottom
    //                                                         multiplier:1.0
    //                                                           constant:32.0]];
    //
    //
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.continueBtn
    //                                                          attribute:NSLayoutAttributeLeading
    //                                                          relatedBy:NSLayoutRelationEqual
    //                                                             toItem:self.view
    //                                                          attribute:NSLayoutAttributeLeading
    //                                                         multiplier:1.0
    //                                                           constant:20.0]];
    //
    //
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.continueBtn
    //                                                          attribute:NSLayoutAttributeTrailing
    //                                                          relatedBy:NSLayoutRelationEqual
    //                                                             toItem:self.view
    //                                                          attribute:NSLayoutAttributeTrailing
    //                                                         multiplier:1.0
    //                                                           constant:20.0]];
    //
    //    //
    //    [self.continueBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.continueBtn
    //                                                                 attribute:NSLayoutAttributeHeight
    //                                                                 relatedBy:NSLayoutRelationEqual
    //                                                                    toItem:nil
    //                                                                 attribute:NSLayoutAttributeNotAnAttribute
    //                                                                multiplier:1.0
    //                                                                  constant:30.0]];
}


//-(void)setLabel:(UILabel *)label withFrame:(CGRect)frame
//{
//    label.frame = CGRectMake(frame.origin.x +  frame.size.width +5, frame.origin.y,frame.size.width,frame.size.height) ;
//    label.textAlignment = NSTextAlignmentLeft;
//    label.textColor = [UIColor blackColor];
//    label.backgroundColor = [UIColor clearColor];
//    label.text = [NSString stringWithFormat:@"ppm"];;
//    label.font = [UIFont fontWithName:@"Insignia LT" size:12.0];
//    label.numberOfLines = 1;
//}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"step one view will appear");
    [super viewWillAppear: animated];
   // [audioRouteLabel setText: TranslatedString([self audioRouteAvailable], nil)];
    
    //listens for the notification named trigger, as a test we push the window frame in app delegate applicationWillEnterForeground
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusTriggered:)
                                                 name:@"trigger"
                                               object:nil];
    
    
    AVAudioSession *session = [ AVAudioSession sharedInstance ];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleRouteChange:)
                                                 name: AVAudioSessionRouteChangeNotification
                                               object: session];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleInterruption:)
                                                 name: AVAudioSessionInterruptionNotification
                                               object: session];
    breatheInMessage.hidden = YES;
    
}

-(void)statusTriggered:(NSNotification*)notification
{
    NSLog(@"status triggered in setop one view controller");
}

-(void)viewWillDisappear:(BOOL)animated
{
    @try {
        if (isListening) {
            [self stopListener];
        }
        if(playing)
        {
            [self stopPlaying];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVAudioSessionRouteChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVAudioSessionInterruptionNotification" object:nil];
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    // Return YES for supported orientations
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait );
}

/*
 -(NSUInteger)supportedInterfaceOrientations
 {
 return UIInterfaceOrientationMaskPortrait ;
 }
 */

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskPortrait;
}

#pragma mark Listener Controls
- (IBAction)toggleListening:(id)sender {
    
    if (isListening) {
        [self stopListener];
        //[continueBtn setStateEnabled:YES];
        ignoreReadings = YES;
        addToInitialOffset = NO;
    } else {
        [self startListener];
        
        //[beginMessage setHidden:YES];
        
        
        //[playFrequencyBtn setTitle:@"Stop" forState:UIControlStateNormal];
    }
    
}



-(void)startCountDown:(id)sender
{
    
    if(!playing)
    {
        [self playFrequency];
    }
    else
    {
        if(ignoreReadings == YES)
        {
            
            // normally < 800 > 1200
            NSLog(@"before reading on begin test %f",beforeRecordingCurrentFrequency);
            if((beforeRecordingCurrentFrequency < 700 || beforeRecordingCurrentFrequency > 1300 ) && overrideConnectedDevice == NO)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected Device"
                                                                message:@"An iCO device is not properly connected or the volume is not high enough on your iPhone."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                return;
            }
            else{
               // [deviceBtn setHidden:YES];
                [startListenBtn setHidden:NO];
                countdown = 19;
                beginTimer =[NSTimer scheduledTimerWithTimeInterval:1.0   target:self   selector:@selector(beginTimerFired:)  userInfo:nil  repeats:YES];
                [breatheInMessage setAlpha:0];
                breatheInMessage.hidden = NO;
                //fade in
                [UIView animateWithDuration:1.0f animations:^{
                    
                    [breatheInMessage setAlpha:1.0f];
                    
                } completion:^(BOOL finished) {
                    
                    deviceStatusLabel.hidden = YES;
                    audioRouteLabel.hidden = YES;
                    ppmScaleWrapper.hidden = YES;
                    
                }];
            }
        }
        
    }
}

-(void)resetDeviceButtonTimer
{
    if(disableButtonTimer != nil)
    {
        if(disableButtonTimer.isValid)
        {
            [disableButtonTimer invalidate];
        }
        disableButtonTimer = nil;
    }
    disableButtonTimer = [NSTimer scheduledTimerWithTimeInterval:5.0   target:self   selector:@selector(disabledDeviceTimerFired:)  userInfo:nil  repeats:NO];
    
}

-(void)disabledDeviceTimerFired:(NSTimer *) theTimer
{
    NSString* routeStr = [self audioRouteAvailable];
    
    
    
    NSRange connected = [routeStr rangeOfString:@"Connected"];
    
    if(connected.location != NSNotFound || overrideConnectedDevice ==YES ) {
       // deviceBtn.stateEnabled = YES;
    }
    
}

-(void)beginTimerFired:(NSTimer *) theTimer
{
    NSLog(@"timerFired @ %@", [theTimer fireDate]);
    countdown--;
    
    if(countdown ==-6)
    {
        
        if(beginTimer)
        {
            if(beginTimer.isValid)
            {
                [beginTimer invalidate];
            }
            beginTimer = nil;
        }
        [self timerEnd];
        
        
        enableContinueTimer =[NSTimer scheduledTimerWithTimeInterval:24.0   target:self   selector:@selector(enableContinueBtn:)  userInfo:nil  repeats:NO];
        [UIView animateWithDuration:1.0f animations:^{
            
            [breatheInMessage setAlpha:0.0f];
            
        } completion:^(BOOL finished) {
            
            breatheInMessage.hidden = YES;
            
        }];
        
       // continueBtn.hidden = NO;
       // [continueBtn setEnabled:NO];
        ppmScaleWrapper.hidden = NO;
        
        deviceStatusLabel.hidden = YES;
        audioRouteLabel.hidden = YES;
        
    }
    
    if(countdown >0)
    {
        
        NSLog(@"frequency during countdown %f",beforeRecordingCurrentFrequency);
    }
    if(countdown ==17)
    {
        
        [UIView beginAnimations:@"animation" context:nil];
    }
    
    if(countdown ==16)
    {
        
        
        [timerCountdownLabel setText:@"15"];
        
        [breatheInMessageLabel setText:@""];
        
        
        //breatheInMessageLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Begin exhaling steadily into the device", nil)];
        [breathingImageView setImage:[UIImage imageNamed:@"breath_hold"]];
        timerView.hidden = NO;
        
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:breatheInMessage cache:NO];
        [UIView setAnimationDuration:0.85];
        [UIView commitAnimations];
        
    }
    
    if(countdown ==5 && isListening == NO)
    {
        //[self toggleListening:nil];start listening on load to allow detection of device on
    }
    if(countdown >5 && countdown <=9)
    {
        addToInitialOffset = YES;
    }
    if(countdown ==5)
    {
        
       // [continueBtn setTitle:TranslatedString(@"Continue to Exhale", nil) forState:UIControlStateDisabled];
       // [continueBtn setTitle:TranslatedString(@"Continue to Exhale", nil) forState:UIControlStateNormal];
        
        addToInitialOffset = NO;
        float totalOffsets = 0;
        for(NSNumber *n in initialOffsetRecordings)
        {
            totalOffsets += [n floatValue];
        }
        
        beforeRecordingCurrentFrequency = totalOffsets / [initialOffsetRecordings count];
        NSLog(@"offset = %f",beforeRecordingCurrentFrequency);
        
        [UIView beginAnimations:@"animation" context:nil];
        
        
    }
    
    if(countdown == 0 )
    {
        
        //[UIView beginAnimations:@"animation" context:nil];
        
        breatheInMessageLabel.text = @"Blow slowly into the monitor, aiming to empty your lungs completely.";
        
        //breatheInMessageLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Begin exhaling steadily into the device", nil)];
        [breathingImageView setImage:[UIImage imageNamed:@"breath_exhale"]];
        
        timerView.hidden = YES;
        
        breatheInMessageLabel.textAlignment = NSTextAlignmentCenter;
        //[breatheInMessageLabel sizeToFit];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:breatheInMessage cache:NO];
        [UIView setAnimationDuration:0.85];
        [UIView commitAnimations];
        
        
        
        
        // breatheInMessageLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Begin to Exhale", nil)];
        ignoreReadings = NO;
        
    }
    
    
    if(countdown >-6){
        if(countdown >0 && countdown <16)
        {
            [timerCountdownLabel setText:[NSString stringWithFormat:@"%d",countdown]];
        }
    }
    else {
        [breatheInMessageLabel setText:@""];
        [timerCountdownLabel setText:@""];
    }
    
}


-(void)enableContinueBtn:(NSTimer *) theTimer
{
    
   // [continueBtn setTitle:TranslatedString(@"Press to Continue", nil) forState:UIControlStateDisabled];
  //  [continueBtn setTitle:TranslatedString(@"Press to Continue", nil) forState:UIControlStateNormal];
   // continueBtn.stateEnabled = YES;
    if(enableContinueTimer)
    {
        //        if(enableContinueTimer.isValid)
        //        {
        //            [enableContinueTimer invalidate];
        //        }
        //        enableContinueTimer = nil;
    }
    
}




-(void)timerEnd
{
   // [continueBtn setHidden:NO];
   // [continueBtn setStateEnabled:NO];
    
    //continueBtn.frame = deviceBtn.frame;
    
    //[countdownLabel setHidden:YES];
    [beginMessage setHidden:YES];
    //[startListenBtn setHidden:NO];
}



- (void)startListener {
    
    recordings = nil;
    recordings = [[NSMutableArray alloc] init];
    lastPeakRecording = 0;
    
    initialOffsetRecordings = nil;
    initialOffsetRecordings = [[NSMutableArray alloc] init];
    
    
    vertSlider.value = 0;
    [self updateFrequencyLabel];
    
    if(overrideConnectedDevice ==NO)
    {
        [rioRef startListening:self];
    }
    isListening = YES;
    
    [startListenBtn setTitle:@"stop" forState:UIControlStateNormal];
    
}

- (void)stopListener {
    @try {
        if(isListening)
        {
            [rioRef stopListening];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
    isListening = NO;
    
    [startListenBtn setTitle:@"start" forState:UIControlStateNormal];
}


//returns to the starting view
-(IBAction) startNewTest:(id)sender
{
    [self stopListener];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
 //animate the screen being pushed
 -(void)hide
 {
 
 //get the view that's currently showing
 UIView *currentView = self.view;
 //get the the underlying UIWindow, or the view containing the current view view
 UIView *theWindow = self.view.superview;
 
 // remove the current view and replace with myView1
 
 [currentView removeFromSuperview];
 
 [theWindow insertSubview:stepTwoViewController.view atIndex:0];
 stepTwoViewController.view.frame = CGRectMake(0, 0, 320, 480);
 
 
 // set up an animation for the transition between the views
 CATransition *animation = [CATransition animation];
 [animation setDuration:0.5];
 [animation setType:kCATransitionPush];
 [animation setSubtype:kCATransitionFromRight];
 //[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
 
 [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
 [[theWindow layer] addAnimation:animation forKey:@"step2"];
 
 NSLog(@"hide triggered");
 
 }
 
 */


//setup the slider bar
-(void)setupSlider
{
    
//    CGRect sliderFrame = CGRectMake(-102, 55, 263, 200);
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (version > 5.0f && version <7.0f)
//    {
//        //sliderFrame = CGRectMake(-39, 106, 263, 200);
//    }
//    [vertSlider setBackgroundColor:[UIColor orangeColor]];
//    vertSlider = [[UISlider alloc] initWithFrame:sliderFrame];
//
//    vertSlider.transform = CGAffineTransformRotate(vertSlider.transform, 270.0/180*M_PI); //270 degrees converted to radians
//
//    UIImage *thumbImage= [UIImage imageNamed:@"diamond.png"];
//
//    UIImage *minImage = [[UIImage imageNamed:@"progBarFull.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:3];
//    UIImage *maxImage = [[UIImage imageNamed:@"progBarEmptyGray.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:3];
//
//    // Setup the image for the slider
//    [vertSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
//    [vertSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
//    [vertSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    
    if(deviceMode)
    {
        vertSlider.minimumValue = 1;
        vertSlider.maximumValue = 8;
        vertSlider.userInteractionEnabled = NO;
    }
    else{
        vertSlider.minimumValue = 1.0;
        vertSlider.maximumValue = 8.0;
    }
    vertSlider.continuous = YES;
    //vertSlider.value = [sharedSoundManager fxVolume];
    
    // Attach an action to sliding
    [vertSlider addTarget:self action:@selector(vertSliderAction:) forControlEvents:UIControlEventValueChanged];
    
    [ppmScaleWrapper addSubview:vertSlider];
    
    
    
    // Cleanup
    
//    minImage = nil;
//    maxImage = nil;
//    thumbImage = nil;
}


//event handler for the sliderbar
-(void) vertSliderAction:(id)sender
{
    //int rounded = floor(vertSlider.value/100 *7 )+1;
    int rounded = floor(vertSlider.value);
    //NSLog(@"rounded = %d",rounded) ;
    
    UIImage *redImgSelected = [UIImage imageNamed:@"redSelected.png"];
    UIImage *redImgDeselected = [UIImage imageNamed:@"redDeselected.png"];
    UIImage *yellowSelected = [UIImage imageNamed:@"yellowSelected.png"];
    UIImage *yellowDeselected = [UIImage imageNamed:@"yellowDeselcted.png"];
    
    int ppmForColourBand = rounded;
    
    /*
     if(deviceMode)
     {
     if(rounded <5)
     {
     ppmForColourBand = 1;
     }
     else if(rounded <10)
     {
     ppmForColourBand = 2;
     }
     else if(rounded <15)
     {
     ppmForColourBand = 3;
     
     }
     else if(rounded < 20)
     {
     ppmForColourBand = 4;
     }
     else if(rounded <25)
     {
     ppmForColourBand = 5;
     }
     else if (rounded < 30)
     {
     ppmForColourBand = 6;
     }
     else
     {
     ppmForColourBand = 7;
     }
     
     
     }
     */
    
    switch (ppmForColourBand) {
        case 1:
            
            [lvl2ImgView setImage:yellowDeselected];
            [lvl3ImgView setImage:redImgDeselected];
            [lvl4ImgView setImage:redImgDeselected];
            [lvl5ImgView setImage:redImgDeselected];
            [lvl6ImgView setImage:redImgDeselected];
            [lvl7ImgView setImage:redImgDeselected];
            //[ppmLabel setTextColor:[UIColor greenSelected]];
            break;
            
        case 2:
            [lvl2ImgView setImage:yellowSelected];
            [lvl3ImgView setImage:redImgDeselected];
            [lvl4ImgView setImage:redImgDeselected];
            [lvl5ImgView setImage:redImgDeselected];
            [lvl6ImgView setImage:redImgDeselected];
            [lvl7ImgView setImage:redImgDeselected];
           // [ppmLabel setTextColor:[UIColor yellowSelected]];
            break;
        case 3:
            
            [lvl2ImgView setImage:yellowSelected];
            [lvl3ImgView setImage:redImgSelected];
            [lvl4ImgView setImage:redImgDeselected];
            [lvl5ImgView setImage:redImgDeselected];
            [lvl6ImgView setImage:redImgDeselected];
            [lvl7ImgView setImage:redImgDeselected];
           // [ppmLabel setTextColor:[UIColor redSelected]];
            break;
        case 4:
            [lvl2ImgView setImage:yellowSelected];
            [lvl3ImgView setImage:redImgSelected];
            [lvl4ImgView setImage:redImgSelected];
            [lvl5ImgView setImage:redImgDeselected];
            [lvl6ImgView setImage:redImgDeselected];
            [lvl7ImgView setImage:redImgDeselected];
           // [ppmLabel setTextColor:[UIColor redSelected]];
            
            break;
        case 5:
            [lvl2ImgView setImage:yellowSelected];
            [lvl3ImgView setImage:redImgSelected];
            [lvl4ImgView setImage:redImgSelected];
            [lvl5ImgView setImage:redImgSelected];
            [lvl6ImgView setImage:redImgDeselected];
            [lvl7ImgView setImage:redImgDeselected];
           // [ppmLabel setTextColor:[UIColor redSelected]];
            break;
        case 6:
            [lvl2ImgView setImage:yellowSelected];
            [lvl3ImgView setImage:redImgSelected];
            [lvl4ImgView setImage:redImgSelected];
            [lvl5ImgView setImage:redImgSelected];
            [lvl6ImgView setImage:redImgSelected];
            [lvl7ImgView setImage:redImgDeselected];
           // [ppmLabel setTextColor:[UIColor redSelected]];
            break;
        case 7:
            [lvl2ImgView setImage:yellowSelected];
            [lvl3ImgView setImage:redImgSelected];
            [lvl4ImgView setImage:redImgSelected];
            [lvl5ImgView setImage:redImgSelected];
            [lvl6ImgView setImage:redImgSelected];
            [lvl7ImgView setImage:redImgSelected];
           // [ppmLabel setTextColor:[UIColor redSelected]];
            break;
            
        default:
            break;
    }
    
    //      readingValue = vertSlider.value;
    //      NSString *readingString =[[NSString alloc] initWithFormat:@"%1.2f", readingValue];
    //      reading.text = readingString;
    if(deviceMode == NO)
    {
        float rem =vertSlider.value - rounded;
        if(vertSlider.value >1.05)
            rem += 0.1;
        int sliderRemainder =  rem*10;
        switch (rounded) {
            case 1:
                
                manualPPMReadingPrecise = lroundf((7.0f/10.0f) * sliderRemainder);
                if(manualPPMReadingPrecise>6)
                    manualPPMReadingPrecise = 6;
                break;
            case 2:
                manualPPMReadingPrecise = lroundf((5.0f/10.0f) * sliderRemainder) +6;
                if(manualPPMReadingPrecise >10)
                    manualPPMReadingPrecise = 10;
                if(manualPPMReadingPrecise <7)
                    manualPPMReadingPrecise = 7;
                break;
            case 3:
                manualPPMReadingPrecise = lroundf((6.0f/10.0f) * sliderRemainder) +10;
                if(manualPPMReadingPrecise >15)
                    manualPPMReadingPrecise = 15;
                if(manualPPMReadingPrecise <11)
                    manualPPMReadingPrecise = 11;
                break;
            case 4:
                manualPPMReadingPrecise = lroundf((6.0f/10.0f) * sliderRemainder) +15;
                if(manualPPMReadingPrecise > 20)
                    manualPPMReadingPrecise = 20;
                if(manualPPMReadingPrecise < 16)
                    manualPPMReadingPrecise = 16;
                break;
            case 5:
                manualPPMReadingPrecise = lroundf((6.0f/10.0f) * sliderRemainder) +20;
                if(manualPPMReadingPrecise >25)
                    manualPPMReadingPrecise = 25;
                if(manualPPMReadingPrecise < 21)
                    manualPPMReadingPrecise = 21;
                break;
            case 6:
                manualPPMReadingPrecise = lroundf((6.0f/10.0f) * sliderRemainder) +25;
                if(manualPPMReadingPrecise > 30)
                    manualPPMReadingPrecise = 30;
                if(manualPPMReadingPrecise < 26)
                    manualPPMReadingPrecise = 26;
                break;
            case 7:
                
                manualPPMReadingPrecise = lroundf((6.0f/10.0f) * sliderRemainder) +30;
                if(manualPPMReadingPrecise >35)
                    manualPPMReadingPrecise = 35;
                if(manualPPMReadingPrecise <31)
                    manualPPMReadingPrecise = 31;
                break;
            default:
                break;
        }
        [ppmLabel setText:[NSString stringWithFormat: @"%@",[NSNumber numberWithInt: manualPPMReadingPrecise]]];
    }
}




-(IBAction)setSliderToCentre:(id)sender
{
    vertSlider.value = floor(vertSlider.value) + 0.35;
    if(vertSlider.value > 7)
    {
        vertSlider.value = 7.35;
    }
    
    if(vertSlider.value <0)
        vertSlider.value = 0.35;
    if(vertSlider.value >7.35)
        vertSlider.value = 7.35;
    
    /*
     if(deviceMode)
     {
     if(vertSlider.value > 99)
     {
     vertSlider.value = 99.35;
     }
     
     if(vertSlider.value <0)
     vertSlider.value = 0.35;
     if(vertSlider.value >99.35)
     vertSlider.value = 99.35;
     }
     else{
     vertSlider.value = floor(vertSlider.value) + 0.35;
     if(vertSlider.value > 7)
     {
     vertSlider.value = 7.35;
     }
     
     if(vertSlider.value <0)
     vertSlider.value = 0.35;
     if(vertSlider.value >7.35)
     vertSlider.value = 7.35;
     vertSlider.value = floor(vertSlider.value) + 0.35;
     
     }
     */
}




#pragma mark -
#pragma mark Key Management
// This method gets called by the rendering function. Update the UI with
// the character type and store it in our string.
- (void)frequencyChangedWithValue:(float)newFrequency{
    //NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"the freq = %f",newFrequency);
    if(ignoreReadings == NO )
    {
        self.currentFrequency = newFrequency;
        [self performSelectorInBackground:@selector(updateFrequencyLabel) withObject:nil];
    }
    else if(addToInitialOffset == YES)
    {
        beforeRecordingCurrentFrequency = newFrequency;
        [self performSelectorInBackground:@selector(addBeforeRecordingFrequencyToInitialOffsetRecording) withObject:nil];
        //NSLog(@"before freq = %f",newFrequency);
    }
    else if(countdown >6)//uses this to see if the device is responding to the 5khz
    {
        beforeRecordingCurrentFrequency = newFrequency;
        // NSLog(@"before freq = %f",newFrequency);
    }
    /*
     * If you want to display letter values for pitches, uncomment this code and
     * add your frequency to pitch mappings in KeyHelper.m
     */
    
    /*
     KeyHelper *helper = [KeyHelper sharedInstance];
     NSString *closestChar = [helper closestCharForFrequency:newFrequency];
     
     // If the new sample has the same frequency as the last one, we should ignore
     // it. This is a pretty inefficient way of doing comparisons, but it works.
     if (![prevChar isEqualToString:closestChar]) {
     self.prevChar = closestChar;
     if ([closestChar isEqualToString:@"0"]) {
     //    [self toggleListening:nil];
     }
     [self performSelectorInBackground:@selector(updateFrequencyLabel) withObject:nil];
     NSString *appendedString = [key stringByAppendingString:closestChar];
     self.key = [NSMutableString stringWithString:appendedString];
     }
     */
    //    [pool drain];
    //    pool = nil;
    
}

-(void)addBeforeRecordingFrequencyToInitialOffsetRecording
{
    if(beforeRecordingCurrentFrequency > 700 && beforeRecordingCurrentFrequency <1300)
    {
        [initialOffsetRecordings addObject:[NSNumber numberWithFloat:beforeRecordingCurrentFrequency]];
    }
}

- (void)updateFrequencyLabel {
    // NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    // self.currentPitchLabel.text = [NSString stringWithFormat:@"%f", self.currentFrequency];
    // [self.currentPitchLabel setNeedsDisplay];
    
    int ppm = round([self findPeakPPM] *100)/100;
    
    //    TimeReading *tr = [[TimeReading alloc] init];
    //
    //    [tr setDatetime:[NSDate date]];
    //    [tr setFrequency:self.currentFrequency ];
    //    [recordings addObject:tr];
    
    //[tr release];
    
    if(ppm <= 6)
    {
        vertSlider.value = ((float)ppm /7) +1;
    }
    else if(ppm <= 10){
        vertSlider.value = ((float)(ppm-7) /4) + 2;
        
    }
    else if(ppm <= 15){
        vertSlider.value = ((float)(ppm-11) /5) +3;
        
    }
    else if(ppm <= 20){
        vertSlider.value = ((float)(ppm-16) /5) +4;
        
    }
    else if(ppm <= 25){
        vertSlider.value = ((float)(ppm-21) /5) +5;
        
    }
    else if(ppm <= 30){
        vertSlider.value = ((float)(ppm-26) /5) +6;
        
    }
    else
    {
        vertSlider.value = ((float)(ppm-31) /5) +7;
        if(vertSlider.value >8)
            vertSlider.value = 8;
    }
    
    // NSLog(@"slider %f, ppm %d",vertSlider.value,ppm);
    
    if ([NSThread isMainThread])
    {
        [ppmLabel setText:[NSString stringWithFormat: @"%@",[NSNumber numberWithInt: ppm]]];
        [self vertSliderAction:nil];
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [ppmLabel setText:[NSString stringWithFormat: @"%@",[NSNumber numberWithInt: ppm]]];
            [self vertSliderAction:nil];
        });
    }
    
    
    
    // ppmLabel.frame = CGRectMake(ppmLabel.frame.origin.x, vertSlider.frame.origin.y + vertSlider.frame.size.height -((vertSlider.frame.size.width/100) *ppm)-35 , ppmLabel.frame.size.width, ppmLabel.frame.size.height);
    
    // NSLog(@"slier frame %f, %f, %f, %f",vertSlider.frame.origin.x, vertSlider.frame.origin.y, vertSlider.frame.size.width,vertSlider.frame.size.height);
    // NSLog(@"ppm frame %f, %f, %f, %f",ppmLabel.frame.origin.x, ppmLabel.frame.origin.y, ppmLabel.frame.size.width,ppmLabel.frame.size.height);
    
    //    [pool drain];
    //    pool = nil;
}



-(double)findPeakPPM
{
    double peaked = lastPeakRecording;
    //    NSArray *recordingscopy = [recordings copy];
    //    for(TimeReading *t in recordingscopy)
    //    {
    //        if([t frequency] > peaked && [t frequency] <= 9000)
    //        {
    //            peaked = [t frequency];
    //        }
    //    }
    if(currentFrequency > lastPeakRecording && currentFrequency <= 9000)
    {
        lastPeakRecording = currentFrequency;
        peaked = lastPeakRecording;
    }
    if(peaked >=beforeRecordingCurrentFrequency)
    {
        peaked = peaked - beforeRecordingCurrentFrequency;
        peaked = (peaked*10) /scaling;//this scales the frequency to PPM (0-100 PPM)
    }
    else{
        peaked = 0.0;
    }
    return  peaked;
}

-(IBAction)playFrequency
{
    //    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
    //    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    if(_deviceBtn.hidden == YES)
    {
        return;
    }
    
    NSString* routeStr = [self audioRouteAvailable];
    
    //    NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
    NSRange receiverRange = [routeStr rangeOfString : @"Receiver"];
    NSRange microphoneRange = [routeStr rangeOfString : @"SpeakerAndMicrophone"];
    //    NSRange headsetRange = [routeStr rangeOfString : @"HeadsetInOut"];
    NSRange connected = [routeStr rangeOfString:@"Connected"];
    
    //    BOOL headphonefortesting = [routeStr rangeOfString:@"Headphone"].location != NSNotFound;
    
    BOOL triedPlayAndFailed = NO;
    
    if(playing)
    {
        //[self stopPlaying];
    }
    else
    {
        if(connected.location != NSNotFound || overrideConnectedDevice == YES ) {
            // Don't change the route if the headset is plugged in.
            NSLog(@"headphone is plugged in ");
            if(!playing)
            {
                [appSoundPlayer setNumberOfLoops:-1];
                [appSoundPlayer play];
              
                playing = YES;
            }
            else{
                
                triedPlayAndFailed = YES;
            }
            
        }
        else if (receiverRange.location != NSNotFound) {
            // Change to play on the speaker
            NSLog(@"play on the speaker");
            triedPlayAndFailed = YES;
            
        }else if (microphoneRange.location != NSNotFound) {
            // Change to play on the speaker
            NSLog(@" on SpeakerAndMicrophone");
            triedPlayAndFailed = YES;
            
        }
        else {
            NSLog(@"Unknown audio route.");
            triedPlayAndFailed = YES;
            
        }
    }
    
    
    // AudioSessionGetProperty (   kAudioSessionProperty_AudioInputAvailable,  &propertySize,      &audioInputIsAvailable);
    
    
    [audioRouteLabel setText:routeStr];
    NSLog(@"%@",routeStr);
    
    if(triedPlayAndFailed)
    {
        
        connectedDeviceAlert = [[UIAlertView alloc] initWithTitle:@"Connected Device"
                                                          message:@"An iCO device is not properly connected, please reconnect the device or choose the manual option."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [connectedDeviceAlert addButtonWithTitle:@"Manual"];
        [connectedDeviceAlert show];
        
        
    }
    else{
        // the device is on, start the instrucitons
        //[self startCountDown];
        [self toggleListening:nil];
        
        //        CGRect tempRect = breatheInMessage.frame;
        //
        //        breatheInMessage.frame = CGRectMake(breatheInMessage.frame.origin.x + breatheInMessage.frame.size.width/2, breatheInMessage.frame.origin.y + breatheInMessage.frame.size.height/2 , 0, 0);
        //
        //        breatheInMessage.hidden = NO;
        //
        //        [UIView animateWithDuration:8.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations: (void (^)(void))^{
        //            breatheInMessage.transform=CGAffineTransformMakeScale(1.2, 1.2);
        //        }completion:^(BOOL finished){
        //            breatheInMessage.transform=CGAffineTransformIdentity;
        //        }];
        
    }
    //[routeStr release];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == connectedDeviceAlert)
    {
        if(buttonIndex ==0)
        {
            deviceMode = YES;
            vertSlider.minimumValue = 0;
            vertSlider.maximumValue = 36;
            vertSlider.userInteractionEnabled = NO;
        }
        else if(buttonIndex ==1)//manual
        {
            [_deviceBtn setHidden:YES];
            [_continueBtn setHidden:NO];
             // [_continueBtn setStateEnabled:YES];
             // continueBtn.frame = deviceBtn.frame;
            
            deviceMode = NO;
            vertSlider.minimumValue = 1;
            vertSlider.maximumValue = 8;
            vertSlider.userInteractionEnabled = YES;
            
        }
    }
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    
}


-(void)stopPlaying
{
    
    if(playing)
    {
        [appSoundPlayer stop];
        playing = NO;
        [startListenBtn setTitle:@"start" forState:UIControlStateNormal];
        
        //[self toggleListening:nil];
        if(isListening)
        {
            [self stopListener];
        }
        [beginMessage setHidden:YES];
        [startListenBtn setHidden:NO];
       // [continueBtn setStateEnabled:YES];
    }
}



-(NSString *)audioRouteAvailable
{
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    CFStringRef audioInputIsAvailable;                            // 1
    
    UInt32 propertySize = sizeof (audioInputIsAvailable);    // 2
    
    
    AudioSessionGetProperty (                                // 3
                             
                             kAudioSessionProperty_AudioInputAvailable,
                             
                             &propertySize,
                             
                             &audioInputIsAvailable
                             
                             );
    
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &audioInputIsAvailable);
    
    NSString *audRoute = (__bridge NSString *)audioInputIsAvailable;
    
    // BOOL headphonefortesting = [audRoute rangeOfString:@"Headphone"].location != NSNotFound;
    
    if([audRoute rangeOfString:@"HeadsetInOut"].location != NSNotFound  )
    {
        audRoute = @"Connected";
        // [startListenBtn setEnabled:YES];
    }
    else{
        
        audRoute = @"Unplugged";
        //  [startListenBtn setEnabled:NO];
        [self stopPlaying];
    }
    return  audRoute ;
}

-(void)resetValues:(id)sender
{
    [self stopListener];
    [ppmLabel setText:@"0"];
    //   [currentPitchLabel setText:@"0"];
    [audioRouteLabel setText:[self audioRouteAvailable]];
    
}

-(void)useDevice:(id)sender
{
    //    DeviceInputViewController *devInputVC = [[DeviceInputViewController alloc] init];
    //    [devInputVC setDelegate:self];
    //
    //    [UIView beginAnimations:@"animation" context:nil];
    //
    //
    //    [self.navigationController pushViewController: devInputVC animated:NO];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    //     [UIView setAnimationDuration:0.85];
    //    [UIView commitAnimations];
    if([self isMicrophonePrivacyOn])
    {
        if(begun == YES)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Microphone Access"
                                                            message:@"Please allow Smokerlyzer access to the microphone, if you are not prompted please go to your phone Settings -> Privacy -> Microphone"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        begun = YES;
    }
    else
    {
        [self playFrequency];
    }
}

-(BOOL)isMicrophonePrivacyOn
{
    __block BOOL privacyOn;
    if([[AVAudioSession sharedInstance] respondsToSelector: @selector(requestRecordPermission:)])
    {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if(!granted)
            {
                privacyOn = YES;
            }
            
            else
            {
                privacyOn = NO;
            }
        }];
        return privacyOn;
        
    }
    else
    {
        return NO;
    }
}


- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) appSoundPlayer successfully: (BOOL) flag {
    
    playing = NO;
    [startListenBtn setEnabled: YES];
    [startListenBtn setTitle:@"start" forState:UIControlStateNormal];
}


- (void) audioPlayerBeginInterruption: player {
    
    NSLog (@"Interrupted. The system has paused audio playback.");
    
    if (playing) {
        
        playing = NO;
        interruptedOnPlayback = YES;
        //[self toggleListening:nil];
    }
}

- (void) audioPlayerEndInterruption: player {
    
    NSLog (@"Interruption ended. Resuming audio playback.");
    
    // Reactivates the audio session, whether or not audio was playing
    //        when the interruption arrived.
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    if (interruptedOnPlayback) {
        
        [appSoundPlayer prepareToPlay];
        [appSoundPlayer play];
        playing = YES;
        interruptedOnPlayback = NO;
        //[self toggleListening:nil];
    }
}



#pragma mark Application setup____________________________

#if TARGET_IPHONE_SIMULATOR
#warning *** Simulator mode: iPod library access works only when running on a device.
#endif

- (void) setupApplicationAudio {
    
    // Gets the file system path to the sound to play.
    NSString *soundFilePath = [[NSBundle mainBundle]    pathForResource:    @"tone500square30sec"
                                                                 ofType:                @"caf"];
    
    // Converts the sound's file path to an NSURL object
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    self.soundFileURL = newURL;
    //[newURL release];
    // Registers this class as the delegate of the audio session.
    // [[AVAudioSession sharedInstance] setDelegate: self];
    
    // The AmbientSound category allows application audio to mix with Media Player
    // audio. The category also indicates that application audio should stop playing
    // if the Ring/Siilent switch is set to "silent" or the screen locks.
    //[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    /*
     // Use this code instead to allow the app sound to continue to play when the screen is locked.
     [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
     
     UInt32 doSetProperty = 0;
     AudioSessionSetProperty (
     kAudioSessionProperty_OverrideCategoryMixWithOthers,
     sizeof (doSetProperty),
     &doSetProperty
     );
     */
    
    // Registers the audio route change listener callback function
    /*
     AudioSessionAddPropertyListener (
     kAudioSessionProperty_AudioRouteChange,
     audioRouteChangeListenerCallback,
     self
     );
     */
    // Activates the audio session.
    
    //NSError *activationError = nil;
    //[[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    
    // Instantiates the AVAudioPlayer object, initializing it with the sound
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: soundFileURL error: nil];
    
    self.appSoundPlayer = newPlayer ;
    //[self.appSoundPlayer retain];
    //[newPlayer release];
    
    // "Preparing to play" attaches to the audio hardware and ensures that playback
    // starts quickly when the user taps Play
    
    [appSoundPlayer prepareToPlay];
    [appSoundPlayer setVolume: 1.0];
    [appSoundPlayer setDelegate: self];
    [audioRouteLabel setText:[self audioRouteAvailable]];
    
    // AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, (__bridge void *)self);
}

//void audioRouteChangeListenerCallback(void  *inClientData,AudioSessionPropertyID  inID,UInt32 inDataSize,const void *inData)
//{
//    if ( inID == kAudioSessionProperty_AudioRouteChange ) {
//        //StepOneViewController *controller = (__bridge StepOneViewController *) inClientData;
//        //[controller performSelector:@selector(audioRouteChanged)];
//    }
//}



-(void)handleInterruption:(NSNotification*)notification{
    // NSInteger reason = 0;
    NSString* reasonStr = @"";
    if ([notification.name isEqualToString:@"AVAudioSessionInterruptionNotification"]) {
        
        /*
         //Posted when an audio interruption occurs.
         reason = [[[notification userInfo] objectForKey:@" AVAudioSessionInterruptionTypeKey"] integerValue];
         if (reason == AVAudioSessionInterruptionTypeBegan) {
         //       Audio has stopped, already inactive
         //       Change state of UI, etc., to reflect non-playing state
         
         }
         
         if (reason == AVAudioSessionInterruptionTypeEnded) {
         //       Make session active
         //       Update user interface
         //       AVAudioSessionInterruptionOptionShouldResume option
         reasonStr = @"AVAudioSessionInterruptionTypeEnded";
         NSNumber* seccondReason = [[notification userInfo] objectForKey:@"AVAudioSessionInterruptionOptionKey"] ;
         switch ([seccondReason integerValue]) {
         case AVAudioSessionInterruptionOptionShouldResume:
         //          Indicates that the audio session is active and immediately ready to be used. Your app can resume the audio operation that was interrupted.
         break;
         default:
         break;
         }
         }
         
         
         if ([notification.name isEqualToString:@"AVAudioSessionDidBeginInterruptionNotification"]) {
         
         //      Posted after an interruption in your audio session occurs.
         //      This notification is posted on the main thread of your app. There is no userInfo dictionary.
         }
         if ([notification.name isEqualToString:@"AVAudioSessionDidEndInterruptionNotification"]) {
         //      Posted after an interruption in your audio session ends.
         //      This notification is posted on the main thread of your app. There is no userInfo dictionary.
         }
         if ([notification.name isEqualToString:@"AVAudioSessionInputDidBecomeAvailableNotification"]) {
         //      Posted when an input to the audio session becomes available.
         //      This notification is posted on the main thread of your app. There is no userInfo dictionary.
         }
         if ([notification.name isEqualToString:@"AVAudioSessionInputDidBecomeUnavailableNotification"]) {
         //      Posted when an input to the audio session becomes unavailable.
         //      This notification is posted on the main thread of your app. There is no userInfo dictionary.
         }
         
         */
        [self audioRouteChanged];
        
    };
    NSLog(@"handleInterruption: %@ reason %@",[notification name],reasonStr);
}

-(void)handleRouteChange:(NSNotification*)notification{
    AVAudioSession *session = [ AVAudioSession sharedInstance ];
    NSString* seccReason = @"";
    NSInteger  reason = [[[notification userInfo] objectForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    //  AVAudioSessionRouteDescription* prevRoute = [[notification userInfo] objectForKey:AVAudioSessionRouteChangePreviousRouteKey];
    switch (reason) {
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            seccReason = @"The route changed because no suitable route is now available for the specified category.";
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            seccReason = @"The route changed when the device woke up from sleep.";
            break;
        case AVAudioSessionRouteChangeReasonOverride:
            seccReason = @"The output route was overridden by the app.";
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            seccReason = @"The category of the session object changed.";
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            seccReason = @"The previous audio output path is no longer available.";
            break;
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            seccReason = @"A preferred new audio output path is now available.";
            break;
        case AVAudioSessionRouteChangeReasonUnknown:
        default:
            seccReason = @"The reason for the change is unknown.";
            break;
    }
    NSLog(@"handle route changed %@",seccReason);
    AVAudioSessionPortDescription *input = [[session.currentRoute.inputs count]?session.currentRoute.inputs:nil objectAtIndex:0];
    if (input.portType == AVAudioSessionPortHeadsetMic) {
        
    }
    
    [self audioRouteChanged];
}


-(void )audioRouteChanged
{
    NSLog(@"AudioRouteChanged");
    NSString *status = [self audioRouteAvailable];
    [audioRouteLabel setText:status];
    
    if(disableButtonTimer)
    {
        [disableButtonTimer invalidate];
        disableButtonTimer = nil;
    }
    
    //_deviceBtn.stateEnabled = NO;
    
    
    if([status isEqualToString:@"Connected"]|| overrideConnectedDevice ==YES)
    {
        if (isListening) {
            [self stopListener];
        }
        if(!playing)
        {
            [self playFrequency];
        }
        if(_deviceBtn.hidden == NO)
        {
            [self resetDeviceButtonTimer];
        }
    }
    else{
        
        if (isListening) {
            [self stopListener];
        }
        if(playing)
        {
            [self stopPlaying];
        }
    }
    
    
    //[status release];
    
}




#pragma  mark device input delegate

-(void)ppmReadingFromDevice:(int)ppmReading
{
    float sliderVal = 0.35;
    if(ppmReading > 0 && ppmReading < 7)
    {
        sliderVal +=1;
    }
    else if(ppmReading >=7 && ppmReading <11)
    {
        sliderVal +=2;
    }
    else if(ppmReading >=11 && ppmReading <16)
    {
        sliderVal += 3;
    }
    else if(ppmReading >=16 && ppmReading <21)
    {
        sliderVal +=4;
    }
    else if(ppmReading >=21 && ppmReading < 26)
    {
        sliderVal += 5;
    }
    else if(ppmReading >=26 && ppmReading < 31)
    {
        sliderVal +=6;
    }
    else if(ppmReading >=31)
    {
        sliderVal += 7;
    }
    vertSlider.value = sliderVal;
    [self vertSliderAction:nil];
}

//start the step 2 view, passing the slider control arguments to it

-(IBAction)continueToStepTwo:(id)sender
{
    @try {
        
        
        if(isListening)
        {
            [self stopListener];
        }
        if(playing)
        {
            [self stopPlaying];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    
    //NSLog(@"the button selected was ermmmm %d",[sender tag] );
    NSString *tit;
    
    
    //int floored = floor(vertSlider.value/100 *7 )+1;
    int floored = floor(vertSlider.value);
    
    if(floored <1)
    {
        floored = 1;
    }
    else if(floored >7)
    {
        floored = 7;
    }
    
    
    switch(floored)
    {
        case 1:
            tit = @"0 - 6";
            //ppmReadingPrecise = 3;
            break;
        case 2:
            tit = @"7 - 10";
            //ppmReadingPrecise = 8;
            break;
        case 3:
            tit = @"11 - 15";
            //ppmReadingPrecise = 13;
            break;
        case 4:
            tit = @"16 - 20";
            //ppmReadingPrecise = 18;
            break;
        case 5:
            tit = @"21 - 25";
            //ppmReadingPrecise = 23;
            break;
        case 6:
            tit = @"26 - 30";
            //ppmReadingPrecise = 28;
            break;
        case 7:
            tit = @"31+";
            //ppmReadingPrecise = 31;
            break;
        default:
            tit = @"";
            break;
            
    }
    
    
    
    selectedLvl = floored;
    
    //NSLog(@"the title : %@",tit);
    
    
   // ResultStore *resStore = [ResultStore defaultResultStore];
    
   // [[resStore getCurrentResult] setPpm_reading_level:selectedLvl];
   // [[[ResultStore defaultResultStore]getCurrentResult]setReading_date:[NSDate date]];
    
    if(deviceMode)
    {
       // int currentUsedWithDeviceCount = [[[ResultStore defaultResultStore]getCurrentSettings]usedWithDeviceCount];
       // currentUsedWithDeviceCount++;
       // [[[ResultStore defaultResultStore]getCurrentResult]setPpm_reading_precise: round([self findPeakPPM] *100)/100];
       // [[[ResultStore defaultResultStore] getCurrentSettings] setUsedWithDeviceCount:currentUsedWithDeviceCount];
       // [[[ResultStore defaultResultStore ] getCurrentResult]setManual_reading:NO];
        
        
    }
    else{
       // [[[ResultStore defaultResultStore]getCurrentResult] setPpm_reading_precise:manualPPMReadingPrecise];
      //  [[[ResultStore defaultResultStore ] getCurrentResult]setManual_reading:YES];
    }
    
    
    
    
//    if([[resStore getCurrentSettings] mode]==1)
//    {
//        [[resStore getCurrentResult] setSkipped_questions:YES];
////        ReportV2ViewController *reportV2VC = [[ReportV2ViewController alloc] initWithLevel:floored theRange:tit];
////        [self.navigationController pushViewController:reportV2VC animated:YES];
//    }
//    else
//    {
//
//        [[resStore getCurrentResult] setSkipped_questions:NO];
//
////        StepTwoViewController *stepTwoViewController = [[StepTwoViewController alloc]
////                                                        initWithNibName:@"StepTwoViewController" bundle:nil];
////        //[stepTwoViewController giveStepOneChoicesToTwoWithLevel:(vertSlider.value /100 *36) range: tit];
////        [stepTwoViewController giveStepOneChoicesToTwoWithLevel:floored range: tit];
////
////        [self.navigationController pushViewController:stepTwoViewController animated:YES];
//    }
//
    
    
    
    
    
    
    //[self hide];
}



@end
