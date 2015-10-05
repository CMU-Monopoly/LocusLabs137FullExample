//
//  ViewController.m
//  RecommendedImplementation
//
//  Copyright (c) 2015 LocusLabs. All rights reserved.
//

#import "ViewController.h"
#import "LocusLabsMapLoader.h"
#import <LocusLabsSDK/LocusLabsSDK.h>

#import "LocusLabsMapPack.h"
#import "LocusLabsMapBackgroundDownloader.h"

@interface ViewController () <LocusLabMapLoaderDelegate>

@property (nonatomic, weak) IBOutlet UIView *navBarView;
@property (nonatomic, weak) IBOutlet UIView *mapPlacement;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *progressStatusLabel;
@property (nonatomic, weak) IBOutlet UIButton *mapFullscreenButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *progressActivityIndicator;
@property (nonatomic, weak) IBOutlet UILabel *departingGateLabel;
@property (nonatomic) IBOutlet NSLayoutConstraint *mapFullscreenConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *mapCompactConstraint;
@property (nonatomic) UIColor *navBarColor;
@property (strong,nonatomic) LocusLabsMapBackgroundDownloader *mapBackgroundDownloader;

@property (nonatomic) LocusLabsMapLoader *mapLoader;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.navBarColor = self.navBarView.backgroundColor;
	[self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    self.mapBackgroundDownloader = [LocusLabsMapBackgroundDownloader mapBackgroundDownloaderWithVenueId:@"dxb"];
    
    // Install the map pack we are shipping with this app.  Map Packs are optional.  They allow you to ship a snapshot of your maps so that your users have them available to them even if they don't have a network connection when they first run the app.  Contact support@locuslabs.com to get a map pack for your account.
    [LocusLabsMapPack mapPackInstallWithCompletionBlock:^void (BOOL didInstall, NSError *err) {
        if (err) {
            NSLog(@"An error occurred while installing the map pack: %@",err);
        } else {
            if (didInstall) {
                NSLog(@"The map pack was installed.");
            } else {
                NSLog(@"The installed maps are up to date, no need to install the map pack.");
            }
        }
        
        [self.mapBackgroundDownloader downloadWithCompletionBlock:^(BOOL didDownload, NSError *err) {
            if (err) {
                NSLog(@"An error occurred while downloading the map: %@",err);
            } else {
                if (didDownload) {
                    NSLog(@"The map was downloaded.");
                } else {
                    NSLog(@"The latest version of the map was already on the device.");
                }
            }
            
            [self setupMap];
        }];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (void)setupMap
{
	self.mapLoader = [[LocusLabsMapLoader alloc] initWithVenueId:@"dxb" andSuperview:self.mapPlacement];
	self.mapLoader.delegate = self;
	[self.mapLoader loadMap];
	self.progressView.hidden = YES;
	self.progressStatusLabel.hidden = NO;
	self.progressStatusLabel.text = @"Preparing Data...";
	[self.progressActivityIndicator startAnimating];
}

- (IBAction)transitionToFullscreen
{
	[self.view removeConstraint:self.mapCompactConstraint];
	[self.view addConstraint:self.mapFullscreenConstraint];
	self.mapLoader.mapView.userInteractionEnabled = YES;
	self.mapFullscreenButton.hidden = YES;
	[self.mapLoader resetMap];
	[UIView animateWithDuration:0.25 animations:^{
		[self.view layoutIfNeeded];
		self.navBarView.backgroundColor = [LLConfiguration sharedConfiguration].blueBackgroundColor;
		self.mapLoader.mapView.bottomBarHidden = NO;
		self.mapLoader.mapView.searchBarHidden = NO;

	} completion:^(BOOL finished) {
	}];
}

- (void)transitionToCompact
{
	[self.view removeConstraint:self.mapFullscreenConstraint];
	[self.view addConstraint:self.mapCompactConstraint];
	self.mapLoader.mapView.userInteractionEnabled = NO;
	[self.mapLoader resetMap];
	[UIView animateWithDuration:0.25 animations:^{
		[self.view layoutIfNeeded];
		self.navBarView.backgroundColor = self.navBarColor;
		self.mapLoader.mapView.bottomBarHidden = YES;
		self.mapLoader.mapView.searchBarHidden = YES;
	} completion:^(BOOL finished) {
		self.mapFullscreenButton.hidden = NO;
	}];
}

#pragma mark LocusLabMapLoaderDelegate

- (void)mapLoaderReady:(LocusLabsMapLoader *)loader
{
	self.progressStatusLabel.hidden = YES;
	self.progressView.hidden = YES;
	[self.progressActivityIndicator stopAnimating];
	self.mapLoader.mapView.bottomBarHidden = YES;
	self.mapLoader.mapView.searchBarHidden = YES;
	self.mapLoader.mapView.userInteractionEnabled = YES;
	[self.mapPlacement insertSubview:self.mapLoader.mapView atIndex:0];
	self.mapFullscreenButton.hidden = NO;
}

- (void)mapLoaderClosed:(LocusLabsMapLoader *)loader
{
	// Collapse map
	[self transitionToCompact];
}

- (NSString *)departingGateForMapLoader:(LocusLabsMapLoader *)loader
{
	return [@"gate:" stringByAppendingString:self.departingGateLabel.text];
}

- (void)mapLoader:(LocusLabsMapLoader *)loader isLoadingWithProgress:(float)progress
{
	[self.progressActivityIndicator stopAnimating];
	self.progressStatusLabel.text = @"Downloading Map...";
	self.progressView.progress = progress;
}

- (void)mapLoaderFinishedDownload:(LocusLabsMapLoader *)loader
{
	self.progressStatusLabel.text = @"Configuring Map...";
	self.progressView.hidden = YES;
	[self.progressActivityIndicator startAnimating];
}

- (void)mapLoader:(LocusLabsMapLoader *)loader failedWithError:(NSError *)error
{
	// Handle error
	self.progressStatusLabel.text = @"Error Downloading Map...";
	self.progressView.hidden = YES;
	[self.progressActivityIndicator startAnimating];
	NSLog(@"Map Loader Error: %@", error);
}

@end