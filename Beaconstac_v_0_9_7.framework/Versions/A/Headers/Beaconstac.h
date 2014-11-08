//
//  Beaconstac.h
//  BeaconstacSDK
//
//  Copyright© 2014, MobStac Inc. All rights reserved.
//
//  All information contained herein is, and remains the property of MobStac Inc.
//  The intellectual and technical concepts contained herein are proprietary to
//  MobStac Inc and may be covered by U.S. and Foreign Patents, patents in process,
//  and are protected by trade secret or copyright law. This product can not be
//  redistributed in full or parts without permission from MobStac Inc. Dissemination
//  of this information or reproduction of this material is strictly forbidden unless
//  prior written permission is obtained from MobStac Inc.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import <Foundation/Foundation.h>
#import "MSLogger.h"
#import "MSBeacon.h"
#import "MSBeaconManager.h"
#import "MSRuleProcessor.h"


/**
 * Defines the delegate methods that will be used to receive beacon-triggered events, including ranging,
 * camping, entry, exit, and any rules that match defined criteria.
 */
@protocol BeaconstacDelegate <NSObject>

/**
 * Sent to the delegate when one or more beacons are detected by the device.
 *
 * @param beaconsDictionary A dictionary with beacon 'UUID:major:minor' as key 
 *                          and MSBeacon as value.
 */
- (void)beaconsRanged:(NSDictionary*)beaconsDictionary;

/**
 * Sent to the delegate when the device has crossed over the near proximity zone threshold for a beacon.
 *
 * @param beacon This returns the beacon object that a device has camped on to.
 * @param beaconsDictionary This returns a dictionary of all available beacons in the range of device.
 */
- (void)campedOnBeacon:(MSBeacon*)beacon amongstAvailableBeacons:(NSDictionary*)beaconsDictionary;

/**
 * Sent to the delegate when the device exited from the region of a beacon on which it was camped on.
 * @param beacon This returns the beacon that a device was previously camped on to and now has exited from beacon's range.
 */
- (void)exitedBeacon:(MSBeacon*)beacon;

/**
 * Sent to the delegate when a rule is triggered and an action needs to be performed.
 *
 * @param ruleName rule name for which an action needs to be performed.
 * @param actionArray Returns an array of actions to be performed when the rule is triggered. Each action is a NSDictionary with the following keys:
 * id - action id.
 * created - Timestamp of when this action was created.
 * updated - Timestamp of when this action was updated.
 * name - Name of the action.
 * rule - id of the rule this action is attached to.
 * state - Whether this action is Active or Inactive.
 * meta - Metadata for the action. NSDictionary with 'action_type' and 'params' as keys.
 *    { 
 *      "action_type" : "popup|webpage|media|custom",
 *      "params" : "..." 
 *    }
 */
- (void)ruleTriggeredWithRuleName:(NSString*)ruleName actionArray:(NSArray*)actionArray;

@end

/**
 * @todo FIXME. Explain this: used to log RuleAction events.
 */
typedef NS_ENUM (NSUInteger, MSActionType){
    MSActionTypeDelivered = 0,
    MSActionTypeOpened = 1,
    MSActionTypeClicked = 2
};

/**
 * The main class and entry point for working with the Beaconstac SDK.
 */
@interface Beaconstac : NSObject

/** 
 * Delegate for events on Beaconstac
 */
@property (nonatomic) id <BeaconstacDelegate> delegate;


/**
 * The MSBeaconManager instance in use.
 */
@property MSBeaconManager *beaconManager;

/**
 * The MSRuleProcessor instance in use.
 */
@property MSRuleProcessor *ruleProcessor;


/** 
 * Set / get beacon affinity, which is how sticky we are to
 * a beacon once we camp on it. By default this is set to MSBeaconAffinityMedium.
 * Use this to control how sensitive your app is to multiple beacons in a given space. 
 * Increasing affinity values (Low -> High) will cause your app to lock harder
 * onto the closest beacon and switch to a new one it sees only when it is sufficiently close
 * to the new one. Random sighting of another "far away" beacon will not be ignored.
 *
 * @see MSBeaconAffinity in MSBeaconManager for allowed values
 */
@property (nonatomic) MSBeaconAffinity beaconaffinity;

/** 
 * Holds all the key values (for facts) required for rule processing. 
 * 
 * It contains keys: nearbeaconName - which contains the camped on beacon name, 
 * nearbeacon - which contains the UUID:major:minor of the camped on beacon and 
 * here - which contains the current location of the device
 */
@property (nonatomic, strong) NSMutableDictionary *factsDictionary;

/**
 * Setup global Beaconstac credentials.
 *
 * @param organizationId An integer with the Organization ID provided by Mobstac
 * @param userToken The developer token provided by Mobstac
 * @param uuid The Beacon UUID. Currently, Beaconstac supports only 1 UUID per app.
 * @param identifier A string which identifies your beacons. It should be of the format com.<company_name>.<app_name>
 */
+ (BOOL)setupOrganizationId:(NSInteger)organizationId userToken:(NSString*)userToken beaconUUID:(NSString*)uuid beaconIdentifier:(NSString*)identifier;

/**
 * Initialize a Beaconstac object with user-specific data, to be used in logging events and processing rules.
 *
 * @param firstName First name of the user
 * @param lastName Last name of the user
 * @param email Email ID of the user
 * @param userInfo Any additional information associated to a user. It must be a dictionary.
 */
- (id)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName emailAddress:(NSString*)email userInfo:(NSDictionary*)userInfo;

/**
 * Updates the primary facts dictionary which is used by MSRuleProcessor to evaluate rules.
 * Facts such as beacon proximity, user location, user id are updated by the SDK.
 * Any external fact which needs to be used must be set by the developer.
 *
 * @param fact The value of the fact for a corresponding key
 * @param key The key against which the fact must be stored
 */
- (void)updateFact:(id)fact forKey:(NSString*)key;

/**
 * Used to log user events to server such as when the user views
 * or clicks on a message shown by the SDK as a result of rule processing.
 *
 * @param actionType Value of type MSActionType
 * @param message Message to be sent to the server
 */
- (void)logEventWithActionType:(MSActionType)actionType andMessage:(NSString*)message;


@end
