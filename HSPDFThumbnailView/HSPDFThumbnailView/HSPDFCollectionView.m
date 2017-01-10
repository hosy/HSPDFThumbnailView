//
//  HSPDFCollectionView.m
//  PDFThumbnailView
//
//  Created by Matthias Hühne on 21.11.16.
//  Copyright © 2016 HOsy software. All rights reserved.
//

#import "HSPDFCollectionView.h"
#import "HSPDFThumbnailItem.h"
#import <Quartz/Quartz.h>

#define kUTIDDCustomType @"de.hosy.ThumbnailView.DragDropType"

@interface HSPDFCollectionView ()
{
    NSMutableArray *_items;
}

@property (nonatomic, strong) NSMutableArray *items;

- (void)moveItemsAtIndexes:(NSIndexSet *)inIndexes toIndex:(NSUInteger)inIndex;

@end


@implementation HSPDFCollectionView

@synthesize rightClickedItemIndex;
@synthesize pdfView = _pdfView;
@synthesize items = _items;
@synthesize arrayController = _arrayController;


- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        rightClickedItemIndex = NSNotFound;
        self.draggingEnabled = YES;
        _items = [[NSMutableArray alloc] init];
        
        NSArray *supportedTypes = [NSArray arrayWithObjects:kUTIDDCustomType, nil];
        [self registerForDraggedTypes:supportedTypes];
        [self setDraggingSourceOperationMask:NSDragOperationMove forLocal:YES];
        
        HSPDFThumbnailItem *collectionViewItem = [[HSPDFThumbnailItem alloc] initWithNibName:@"HSPDFThumbnailItem" bundle:nil];;
        self.itemPrototype = collectionViewItem;
        
        self.delegate = self;
    }
    return self;
}


- (void)setPdfView:(PDFView *)inPdfView
{
    _pdfView = inPdfView;
    
    [self.pdfView addObserver:self forKeyPath:@"document"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(presentPageChanged:)
                                                 name:PDFViewPageChangedNotification
                                               object:self.pdfView];
}


- (void)setArrayController:(NSArrayController *)inArrayController
{
    _arrayController = inArrayController;
    
    [self.arrayController addObserver:self forKeyPath:@"selectedObjects"
                              options:NSKeyValueObservingOptionNew
                              context:nil];
}


#pragma mark Thumbnail selection changed - Show PDF page


- (void)presentPageChanged:(NSNotification *)inNotification
{
    PDFPage *aPage = self.pdfView.currentPage;
    NSUInteger selectPage = [self.pdfView.document indexForPage:aPage];
    
    [self setSelectionIndexes:[NSIndexSet indexSetWithIndex:selectPage]];
    
    NSRect selectionRect = [self frameForItemAtIndex:[[self selectionIndexes] firstIndex]];
    [self scrollRectToVisible:selectionRect];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedObjects"])
    {
        [self.pdfView goToPage:[self.pdfView.document pageAtIndex:self.arrayController.selectionIndex]];
    }
    else if ([keyPath isEqualToString:@"document"])
    {
        [self willChangeValueForKey:@"items"];
        
        [self.items removeAllObjects];
        
        for (int i=0; i < self.pdfView.document.pageCount; i++)
        {
            NSMutableDictionary *newDict = [NSMutableDictionary new];
            [newDict setObject:[NSString stringWithFormat:@"%d", (i + 1)] forKey:@"label"];
            [newDict setObject:[self.pdfView.document pageAtIndex:i] forKey:@"page"];
            
            [self.items addObject:newDict];
        }
        [self didChangeValueForKey:@"items"];
    }
}


#pragma mark Drag/Drop


- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event
{
    if (self.dragDelegate != nil && [self.dragDelegate respondsToSelector:@selector(collectionView:canDragItemsAtIndexes:withEvent:)])
    {
        return [self.dragDelegate collectionView:collectionView canDragItemsAtIndexes:indexes withEvent:event];
    }
    
    if (self.items.count > 1 && self.draggingEnabled == YES)
    {
        return YES;
    }
    
    return NO;
}


- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation
{
    if (self.dragDelegate != nil && [self.dragDelegate respondsToSelector:@selector(collectionView:validateDrop:proposedIndex:dropOperation:)])
    {
        return [self.dragDelegate collectionView:collectionView validateDrop:draggingInfo proposedIndex:proposedDropIndex dropOperation:proposedDropOperation];
    }
    
    return NSDragOperationMove;
}


- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard
{
    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:indexes];
    [pasteboard declareTypes:@[kUTIDDCustomType] owner:self];
    [pasteboard setData:indexData forType:kUTIDDCustomType];
    
    return YES;
}


- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation
{
    NSPasteboard *pBoard = [draggingInfo draggingPasteboard];
    NSData *indexData = [pBoard dataForType:kUTIDDCustomType];
    NSIndexSet *indexes = [NSKeyedUnarchiver unarchiveObjectWithData:indexData];
    
    [self moveItemsAtIndexes:indexes toIndex:index];
    [self movePagesAtIndexes:indexes toIndex:index inPDFDocument:self.pdfView.document];
    
    if (self.dragDelegate != nil && [self.dragDelegate respondsToSelector:@selector(draggingMovedPDFDocumentPagesAtIndexes:toIndex:)])
    {
        [self.dragDelegate draggingMovedPDFDocumentPagesAtIndexes:indexes toIndex:index];
    }
    
    return YES;
}


#pragma mark Reorder Dragged Files in PDF Document


- (void)moveItemsAtIndexes:(NSIndexSet *)inIndexes toIndex:(NSUInteger)inIndex
{
    __block NSInteger draggedCellStart = 0;
    __block NSInteger draggedCellEnd = self.items.count;
    NSInteger newIndex = inIndex;
    
    NSMutableArray *tmpObjects = [NSMutableArray new];
    __block BOOL initStartCell = NO;
    [inIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        if (initStartCell == NO)
        {
            initStartCell = YES;
            draggedCellStart = idx;
        }
        draggedCellEnd = idx;
        
        // Thumbnail Data
        NSDictionary *aObject = [self.items objectAtIndex:idx];
        [tmpObjects addObject:aObject];
        
    }];
    
    
    [self willChangeValueForKey:@"items"];
    
    [self.items removeObjectsAtIndexes:inIndexes];
    
    if (newIndex > draggedCellStart)
    {
        newIndex -= tmpObjects.count - 1;
    }
    
    NSIndexSet *newIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(newIndex, [tmpObjects count])];
    [self.items insertObjects:tmpObjects atIndexes:newIndexes];
    
    if (inIndex < draggedCellStart)
    {
        for (NSInteger i = inIndex; i<=draggedCellEnd; i++)
        {
            [[self.items objectAtIndex:i] setObject:[NSString stringWithFormat:@"%ld", (i + 1)] forKey:@"label"];
        }
    }
    else
    {
        for (NSInteger i = draggedCellStart; i<=inIndex; i++)
        {
            [[self.items objectAtIndex:i] setObject:[NSString stringWithFormat:@"%ld", (i + 1)] forKey:@"label"];
        }
    }
    
    [self didChangeValueForKey:@"items"];
}


- (PDFDocument *)movePagesAtIndexes:(NSIndexSet *)inIndexes toIndex:(NSUInteger)inIndex inPDFDocument:(PDFDocument *)inDocument
{
    __block NSInteger draggedCellStart = 0;
    __block NSInteger draggedCellEnd = self.items.count;
    
    NSMutableArray *tmpPageObjects = [NSMutableArray new];
    __block BOOL initStartCell = NO;
    
    
    if (inDocument != self.pdfView.document) // Only needed for external documents, without a pdf view
    {
        // Workaround for Apple Bug, if a PDFDocument has no PDFView, loop every page
        // Without the loop, removePageAtIndex deletes only the last page of the document, instead the index page
        for (NSInteger i=0; i< inDocument.pageCount;i++)
        {
            PDFPage *aPage = [inDocument pageAtIndex:i];
#pragma unused(aPage)
        }
    }
    
    [inIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        if (initStartCell == NO)
        {
            initStartCell = YES;
            draggedCellStart = idx;
        }
        draggedCellEnd = idx;
        
        // PDF Document Page
        PDFPage *aPage = [inDocument pageAtIndex:idx];
        [tmpPageObjects addObject:aPage];
        
    }];
    
    NSUInteger cnt = 0;
    NSInteger newInsertIndex = inIndex;
    
    for (PDFPage *aPage in tmpPageObjects)
    {
        NSUInteger pageIndex = [inDocument indexForPage:aPage];
        [inDocument removePageAtIndex:pageIndex];
        
        if (newInsertIndex >= draggedCellStart)
        {
            [inDocument insertPage:aPage atIndex:(newInsertIndex)];
        }
        else
        {
            [inDocument insertPage:aPage atIndex:(newInsertIndex + cnt)];
        }
        
        cnt++;
    }
    
    return inDocument;
}


#pragma mark Context Menu Handling - Setting clicked Index


- (NSMenu *)menuForEvent:(NSEvent*)event
{
    self.rightClickedItemIndex = NSNotFound;
    NSPoint point = [self convertPoint:event.locationInWindow fromView:nil];
    NSUInteger count = self.items.count;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        NSRect itemFrame = [self frameForItemAtIndex:i];
        if (NSMouseInRect(point, itemFrame, self.isFlipped))
        {
            self.rightClickedItemIndex = i;
            break;
        }
    }
    
    if (self.rightClickedItemIndex != NSNotFound)
    {
        return [super menuForEvent:event];
    }
    
    return nil;
}


@end
