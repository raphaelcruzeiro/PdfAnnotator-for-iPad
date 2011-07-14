//
//  PDFPageViewController.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/2/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFPagingViewController.h"
#import "TextMarkerSelectorViewController.h"

@class PDFDocument;
@class PDFPagingViewController;
@class DrawingViewController;

@interface PDFPageViewController : UIViewController <UIScrollViewDelegate, PDFPagingViewProtocol>
{
    UIScrollView *scrollView;
    UIView *contentView;
}

@property (nonatomic, retain) PDFDocument *_document;

@property (nonatomic, retain) PDFPagingViewController *pagingViewController;
@property (nonatomic, retain) DrawingViewController *drawingViewController;

- (void) loadDocument:(PDFDocument *)document;
- (void) refreshPage;
- (void)setPenMode:(BOOL)enabled;
- (void)setHandMode:(BOOL)enabled;

- (void)setBrush:(TextMarkerBrush)brush;

@end
