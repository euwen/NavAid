//
//  NAArrowView.h
//  NavAid
//
//  Created by Scott Andrus on 2/16/14.
//  Copyright (c) 2014 Tapatory, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface NAArrowView : UIView <CLLocationManagerDelegate>

- (void)startPointing;
- (void)stopPointing;
- (BOOL)isPointing;

@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) CGFloat thickness;

@property (strong, nonatomic) CLLocation *destination;

@end
