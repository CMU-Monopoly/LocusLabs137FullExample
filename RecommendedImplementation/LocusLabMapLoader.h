//
//  LocusLabMapLoader.h
//  RecommendedImplementation
//
//  Copyright (c) 2015 LocusLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocusLabsSDK/LocusLabsSDK.h>

@class LocusLabMapLoader;

@protocol LocusLabMapLoaderDelegate <NSObject>

@required
- (void)mapLoaderReady:(LocusLabMapLoader*)loader;
- (void)mapLoaderClosed:(LocusLabMapLoader*)loader;

@optional
- (void)mapLoader:(LocusLabMapLoader*)loader isLoadingWithProgress:(float)progress;
- (void)mapLoader:(LocusLabMapLoader*)loader failedWithError:(NSError*)error;

@end

@interface LocusLabMapLoader : NSObject

- (instancetype)initWithVenueId:(NSString*)venueId andSuperview:(UIView*)superview;
- (void)loadMap;

@property (nonatomic, weak) id<LocusLabMapLoaderDelegate> delegate;
@property (nonatomic, readonly) NSString *venueId;
@property (nonatomic, readonly) LLMapView *mapView;

@end