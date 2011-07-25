//
//  PDFPageViewController.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/2/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFPagingViewController.h"
#import "TextMarkerSelectorViewController.h"
#import "DrawingViewController.h"

@class PDFDocument;
@class PDFPagingViewController;

@protocol PDFPageViewControllerDelegate;

@interface PDFPageViewController : UIViewController <UIScrollViewDelegate, PDFPagingViewProtocol, DrawingViewControllerDelegate>
{
    UIScrollView *scrollView;
    UIView *contentView;
    CGFloat maximumZoomScale, minimumZoomScale;
}

@property (nonatomic, retain) id<PDFPageViewControllerDelegate> delegate;

@property (nonatomic, retain) PDFDocument *_document;

@property (nonatomic, retain) PDFPagingViewController *pagingViewController;
@property (nonatomic, retain) DrawingViewController *drawingViewController;

- (id)initWithDelegate:(id<PDFPageViewControllerDelegate>)_delegate;
- (void) loadDocument:(PDFDocument *)document;
- (void) refreshPage;
- (void)setPenMode:(BOOL)enabled;
- (void)setHandMode:(BOOL)enabled;

- (void)setBrush:(TextMarkerBrush)brush;

- (void)undo;
- (void)redo;

@end

@protocol PDFPageViewControllerDelegate <NSObject>

- (void)changed;
- (void)canUndo:(BOOL)value;

@end
