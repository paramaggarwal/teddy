//
//  FirstViewController.m
//  Teddy
//
//  Created by Param Aggarwal on 08/11/14.
//  Copyright (c) 2014 DP. All rights reserved.
//

#import "FirstViewController.h"
#import <Beaconstac_v_0_9_7/Beaconstac.h>

@interface FirstViewController () <BeaconstacDelegate>

@property Beaconstac *beaconstac;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[MSLogger sharedInstance]setLoglevel:MSLogLevelVerbose];
    
    // Setup and initialize the Beaconstac SDK
    
    BOOL success = [Beaconstac setupOrganizationId:84
                                         userToken:@"9e5bc5b1e14fd49ec21d47287e546130b1d286e9"
                                        beaconUUID:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
                                  beaconIdentifier:@"com.beaconstac"];
    
    if (success) {
        NSLog(@"DemoApp:Successfully saved credentials.");
    }
    
    self.beaconstac = [[Beaconstac alloc]init];
    self.beaconstac.delegate = self;
    
    // Demonstrates Custom Attributes functionality.
    [self customAttributeDemo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Beaconstac delegate
// Tells the delegate a list of beacons in range.
- (void)beaconsRanged:(NSDictionary *)beaconsDictionary
{
}

// Tells the delegate about the camped on beacon among available beacons.
- (void)campedOnBeacon:(id)beacon amongstAvailableBeacons:(NSDictionary *)beaconsDictionary
{
    NSLog(@"DemoApp:Entered campedOnBeacon");
    NSLog(@"DemoApp:campedOnBeacon: %@, %@", beacon, beaconsDictionary);
    NSLog(@"DemoApp:facts Dict: %@", _beaconstac.factsDictionary);
}

// Tells the delegate when the device exits from the camped on beacon range.
- (void)exitedBeacon:(id)beacon
{
    NSLog(@"DemoApp:Entered exitedBeacon");
    NSLog(@"DemoApp:exitedBeacon: %@", beacon);
    
}

// Tells the delegate that a rule is triggered with corresponding list of actions.
- (void)ruleTriggeredWithRuleName:(NSString *)ruleName actionArray:(NSArray *)actionArray
{
    NSLog(@"DemoApp:Action Array: %@", actionArray);
    //
    // actionArray contains the list of actions to trigger for the rule that matched.
    //
    for (NSDictionary *actionDict in actionArray) {
        //
        // meta.action_type can be "popup", "webpage", "media", or "custom"
        //
        if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"popup"]) {
            //
            // Show an alert
            //
            NSLog(@"DemoApp:Text Alert action type");
            NSString *message = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"text"];
            [[[UIAlertView alloc] initWithTitle:ruleName message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            
        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"webpage"]) {
            //
            // Handle webpage by popping up a WebView
            //
            NSLog(@"DemoApp:Webpage action type");
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            UIWebView *webview=[[UIWebView alloc]initWithFrame:screenRect];
            NSString *url=[[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
            NSURL *nsurl=[NSURL URLWithString:url];
            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
            [webview loadRequest:nsrequest];
            
            [self.view addSubview:webview];
            
            // Setting title of the current View Controller
            self.title = @"Webpage action";
            
        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"custom"]) {
            //
            // Custom JSON converted to NSDictionary - it's up to you how you want to handle it
            //
            NSDictionary *params = [[actionDict objectForKey:@"meta"]objectForKey:@"params"];
            NSLog(@"DemoApp:Received custom action_type: %@", params);
            
        }
    }
}

- (void)customAttributeDemo
{
    [_beaconstac updateFact:@"female" forKey:@"Gender"];
}

@end
