//
//  HSPDFThumbnailItem.h
//  PDFThumbnailView
//
//  Created by Matthias Hühne on 17.11.16.
//  Copyright © 2016 HOsy software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HSPDFSelectionTextFieldCell;

@interface HSPDFThumbnailItem : NSCollectionViewItem

@property (assign) IBOutlet NSImageView *thumbnail;
@property (assign) IBOutlet NSTextField *label;
@property (assign) IBOutlet HSPDFSelectionTextFieldCell *textFieldCell;

- (NSRect)imageRectInImageView;

@end
