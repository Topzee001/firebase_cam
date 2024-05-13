import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageViewer extends StatelessWidget {
  final List<String> imageUrls;

  const FullScreenImageViewer({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Image Viewer'),
      ),
      body: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return PhotoView(
            imageProvider: NetworkImage(imageUrls[index]),
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(),
            ),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered,
          );
        },
      ),
    );
  }
}
