//
//  LocusLabsMapDownloader.m
//  RecommendedImplementation
//
//  Created by Sam Ziegler on 7/12/15.
//  Copyright (c) 2015 LocusLabs. All rights reserved.
//

#import "LocusLabsMapBackgroundDownloader.h"

#import "LocusLabsSDK/LocusLabsSDK.h"

#import "LocusLabsCache.h"

@interface MyDownloader : NSObject <LLAirportDatabaseDelegate>

@property (strong,nonatomic) LLAirportDatabase *airportDatabase;
@property (strong,nonatomic) void (^completionBlock)(BOOL didDownload, NSError *err);

- (void)downloadVenueId:(NSString *)venueId completionBlock:(void (^)(BOOL didDownload, NSError *err))completionBlock;

@end

@implementation MyDownloader

- (id)init
{
    self = [super init];
    
    if (self) {
        _airportDatabase = [[LLAirportDatabase alloc] init];
        _airportDatabase.delegate = self;
    }
    
    return self;
}

- (void)downloadVenueId:(NSString *)venueId completionBlock:(void (^)(BOOL didDownload, NSError *err))completionBlock
{
    self.completionBlock = completionBlock;
    [self.airportDatabase loadAirport:venueId];
}

- (void)airportDatabase:(LLAirportDatabase *)airportDatabase airportLoaded:(LLAirport *)airport
{
    self.completionBlock(true,nil);
}

- (void)airportDatabase:(LLAirportDatabase *)airportDatabase airportLoadFailed:(NSString *)venueId code:(LLDownloaderError)errorCode message:(NSString *)message
{
    self.completionBlock(false,[NSError errorWithDomain:@"sdk.locuslabs.com" code:errorCode userInfo:nil]);
}

@end

@interface LocusLabsMapBackgroundDownloader ()

@property (strong,nonatomic) MyDownloader *myDownloader;

@end

@implementation LocusLabsMapBackgroundDownloader

+ (LocusLabsMapBackgroundDownloader *)mapBackgroundDownloaderWithVenueId:(NSString *)venueId
{
    return [[LocusLabsMapBackgroundDownloader alloc] initWithVenueId:venueId cache:[LocusLabsCache defaultCache]];
}

- (id)initWithVenueId:(NSString *)venueId cache:(LocusLabsCache *)cache
{
    self = [super init];
    
    if (self) {
        _venueId = venueId;
        _cache = cache;
    }
    
    return self;
}

- (BOOL)needsDownloading
{
    NSDictionary *venueList = self.cache.loadVenueList;
    
    if (!venueList) {
        return true;
    }
    
    NSDictionary *venueInfo = [venueList objectForKey:self.venueId];
    if (!venueInfo) {
        return true;
    }
    
    NSString *assetVersion = [venueInfo objectForKey:@"assetVersion"];
    NSString *asset = [NSString stringWithFormat:@"accounts/%@/%@/%@/%@/%@VenueData.json",[LLLocusLabs setup].accountId,self.venueId,assetVersion,[LLLocusLabs setup].assetsFormatVersion,self.venueId];
    
    return [self.cache assetExists:asset];
}

- (void)downloadWithCompletionBlock:(void (^)(BOOL didDownload, NSError *err))completionBlock
{
    if (!self.needsDownloading) {
        completionBlock(false,nil);
        return;
    }
    
    self.myDownloader = [[MyDownloader alloc] init];
    [self.myDownloader downloadVenueId:self.venueId completionBlock:completionBlock];
}

@end
