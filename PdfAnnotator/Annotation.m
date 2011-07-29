//
//  Annotation.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/16/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "Annotation.h"
#import "PageAnnotation.h"

@implementation Annotation

@synthesize _pageAnnotations;

- (id)init
{
    self = [super init];
    if (self) {
        self._pageAnnotations = [[[NSMutableArray alloc] init] autorelease];
    }
    
    return self;
}

- (PageAnnotation*)annotationForPage:(NSInteger)page
{
    for(PageAnnotation * a in self._pageAnnotations) {
        if([a getPageNumber] == page)
            return a;
    }
    
    return Nil;
}

- (void)dealloc
{
    [super dealloc];
    
    [_pageAnnotations release];
}

@end
