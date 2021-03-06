//
//  LocusLabsCache.h
//  RecommendedImplementation
//
//  Created by Sam Ziegler on 7/12/15.
//  Copyright (c) 2015 LocusLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocusLabsCache : NSObject

+ (LocusLabsCache *)defaultCache;

@property (strong,nonatomic,readonly) NSString *cachePath;

+ (NSString *)filenameForAsset:(NSString *)asset;

- (id)initWithCachePath:(NSString *)cachePath;

- (NSString *)pathForAssset:(NSString *)asset;
- (BOOL)assetExists:(NSString *)asset;
- (id)readJsonAsset:(NSString *)asset;
- (void)writeJsonAsset:(NSString *)asset json:(id)json;
- (NSString *)venueListAsset;
- (NSDictionary *)loadVenueList;
- (void)clear;
- (BOOL)setup;
- (BOOL)tearDown;
- (BOOL)isEmpty;
- (BOOL)isValid;

@end
