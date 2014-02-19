//
//  NAViewController.m
//  NavAid
//
//  Created by Scott Andrus on 2/6/14.
//  Copyright (c) 2014 Tapatory, LLC. All rights reserved.
//

#import "NAViewController.h"

#import "CLLocationManager+AFExtensions.h"

@interface NAViewController ()

@property (strong, nonatomic) NAArrowView *arrowView;
@property (strong, nonatomic) UIImagePickerController *picker;

@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UIView *statusBarView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation NAViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    self.picker.navigationBarHidden = YES;
    self.picker.toolbarHidden = YES;
    self.picker.cameraViewTransform =
    CGAffineTransformScale(self.picker.cameraViewTransform,
                           1.0,
                           (self.view.frame.size.height -
                            self.controlsView.frame.size.height) /
                           self.view.frame.size.width);
    
    UIView *overlayView =
    [[UIView alloc] initWithFrame:self.view.frame];
    
    overlayView.opaque = NO;
    overlayView.backgroundColor = [UIColor clearColor];
    
    [self setupArrowViewInView:overlayView];
    [overlayView addSubview:self.controlsView];
    [overlayView addSubview:self.statusBarView];
    [overlayView addSubview:self.distanceLabel];
    
    self.picker.cameraOverlayView = overlayView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self presentViewController:self.picker animated:NO completion:nil];
}

#pragma mark - Setup

- (void)setupArrowViewInView:(UIView *)view
{
    CGRect frame = CGRectMake(view.frame.size.width / 6.0,
                              view.frame.size.height / 10.0,
                              4.0 * view.frame.size.width / 6.0,
                              5.5 * view.frame.size.height / 10.0);
    self.arrowView = [[NAArrowView alloc] initWithFrame:frame];
    self.arrowView.delegate = self;
    [view addSubview:self.arrowView];
}

#pragma mark - Button actions

- (IBAction)buttonPressed:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Featheringill Hall"]) {
        self.arrowView.destination =
        [[CLLocation alloc] initWithLatitude:36.1447809
                                   longitude:-86.8032186];
    } else if ([sender.titleLabel.text isEqualToString:@"Roma"]) {
        self.arrowView.destination =
        [[CLLocation alloc] initWithLatitude:36.1480013
                                   longitude:-86.8083296];
    } else if ([sender.titleLabel.text isEqualToString:@"Ben & Jerry's"]) {
        self.arrowView.destination =
        [[CLLocation alloc] initWithLatitude:36.146143
                                   longitude:-86.7994725];
    } else if ([sender.titleLabel.text isEqualToString:@"Qdoba"]) {
        self.arrowView.destination =
        [[CLLocation alloc] initWithLatitude:36.1504781
                                   longitude:-86.8008202];
    }
    
    self.distanceLabel.text = [self.arrowView.locationManager distanceToLocation:self.arrowView.destination];
    
    if (!self.arrowView.isPointing) {
        [self.arrowView startPointing];
    }
}

#pragma mark - NAArrowViewDelegate

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    self.distanceLabel.text = [manager distanceToLocation:self.arrowView.destination];
}

@end
