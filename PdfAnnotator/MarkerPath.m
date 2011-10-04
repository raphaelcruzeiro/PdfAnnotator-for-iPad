// Copyright (C) 2011 by Raphael Cruzeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
@synthesize active;
@synthesize loadedFromFile;

- (id)initWithPoint:(CGPoint)point AndBrush:(TextMarkerBrush)brush
{
    self = [super init];
    if (self) {
        active = YES;
        _brush = brush;
        _path = CGPathCreateMutable();
        CGPathMoveToPoint(_path, NULL, point.x, point.y);
        points = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithBrush:(TextMarkerBrush)brush
{
    self = [super init];
    if(self) {
        active = YES;
        _brush = brush;
        _path = CGPathCreateMutable();
        points = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addPoint:(CGPoint)point
{
    CGPoint currentPoint = CGPathGetCurrentPoint(_path);
    if(CGPointZero.x == currentPoint.x && CGPointZero.y == currentPoint.y)
        CGPathMoveToPoint(_path, NULL, point.x, point.y);
    
    CGPathAddLineToPoint(_path, NULL, point.x, point.y);
    [points addObject: [[[MrkPoint alloc] initWith:point.x And:point.y] autorelease]];
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
}

@end
