//
//  Annotation.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/16/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MarkerPath;
@class PageAnnotation;

@interface Annotation : NSObject {
   
}

@property (nonatomic, retain) NSMutableArray *_pageAnnotations;

- (PageAnnotation*)annotationForPage:(NSInteger)page;

@end
