//
//  DrawingViewController.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/14/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingViewController : UIViewController {
    BOOL drawable;
    CGPoint lastPoint;
    CGContextRef context;
    CGRect viewFrame;
}

@property (nonatomic, retain) UIImageView *imageView;

- (id)initWithFrame:(CGRect)frame;
- (void)setDrawable:(BOOL)enabled;
- (void)prepareBrush;

@end
