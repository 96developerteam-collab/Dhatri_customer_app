import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  // ...existing code...

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: product.imageUrl,
            placeholder: (context, url) => const ShimmerPlaceholder(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            memCacheWidth: 400,
            maxHeightDiskCache: 600,
          ),
          // ...existing code...
        ],
      ),
    );
  }
}

