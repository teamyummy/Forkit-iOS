//
//  Annotation.m
//  Forkit
//
//  Created by Nexus_MYT on 2016. 11. 29..
//  Copyright © 2016년 david. All rights reserved.
//

#import "Annotation.h"

@interface Annotation()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

@implementation Annotation

- (instancetype)initWithTitle:(NSString *)title AndCoordinate:(CLLocationCoordinate2D)coordinate{
    self = [super init];
    if (self) {
        self.title = title;
        self.coordinate = coordinate;
    }
    return self;
}

@end
