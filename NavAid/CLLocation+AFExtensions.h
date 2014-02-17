//
//  CLLocation+AFExtensions.h
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/29.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (AFExtensions)

- (double)bearingInRadiansTowardsLocation:(CLLocation *)towardsLocation;
- (double)bearingInDegreesTowardsLocation:(CLLocation *)towardsLocation;
- (CLLocation *)locationAtDistance:(CLLocationDistance)atDistance alongBearingInRadians:(double)bearingInRadians;
+ (CLLocation *)locationWithCoordinate:(CLLocationCoordinate2D)someCoordinate;

@end
