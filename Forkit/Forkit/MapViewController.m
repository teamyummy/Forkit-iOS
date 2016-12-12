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
#import "RestaurantListCollectionViewCell.h"
#import "RestaurantDetailViewController.h"

static const NSInteger collcetionSectionMargin = 20;
static const NSInteger collcetionCellMargin = 8;
static CGFloat collcetionCellWidth;

@interface MapViewController () <MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *invisibleScrollView;
@property (weak, nonatomic) IBOutlet MKMapView *restaurantMapView;
@property (weak, nonatomic) IBOutlet UICollectionView *restaurantCollectionView;

@property NSInteger annotationIndexArraryCount;
@property NSInteger annotationIndex;
@property NSMutableArray *annotationIndexArrary;

@property MKCoordinateRegion region;

@end

@implementation MapViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _annotationIndexArrary = [NSMutableArray array];
    _annotationIndex = 100;
    _annotationIndexArraryCount = 0;
    
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
        Annotation *restaurantAnnotation = [[Annotation alloc] initWithTitle:[restaurantDict objectForKey:JSONRestaurnatNameKey]
                                                               AndCoordinate:CLLocationCoordinate2DMake([restaurantDict[JSONRestaurnatLatitudeKey] floatValue],
                                                                                                        [restaurantDict[JSONRestaurnatLongitudeKey] floatValue])];
        restaurantAnnotation.index = _annotationIndex;
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
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *const mapAnnotationIdentifier = @"pin";
    
    Annotation *myAnnotation = (Annotation *)annotation;
    [_annotationIndexArrary addObject:[NSNumber numberWithInteger:myAnnotation.index]];
    
    MKAnnotationView *newAnnotation = (MKAnnotationView *) [self.restaurantMapView dequeueReusableAnnotationViewWithIdentifier:mapAnnotationIdentifier];
    
    newAnnotation.canShowCallout = NO;
    
    if (newAnnotation == nil)
    {
        newAnnotation = [[MKAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:mapAnnotationIdentifier];
    }
    [self createButtonWithAnnotation:newAnnotation];
    
    return newAnnotation;
}

- (void)createButtonWithAnnotation:(MKAnnotationView *)annotation
{
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"dummyFoodImage"]
                              forState:UIControlStateNormal];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"dummyImage"]
                              forState:UIControlStateSelected];
    
    [locationButton addTarget:self
                       action:@selector(clickAnnotationButton:)
             forControlEvents:UIControlEventTouchUpInside];
    
    locationButton.frame = CGRectMake(0, 0, 30, 30);
    locationButton.tag = [[_annotationIndexArrary objectAtIndex:_annotationIndexArraryCount] integerValue];

    locationButton.userInteractionEnabled = YES;
    
    annotation.frame = CGRectMake(0, 0, 30, 30);
    [annotation addSubview:locationButton];
    
    _annotationIndexArraryCount += 1;
}

- (void)clickAnnotationButton:(UIButton *)sender
{
    for (NSInteger i = 100; i < _annotationIndexArrary.count + 100; i++)
    {
        UIButton *allButton = (UIButton *)[self.view viewWithTag:i];
        allButton.selected = NO;
    }
    if (sender.selected == NO)
    {//selected
        sender.selected = YES;
        
        NSInteger pageNumber = sender.tag - 100;
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
