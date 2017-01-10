//
//  ThumbnailPDF.h
//  ThumbnailPDF
//
//  Created by Diego Costa on 22/04/15.
//  Copyright (c) 2015 DiegoCosta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>

@class ThumbnailPDF;

typedef void (^completionHandler)(ThumbnailPDF * ThumbnailPDF, BOOL finished);

@interface ThumbnailPDF : NSObject

@property (nonatomic, strong) NSURL         *baseURL;
@property (nonatomic, strong) NSData        *data;
@property (nonatomic, assign) CGImageRef    myThumbnailImage;

@property (nonatomic, assign) int     imageSize;
@property (nonatomic, assign) int     indexPage;


-(CGImageRef)thumbnailFromData:(NSData *)data andSize:(int)size;
-(CGImageRef)thumbnailFromData:(NSData *)data andSize:(int)size andPageIndex:(int)indexPage;

-(void)startWithCompletionHandler:(NSData *)data andSize:(int)size completion:(completionHandler)completionHandler;

@end
