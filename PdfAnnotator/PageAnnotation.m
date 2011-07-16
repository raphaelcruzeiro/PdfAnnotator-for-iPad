//
//  PageAnnotation.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/16/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "PageAnnotation.h"

@implementation PageAnnotation

@synthesize _paths;

- (id)initWithPageNumber:(NSInteger)pageNumber
{
    self = [super init];
    if (self) {
        _pageNumber = pageNumber;
        
        _paths = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSInteger)getPageNumber
{
    return _pageNumber;
}

@end
