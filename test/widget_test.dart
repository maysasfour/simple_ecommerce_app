// Widget smoke tests for ShopSmart EN
// These tests verify top-level app structure without requiring Firebase.

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ecommerce_app/consts/validator.dart';
import 'package:simple_ecommerce_app/models/product_model.dart';
import 'package:simple_ecommerce_app/providers/cart_provider.dart';
import 'package:simple_ecommerce_app/providers/products_provider.dart';

/// Smoke test: validates that all key classes are importable and instantiable.
void main() {
  group('App smoke tests', () {
    test('CartProvider can be instantiated', () {
      final cart = CartProvider();
      expect(cart, isNotNull);
      expect(cart.getCartitems.isEmpty, isTrue);
    });

    test('ProductsProvider can be instantiated', () {
      final provider = ProductsProvider();
      expect(provider, isNotNull);
      expect(provider.getProducts.isEmpty, isTrue);
    });

    test('ProductModel can be created manually', () {
      final p = ProductModel(
        productId: 'test-001',
        productTitle: 'Test Product',
        productPrice: '29.99',
        productCategory: 'Electronics',
        productDescription: 'A test product',
        productImage: 'https://example.com/image.jpg',
        productQuantity: '100',
      );
      expect(p.productId, 'test-001');
      expect(p.productPrice, '29.99');
    });

    test('email validator accepts valid email', () {
      expect(MyValidators.emailValidator('admin@shopsmart.com'), isNull);
    });

    test('password validator rejects weak password', () {
      expect(MyValidators.passwordValidator('123'), isNotNull);
    });

    test('price validator accepts valid price', () {
      expect(MyValidators.priceValidator('49.99'), isNull);
    });

    test('quantity validator accepts zero', () {
      expect(MyValidators.quantityValidator('0'), isNull);
    });
  });
}
