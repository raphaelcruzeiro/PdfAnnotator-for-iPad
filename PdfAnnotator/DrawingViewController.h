//
//  DrawingViewController.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/14/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkerPath.h"

@protocol DrawingViewControllerDelegate;

@interface DrawingViewController : UIViewController {
    BOOL drawable;
    CGPoint lastPoint;
    CGContextRef context;
    CGRect viewFrame;
    TextMarkerBrush _brush;
    BOOL firstTime;
    MarkerPath *currentPath;
}

@property (nonatomic, retain) id<DrawingViewControllerDelegate> delegate;

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSMutableArray *_paths;

- (id)initWithFrame:(CGRect)frame AndPaths:(NSMutableArray*)paths AndDelegate:(id<DrawingViewControllerDelegate>)_delegate;
- (void)setDrawable:(BOOL)enabled;
- (void)prepareBrush;

- (void)undo;
- (void)redo;

- (BOOL)canUndo;
- (BOOL)canRedo;

- (void)drawPaths;

- (void)setBrush:(TextMarkerBrush)brush;

@end

@protocol DrawingViewControllerDelegate <NSObject>

- (void)changed;
- (void)canUndo:(BOOL)value;

@end
