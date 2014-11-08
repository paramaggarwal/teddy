//
//  MSBeaconManager.h
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
#import <CoreLocation/CoreLocation.h>
#import "MSBeacon.h"

/**
 * Beacon affinity is how "sticky" we are to a beacon, once we're camped on it.
 */
typedef NS_ENUM (NSUInteger, MSBeaconAffinity)
{
    MSBeaconAffinityNone = 0,
    MSBeaconAffinityLow = 3,
    MSBeaconAffinityMedium = 4,
    MSBeaconAffinityHigh = 5
};

/**
 * Protocol used to receive beacon events
 */
@protocol MSBeaconManagerDelegate <NSObject>

/**
 * Gives a dictionary of all visible Beacon objects with 
 * <MSBeacon> as value and key as @"UUID:major:minor".
 */
- (void)beaconsRanged:(NSDictionary*)beaconsDictionary;

/**
 * Gives a MSBeacon on which the device is currently camped 
 * on amongst all visible beacons dictionary.
 */
- (void)campedOnBeacon:(MSBeacon*)beacon amongstAvailableBeacons:(NSDictionary*)beaconsDictionary;

/**
 * Method to report if the device just camped off a beacon <MSBeacon>
 */
- (void)exitedBeacon:(MSBeacon*)beacon;

/**
 * Reports if the device has been camped on to <MSBeacon>
 * for more than dwell time.
 */
- (void)dwellTimeExpired:(MSBeacon*)beacon;

/*
 * Reports if the GPS location changed
 */
- (void)locationUpdatedTo:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
@end


/**
 * Manages all the beacons around and presents callbacks using the protocol.
 */
@interface MSBeaconManager : NSObject<CLLocationManagerDelegate>

/**
 * Delegate to send events to.
 */
@property (nonatomic) id <MSBeaconManagerDelegate> delegate;

/**
 * Current location, as reported by the OS.
 */
@property (strong, nonatomic) CLLocation *currentLocation;

/**
 * Beacon identification string. e.g. com.mobstac.foo
 */
@property (strong, nonatomic) NSString *beaconIdentifier;

/**
 * UUID of the beacon.
 */
@property (strong, nonatomic) NSUUID *beaconUUID;

/**
 * Current affinity level.
 */
@property (nonatomic, assign) MSBeaconAffinity beaconaffinity;

/**
 * Initializes a MSBeaconManager to monitor all beacons with the
 * given UUID and identifier.
 */
- (id)initWithUUID:(NSUUID*)uuid forIdentifier:(NSString*)identifier;

/**
 * Stop sending location updates.
 */
- (void)stopLocationUpdates;


@end
