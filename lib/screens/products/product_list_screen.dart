import 'package:cached_network_image/cached_network_image.dart';

class ProductListScreen extends StatefulWidget {
  // ...existing code...
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoadingMore) {
      _loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: provider.products.length + (_isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == provider.products.length) {
              return const Center(child: CircularProgressIndicator());
            }
            return ProductCard(
              key: ValueKey(provider.products[index].id),
              product: provider.products[index],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

