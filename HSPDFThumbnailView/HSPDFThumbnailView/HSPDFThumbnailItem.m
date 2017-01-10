//
//  HSPDFThumbnailItem.m
//  PDFThumbnailView
//
//  Created by Matthias Hühne on 17.11.16.
//  Copyright © 2016 HOsy software. All rights reserved.
//

#import "HSPDFThumbnailItem.h"
#import "HSPDFSelectionView.h"
#import "HSPDFSelectionTextFieldCell.h"

@interface HSPDFThumbnailItem ()

@end

@implementation HSPDFThumbnailItem

- (void)setSelected:(BOOL)flag
{
    [super setSelected:flag];
    
    NSRect displayedImageRect = [self imageRectInImageView];
    CGFloat x = displayedImageRect.origin.x + self.thumbnail.frame.origin.x;
    CGFloat y = displayedImageRect.origin.y + self.thumbnail.frame.origin.y;
    
    [(HSPDFSelectionView *)[self view] setSelectionOrigin:CGPointMake(x, y)];
    [(HSPDFSelectionView *)[self view] setSelectionSize:displayedImageRect.size];
    [(HSPDFSelectionView *)[self view] setSelected:flag];
    [(HSPDFSelectionView *)[self view] setNeedsDisplay:YES];
    [self.textFieldCell setSelected:flag];
    [self.label setNeedsDisplay:YES];
}


- (float)imageReduction
{
    NSSize size = [self.thumbnail.image size];
    NSRect iFrame = [self.thumbnail bounds];
    if (NSWidth(iFrame) > size.width && NSHeight(iFrame) > size.height)
    {
        return 1.0;
    }
    else
    {
        double xRatio = NSWidth(iFrame)/size.width;
        double yRatio = NSHeight(iFrame)/size.height;
        return MIN (xRatio, yRatio);
    }
}


- (NSRect)imageRectInImageView
{
    NSSize size = [self.thumbnail.image size];
    NSRect iBounds = [self.thumbnail bounds];
    float reduction = [self imageReduction];
    NSRect imageRect;
    
    imageRect.size.width = floor(size.width * reduction + 0.5);
    imageRect.size.height = floor(size.height * reduction + 0.5);
    imageRect.origin.x = floor((iBounds.size.width - imageRect.size.width)/2.0 + 0.5);
    imageRect.origin.y = floor((iBounds.size.height - imageRect.size.height)/2.0 + 0.5);
    
    return (imageRect);
}


@end
