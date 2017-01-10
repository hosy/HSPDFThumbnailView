//
//  HSPDFSelectionView.m
//  PDFThumbnailView
//
//  Created by Matthias Hühne on 17.11.16.
//  Copyright © 2016 HOsy software. All rights reserved.
//

#import "HSPDFSelectionView.h"

@implementation HSPDFSelectionView

@synthesize selected, selectionOrigin, selectionSize;

- (void)drawRect:(NSRect)dirtyRect
{
    if (selected)
    {
        NSColor* color = [NSColor colorWithCalibratedRed: 0.5 green: 0.5 blue: 0.5 alpha: 0.3];
        
        //// Rectangle Drawing
        NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(self.selectionOrigin.x - 9.0, self.selectionOrigin.y - 9, self.selectionSize.width + 18.0, self.selectionSize.height + 18) xRadius: 10 yRadius: 10];
        [color setFill];
        [rectanglePath fill];
    }
}

@end
