//
//  RestaurantAnnotationProtocol.m
//  Forkit
//
//  Created by david on 2016. 12. 13..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RestaurantAnnotationProtocol.h"

@interface RestaurantAnnotationProtocol ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

@implementation RestaurantAnnotationProtocol

- (instancetype)initWithTitle:(NSString *)title AndCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        self.title = title;
        self.coordinate = coordinate;
    }
    return self;
}

@end
