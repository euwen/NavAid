//
//  NAViewController.m
//  NavAid
//
//  Created by Scott Andrus on 2/6/14.
//  Copyright (c) 2014 Tapatory, LLC. All rights reserved.
//

#import "NAViewController.h"

#import "NAArrowView.h"
#import "CLLocation+AFExtensions.h"

@interface NAViewController ()

@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) CLLocation *destination;

@property (strong, nonatomic) NAArrowView *arrowView;

@end

@implementation NAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [self setupArrowView];
    
    self.locManager = [CLLocationManager new];
    [self prepareAndStartLocationManager:self.locManager withDelegate:self];
    
    self.motionManager = [CMMotionManager new];
    [self.motionManager startDeviceMotionUpdates];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateArrow:)];
    link.frameInterval = 1;
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setupArrowView
{
    CGRect frame = CGRectMake(self.view.frame.size.width / 6.0,
                              self.view.frame.size.height / 10.0,
                              4.0 * self.view.frame.size.width / 6.0,
                              6.5 * self.view.frame.size.height / 10.0);
    self.arrowView = [[NAArrowView alloc] initWithFrame:frame];
    
    /* DEBUG START */
    self.arrowView.layer.borderColor = [[UIColor redColor] CGColor];
    self.arrowView.layer.borderWidth = 4.0;
    /* DEBUG END */
    
    [self.view addSubview:self.arrowView];
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

#pragma mark - CADisplayLink selector

- (void)updateArrow:(CADisplayLink *)displayLink
{
    [self.arrowView pointAtDestination:self.destination
                          withAttitude:self.motionManager.deviceMotion.attitude
                          withLocation:self.locManager.location
                            andHeading:self.locManager.heading];
}

#pragma mark - Button actions

- (IBAction)buttonPressed:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Featheringill Hall"]) {
        self.destination = [CLLocation locationWithCoordinate:
                            CLLocationCoordinate2DMake(36.1447809,-86.8032186)];
    } else if ([sender.titleLabel.text isEqualToString:@"Roma"]) {
        self.destination = [CLLocation locationWithCoordinate:
                            CLLocationCoordinate2DMake(36.1480013,-86.8083296)];
    }
}

@end
