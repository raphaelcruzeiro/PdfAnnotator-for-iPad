//
//  DrawingViewController.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/14/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import <UIKit/UIKit.h>

enum TextMarkerBrush {
    TextMarkerBrushYellow,
    TextMarkerBrushGreen,
    TextMarkerBrushRed,
    TextMarkerBrushBlue
};

typedef enum TextMarkerBrush TextMarkerBrush;

@interface DrawingViewController : UIViewController {
    BOOL drawable;
    CGPoint lastPoint;
    CGContextRef context;
    CGRect viewFrame;
    TextMarkerBrush _brush;
    BOOL firstTime;
}

@property (nonatomic, retain) UIImageView *imageView;

- (id)initWithFrame:(CGRect)frame;
- (void)setDrawable:(BOOL)enabled;
- (void)prepareBrush;

- (void)setBrush:(TextMarkerBrush)brush;

@end
