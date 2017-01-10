# HSPDFThumbnailView - Simple PDF Thumbnail View for macOS

In macOS 10.12 the system PDF thumbnail view is broken. You cannot select any item and thumbnails will not be displayed.
This is a simple replacement view. It shows thumbnails of a PDF file and you can select pages. You can also set a menu to the view and you will get the page index, on which page the context menu was clicked. Dragging PDF pages is also supported.

## Implementation

1. Add the folder HSPDFThumbnailView to your project
2. Add a NSCollectionView to your storyboard or xib file (Layout: Content Array, Selectable: YES)
3. Change the class of your NSCollectionView to HSPDFCollectionView
4. Add an ArrayController object to your storyboard or xib file, connect it to the HSPDFThumbnailView
5. Check the bindings in the Sample Project and add this bindings to your collection view and array controller.
6. Connect your PDFView to HSPDFThumbnailView
7. Run your project


This project using code from the [ThumbnailPDF](https://github.com/cavalcante13/ThumbnailPDF) project, for creating the thumbnail from  the PDF file.


## License

This library is available under the [ISC license](http://choosealicense.com/licenses/isc/), which is a simplified variant of the two-clause BSD license.

If you use this library, I appreciate if you let me know [@hosymat](https://twitter.com/hosymat) on Twitter.

![alt text](https://raw.githubusercontent.com/hosy/HSPDFThumbnailView/master/HSPDFThumbnailView/Ressources/HSPDFThumbnailView.png "HSPDFThumbnailView Screenshot")