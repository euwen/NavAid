//
//  NAArrowView.m
//  NavAid
//
//  Created by Scott Andrus on 2/16/14.
//  Copyright (c) 2014 Tapatory, LLC. All rights reserved.
//

#import "NAArrowView.h"

#import "CLLocation+AFExtensions.h"

@interface NAArrowView ()

@property (strong, nonatomic) CATransformLayer *container;
@property (strong, nonatomic) CAShapeLayer *top;
@property (strong, nonatomic) CAShapeLayer *bottom;
@property (strong, nonatomic) CALayer *left;
@property (strong, nonatomic) CALayer *right;
@property (strong, nonatomic) CALayer *back;

@property (strong, nonatomic) UIColor *borderColor;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) CGFloat opacity;

@property (assign, nonatomic) BOOL shouldRebuild;
@property (assign, nonatomic) BOOL isPointing;

@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

static const CGFloat kArrowThickness = 30;
static const CGFloat kArrowBorderWidth = 3.0;
static const CGFloat kArrowCornerRadius = 3.0;
static const CGFloat kArrowOpacity = 0.4;

@implementation NAArrowView

#pragma mark - C Functions

CG_INLINE CGRect CGRectForm(CGPoint p, CGSize s)
{
    CGRect rect;
    rect.origin = p;
    rect.size = s;
    return rect;
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setColor:[UIColor blackColor]];
        [self setThickness:kArrowThickness];
        [self setBorderWidth:kArrowBorderWidth];
        [self setCornerRadius:kArrowCornerRadius];
        [self setOpacity:kArrowOpacity];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setOpaque:NO];
        [self rebuild];
        
        self.locManager = [CLLocationManager new];
        [self prepareAndStartLocationManager:self.locManager withDelegate:self];
        
        self.motionManager = [CMMotionManager new];
        [self.motionManager startDeviceMotionUpdates];
    }
    return self;
}

- (void)prepareAndStartLocationManager:(CLLocationManager *)locManager
                          withDelegate:(id<CLLocationManagerDelegate>)delegate
{
    locManager.delegate = delegate;
    locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locManager.headingFilter = kCLHeadingFilterNone;
    
    [locManager startUpdatingLocation];
    [locManager startUpdatingHeading];
}

- (void)rebuild
{
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    [self buildLayers:self.frame];
    [self.layer addSublayer:self.container];
    [self.container addSublayer:self.top];
    [self.container addSublayer:self.bottom];
    [self.container addSublayer:self.left];
    [self.container addSublayer:self.right];
    [self.container addSublayer:self.back];
    self.shouldRebuild = NO;
}

#pragma mark - Accessors/Mutators

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.shouldRebuild = YES;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    _borderColor = [UIColor colorWithRed:34.0/242.0
                                   green:169.0/242.0
                                    blue:242.0/242.0
                                   alpha:1.0];
    self.shouldRebuild = YES;
}

- (void)setThickness:(CGFloat)thickness
{
    _thickness = thickness;
    self.shouldRebuild = YES;
}

#pragma mark - Layer Construction

