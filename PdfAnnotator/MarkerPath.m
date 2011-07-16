//
//  MakerPath.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/16/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "MarkerPath.h"

@implementation MarkerPath

- (id)initWithPoint:(CGPoint)point AndBrush:(TextMarkerBrush)brush
{
    self = [super init];
    if (self) {
        _brush = brush;
        _path = CGPathCreateMutable();
        CGPathMoveToPoint(_path, NULL, point.x, point.y);
    }
    
    return self;
}

- (void)addPoint:(CGPoint)point
{
    CGPathAddLineToPoint(_path, NULL, point.x, point.y);
    
}

- (TextMarkerBrush)getBrush
{
    return _brush;
}

- (CGPathRef)getPath
{
    return _path;
}

- (void)dealloc
{
    [super dealloc];
    
    CGPathRelease(_path);
}

@end
