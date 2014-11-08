//
//  VideoAndAudioViewController.h
//  DemoBeaconstac
//
//  Created by Garima Batra on 10/30/14.
//  Copyright (c) 2014 Mobstac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoAndAudioViewController : UIViewController <AVAudioPlayerDelegate>
@property (nonatomic) NSString *mediaType;
@property (nonatomic) NSString *mediaUrl;
@end
