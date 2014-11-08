//
//  FirstViewController.m
//  Teddy
//
//  Created by Param Aggarwal on 08/11/14.
//  Copyright (c) 2014 DP. All rights reserved.
//

#import "FirstViewController.h"
#import <Beaconstac_v_0_9_7/Beaconstac.h>
#import <Parse/Parse.h>

@interface FirstViewController () <BeaconstacDelegate, UIAlertViewDelegate>

@property Beaconstac *beaconstac;
@property NSString *username;
@property UITextField *loginField;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (!self.username) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Enter user name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        self.loginField = [alertView textFieldAtIndex:0];
        [alertView show];
    }
    
    self.teddyImageView.image = nil;
    self.teddyNameLabel.text = @"Searching...";
    self.teddyMessageLabel.text = @"";
    
}

- (void)setup {
    [[MSLogger sharedInstance]setLoglevel:MSLogLevelVerbose];
    
    BOOL success = NO;
    if ([self.username isEqualToString:@"param"]) {
        self.teddyNameLabel.text = @"Bos";
        self.teddyImageView.image = [UIImage imageNamed:@"bos"];
        self.teddyMessageLabel.text = @"I need a walk. Let's go out.";
        
        success = [Beaconstac setupOrganizationId:79
                                             userToken:@"e3663f9911a6f1c99c078a09967feaba52d39935"
                                            beaconUUID:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
                                      beaconIdentifier:@"com.beaconstac.param"];
        
    } else {
        self.teddyNameLabel.text = @"Marco";
        self.teddyImageView.image = [UIImage imageNamed:@"marco"];
        self.teddyMessageLabel.text = @"Don't leave me alone for so long!";
        
        success = [Beaconstac setupOrganizationId:84
                                             userToken:@"9e5bc5b1e14fd49ec21d47287e546130b1d286e9"
                                            beaconUUID:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
                                      beaconIdentifier:@"com.beaconstac.dunty"];
    }
    
    // Setup and initialize the Beaconstac SDK
    
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.username = self.loginField.text;

        PFObject *member = [PFObject objectWithClassName:@"Member"];
        member[@"name"] = self.username;
        [member saveInBackground];
        
        [self setup];
    }
}

@end
