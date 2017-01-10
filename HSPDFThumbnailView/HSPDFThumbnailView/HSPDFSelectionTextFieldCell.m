//
//  HSPDFSelectionTextFieldCell.m
//  PDFThumbnailView
//
//  Created by Matthias Hühne on 17.11.16.
//  Copyright © 2016 HOsy software. All rights reserved.
//

#import "HSPDFSelectionTextFieldCell.h"

@implementation HSPDFSelectionTextFieldCell

@synthesize selected;


- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        _inFront = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didBecomeMain:)
                                                     name:NSWindowDidBecomeMainNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didResignMain:)
                                                     name:NSWindowDidResignMainNotification
                                                   object:nil];
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSWindowDidBecomeMainNotification
                                                  object:[[self controlView] window]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSWindowDidResignMainNotification
                                                  object:[[self controlView] window]];
}


- (void)didBecomeMain:(NSNotification *)inNotification
{
    _inFront = YES;
    [self.controlView setNeedsDisplay:YES];
}


- (void)didResignMain:(NSNotification *)inNotification
{
    _inFront = NO;
    [self.controlView setNeedsDisplay:YES];
}


- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSColor *textColor = nil;
    NSFont *font = [self font];
    NSString *fontName = [font fontName];
    double fontSize = [font pointSize];
    
    NSInteger textSize = (int) fontSize;
    
    if( self.selected == NO )
    {
        textColor = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:1];
    }
    else
    {
        textColor = [NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:1];
    }
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont fontWithName:fontName size:fontSize], NSFontAttributeName,
                                textColor, NSForegroundColorAttributeName,
                                nil];
    
    
    NSAttributedString *currentText = [[NSAttributedString alloc] initWithString:[self title] attributes: attributes];
    
    NSSize attrSize = [currentText size];
    
    while (attrSize.width > cellFrame.size.width && --textSize > 0) {
        
        
        attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                      [NSFont fontWithName:fontName size:textSize], NSFontAttributeName,
                      textColor, NSForegroundColorAttributeName,
                      nil];
        
        currentText=[[NSAttributedString alloc] initWithString:[self title] attributes: attributes];
        
        attrSize = [currentText size];
        
    }
    
    switch ([self alignment]) {
        default:
        case NSTextAlignmentLeft:
            [currentText drawAtPoint:NSMakePoint( cellFrame.origin.x,
                                                 cellFrame.origin.y + (cellFrame.size.height/2) - (attrSize.height/2))];
            break;
            
        case NSTextAlignmentRight:
            [currentText drawAtPoint:NSMakePoint( cellFrame.origin.x + (cellFrame.size.width) - (attrSize.width),
                                                 cellFrame.origin.y + (cellFrame.size.height/2) - (attrSize.height/2))];
            break;
            
        case NSTextAlignmentCenter:
        {
            if (self.selected == YES)
            {
                NSColor *color = [NSColor selectedMenuItemColor];
                if (_inFront == NO)
                {
                    color = [NSColor lightGrayColor];
                }
                
                //// Rectangle Drawing
                NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(cellFrame.origin.x + (cellFrame.size.width /2) - (attrSize.width/2) - 3, cellFrame.origin.y + (cellFrame.size.height/2) - (attrSize.height/2) + 2, attrSize.width + 6.0, cellFrame.size.height - 2) xRadius: 3 yRadius: 3];
                [color setFill];
                [rectanglePath fill];
            }
            
            [currentText drawAtPoint:NSMakePoint( cellFrame.origin.x + (cellFrame.size.width /2) - (attrSize.width/2),
                                                 cellFrame.origin.y + (cellFrame.size.height/2) - (attrSize.height/2))];
            
            break;
        }
    }
    
}

@end
