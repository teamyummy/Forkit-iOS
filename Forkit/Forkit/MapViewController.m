//
//  MapViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 29..
//  Copyright © 2016년 david. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *FIMapView;
@property CLLocationManager *locationManager;
@property CLLocationCoordinate2D coordinate;
@property MKCoordinateSpan span;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //좌표
    self.coordinate = CLLocationCoordinate2DMake(37.5754, 126.9769);
    
    //반경
    self.span = MKCoordinateSpanMake(0.5, 0.5);
    
    //어떤지역 (좌표의 지점 센터, 반경)
    MKCoordinateRegion region = MKCoordinateRegionMake(_coordinate, _span);
    
    [self.FIMapView setRegion:region];
    
}
- (IBAction)clickDismissButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
