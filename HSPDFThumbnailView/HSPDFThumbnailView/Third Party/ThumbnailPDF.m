//
//  ThumbnailPDF.m
//  ThumbnailPDF
//
//  Created by Diego Costa on 22/04/15.
//  Copyright (c) 2015 DiegoCosta. All rights reserved.
//

#import "ThumbnailPDF.h"

@implementation ThumbnailPDF

-(id)init {
    if (self = [super init]) {
        _data = [[NSData alloc] init];
        _imageSize = 0;
        _indexPage = 0;
    }
    return self;
}
-(CGImageRef)thumbnailFromData:(NSData *)data andSize:(int)size andPageIndex:(int)indexPage {
    _indexPage = indexPage;
    
    return [self thumbnailFromData:data andSize:size];
}
-(void)startWithCompletionHandler:(NSData *)data andSize:(int)size completion:(completionHandler)completionHandler {
  
    dispatch_queue_t block = dispatch_queue_create("com.br.ThumbnailPDF", NULL);
    dispatch_async(block, ^{
        
        [self thumbnailFromData:data andSize:size];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(self , YES);

        });
    });

}
-(CGImageRef)thumbnailFromData:(NSData *)data andSize:(int)size {
   
    _myThumbnailImage = NULL;
    CGImageSourceRef myImageSource;
    CFStringRef   myKeys[3];
    CFDictionaryRef myOptions = NULL;
    CFTypeRef     myValues[3];
    
    CFNumberRef   thumbnailSize;
    
    self.data       = data;
    self.imageSize  = size;
    
    myImageSource = CGImageSourceCreateWithData((__bridge CFDataRef)self.data, NULL);
    
    if (myImageSource == NULL) {
        fprintf(stderr, "Image Source is NULL");
    }
    
    thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &size);
    
    myKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
    myValues[0] = (CFTypeRef)kCFBooleanTrue;
    myKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    myValues[1] = (CFTypeRef)kCFBooleanTrue;
    myKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
    myValues[2] = (CFTypeRef)thumbnailSize;
    
    myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
                                   (const void **) myValues, 2,
                                   &kCFTypeDictionaryKeyCallBacks,
                                   & kCFTypeDictionaryValueCallBacks);
    // Create the thumbnail image using the specified options.
    
    size_t totalPages = CGImageSourceGetCount(myImageSource);
    if (_indexPage < 0 || _indexPage > totalPages) {
        fprintf(stderr, "Thumbnail not created because indexPage it's not valid.\n");
    }
    
    _myThumbnailImage = CGImageSourceCreateThumbnailAtIndex(myImageSource,
                                                           _indexPage,
                                                           myOptions);
    // Release the options dictionary and the image source
    // when you no longer need them.
    CFRelease(thumbnailSize);
    CFRelease(myOptions);
    CFRelease(myImageSource);
    // Make sure the thumbnail image exists before continuing.
    if (!_myThumbnailImage) {
        fprintf(stderr, "Thumbnail image not created from image source.");
    }
    
    return _myThumbnailImage;
}

@end
