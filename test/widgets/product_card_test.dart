import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amazkart/widgets/product_card.dart';
import 'package:amazkart/models/product.dart';

void main() {
  group('ProductCard Widget Tests', () {
    testWidgets('displays product information correctly', (tester) async {
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 29.99,
        imageUrl: 'https://example.com/image.jpg',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: product),
          ),
        ),
      );

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$29.99'), findsOneWidget);
    });

    testWidgets('triggers add to cart callback', (tester) async {
      bool callbackTriggered = false;
      final product = Product(id: '1', name: 'Test', price: 10.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: product,
              onAddToCart: () => callbackTriggered = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add_shopping_cart));
      expect(callbackTriggered, isTrue);
    });
  });
}

