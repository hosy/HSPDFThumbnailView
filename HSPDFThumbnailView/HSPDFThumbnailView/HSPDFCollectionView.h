//
//  HSPDFCollectionView.h
//  PDFThumbnailView
//
//  Created by Matthias Hühne on 21.11.16.
//  Copyright © 2016 HOsy software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PDFView, PDFDocument;

@interface HSPDFCollectionView : NSCollectionView <NSCollectionViewDelegate>
{
    PDFView *pdfView;
}

@property(nonatomic, assign) id dragDelegate;
@property(nonatomic, assign) NSUInteger rightClickedItemIndex;
@property(nonatomic, assign) BOOL draggingEnabled;
@property(nonatomic, assign) IBOutlet PDFView *pdfView;
@property(nonatomic, assign) IBOutlet NSArrayController *arrayController;

- (PDFDocument *)movePagesAtIndexes:(NSIndexSet *)inIndexes toIndex:(NSUInteger)inIndex inPDFDocument:(PDFDocument *)inDocument;

@end


@protocol HSPDFCollectionViewDelegate <NSObject>

- (void)draggingMovedPDFDocumentPagesAtIndexes:(NSIndexSet *)indexSet toIndex:(NSUInteger)index;
- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event;
- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation;

@end
