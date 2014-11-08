//
//  VideoAndAudioViewController.m
//  DemoBeaconstac
//
//  Created by Garima Batra on 10/30/14.
//  Copyright (c) 2014 Mobstac. All rights reserved.
//

#import "VideoAndAudioViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoAndAudioViewController () {
    MPMoviePlayerController *videoPlayer;
    AVAudioPlayer *audioPlayer;
}
@end

@implementation VideoAndAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Media Type: %@, Media URL: %@", self.mediaType, self.mediaUrl);
    
    [self fillContainer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillContainer
{
    if (self.mediaType != nil && [self.mediaType caseInsensitiveCompare:@"video"] == NSOrderedSame) {
        NSURL *url = [NSURL URLWithString: self.mediaUrl];
        videoPlayer = [[MPMoviePlayerController alloc] init];
        videoPlayer.movieSourceType = MPMovieSourceTypeStreaming;
        videoPlayer.controlStyle = MPMovieControlStyleDefault;
        videoPlayer.contentURL = url;
        videoPlayer.view.frame = CGRectMake(0, 70, 320, 270);
        [self.view addSubview:videoPlayer.view];
        [videoPlayer prepareToPlay];
        videoPlayer.shouldAutoplay = YES;
        [videoPlayer play];
        
    } else if (self.mediaType != nil && [self.mediaType caseInsensitiveCompare:@"audio"] == NSOrderedSame) {
        NSURL *url = [NSURL URLWithString: self.mediaUrl];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
             
             if ([data length] > 0 && error == nil) {
                 NSError *error2;
                 audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error2];
                 audioPlayer.numberOfLoops = 0;	// Negative number means loop forever
                 [audioPlayer play];
             } else {
                 NSLog(@"Audio error");
             }
         }];
    }
}

@end
