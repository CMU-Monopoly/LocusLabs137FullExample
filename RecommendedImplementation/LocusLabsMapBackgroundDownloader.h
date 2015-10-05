//
//  LocusLabsMapDownloader.h
//  RecommendedImplementation
//
//  Created by Sam Ziegler on 7/12/15.
//  Copyright (c) 2015 LocusLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocusLabsCache;

@interface LocusLabsMapBackgroundDownloader : NSObject

@property (strong,nonatomic,readonly) NSString *venueId;
@property (strong,nonatomic,readonly) LocusLabsCache *cache;

+ (LocusLabsMapBackgroundDownloader *)mapBackgroundDownloaderWithVenueId:(NSString *)venueId;

- (id)initWithVenueId:(NSString *)venueId cache:(LocusLabsCache *)cache;

- (BOOL)needsDownloading;
- (void)downloadWithCompletionBlock:(void (^)(BOOL didDownload, NSError *err))completionBlock;

@end
