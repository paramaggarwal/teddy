//
//  MSNetwork.h
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
 * Communicate with Beaconstac REST API.
 */
@interface MSNetwork : NSObject

/**
 * POST to specified URL with given data.
 */
+ (void)postToServer:(NSMutableDictionary*)postParams withURL:(NSString*)urlString WithCompletionBlock:(void (^)(NSData *responseData, NSError *error))completionBlock;

/**
 * Fetch data for given URL
 */
+ (void)fetchDataForSubURL:(NSString*)subUrl WithCompletionBlock:(void (^)(NSDictionary *responseJson, NSError *error))completionBlock;

/**
 * Helper for URL encoding.
 */
+ (NSString *)urlEncodeStringFromString:(NSString *)string;

@end
