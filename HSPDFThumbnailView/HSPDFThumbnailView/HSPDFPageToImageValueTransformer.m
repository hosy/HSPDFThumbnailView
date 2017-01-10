//
//  PDFPageToImageValueTransformer.m
//  PDFThumbnailView
//
//  Created by Matthias Hühne on 29.11.16.
//  Copyright © 2016 HOsy software. All rights reserved.
//

#import "HSPDFPageToImageValueTransformer.h"
#import "ThumbnailPDF.h"
#import <Quartz/Quartz.h>

@implementation HSPDFPageToImageValueTransformer

+ (Class)transformedValueClass
{
    return [NSImage class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    
    if (value == nil) return nil;
    
    ThumbnailPDF *thumbPDF = [[ThumbnailPDF alloc] init];
    
    CGImageRef imageRef = [thumbPDF thumbnailFromData:[(PDFPage *)value dataRepresentation] andSize:160];
    
    NSImage *image = [[NSImage alloc] initWithCGImage:imageRef size:CGSizeMake(CGImageGetWidth(imageRef),
                                                                               CGImageGetHeight(imageRef))];
    
    return image;
}



@end
