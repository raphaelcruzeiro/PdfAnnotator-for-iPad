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

#import <Foundation/Foundation.h>

enum TextMarkerBrush {
    TextMarkerBrushYellow,
    TextMarkerBrushGreen,
    TextMarkerBrushRed,
    TextMarkerBrushBlue
};

@interface MrkPoint : NSObject {

}

- (id)initWith:(CGFloat)x And:(CGFloat)y;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end

typedef enum TextMarkerBrush TextMarkerBrush;

@interface MarkerPath : NSObject {
    TextMarkerBrush _brush;
    CGMutablePathRef _path;
}

@property (nonatomic, retain) NSMutableArray *points;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL loadedFromFile;

- (id)initWithPoint:(CGPoint)point AndBrush:(TextMarkerBrush)brush;
- (id)initWithBrush:(TextMarkerBrush)brush;

- (void)addPoint:(CGPoint)point;

- (TextMarkerBrush)getBrush;
- (CGPathRef)getPath;

@end
