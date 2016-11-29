//
//  MapViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 29..
//  Copyright © 2016년 david. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"

@interface MapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *FIMapView;
@property CLLocationManager *locationManager;
@property CLLocationCoordinate2D coordinate;
@property MKCoordinateSpan span;

@end

@implementation MapViewController

static NSString *const mapAnnotationIdentifier = @"pin";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //좌표
    self.coordinate = CLLocationCoordinate2DMake(37.5754, 126.9769);
    
    //반경
    self.span = MKCoordinateSpanMake(0.5, 0.5);
    
    //어떤지역 (좌표의 지점 센터, 반경)
    MKCoordinateRegion region = MKCoordinateRegionMake(_coordinate, _span);
    
    //! 테스트 코드 -> custom annotation
    Annotation *testAnnotation = [[Annotation alloc] initWithTitle:@"I am Lee hong hwa!" AndCoordinate:_coordinate];
    [self.FIMapView addAnnotation:testAnnotation];
    
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *newAnnotation = (MKAnnotationView *) [self.FIMapView dequeueReusableAnnotationViewWithIdentifier:mapAnnotationIdentifier];
    
    if (!newAnnotation) {
        Annotation *myAnnotation = (Annotation *)annotation;
        newAnnotation = [[MKAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:mapAnnotationIdentifier];
    }
    
    newAnnotation.frame = CGRectMake(0, 0, 30, 30);
    
    UIImageView *annotationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dummyFoodImage"]];
    annotationImageView.frame = CGRectMake(0, 0, 30, 30);
    [newAnnotation addSubview:annotationImageView];
    
    return newAnnotation;
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
