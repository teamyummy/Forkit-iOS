//
//  MapViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 29..
//  Copyright © 2016년 david. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "RestaurantAnnotationProtocol.h"
#import "RestaurantAnnotationView.h"
#import "RestaurantListCollectionViewCell.h"
#import "RestaurantDetailViewController.h"

static const NSInteger collcetionSectionMargin = 20;
static const NSInteger collcetionCellMargin = 8;
static const NSInteger annotationIndexStart = 100;
static CGFloat collecetionCellWidth;

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *invisibleScrollView;
@property (weak, nonatomic) IBOutlet MKMapView *restaurantMapView;
@property (weak, nonatomic) IBOutlet UICollectionView *restaurantCollectionView;

@property NSInteger annotationIndex;

@property CLLocationManager *locationManager;
@property MKCoordinateRegion region;

@end

@implementation MapViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _annotationIndex = annotationIndexStart;
    [self createLoactionManger];
    [self setCollectionCellSizeAndScrollWidth];
    [self updateMapViewLocation:CLLocationCoordinate2DMake(37.516287, 127.020015)];
    [self.restaurantMapView setShowsUserLocation:YES];
    [self createAnotations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - custom method

- (void)setCollectionCellSizeAndScrollWidth
{
    CGFloat superViewWidth = self.view.frame.size.width;
    
    collecetionCellWidth = (superViewWidth - collcetionSectionMargin * 2);
    
    _invisibleScrollView.contentSize = CGSizeMake((collecetionCellWidth * 10) + (collcetionCellMargin * 10), 0);
    self.invisibleScrollView.delegate = self;
    
    [_restaurantCollectionView addGestureRecognizer:_invisibleScrollView.panGestureRecognizer];
}

- (void)createAnotations
{
    for (NSDictionary *restaurantDict in _restaurantDataList)
    {
        RestaurantAnnotationProtocol *restaurantAnnotation = [[RestaurantAnnotationProtocol alloc] initWithTitle:[restaurantDict objectForKey:JSONRestaurnatNameKey]
                                                                                                   AndCoordinate:CLLocationCoordinate2DMake([restaurantDict[JSONRestaurnatLatitudeKey] floatValue],
                                                                                                                                            [restaurantDict[JSONRestaurnatLongitudeKey] floatValue])];
        restaurantAnnotation.indexPath = _annotationIndex;
        restaurantAnnotation.isSelected = NO;
        
        _annotationIndex += 1;
        [self.restaurantMapView addAnnotation:restaurantAnnotation];
    }
}

- (void)createLoactionManger
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)updateMapViewLocation:(CLLocationCoordinate2D)coordinates
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.025, 0.025);
    self.region = MKCoordinateRegionMake(coordinates, span);
    [self.restaurantMapView setRegion:_region animated:YES];
}

//보이는 annotation의 갯수 출력
- (NSInteger)anotationsInVisibleMapAnnotationCount
{
    NSSet *annotationSet = [_restaurantMapView annotationsInMapRect:[_restaurantMapView visibleMapRect]];
    
    return annotationSet.count;
}

#pragma mark - Collection View Delegate

//item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.restaurantDataList.count;
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *const reuseIdentifierdentifierShopCollectionCell = @"shopCollectionCell";
    
    RestaurantListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierdentifierShopCollectionCell
                                                                           forIndexPath:indexPath];
    NSDictionary *restaurantDataTempDict;
    restaurantDataTempDict = [self.restaurantDataList objectAtIndex:indexPath.row];
    
    if (self.restaurantDataList != nil)
    {
        
        cell.restaurantTitleLabel.text = [restaurantDataTempDict objectForKey:JSONRestaurnatNameKey];
        
        cell.restaurantAddressLabel.text = [restaurantDataTempDict objectForKey:JSONRestaurnatAddressKey];
        
        cell.restaurantScoreLabel.text = [restaurantDataTempDict objectForKey:JSONRestaurnatAvgReviewScoreKey];
        
        cell.restaurantReviewCountLabel.text = [restaurantDataTempDict objectForKey:JSONRestaurnatTotalReviewCountKey];
        
        cell.restaurantLikeCountLabel.text = [restaurantDataTempDict objectForKey:JSONRestaurnatTotalLikeKey];
        
        NSArray *images = [restaurantDataTempDict objectForKey:JSONCommonImagesKey];
        
        if (images != nil && [images count] != 0)
        {
            [cell.restaurantImageView sd_setImageWithURL:[[images objectAtIndex:0] objectForKey:JSONCommonSmallImageURLKey]];
        }
    }

    return cell;
}

