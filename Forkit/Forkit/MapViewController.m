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

#import "CustomCollectionViewController.h"
#import "CustomCollectionViewCell.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *FIMapView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property CLLocationManager *locationManager;
@property CLLocationCoordinate2D coordinate;
@property MKCoordinateSpan span;


//! map annotations
@property NSMutableArray *annotationCoordinates;

@end

@implementation MapViewController

static NSString *const mapAnnotationIdentifier = @"pin";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //! DataManager 에서 받아오는 것으로 수정
    self.annotationCoordinates = [[NSMutableArray alloc] initWithArray:@[@{@"title":@"shop1", @"latitude":@"37.5264", @"longitude":@"126.9569"}, @{@"title":@"shop2", @"latitude":@"37.5553", @"longitude":@"126.9269"},@{@"title":@"shop3", @"latitude":@"37.5872", @"longitude":@"126.9770"}]];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.FIMapView.delegate = self;
    
    //좌표
    self.coordinate = CLLocationCoordinate2DMake(37.5754, 126.9769);
    //반경
    self.span = MKCoordinateSpanMake(0.5, 0.5);
    //어떤지역 (좌표의 지점 센터, 반경)
    MKCoordinateRegion region = MKCoordinateRegionMake(_coordinate, _span);
    [self.FIMapView setRegion:region];

//    self.scrollView.contentSize
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)clickDismissButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    for (NSDictionary *coordinate in self.annotationCoordinates) {
        Annotation *shopAnnotation = [[Annotation alloc] initWithTitle:coordinate[@"title"] AndCoordinate:CLLocationCoordinate2DMake([coordinate[@"latitude"] floatValue], [coordinate[@"longitude"] floatValue])];
        [self.FIMapView addAnnotation:shopAnnotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *newAnnotation = (MKAnnotationView *) [self.FIMapView dequeueReusableAnnotationViewWithIdentifier:mapAnnotationIdentifier];
    newAnnotation.canShowCallout = YES;
    
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
