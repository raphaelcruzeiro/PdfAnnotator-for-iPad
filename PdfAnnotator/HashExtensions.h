//
//  MyClass.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/18/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MyExtensions)
- (NSString *) md5;
@end

@interface NSData (MyExtensions)
- (NSString*)md5;
@end