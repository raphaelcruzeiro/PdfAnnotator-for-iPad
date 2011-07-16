//
//  PageAnnotation.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/16/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageAnnotation : NSObject {
    NSInteger _pageNumber;
}

@property (nonatomic, retain) NSMutableArray *_paths;

- (id)initWithPageNumber:(NSInteger)pageNumber;

-(NSInteger)getPageNumber;

@end
