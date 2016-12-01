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

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *FIMapView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property CLLocationManager *locationManager;
@property CLLocationCoordinate2D coordinate;
@property MKCoordinateSpan span;

//! map annotations
@property NSMutableArray *shopDatas;

@end

@implementation MapViewController

static NSString *const mapAnnotationIdentifier = @"pin";
static const NSInteger scrollViewHeight = 88;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //! DataManager 에서 받아오는 것으로 수정
    self.shopDatas = [[NSMutableArray alloc] initWithArray:@[
  @{@"name":@"shop1", @"score":@"5", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5264", @"longitude":@"126.9569"},
  @{@"name":@"shop2", @"score":@"4", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5553", @"longitude":@"126.9269"},
  @{@"name":@"shop3", @"score":@"2", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5872", @"longitude":@"126.9770"},
  @{@"name":@"shop4", @"score":@"5", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5264", @"longitude":@"126.9639"},
  @{@"name":@"shop5", @"score":@"4", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5523", @"longitude":@"126.9169"},
  @{@"name":@"shop6", @"score":@"2", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5132", @"longitude":@"126.9070"},
  @{@"name":@"shop7", @"score":@"5", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5314", @"longitude":@"126.9129"},
  @{@"name":@"shop8", @"score":@"4", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5433", @"longitude":@"126.9439"},
  @{@"name":@"shop9", @"score":@"2", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5222", @"longitude":@"126.9220"}
  ]];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.FIMapView.delegate = self;
    
    //좌표
    self.coordinate = CLLocationCoordinate2DMake(37.5754, 126.9769);
    //반경
    self.span = MKCoordinateSpanMake(0.15, 0.15);
    //어떤지역 (좌표의 지점 센터, 반경)
    MKCoordinateRegion region = MKCoordinateRegionMake(_coordinate, _span);
    [self.FIMapView setRegion:region];

    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = NO; // 델리게이트로 페이징을 맞췄기 때문에 NO 를 줌
    self.scrollView.contentSize = CGSizeMake(self.shopDatas.count * self.scrollView.frame.size.width + 60, scrollViewHeight);
    self.scrollView.contentOffset = CGPointMake(0, 0);
//    self.scrollView.backgroundColor = [UIColor redColor];
    
    MapViewController __weak *wself = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself createPageViews];
    });
}

- (void)createPageViews {
    NSInteger i = 0;
    for (NSDictionary *shopData in self.shopDatas) {
        UIView *shopView = [[UIView alloc] initWithFrame:CGRectMake(30+i*(self.scrollView.bounds.size.width), 0, self.scrollView.bounds.size.width-30, scrollViewHeight)];
        shopView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:shopView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollViewHeight, scrollViewHeight)];
        imageView.image = [UIImage imageNamed:@"dummyFoodImage"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [shopView addSubview:imageView];
        
        UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(scrollViewHeight, 0, shopView.frame.size.width-imageView.frame.size.width-30, shopView.frame.size.height)];
//        textView.backgroundColor = [UIColor grayColor];
        [shopView addSubview:textView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
        titleLabel.text = shopData[@"name"];
        titleLabel.font = [UIFont systemFontOfSize:17];
        [textView addSubview:titleLabel];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2*10+10, 100, 20)];
        addressLabel.text = shopData[@"address"];
        addressLabel.font = [UIFont systemFontOfSize:14];
        addressLabel.alpha = 0.7;
        [textView addSubview:addressLabel];
        
        UIStackView *lowerHorizontalStackView = [[UIStackView alloc] initWithFrame:CGRectMake(15, 50, textView.frame.size.width-30, 30)];
        lowerHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        [textView addSubview:lowerHorizontalStackView];
        
        UIImageView *scoreView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        scoreView.image = [UIImage imageNamed:@"dummyFoodImage"];
        [lowerHorizontalStackView addSubview:scoreView];
        UILabel *scoreTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 30, 30)];
        scoreTextLabel.text = shopData[@"score"];
        [lowerHorizontalStackView addSubview:scoreTextLabel];
        UILabel *reviewAndFavoriteCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, lowerHorizontalStackView.frame.size.width-60, 30)];
        reviewAndFavoriteCountLabel.text = [NSString stringWithFormat:@"리뷰 %@ 즐겨찾기 %@", shopData[@"review_count"], shopData[@"favorite_count"]];
        [lowerHorizontalStackView addSubview:reviewAndFavoriteCountLabel];
        i++;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)clickDismissButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Map View Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    for (NSDictionary *coordinate in self.shopDatas) {
        Annotation *shopAnnotation = [[Annotation alloc] initWithTitle:coordinate[@"name"] AndCoordinate:CLLocationCoordinate2DMake([coordinate[@"latitude"] floatValue], [coordinate[@"longitude"] floatValue])];
        [self.FIMapView addAnnotation:shopAnnotation];
    }
    
    //stop
    [self.locationManager stopUpdatingLocation];
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

#pragma mark - Scroll View Delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.scrollView) {
        CGFloat x = targetContentOffset->x;
        CGFloat pagingWidth = 375;
        x = roundf(x / pagingWidth) * (pagingWidth);
        targetContentOffset->x = x;
    }
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
