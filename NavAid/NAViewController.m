//
//  NAViewController.m
//  NavAid
//
//  Created by Scott Andrus on 2/6/14.
//  Copyright (c) 2014 Tapatory, LLC. All rights reserved.
//

#import "NAViewController.h"
#import "NAArrowView.h"

// transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y self.view.frame.size.height / self.view.frame.size.width

@interface NAViewController ()

@property (strong, nonatomic) NAArrowView *arrowView;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UIView *statusBarView;

@end

@implementation NAViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.showsCameraControls = NO;
    picker.navigationBarHidden = YES;
    picker.toolbarHidden = YES;
    picker.cameraViewTransform =
    CGAffineTransformScale(picker.cameraViewTransform,
                           CAMERA_TRANSFORM_X,
                           CAMERA_TRANSFORM_Y);
    
    UIView *overlayView =
    [[UIView alloc] initWithFrame:self.view.frame];
    
    overlayView.opaque = NO;
    overlayView.backgroundColor = [UIColor clearColor];
    
    [self setupArrowViewInView:overlayView];
    [overlayView addSubview:self.controlsView];
    [overlayView addSubview:self.statusBarView];
    
    picker.cameraOverlayView = overlayView;
    
    [self presentViewController:picker animated:NO completion:nil];
}

#pragma mark - Setup

- (void)setupArrowViewInView:(UIView *)view
{
    CGRect frame = CGRectMake(view.frame.size.width / 6.0,
                              view.frame.size.height / 10.0,
                              4.0 * view.frame.size.width / 6.0,
                              6.5 * view.frame.size.height / 10.0);
    self.arrowView = [[NAArrowView alloc] initWithFrame:frame];
    [view addSubview:self.arrowView];
}

#pragma mark - Button actions

- (IBAction)buttonPressed:(UIButton *)sender
{
    if (!self.arrowView.isPointing) {
        [self.arrowView startPointing];
    }
    
    if ([sender.titleLabel.text isEqualToString:@"Featheringill Hall"]) {
        self.arrowView.destination =
        [[CLLocation alloc] initWithLatitude:36.1447809
                                   longitude:-86.8032186];
    } else if ([sender.titleLabel.text isEqualToString:@"Roma"]) {
        self.arrowView.destination =
        [[CLLocation alloc] initWithLatitude:36.1480013
                                   longitude:-86.8083296];
    }
}

@end
