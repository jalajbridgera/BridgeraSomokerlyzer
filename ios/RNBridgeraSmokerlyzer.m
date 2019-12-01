
#import "CommunicateDeviceViewController.h"
#import <UIKit/UIKit.h>
#import "RNBridgeraSmokerlyzer.h"

#if __has_include(<React/RCTEventDispatcher.h>)
#import <React/RCTEventDispatcher.h>
#else
#import "RCTEventDispatcher.h"
#endif

@implementation RNBridgeraSmokerlyzer

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueuex
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

  RCT_EXPORT_METHOD(registerCallBack:(int)devicePin)
  {
  //    [[NSNotificationCenter defaultCenter] addObserver:self
  //    selector:@SEL(methodYouWantToInvoke:) //note the ":" - should take an NSNotification as parameter
  //        name:@"SomethingInterestingDidHappenNotification"
  //      object:objectOfNotification]; //if you specify nil for object, you get all the notifications with the matching name, regardless of who sent them
      
      
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceModeChange:) name:@"deviceMode" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleButtonUpdate:) name:@"buttonUpdate" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleViewTimeUpdate:) name:@"viewTimeUpdate" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTimeUpdate:) name:@"timeUpdate" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResult:) name:@"result" object:nil];
      
      [CommunicateDeviceViewController initializeLibrary:devicePin];
  }

  RCT_EXPORT_METHOD(startTest:(RCTResponseSenderBlock)callback)
  {
      //callback(@[text]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startTest" object:nil userInfo:nil];
  }

  RCT_EXPORT_METHOD(callMyName:(NSString *)text:(RCTResponseSenderBlock)callback)
  {
      callback(@[text]);
      
  }
-(void)handleDeviceModeChange:(NSNotification *)notification{
    NSLog(@"%@",notification.userInfo);
    NSDictionary *dict = notification.userInfo;
    
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"smokerlyzerDidChange"
                                                    body:@{@"smokerlyzer": [dict valueForKey:@"info"]}];
}
-(void)handleButtonUpdate:(NSNotification *)notification{
    
    NSLog(@"%@",notification.userInfo);
    NSDictionary *dict = notification.userInfo;
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"smokerlyzerDidChange"
                                                    body:@{@"smokerlyzer": [dict valueForKey:@"info"]}];
}
-(void)handleTimeUpdate:(NSNotification *)notification{
    
    NSLog(@"%@",notification.userInfo);
    NSDictionary *dict = notification.userInfo;
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"smokerlyzerDidChange"
                                                    body:@{@"smokerlyzer": [dict valueForKey:@"info"]}];
}
-(void)handleViewTimeUpdate:(NSNotification *)notification{
    NSLog(@"%@",notification.userInfo);
    NSDictionary *dict = notification.userInfo;
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"smokerlyzerDidChange"
                                                    body:@{@"smokerlyzer": [dict valueForKey:@"info"]}];
}
-(void)handleResult:(NSNotification *)notification{
    NSLog(@"%@",notification.userInfo);
    NSDictionary *dict = notification.userInfo;
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"smokerlyzerDidChange"
                                                    body:@{@"smokerlyzer": [dict valueForKey:@"info"]}];
}
  @end