- (void)addArrowMaskToShapeLayer:(CAShapeLayer *)layer
{
    UIBezierPath *shapePath = [UIBezierPath bezierPath];
    [shapePath moveToPoint:CGPointMake(0,
                                       layer.frame.size.height)];
    [shapePath addLineToPoint:CGPointMake(layer.frame.size.width / 2.0,
                                          0)];
    [shapePath addLineToPoint:CGPointMake(layer.frame.size.width,
                                          layer.frame.size.height)];
    [shapePath addLineToPoint:CGPointMake(layer.frame.size.width / 2.0,
                                          3.0 * layer.frame.size.height / 4.0)];
    [shapePath addLineToPoint:CGPointMake(0,
                                          layer.frame.size.height)];
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [shapePath CGPath];
    mask.lineJoin = kCALineJoinRound;
    layer.mask = mask;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forLayer:(CALayer *)layer
{
    CGPoint newPoint = CGPointMake(layer.bounds.size.width * anchorPoint.x,
                                   layer.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(layer.bounds.size.width * layer.anchorPoint.x,
                                   layer.bounds.size.height * layer.anchorPoint.y);
    
    CGPoint position = layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    layer.position = position;
    layer.anchorPoint = anchorPoint;
}

- (void)buildLayers:(CGRect)frame
{
    self.container = [CATransformLayer layer];
    [self buildContainerLayer:self.container withFrame:frame];
    
    self.top = [CAShapeLayer layer];
    [self buildTopLayer:self.top withFrame:frame];
    
    self.bottom = [CAShapeLayer layer];
    [self buildBottomLayer:self.bottom withFrame:frame];
    
    self.left = [CALayer layer];
    [self buildLeftLayer:self.left withFrame:frame];
    
    self.right = [CALayer layer];
    [self buildRightLayer:self.right withFrame:frame];
    
    self.back = [CALayer layer];
    [self buildBackLayer:self.back withFrame:frame];
}

- (void)modifyLayer:(CALayer *)layer
        withBGColor:(UIColor *)bgColor
        borderColor:(UIColor *)borderColor
        borderWidth:(CGFloat)borderWidth
       cornerRadius:(CGFloat)cornerRadius
            opacity:(CGFloat)opacity
{
    layer.backgroundColor = [bgColor CGColor];
    layer.opacity = opacity;
    layer.borderColor = [borderColor CGColor];
    layer.borderWidth = borderWidth;
    layer.cornerRadius = cornerRadius;
}

- (void)buildContainerLayer:(CATransformLayer *)container
                  withFrame:(CGRect)frame
{
    container.frame = CGRectForm(CGPointMake(0, 0), frame.size);
}

- (void)buildTopLayer:(CAShapeLayer *)top withFrame:(CGRect)frame
{
    [self modifyLayer:top
          withBGColor:self.color
          borderColor:self.borderColor
          borderWidth:self.borderWidth
         cornerRadius:self.cornerRadius
              opacity:self.opacity];
    
    top.transform = CATransform3DMakeTranslation(0, 0, self.thickness / 2.0);
    top.frame = CGRectForm(CGPointMake(0, 0), frame.size);
    
    [self addArrowMaskToShapeLayer:top];
}

- (void)buildBottomLayer:(CAShapeLayer *)bottom withFrame:(CGRect)frame
{
    [self modifyLayer:bottom
          withBGColor:self.color
          borderColor:self.borderColor
          borderWidth:self.borderWidth
         cornerRadius:self.cornerRadius
              opacity:self.opacity];
    
    bottom.transform = CATransform3DMakeTranslation(0, 0, -self.thickness / 2.0);
    bottom.frame = CGRectForm(CGPointMake(0, 0), frame.size);
    
    [self addArrowMaskToShapeLayer:bottom];
}

- (void)buildLeftLayer:(CALayer *)left withFrame:(CGRect)frame
{
    [self modifyLayer:left
          withBGColor:self.color
          borderColor:self.borderColor
          borderWidth:self.borderWidth
         cornerRadius:self.cornerRadius
              opacity:self.opacity];
    
    CGFloat hypot = hypotf(frame.size.height, frame.size.width/2.0);
    left.frame = CGRectForm(CGPointMake(0,
                                        frame.size.height - hypot),
                            CGSizeMake(self.thickness,
                                       hypot));
    
    [self setAnchorPoint:CGPointMake(0, 1.0) forLayer:left];
    
    CATransform3D rotation = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    CGFloat angle = atanf((frame.size.width/2.0) / frame.size.height);
    rotation = CATransform3DRotate(rotation, -angle, 1, 0, 0);
    rotation = CATransform3DTranslate(rotation, -self.thickness / 2.0, 0, 0);
    left.transform = rotation;
}

- (void)buildRightLayer:(CALayer *)right withFrame:(CGRect)frame
{
    [self modifyLayer:right
          withBGColor:self.color
          borderColor:self.borderColor
          borderWidth:self.borderWidth
         cornerRadius:self.cornerRadius
              opacity:self.opacity];
    
    CGFloat hypot = hypotf(frame.size.height, frame.size.width/2.0);
    right.frame = CGRectForm(CGPointMake(frame.size.width,
                                         frame.size.height - hypot),
                             CGSizeMake(self.thickness,
                                        hypot));
    
    [self setAnchorPoint:CGPointMake(0, 1.0) forLayer:right];
    
    CATransform3D rotation = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    CGFloat angle = atanf((frame.size.width/2.0) / frame.size.height);
    rotation = CATransform3DRotate(rotation, angle, 1, 0, 0);
    rotation = CATransform3DTranslate(rotation, -self.thickness / 2.0, 0, 0);
    right.transform = rotation;
}

- (void)buildBackLayer:(CALayer *)back withFrame:(CGRect)frame
{
    [self modifyLayer:back
          withBGColor:self.color
          borderColor:self.borderColor
          borderWidth:self.borderWidth
         cornerRadius:self.cornerRadius
              opacity:self.opacity];
    
    back.frame = CGRectForm(CGPointMake(0,
                                        frame.size.height - self.thickness / 2.0),
                            CGSizeMake(frame.size.width,
                                       self.thickness));
    
    back.transform = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
}

#pragma mark - CADisplayLink Rendering

- (void)startPointing
{
    [self setIsPointing:YES];
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self
                                                      selector:@selector(updateArrow:)];
    link.frameInterval = 1;
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopPointing
{
    [self setIsPointing:NO];
}

- (void)updateArrow:(CADisplayLink *)displayLink
{
    if (!self.isPointing) {
        [displayLink invalidate];
    }
    
    if (self.shouldRebuild) {
        [self rebuild];
    }
    
    [self pointAtDestination:self.destination
                withAttitude:self.motionManager.deviceMotion.attitude
                withLocation:self.locManager.location
                  andHeading:self.locManager.heading];
}

- (void)pointAtDestination:(CLLocation *)destination
              withAttitude:(CMAttitude *)attitude
              withLocation:(CLLocation *)location
                andHeading:(CLHeading *)heading
{
    double rotationAngle =
    [location bearingInRadiansTowardsLocation:destination] -
    heading.magneticHeading * ((double)M_PI/(double)180.0);

    // Create 3D Transform based on pitch and roll of device
    CATransform3D transform;
    transform = CATransform3DMakeRotation(attitude.pitch, 1, 0, 0);
    transform = CATransform3DRotate(transform, attitude.roll, 0, 1, 0);
    transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1);
    
    // Transform the container
    self.container.transform = transform;
}

@end
