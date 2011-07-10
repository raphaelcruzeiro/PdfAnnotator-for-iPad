//
//  PDFPagingViewController.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/10/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFPagingViewController : UIViewController {
    BOOL expanded;
    CGRect expandedFrame;
    CGRect collapsedFrame;
}

@property (nonatomic, retain) UIButton *collapseButton;

- (id)init;
- (void)expand;
- (void)collapse;
- (void) toggle;

@end
