//
//  HSPDFSelectionView.h
//  PDFThumbnailView
//
//  Created by Matthias Hühne on 17.11.16.
//  Copyright © 2016 HOsy software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HSPDFSelectionView : NSView
{
    BOOL selected;
    CGPoint selectionOrigin;
    CGSize selectionSize;
}

@property (readwrite) BOOL selected;
@property (readwrite) CGPoint selectionOrigin;
@property (readwrite) CGSize selectionSize;

@end
