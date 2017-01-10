//
//  ViewController.m
//  PDFThumbnailView
//
//  Created by Matthias Hühne on 21.11.16.
//  Copyright © 2016 HOsy software. All rights reserved.
//

#import "ViewController.h"
#import "HSPDFThumbnailItem.h"
#import "ThumbnailPDF.h"
#import "HSPDFCollectionView.h"
#import <Quartz/Quartz.h>




@interface ViewController ()

@property (weak) IBOutlet HSPDFCollectionView *collectionView;
@property (weak) IBOutlet  PDFView *pdfView;

@end

@implementation ViewController


- (void)awakeFromNib
{
    [self openSamplePDF];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}


#pragma mark Load PDF File


- (void)openSamplePDF
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Example" ofType:@"pdf"];
    PDFDocument *pdfDocument = [[PDFDocument alloc] initWithData:[NSData dataWithContentsOfFile:path]];
    
    self.pdfView.document = pdfDocument;
}


- (IBAction)openPDFFile:(id)inSender
{
    NSOpenPanel *panel;
    NSArray* fileTypes = [[NSArray alloc] initWithObjects:@"pdf", @"PDF", nil];
    panel = [NSOpenPanel openPanel];
    [panel setFloatingPanel:YES];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:fileTypes];
    NSInteger i = [panel runModal];
    if( i == NSOKButton )
    {
        NSString *path = [[[panel URLs] firstObject] path];
        PDFDocument *pdfDocument = [[PDFDocument alloc] initWithData:[NSData dataWithContentsOfFile:path]];
        
        self.pdfView.document = pdfDocument;
    }
}


#pragma mark Context Menu Action


- (IBAction)firstMenuItemAction:(id)sender
{
    NSLog(@"---> %ld", self.collectionView.rightClickedItemIndex);
}


@end
