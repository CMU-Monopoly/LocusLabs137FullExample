//
//  LocusLabsMapPackFinder.m
//  RecommendedImplementation
//
//  Created by Sam Ziegler on 7/12/15.
//  Copyright (c) 2015 LocusLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "LocusLabsMapPackFinder.h"

@interface LocusLabsMapPackFinderTests : XCTestCase

@end

@implementation LocusLabsMapPackFinderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAppMapPackPaths {
    LocusLabsMapPackFinder *finder = [LocusLabsMapPackFinder mapPackFinder];
    NSArray *paths = finder.mapPackPaths;
    XCTAssertEqual(paths.count, 1);
}

- (void)testNewestMapPackPath {
    LocusLabsMapPackFinder *finder = [LocusLabsMapPackFinder mapPackFinder];
    NSString *newestMapPackPath = finder.newestMapPackPath;
    XCTAssert([newestMapPackPath hasSuffix:@"A11F4Y6SZRXH4X-2015-06-26T16:50:24.tar.gz"]);
}

@end
