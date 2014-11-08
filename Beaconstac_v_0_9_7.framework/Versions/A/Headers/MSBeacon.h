//
//  MSBeacon.h
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


/**
 * Delegate to receive MSBeacon events
 */
@protocol MSBeaconProtocol <NSObject>

/**
 * Sent to the delegate when the time interval since the device camped on to beacon
 * exceeds the set dwell time for the beacon object.
 */
- (void)dwellTimeExpired;

@end

/**
 * Represents a single beacon in the system.
 */
@interface MSBeacon : NSObject

@property (nonatomic) id<MSBeaconProtocol> delegate;

/**
 * Represents beacon identity in the form "UUID:Major:Minor"
 */
@property (nonatomic, strong) NSString *beaconKey;

/**
 * Latest value of RSSI, Reverse strength Index as registered by the receiver from the beacon
 */
@property (nonatomic, strong, readonly) NSNumber *latestRssi;

/**
 * The correction value applied to the RSSI to smoothen out erroneous values
 */
@property (nonatomic) int bias;

/**
 * If the device is camped on to the beacon
 */
@property (nonatomic) BOOL isCampedOn;

/**
 * This returns the latest RSSI value
 */
- (int)getLatestRssi;

/**
 * This is used to set the current RSSI value internally.
 *
 * @param state Current RSSI value associated to the beacon object
 */
- (void)addBeaconState:(int)state;

/**
 * States if the proximity of the beacon is far
 */
- (BOOL)isFar;

/**
 * Returns the mean of previous three RSSI values associated to the beacon object.
 */
- (int)getMeanRssi;

@end
