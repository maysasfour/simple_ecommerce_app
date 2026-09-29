import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ecommerce_app/models/cart_model.dart';
import 'package:simple_ecommerce_app/models/product_model.dart';
import 'package:simple_ecommerce_app/providers/cart_provider.dart';
import 'package:simple_ecommerce_app/providers/products_provider.dart';

// Helper: build a ProductModel without Firestore
ProductModel _makeProduct({
  required String id,
  required String price,
}) {
  return ProductModel(
    productId: id,
    productTitle: 'Test $id',
    productPrice: price,
    productCategory: 'Test',
    productDescription: 'desc',
    productImage: 'https://example.com/img.jpg',
    productQuantity: '10',
  );
}

void main() {
  late CartProvider cart;
  late ProductsProvider productsProvider;

  setUp(() {
    cart = CartProvider();
    productsProvider = ProductsProvider();
    productsProvider.products = [
      _makeProduct(id: 'p1', price: '10.00'),
      _makeProduct(id: 'p2', price: '25.50'),
      _makeProduct(id: 'p3', price: '5.99'),
    ];
  });

  group('CartProvider — local logic', () {
    // ── isProdinCart ─────────────────────────────────────────────────────
    group('isProdinCart', () {
      test('returns false when cart is empty', () {
        expect(cart.isProdinCart(productId: 'p1'), isFalse);
      });

      test('returns true after adding product', () {
        cart.addProductToCart(productId: 'p1');
        expect(cart.isProdinCart(productId: 'p1'), isTrue);
      });

      test('returns false for product that was not added', () {
        cart.addProductToCart(productId: 'p1');
        expect(cart.isProdinCart(productId: 'p2'), isFalse);
      });
    });

    // ── addProductToCart ─────────────────────────────────────────────────
    group('addProductToCart', () {
      test('adds a new product with quantity 1', () {
        cart.addProductToCart(productId: 'p1');
        expect(cart.getCartitems.length, 1);
        expect(cart.getCartitems['p1']!.quantity, 1);
      });

      test('does not duplicate if product already in cart', () {
        cart.addProductToCart(productId: 'p1');
        cart.addProductToCart(productId: 'p1');
        expect(cart.getCartitems.length, 1);
      });

      test('can add multiple distinct products', () {
        cart.addProductToCart(productId: 'p1');
        cart.addProductToCart(productId: 'p2');
        expect(cart.getCartitems.length, 2);
      });
    });

    // ── updateQty ────────────────────────────────────────────────────────
    group('updateQty', () {
      test('updates quantity of existing item', () {
        cart.addProductToCart(productId: 'p1');
        cart.updateQty(productId: 'p1', qty: 5);
        expect(cart.getCartitems['p1']!.quantity, 5);
      });
    });

    // ── removeOneItem ────────────────────────────────────────────────────
    group('removeOneItem', () {
      test('removes item from cart', () {
        cart.addProductToCart(productId: 'p1');
        expect(cart.getCartitems.length, 1);
        cart.removeOneItem(productId: 'p1');
        expect(cart.getCartitems.length, 0);
      });

      test('removing non-existent item does not throw', () {
        expect(() => cart.removeOneItem(productId: 'unknown'), returnsNormally);
      });
    });

    // ── clearLocalCart ───────────────────────────────────────────────────
    group('clearLocalCart', () {
      test('empties the cart', () {
        cart.addProductToCart(productId: 'p1');
        cart.addProductToCart(productId: 'p2');
        cart.clearLocalCart();
        expect(cart.getCartitems.isEmpty, isTrue);
      });
    });

    // ── getTotal ─────────────────────────────────────────────────────────
    group('getTotal', () {
      test('returns 0 for empty cart', () {
        expect(cart.getTotal(productsProvider: productsProvider), 0.0);
      });

      test('calculates total for single item qty=1', () {
        cart.addProductToCart(productId: 'p1'); // $10.00 × 1
        final total = cart.getTotal(productsProvider: productsProvider);
        expect(total, closeTo(10.00, 0.001));
      });

      test('calculates total for multiple items', () {
        cart.addProductToCart(productId: 'p1'); // $10.00
        cart.addProductToCart(productId: 'p2'); // $25.50
        final total = cart.getTotal(productsProvider: productsProvider);
        expect(total, closeTo(35.50, 0.001));
      });

      test('respects updated quantity', () {
        cart.addProductToCart(productId: 'p1'); // $10.00 × 3 = $30
        cart.updateQty(productId: 'p1', qty: 3);
        final total = cart.getTotal(productsProvider: productsProvider);
        expect(total, closeTo(30.00, 0.001));
      });

      test('ignores unknown product IDs gracefully', () {
        // Manually inject unknown product
        final items = cart.getCartitems;
        items['unknown'] = CartModel(
          cartId: 'c', productId: 'unknown', quantity: 2);
        final total = cart.getTotal(productsProvider: productsProvider);
        expect(total, 0.0);
      });
    });

    // ── getQty ───────────────────────────────────────────────────────────
    group('getQty', () {
      test('returns 0 for empty cart', () {
        expect(cart.getQty(), 0);
      });

      test('returns total quantity of all items', () {
        cart.addProductToCart(productId: 'p1');
        cart.addProductToCart(productId: 'p2');
        cart.updateQty(productId: 'p2', qty: 3);
        expect(cart.getQty(), 4); // 1 + 3
      });
    });
  });
}
