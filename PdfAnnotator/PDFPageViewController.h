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
- (void)setEraserMode:(BOOL)enabled;

- (void)setBrush:(TextMarkerBrush)brush;

- (void)undo;
- (void)redo;

@end

@protocol PDFPageViewControllerDelegate <NSObject>

- (void)switchToHandMode;
- (void)changed;
- (void)canUndo:(BOOL)value;
- (void)canRedo:(BOOL)value;

@end
