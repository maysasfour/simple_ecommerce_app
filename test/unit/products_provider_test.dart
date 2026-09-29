import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ecommerce_app/models/product_model.dart';
import 'package:simple_ecommerce_app/providers/products_provider.dart';

ProductModel _makeProduct({
  required String id,
  required String title,
  required String category,
}) {
  return ProductModel(
    productId: id,
    productTitle: title,
    productPrice: '9.99',
    productCategory: category,
    productDescription: 'A great product',
    productImage: 'https://example.com/img.jpg',
    productQuantity: '50',
  );
}

void main() {
  late ProductsProvider provider;

  setUp(() {
    provider = ProductsProvider();
    provider.products = [
      _makeProduct(id: '1', title: 'iPhone 15 Pro', category: 'Phones'),
      _makeProduct(id: '2', title: 'Samsung Galaxy S24', category: 'Phones'),
      _makeProduct(id: '3', title: 'MacBook Pro', category: 'Laptops'),
      _makeProduct(id: '4', title: 'Nike Air Force 1', category: 'Shoes'),
      _makeProduct(id: '5', title: 'Adidas Ultraboost', category: 'Shoes'),
    ];
  });

  group('ProductsProvider', () {
    // ── findByProdId ──────────────────────────────────────────────────────
    group('findByProdId', () {
      test('returns product for existing ID', () {
        final p = provider.findByProdId('1');
        expect(p, isNotNull);
        expect(p!.productTitle, 'iPhone 15 Pro');
      });

      test('returns null for non-existent ID', () {
        expect(provider.findByProdId('999'), isNull);
      });

      test('returns correct product among multiple', () {
        final p = provider.findByProdId('4');
        expect(p!.productCategory, 'Shoes');
      });
    });

    // ── findByCategory ────────────────────────────────────────────────────
    group('findByCategory', () {
      test('returns all products in category', () {
        final phones = provider.findByCategory(categoryName: 'Phones');
        expect(phones.length, 2);
      });

      test('returns empty list for non-existent category', () {
        final watches = provider.findByCategory(categoryName: 'Watches');
        expect(watches.isEmpty, isTrue);
      });

      test('is case-insensitive', () {
        final laptops = provider.findByCategory(categoryName: 'laptops');
        expect(laptops.length, 1);
        expect(laptops.first.productTitle, 'MacBook Pro');
      });

      test('returns single result for unique category', () {
        final laptops = provider.findByCategory(categoryName: 'Laptops');
        expect(laptops.length, 1);
      });

      test('returns multiple shoes', () {
        final shoes = provider.findByCategory(categoryName: 'Shoes');
        expect(shoes.length, 2);
      });
    });

    // ── searchQuery ───────────────────────────────────────────────────────
    group('searchQuery', () {
      test('returns matching products for partial title match', () {
        final results = provider.searchQuery(
          searchText: 'iphone',
          passedList: provider.products,
        );
        expect(results.length, 1);
        expect(results.first.productId, '1');
      });

      test('is case-insensitive', () {
        final results = provider.searchQuery(
          searchText: 'MACBOOK',
          passedList: provider.products,
        );
        expect(results.length, 1);
      });

      test('returns all items for empty search text', () {
        final results = provider.searchQuery(
          searchText: '',
          passedList: provider.products,
        );
        expect(results.length, provider.products.length);
      });

      test('returns empty list when no match found', () {
        final results = provider.searchQuery(
          searchText: 'zxyzxyzxyz',
          passedList: provider.products,
        );
        expect(results.isEmpty, isTrue);
      });

      test('respects passed list, not full products list', () {
        final subset = provider.products.take(2).toList();
        final results = provider.searchQuery(
          searchText: 'macbook',
          passedList: subset,
        );
        expect(results.isEmpty, isTrue); // MacBook not in first 2
      });
    });

    // ── getProducts ───────────────────────────────────────────────────────
    group('getProducts', () {
      test('returns all products', () {
        expect(provider.getProducts.length, 5);
      });
    });
  });
}
