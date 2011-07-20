//
//  MakerPath.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/16/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

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

- (id)initWithPoint:(CGPoint)point AndBrush:(TextMarkerBrush)brush;
- (id)initWithBrush:(TextMarkerBrush)brush;

- (void)addPoint:(CGPoint)point;

- (TextMarkerBrush)getBrush;
- (CGPathRef)getPath;

@end
