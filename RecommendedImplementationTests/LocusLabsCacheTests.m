//
//  LocusLabsCacheTests.m
//  RecommendedImplementation
//
//  Created by Sam Ziegler on 7/12/15.
//  Copyright (c) 2015 LocusLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "LocusLabsCache.h"

@interface LocusLabsCacheTests : XCTestCase

@property (strong,nonatomic) LocusLabsCache *cache;

@end

@implementation LocusLabsCacheTests

+ (LocusLabsCache *)randomCache
{
    NSUUID *uuid = [NSUUID UUID];
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:[uuid UUIDString]];
    
    return [[LocusLabsCache alloc] initWithCachePath:cacheDirectory];
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.cache = [LocusLabsCacheTests randomCache];
    [self.cache setup];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [self.cache tearDown];
}

- (void)testFilenameForAsset {
    NSDictionary *tests = [NSDictionary dictionaryWithObjectsAndKeys:@"test",@"test",@"test-test",@"test/test",nil];
    [tests enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        XCTAssertEqualObjects([LocusLabsCache filenameForAsset:key],value);
    }];
}

- (void)testDefaultCachePath {
    LocusLabsCache *defaultCache = [LocusLabsCache defaultCache];
    
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    XCTAssertEqualObjects(defaultCache.cachePath, [cacheDirectory stringByAppendingPathComponent:@"locuslabs"]);
}

- (void)testIsValid {
    XCTAssert(self.cache.isValid);
    NSDictionary *d = [NSDictionary dictionary];
    [self.cache writeJsonAsset:@"test" json:d];
    XCTAssert(self.cache.isValid);
    XCTAssert([self.cache tearDown]);
    XCTAssert(!self.cache.isValid);
}

- (void)testWriteJsonAsset {
    NSDictionary *output = [NSDictionary dictionary];
    [self.cache writeJsonAsset:@"test" json:output];
    NSDictionary *input = [self.cache readJsonAsset:@"test"];
    XCTAssertEqualObjects(input, output);
}

- (void)testIsEmpty {
    XCTAssert(self.cache.isEmpty);
    NSDictionary *d = [NSDictionary dictionary];
    [self.cache writeJsonAsset:@"test" json:d];
    XCTAssert(!self.cache.isEmpty);
}

- (void)testAssetExists {
    XCTAssert(![self.cache assetExists:@"test"]);
    NSDictionary *output = [NSDictionary dictionary];
    [self.cache writeJsonAsset:@"test" json:output];
    XCTAssert([self.cache assetExists:@"test"]);
}

@end
