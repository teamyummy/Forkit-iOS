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
static CGFloat collcetionCellWidth;

@interface MapViewController () <MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *invisibleScrollView;
@property (weak, nonatomic) IBOutlet MKMapView *restaurantMapView;
@property (weak, nonatomic) IBOutlet UICollectionView *restaurantCollectionView;

@property NSInteger annotationIndex;

@property MKCoordinateRegion region;

@end

@implementation MapViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _annotationIndex = annotationIndexStart;
    
    [self setCollectionCellSizeAndScrollWidth];
    [self updateMapViewLocation:CLLocationCoordinate2DMake(37.516287, 127.020015)];
    [self.restaurantMapView setShowsUserLocation:YES];
    [self setAnotations];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)setCollectionCellSizeAndScrollWidth
{
    CGFloat superViewWidth = self.view.frame.size.width;
    
    collcetionCellWidth = (superViewWidth - collcetionSectionMargin * 2);
    
    _invisibleScrollView.contentSize = CGSizeMake((collcetionCellWidth * 10) + (collcetionCellMargin * 10), 0);
    self.invisibleScrollView.delegate = self;
    
    [_restaurantCollectionView addGestureRecognizer:_invisibleScrollView.panGestureRecognizer];
}

#pragma mark - custom method

- (void)updateMapViewLocation:(CLLocationCoordinate2D)coordinates
{
    //반경
    MKCoordinateSpan span = MKCoordinateSpanMake(0.025, 0.025);
    //어떤지역 (좌표의 지점 센터, 반경)
    self.region = MKCoordinateRegionMake(coordinates, span);
    
    [self.restaurantMapView setRegion:_region animated:YES];
}

- (void)setAnotations
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

#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.restaurantDataList.count;
}

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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ;
    return CGSizeMake(collcetionCellWidth,
                      collectionView.frame.size.height);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, collcetionSectionMargin, 0, collcetionSectionMargin);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_invisibleScrollView)
    {
        _restaurantCollectionView.contentOffset = _invisibleScrollView.contentOffset;
    }
}
#pragma mark - Click Button

- (IBAction)clickDismissButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CLLocation Manager Delegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKPointAnnotation *annotation = (MKPointAnnotation*)view.annotation;
    [self updateMapViewLocation:CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)];
    RestaurantAnnotationView *restaurantAnnotationView = (RestaurantAnnotationView *)view;
    [self clickAnnotationButton:restaurantAnnotationView mapView:mapView];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    static NSString *const MapAnnotationIdentifier = @"pin";
    
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

- (void)clickAnnotationButton:(RestaurantAnnotationView *)annotationView mapView:(MKMapView *)mapView
{
    NSArray *annotations = mapView.annotations;
    for (NSInteger i = 100; i < mapView.annotations.count + annotationIndexStart; i++)
    {
        RestaurantAnnotationProtocol *annotation = annotations[i - annotationIndexStart];
        if ([annotation isKindOfClass:[RestaurantAnnotationProtocol class]])
        {
            annotation.isSelected = NO;
            UIButton *button = (UIButton *)[mapView viewWithTag:i];
            button.selected = NO;
        }
    }
    if (annotationView.locationButton.selected == NO)
    {//selected
        annotationView.locationButton.selected = YES;
        RestaurantAnnotationProtocol *restaurantAnnotation = (RestaurantAnnotationProtocol *)annotationView.annotation;
        restaurantAnnotation.isSelected = YES;
        NSInteger pageNumber = annotationView.locationButton.tag - annotationIndexStart;
        CGPoint pageOffset = CGPointMake(pageNumber * (collcetionCellWidth + 8.f), 0);
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
