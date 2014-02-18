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

@property (strong, nonatomic) NAArrowView *arrowView;

@end

@implementation NAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [self setupArrowView];
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
    [self.view addSubview:self.arrowView];
}

#pragma mark - Button actions

- (IBAction)buttonPressed:(UIButton *)sender
{
    if (!self.arrowView.isPointing) {
        [self.arrowView startPointing];
    }
    
    if ([sender.titleLabel.text isEqualToString:@"Featheringill Hall"]) {
        self.arrowView.destination = [CLLocation locationWithCoordinate:
                                      CLLocationCoordinate2DMake(36.1447809,
                                                                 -86.8032186)];
    } else if ([sender.titleLabel.text isEqualToString:@"Roma"]) {
        self.arrowView.destination = [CLLocation locationWithCoordinate:
                                      CLLocationCoordinate2DMake(36.1480013,
                                                                 -86.8083296)];
    }
}

@end