//size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ;
    return CGSizeMake(collecetionCellWidth,
                      collectionView.frame.size.height);
}

//section margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, collcetionSectionMargin, 0, collcetionSectionMargin);
}

//selected
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

//Did scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        _restaurantCollectionView.contentOffset = _invisibleScrollView.contentOffset;
}

//End Scroll
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self anotationsInVisibleMapAnnotationCount] != 1)
    {
        CGFloat offesetX = _restaurantCollectionView.contentOffset.x;
        NSInteger pageNumber = (NSInteger)offesetX/(NSInteger)collecetionCellWidth;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ButtonClickedNotification
                                                            object:nil];
        UIButton *annotationButton = (UIButton *)[_restaurantMapView viewWithTag:pageNumber + annotationIndexStart];
        annotationButton.selected = YES;
        RestaurantAnnotationView *annotationView = (RestaurantAnnotationView *)annotationButton.superview;
        RestaurantAnnotationProtocol *annotation = (RestaurantAnnotationProtocol *)annotationView.annotation;
        annotation.isSelected = YES;
        [self updateMapViewLocation:annotation.coordinate];
    }
}

#pragma mark - Click Button

- (IBAction)clickDismissButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CLLocation Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *userRecentLocation = [locations lastObject];
    [self updateMapViewLocation:userRecentLocation.coordinate];

    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class]])
    {
        return;
    }
    
    MKPointAnnotation *annotation = (MKPointAnnotation*)view.annotation;
    [self updateMapViewLocation:CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)];
    [[NSNotificationCenter defaultCenter] postNotificationName:ButtonClickedNotification object:nil];
    RestaurantAnnotationView *restaurantAnnotationView = (RestaurantAnnotationView *)view;
    [self clickAnnotationButton:restaurantAnnotationView];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *const MapAnnotationIdentifier = @"mapAnnotationIdentifier";
    
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    RestaurantAnnotationProtocol *myAnnotation = (RestaurantAnnotationProtocol *)annotation;
    RestaurantAnnotationView *newAnnotation = (RestaurantAnnotationView *) [self.restaurantMapView dequeueReusableAnnotationViewWithIdentifier:MapAnnotationIdentifier];
    
    if (newAnnotation == nil)
    {
        newAnnotation = [[RestaurantAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:MapAnnotationIdentifier];
    }
    
    NSInteger annotationIndexPath = myAnnotation.indexPath;
    
    newAnnotation.indexPath = annotationIndexPath;
    newAnnotation.locationButton.tag = annotationIndexPath;
    newAnnotation.locationButton.selected = myAnnotation.isSelected;
    
    return newAnnotation;
}

- (void)clickAnnotationButton:(RestaurantAnnotationView *)annotationView
{
    if (annotationView.locationButton.selected == NO)
    {//selected
        annotationView.locationButton.selected = YES;
        RestaurantAnnotationProtocol *restaurantAnnotation = (RestaurantAnnotationProtocol *)annotationView.annotation;
        restaurantAnnotation.isSelected = YES;
        NSInteger pageNumber = annotationView.locationButton.tag - annotationIndexStart;
        CGPoint pageOffset = CGPointMake(pageNumber * (collecetionCellWidth + 8.f), 0);
        [UIView animateWithDuration:0.2 animations:^{
            _restaurantCollectionView.contentOffset = pageOffset;
            _invisibleScrollView.contentOffset = pageOffset;
        }];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[RestaurantDetailViewController class]])
    {
        RestaurantListCollectionViewCell *cell = sender;
        NSIndexPath *cellIndex = [_restaurantCollectionView indexPathForCell:cell];
        NSDictionary *restaurantDatas = [_restaurantDataList objectAtIndex:cellIndex.row];
        
        RestaurantDetailViewController *restaurantDetailVC = segue.destinationViewController;
        restaurantDetailVC.restaurantDatas = restaurantDatas;
    }
}


@end
