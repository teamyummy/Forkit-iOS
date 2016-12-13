//
//  RestaurantAnnotationView.m
//  Forkit
//
//  Created by david on 2016. 12. 13..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RestaurantAnnotationView.h"
#import "MapViewController.h"


@implementation RestaurantAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createButtonWithAnnotation:self];
    }
    return self;
}

- (void)createButtonWithAnnotation:(RestaurantAnnotationView *)annotationView
{
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setBackgroundImage:[UIImage imageNamed:@"dummyFoodImage"]
                              forState:UIControlStateNormal];
    [_locationButton setBackgroundImage:[UIImage imageNamed:@"dummyImage"]
                              forState:UIControlStateSelected];
    
    _locationButton.frame = CGRectMake(0, 0, 30, 30);
    _locationButton.userInteractionEnabled = NO;
    
    annotationView.frame = CGRectMake(0, 0, 30, 30);
    [annotationView addSubview:_locationButton];
}
@end
