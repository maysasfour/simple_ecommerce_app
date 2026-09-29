import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ecommerce_app/providers/wishlist_provider.dart';

void main() {
  late WishlistProvider provider;

  setUp(() {
    provider = WishlistProvider();
  });

  group('WishlistProvider — local logic', () {
    // ── addOrRemoveFromWishlist ────────────────────────────────────────────
    group('addOrRemoveFromWishlist', () {
      test('adds product when not in wishlist', () {
        provider.addOrRemoveFromWishlist(productId: 'p1');
        expect(provider.getWishlists.containsKey('p1'), isTrue);
      });

      test('removes product when already in wishlist', () {
        provider.addOrRemoveFromWishlist(productId: 'p1');
        provider.addOrRemoveFromWishlist(productId: 'p1');
        expect(provider.getWishlists.containsKey('p1'), isFalse);
      });

      test('toggle twice results in empty wishlist', () {
        provider.addOrRemoveFromWishlist(productId: 'p1');
        provider.addOrRemoveFromWishlist(productId: 'p1');
        expect(provider.getWishlists.isEmpty, isTrue);
      });

      test('can add multiple products', () {
        provider.addOrRemoveFromWishlist(productId: 'p1');
        provider.addOrRemoveFromWishlist(productId: 'p2');
        provider.addOrRemoveFromWishlist(productId: 'p3');
        expect(provider.getWishlists.length, 3);
      });

      test('removing one does not affect others', () {
        provider.addOrRemoveFromWishlist(productId: 'p1');
        provider.addOrRemoveFromWishlist(productId: 'p2');
        provider.addOrRemoveFromWishlist(productId: 'p1'); // remove p1
        expect(provider.getWishlists.containsKey('p1'), isFalse);
        expect(provider.getWishlists.containsKey('p2'), isTrue);
      });
    });

    // ── isProdinWishlist ──────────────────────────────────────────────────
    group('isProdinWishlist', () {
      test('returns false when product not in wishlist', () {
        expect(provider.isProdinWishlist(productId: 'p1'), isFalse);
      });

      test('returns true after product is added', () {
        provider.addOrRemoveFromWishlist(productId: 'p1');
        expect(provider.isProdinWishlist(productId: 'p1'), isTrue);
      });

      test('returns false after product is removed', () {
        provider.addOrRemoveFromWishlist(productId: 'p1');
        provider.addOrRemoveFromWishlist(productId: 'p1');
        expect(provider.isProdinWishlist(productId: 'p1'), isFalse);
      });
    });

    // ── clearLocalWishlist ────────────────────────────────────────────────
    group('clearLocalWishlist', () {
      test('clears all items', () {
        provider.addOrRemoveFromWishlist(productId: 'p1');
        provider.addOrRemoveFromWishlist(productId: 'p2');
        provider.clearLocalWishlist();
        expect(provider.getWishlists.isEmpty, isTrue);
      });

      test('clearing empty list does not throw', () {
        expect(() => provider.clearLocalWishlist(), returnsNormally);
      });

      test('can add items after clearing', () {
        provider.addOrRemoveFromWishlist(productId: 'p1');
        provider.clearLocalWishlist();
        provider.addOrRemoveFromWishlist(productId: 'p2');
        expect(provider.getWishlists.length, 1);
        expect(provider.isProdinWishlist(productId: 'p2'), isTrue);
      });
    });

    // ── WishlistModel integrity ───────────────────────────────────────────
    group('WishlistModel stored values', () {
      test('stored WishlistModel has correct productId', () {
        provider.addOrRemoveFromWishlist(productId: 'p-test');
        final model = provider.getWishlists['p-test'];
        expect(model, isNotNull);
        expect(model!.productId, 'p-test');
      });

      test('stored WishlistModel has non-empty wishlistId', () {
        provider.addOrRemoveFromWishlist(productId: 'p-test');
        final model = provider.getWishlists['p-test']!;
        expect(model.wishlistId.isNotEmpty, isTrue);
      });
    });
  });
}
