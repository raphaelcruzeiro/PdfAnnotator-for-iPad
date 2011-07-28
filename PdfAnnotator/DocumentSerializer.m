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
#import "NSFileManagerExtension.h"


@implementation DocumentSerializer

- (void)serialize:(PDFDocument *)document
{
    NSString *xmlDoc = @"<?xml- version=\"1.0\"?>\n%@";
    NSString *fileNode = [NSString stringWithFormat:@"<File name=\"%@\" hash=\"%@\" />", document.name, document.hash];
    
    NSString *pagesNode = @"";
    
    NSString *pages = @"";
    
    for(PageAnnotation *p in document.annotation._pageAnnotations) {
        NSString *markers = @"";
        
        for(MarkerPath *path in p._paths) {
            if(path.active) {
                path.loadedFromFile = YES;
                
                NSString *mark = @"";
                NSString *points = @"";
                
                for(MrkPoint *pt in path.points) {
                    NSString *mrkPoint = [NSString stringWithFormat:@"<Point x=\"%f\" y=\"%f\"/>", pt.x, pt.y];
                    points = [points stringByAppendingFormat:@"%@\n%@", mrkPoint, @"\n"];
                }
                
                mark = [NSString stringWithFormat:@"<Marker brush=\"%d\">\n%@\n</Marker>", (int)[path getBrush], points];
                markers = [markers stringByAppendingFormat:@"%@\n%@", mark, @"\n"];
            }
        }
        
        markers = [NSString stringWithFormat:@"<Markers>\n%@\n</Markers>", markers];
        
        NSString *page = [NSString stringWithFormat:@"<Page number=\"%d\">\n%@\n</Page>", [p getPageNumber], markers];
        pages = [pages stringByAppendingFormat:@"%@\n", page];
    }
    
    pagesNode = [NSString stringWithFormat:@"<Pages>\n%@\n</Pages>", pages];
    
    NSString *documentBody = [NSString stringWithFormat:@"%@\n%@", fileNode, pagesNode];
    NSString *documentNode = [NSString stringWithFormat:@"<Document version=\"%@\">\n%@\n</Document>", document.version, documentBody];
    
    xmlDoc = [NSString stringWithFormat:xmlDoc, documentNode];
        
    NSString *filePath = [[[NSFileManager defaultManager] documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mrk", [document.name stringByDeletingPathExtension]]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }

    [xmlDoc writeToFile:filePath atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
}

@end
