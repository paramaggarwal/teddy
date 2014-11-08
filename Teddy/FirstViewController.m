//
//  FirstViewController.m
//  Teddy
//
//  Created by Param Aggarwal on 08/11/14.
//  Copyright (c) 2014 DP. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

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
    NSLog(@"%@", beaconsDictionary);
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [beaconsDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *uuid, MSBeacon *beacon, BOOL *stop) {

        NSString *major = [[beacon.beaconKey componentsSeparatedByString:@":"] objectAtIndex:1];
        NSString *proximity = beacon.isFar ? @"Far" : @"Near";

        NSString *key = [NSString stringWithFormat:@"%@ teddy %@", proximity, major];
        [array addObject:key];
        
        if ([major isEqualToString:@"63738"] && [self.username isEqualToString:@"param"]) {
            if (!beacon.isFar) {
                self.teddyImageView.layer.opacity = 1.0f;
                self.teddyNameLabel.text = @"Bos";
            } else {
                self.teddyImageView.layer.opacity = 0.2f;
                self.teddyNameLabel.text = @"Bye Bos!";
            }
        }
        
        if ([major isEqualToString:@"54051"] && [self.username isEqualToString:@"dunty"]) {
            if (!beacon.isFar) {
                self.teddyImageView.layer.opacity = 1.0f;
                self.teddyNameLabel.text = @"Marco";
            } else {
                self.teddyImageView.layer.opacity = 0.2f;
                self.teddyNameLabel.text = @"Bye Marco!";
            }
        }
        
    }];
    
    SecondViewController *second = [[self.tabBarController viewControllers] lastObject];
    second.beacons = array;
    [second.tableView reloadData];
}

// Tells the delegate about the camped on beacon among available beacons.
- (void)campedOnBeacon:(id)beacon amongstAvailableBeacons:(NSDictionary *)beaconsDictionary
{
    MSBeacon *myBeacon = (MSBeacon *)beacon;
    
    if (!myBeacon.isFar) {
        self.teddyImageView.layer.opacity = 1.0f;
    } else {
        self.teddyImageView.layer.opacity = 0.5f;
    }
        
//    NSLog(@"DemoApp:Entered campedOnBeacon");
//    NSLog(@"DemoApp:campedOnBeacon: %@, %@", beacon, beaconsDictionary);
//    NSLog(@"DemoApp:facts Dict: %@", _beaconstac.factsDictionary);
    
}

// Tells the delegate when the device exits from the camped on beacon range.
- (void)exitedBeacon:(id)beacon
{
    MSBeacon *beacon1 = (MSBeacon *)beacon;
    NSString *minor = [[beacon1.beaconKey componentsSeparatedByString:@":"] lastObject];
    
    
    if ([minor isEqualToString:@"4260"]) { //marco
        if ([self.username isEqualToString:@"param"]) {
            [self showAlert:@"Bye Marco!" message:@""];
        } else {
            [self showAlert:@"You are leaving your teddy behind." message:@""];
        }
    } else if ([minor isEqualToString:@"9585"]) { //bos
        if ([self.username isEqualToString:@"param"]) {
            [self showAlert:@"You are leaving your teddy behind." message:@""];
        } else {
            [self showAlert:@"Bye Bos!" message:@""];
        }
    }
    
//    NSLog(@"DemoApp:Entered exitedBeacon");
//    NSLog(@"DemoApp:exitedBeacon: %@", beacon);
    
}

// Tells the delegate that a rule is triggered with corresponding list of actions.
- (void)ruleTriggeredWithRuleName:(NSString *)ruleName actionArray:(NSArray *)actionArray
{
    for (NSDictionary *actionDict in actionArray) {
        if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"popup"]) {
            NSString *message = [[[actionDict objectForKey:@"meta"] objectForKey:@"params"] objectForKey:@"text"];
            [self showAlert:ruleName message:message];
            
        } else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"custom"]) {
            NSDictionary *params = [[actionDict objectForKey:@"meta"]objectForKey:@"params"];
            NSLog(@"DemoApp:Received custom action_type: %@", params);
        }
    }
}

- (void)showAlert:(NSString *)title message:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
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
