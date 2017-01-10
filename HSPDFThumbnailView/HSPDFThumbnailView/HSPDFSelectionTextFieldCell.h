//
//  HSPDFSelectionTextFieldCell.h
//  PDFThumbnailView
//
//  Created by Matthias Hühne on 17.11.16.
//  Copyright © 2016 HOsy software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HSPDFSelectionTextFieldCell : NSTextFieldCell
{
    BOOL selected;
    BOOL _inFront;
}

@property (nonatomic, readwrite) BOOL selected;

@end
