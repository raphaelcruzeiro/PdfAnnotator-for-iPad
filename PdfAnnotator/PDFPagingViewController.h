//
//  PDFPagingViewController.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/10/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDFDocument;
@class PDFThumbnailFactory;

@interface PDFPagingViewController : UIViewController {
    BOOL expanded;
    CGRect expandedFrame;
    CGRect collapsedFrame;
}

@property (nonatomic, retain) PDFDocument *_document;

@property (nonatomic, retain) PDFThumbnailFactory *thumbFactory;

@property (nonatomic, retain) UIButton *collapseButton;

- (id)initWithDocument:(PDFDocument*)document;
- (void)expand;
- (void)collapse;
- (void) toggle;

- (void)pageItemClicked:(id)sender;

@end
