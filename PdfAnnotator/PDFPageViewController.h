//
//  PDFPageViewController.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/2/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFPagingViewController.h"

@class PDFDocument;
@class PDFPagingViewController;

@interface PDFPageViewController : UIViewController <UIScrollViewDelegate, PDFPagingViewProtocol>
{
    UIView *contentView;
}

@property (nonatomic, retain) PDFDocument *_document;

@property (nonatomic, retain) PDFPagingViewController *pagingViewController;

- (void) loadDocument:(PDFDocument *)document;
- (void) refreshPage;

@end
