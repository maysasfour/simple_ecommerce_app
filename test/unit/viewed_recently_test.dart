import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ecommerce_app/providers/viewed_recently_provider.dart';

void main() {
  late ViewedProdProvider provider;

  setUp(() {
    provider = ViewedProdProvider();
  });

  group('ViewedProdProvider', () {
    // ── addViewedProd ─────────────────────────────────────────────────────
    group('addViewedProd', () {
      test('adds product to viewed list', () {
        provider.addViewedProd(productId: 'p1');
        expect(provider.getViewedProds.containsKey('p1'), isTrue);
      });

      test('does not duplicate same product', () {
        provider.addViewedProd(productId: 'p1');
        provider.addViewedProd(productId: 'p1');
        expect(provider.getViewedProds.length, 1);
      });

      test('can add multiple distinct products', () {
        provider.addViewedProd(productId: 'p1');
        provider.addViewedProd(productId: 'p2');
        provider.addViewedProd(productId: 'p3');
        expect(provider.getViewedProds.length, 3);
      });

      test('stores a ViewedProdModel with correct productId', () {
        provider.addViewedProd(productId: 'prod-abc');
        final item = provider.getViewedProds['prod-abc'];
        expect(item, isNotNull);
        expect(item!.productId, 'prod-abc');
      });

      test('ViewedProdModel viewedProdId is non-empty UUID', () {
        provider.addViewedProd(productId: 'p42');
        final item = provider.getViewedProds['p42']!;
        expect(item.viewedProdId.isNotEmpty, isTrue);
      });
    });

    // ── clearViewedProd ───────────────────────────────────────────────────
    group('clearViewedProd', () {
      test('clears all viewed products', () {
        provider.addViewedProd(productId: 'p1');
        provider.addViewedProd(productId: 'p2');
        provider.clearViewedProd();
        expect(provider.getViewedProds.isEmpty, isTrue);
      });

      test('clearing empty list does not throw', () {
        expect(() => provider.clearViewedProd(), returnsNormally);
      });

      test('can add products again after clearing', () {
        provider.addViewedProd(productId: 'p1');
        provider.clearViewedProd();
        provider.addViewedProd(productId: 'p2');
        expect(provider.getViewedProds.length, 1);
        expect(provider.getViewedProds.containsKey('p2'), isTrue);
      });
    });
  });
}
