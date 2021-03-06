//
//  RestaurantAnnotationView.m
//  Forkit
//
//  Created by david on 2016. 12. 13..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RestaurantAnnotationView.h"
#import "RestaurantAnnotationProtocol.h"
//#import "MapViewController.h"

@implementation RestaurantAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createButtonWithAnnotation:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveNoSelectedButton:)
                                                     name:ButtonClickedNotification
                                                   object:nil];
    }
    return self;
}

- (void)createButtonWithAnnotation:(RestaurantAnnotationView *)annotationView
{
    _locationButton = [AnnotationButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setBackgroundImage:[UIImage imageNamed:@"locationDeSelected"]
                              forState:UIControlStateNormal];
    [_locationButton setBackgroundImage:[UIImage imageNamed:@"locationSelected"]
                              forState:UIControlStateSelected];
    
    _locationButton.frame = CGRectMake(0, 0, 44, 44);
    _locationButton.userInteractionEnabled = NO;
    
    annotationView.frame = CGRectMake(0, 0, 44, 44);
    [annotationView addSubview:_locationButton];
}

- (void)didReceiveNoSelectedButton:(NSNotification *)noti
{
    self.locationButton.selected = NO;
    RestaurantAnnotationProtocol *annotation = (RestaurantAnnotationProtocol *)self.annotation;
    annotation.isSelected = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
