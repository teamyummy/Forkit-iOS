//
//  MKAnnotationView+CorrectIndex.m
//  Forkit
//
//  Created by david on 2016. 12. 12..
//  Copyright © 2016년 david. All rights reserved.
//

#import "MKAnnotationView+CorrectIndex.h"

@implementation MKAnnotationView (CorrectIndex)

@dynamic correctInteger;

- (NSInteger)correctInteger
{
    return _correctInteger
}

- (void)correctInteger:(NSInteger)correctInteger
{
    _correctInteger = correctInteger
}
@end
