import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);
  bool get isLoading => _isLoading;

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');
    if (cartJson != null) {
      final List<dynamic> decoded = json.decode(cartJson);
      _items = decoded.map((item) => CartItem.fromJson(item)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addItem(Product product, int quantity) async {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      _items.add(CartItem.fromProduct(product, quantity));
    }

    await _persistCart();
    notifyListeners();
  }

  Future<void> _persistCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = json.encode(_items.map((item) => item.toJson()).toList());
    await prefs.setString('cart', cartJson);
  }

  // ...existing code...
}

