//
//  MakerPath.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/16/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "MarkerPath.h"

@implementation MrkPoint

@synthesize x;
@synthesize y;

- (id)initWith:(CGFloat)_x And:(CGFloat)_y
{
    if((self = [super init])) {
        self.x = _x;
        self.y = _y;
    }
    
    return self;
}

@end

@implementation MarkerPath

@synthesize points;

- (id)initWithPoint:(CGPoint)point AndBrush:(TextMarkerBrush)brush
{
    self = [super init];
    if (self) {
        _brush = brush;
        _path = CGPathCreateMutable();
        CGPathMoveToPoint(_path, NULL, point.x, point.y);
        points = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addPoint:(CGPoint)point
{
    CGPathAddLineToPoint(_path, NULL, point.x, point.y);
    [points addObject:[[MrkPoint alloc] initWith:point.x And:point.y]];
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
    [points release];
    
    CGPathRelease(_path);
}

@end
