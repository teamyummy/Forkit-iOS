//
//  RestaurantAnnotationProtocol.h
//  Forkit
//
//  Created by david on 2016. 12. 13..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RestaurantAnnotationProtocol : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property NSInteger indexPath;
@property BOOL isSelected;

- (instancetype)initWithTitle:(NSString *)title AndCoordinate:(CLLocationCoordinate2D)coordinate;

@end
