//
//  DocumentSerializer.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/19/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "DocumentSerializer.h"
#import "PDFDocument.h"
#import "Annotation.h"
#import "PageAnnotation.h"
#import "MarkerPath.h"


@implementation DocumentSerializer

- (void)serialize:(PDFDocument *)document
{
    NSString *xmlDoc = @"<?xml- version=\"1.0\"?>\n%@";
    NSString *documentNode = @"<Document>\n%@\n</Document>";
    NSString *fileNode = [NSString stringWithFormat:@"<File name=\"%@\" hash=\"%@\" />", document.name, document.hash];
    
    NSString *pagesNode = @"";
    
    NSString *pages = @"";
    
    for(PageAnnotation *p in document.annotation._pageAnnotations) {
        NSString *markers = @"";
        
        for(MarkerPath *path in p._paths) {
            NSString *mark = @"";
            NSString *points = @"";
            
            for(MrkPoint *pt in path.points) {
                CGFloat x = pt.x;
                CGFloat y = pt.y;
                NSString *mrkPoint = [NSString stringWithFormat:@"<Point x=\"%f\" y=\"%f\"/>", x, y];
                points = [points stringByAppendingFormat:@"%@\n%@", mrkPoint, @"\n"];
            }
            
            mark = [NSString stringWithFormat:@"<Marker brush=\"%d\">\n%@\n</Marker>", (int)[path getBrush], points];
            markers = [markers stringByAppendingFormat:@"%@\n%@", mark, @"\n"];
        }
        
        markers = [NSString stringWithFormat:@"<Markers>\n%@\n</Markers>", markers];
        
        NSString *page = [NSString stringWithFormat:@"<Page number=\"%d\">\n%@\n</Page>", [p getPageNumber], markers];
        pages = [pages stringByAppendingFormat:@"%@\n", page];
    }
    
    pagesNode = [NSString stringWithFormat:@"<Pages>\n%@\n</Pages>", pages];
    
    NSString *documentBody = [NSString stringWithFormat:@"%@\n%@", fileNode, pagesNode];
    documentNode = [NSString stringWithFormat:@"<Document>\n%@\n</Document>", documentBody];
    
    xmlDoc = [NSString stringWithFormat:xmlDoc, documentNode];
    
    NSLog(@"%@", xmlDoc);
}

@end
