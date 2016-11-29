//
//  Annotation.h
//  Forkit
//
//  Created by Nexus_MYT on 2016. 11. 29..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (instancetype)initWithTitle:(NSString *)title AndCoordinate:(CLLocationCoordinate2D)coordinate;

@end
