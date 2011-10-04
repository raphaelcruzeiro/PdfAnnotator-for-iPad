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

@class PDFDocument;
@class PDFThumbnailFactory;
@protocol PDFPagingViewProtocol;

@interface PDFPagingViewController : UIViewController <UIScrollViewDelegate> {
    BOOL expanded;
    CGRect expandedFrame;
    CGRect collapsedFrame;
    CGFloat currentX;
}

@property (nonatomic, retain) id<PDFPagingViewProtocol> delegate;

@property (nonatomic, retain) PDFDocument *_document;

@property (nonatomic, retain) PDFThumbnailFactory *thumbFactory;

@property (nonatomic, retain) UIButton *collapseButton;

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray * buttons;

@property (nonatomic, retain) UIImage *pagePlaceholder;
@property (nonatomic, retain) UIImage *loading;

- (id)initWithDocument:(PDFDocument*)document AndObserver:(id<PDFPagingViewProtocol>)observer;
- (void)expand;
- (void)collapse;
- (void)toggle;
- (void)loadThumbs;
- (void)setLabel:(CGFloat)x forIndex:(NSInteger)i AndButtonWidth:(CGFloat)width;

- (void)pageItemClicked:(id)sender;

@end

@protocol PDFPagingViewProtocol <NSObject>

- (void)pageSelected:(NSInteger)page;

@end
