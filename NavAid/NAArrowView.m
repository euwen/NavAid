//
//  NAArrowView.m
//  NavAid
//
//  Created by Scott Andrus on 2/16/14.
//  Copyright (c) 2014 Tapatory, LLC. All rights reserved.
//

#import "NAArrowView.h"

#import "CLLocation+AFExtensions.h"

@interface CALayer (Sublayers)

- (void)addSublayer:(CALayer *)sublayer size:(CGSize)size position:(CGPoint)point;

@end

@implementation CALayer (Sublayers)

- (void)addSublayer:(CALayer *)sublayer size:(CGSize)size position:(CGPoint)point
{
    sublayer.frame = CGRectMake(point.x, point.y, size.width, size.height);
    [self addSublayer:sublayer];
}

@end

@interface NAArrowView ()

@property (strong, nonatomic) CATransformLayer *container;

@property (strong, nonatomic) CALayer *top;
@property (strong, nonatomic) CALayer *bottom;
@property (strong, nonatomic) CALayer *left;
@property (strong, nonatomic) CALayer *right;
@property (strong, nonatomic) CALayer *back;

@end

static const CGFloat kArrowThickness = 40;

@implementation NAArrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildLayers];
        self.container.frame = CGRectMake(0,
                                          0,
                                          frame.size.width,
                                          frame.size.height);
        [self.layer addSublayer:self.container];
        [self.container addSublayer:self.top
                               size:frame.size
                           position:CGPointMake(0, 0)];
        [self.container addSublayer:self.bottom
                               size:frame.size
                           position:CGPointMake(0, 0)];
        [self.container addSublayer:self.left
                               size:CGSizeMake(kArrowThickness, frame.size.height)
                           position:CGPointMake(-kArrowThickness / 2.0, 0)];
        [self.container addSublayer:self.right
                               size:CGSizeMake(kArrowThickness, frame.size.height)
                           position:CGPointMake(frame.size.width - kArrowThickness / 2.0, 0)];
        [self.container addSublayer:self.back
                               size:CGSizeMake(frame.size.width, kArrowThickness)
                           position:CGPointMake(0, frame.size.height - kArrowThickness / 2.0)];
    }
    return self;
}

- (void)buildLayers
{
    self.container = [CATransformLayer layer];
    
    self.top = [CALayer layer];
    [self buildTopLayer:self.top];
    
    self.bottom = [CALayer layer];
    [self buildBottomLayer:self.bottom];
    
    self.left = [CALayer layer];
    [self buildLeftLayer:self.left];
    
    self.right = [CALayer layer];
    [self buildRightLayer:self.right];
    
    self.back = [CALayer layer];
    [self buildBackLayer:self.back];
}

- (void)buildTopLayer:(CALayer *)top
{
    top.backgroundColor = [[UIColor blackColor] CGColor];
    top.opacity = 0.6;
    top.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.5] CGColor];
    top.borderWidth = 3;
    top.cornerRadius = 10;
    top.transform = CATransform3DMakeTranslation(0, 0, kArrowThickness / 2.0);
}

- (void)buildBottomLayer:(CALayer *)bottom
{
    bottom.backgroundColor = [[UIColor blackColor] CGColor];
    bottom.opacity = 0.6;
    bottom.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.5] CGColor];
    bottom.borderWidth = 3;
    bottom.cornerRadius = 10;
    bottom.transform = CATransform3DMakeTranslation(0, 0, -kArrowThickness / 2.0);
}

- (void)buildLeftLayer:(CALayer *)left
{
    left.backgroundColor = [[UIColor blackColor] CGColor];
    left.opacity = 0.6;
    left.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.5] CGColor];
    left.borderWidth = 3;
    left.cornerRadius = 10;
    left.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
}

- (void)buildRightLayer:(CALayer *)right
{
    right.backgroundColor = [[UIColor blackColor] CGColor];
    right.opacity = 0.6;
    right.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.5] CGColor];
    right.borderWidth = 3;
    right.cornerRadius = 10;
    right.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
}

- (void)buildBackLayer:(CALayer *)back
{
    back.backgroundColor = [[UIColor blackColor] CGColor];
    back.opacity = 0.6;
    back.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.5] CGColor];
    back.borderWidth = 3;
    back.cornerRadius = 10;
    back.transform = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
}

- (void)pointAtDestination:(CLLocation *)destination
              withAttitude:(CMAttitude *)attitude
              withLocation:(CLLocation *)location
                andHeading:(CLHeading *)heading
{
    double rotationAngle =
    [location bearingInRadiansTowardsLocation:destination] -
    heading.magneticHeading * ((double)M_PI/(double)180.0);

    // Create 3D Affine Transform based on pitch and roll of device
    CATransform3D transform;
    transform = CATransform3DMakeRotation(attitude.pitch, 1, 0, 0);
    transform = CATransform3DRotate(transform, attitude.roll, 0, 1, 0);
    transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1);
    
    // Transform the container
    self.container.transform = transform;
}

@end
