//
//  DBSerializer.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/17/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "DBSerializer.h"
#import "Database.h"
#import "PDFDocument.h"


@implementation DBSerializer

@synthesize database;

- (id)init
{
    if((self = [super init])) {
        self.database = [[Database alloc] init];
        [self createSchema];
    }
    
    return self;
}

- (void)createSchema
{
    documentFields = [[NSArray alloc] initWithObjects:@"ID", @"Name", @"Hash", nil];
    pageFields = [[NSArray alloc] initWithObjects:@"ID", @"Number", @"Document_ID", nil];
    markFields = [[NSArray alloc] initWithObjects:@"ID", @"Brush", @"Page_ID", nil];
    pointFields = [[NSArray alloc] initWithObjects:@"ID", @"X", @"Y", @"Mark_ID", nil];
    
    [database createTable:@"Document" WithFields:documentFields];
    [database createTable:@"Page" WithFields:pageFields];
    [database createTable:@"Mark" WithFields:markFields];
    [database createTable:@"Point" WithFields:pointFields];
}

- (void)insertPDFDocument:(PDFDocument *)document
{
    [database insertInto:@"Document" Fields:documentFields Values:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", ([database getLastIdFromTable:@"Document"] + 1)], document.name, @"", nil]];
}

- (void)dealloc
{
    [super dealloc];
    [self.database release];
}

@end
