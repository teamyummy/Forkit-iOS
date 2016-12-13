//
//  RestaurantAnnotationView.h
//  Forkit
//
//  Created by david on 2016. 12. 13..
//  Copyright © 2016년 david. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface RestaurantAnnotationView : MKAnnotationView

@property (nonatomic, strong) AnnotationDataManager *dataManager;

@property UIButton *locationButton;

@property NSInteger indexPath;

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
