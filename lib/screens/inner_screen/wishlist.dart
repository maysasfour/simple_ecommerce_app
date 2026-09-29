import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/providers/cart_provider.dart';
import 'package:simple_ecommerce_app/providers/wishlist_provider.dart';
import 'package:simple_ecommerce_app/services/assets_manager.dart';
import 'package:simple_ecommerce_app/services/my_app_functions.dart';
import 'package:simple_ecommerce_app/widgets/empty_bag.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';

import '../../widgets/products/product_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const routName = '/WishlistScreen';
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return wishlistProvider.getWishlists.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.bagWish,
              title: 'Your wishlist is empty',
              subtitle: 'Save items you love and shop them later',
              buttonText: 'Shop Now',
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.shoppingCart),
              ),
              title: TitlesTextWidget(
                  label: 'Wishlist (${wishlistProvider.getWishlists.length})'),
              actions: [
                // Move all to cart
                TextButton.icon(
                  onPressed: () async {
                    final items = wishlistProvider.getWishlists.values.toList();
                    for (final item in items) {
                      if (!cartProvider.isProdinCart(
                          productId: item.productId)) {
                        await cartProvider.addToCartFirebase(
                          productId: item.productId,
                          qty: 1,
                          context: context,
                        );
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All items moved to cart 🛒'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                  label: const Text('All to Cart', style: TextStyle(fontSize: 12)),
                ),
                // Clear wishlist
                IconButton(
                  onPressed: () {
                    MyAppFunctions.showErrorOrWarningDialog(
                      isError: false,
                      context: context,
                      subtitle: 'Clear wishlist?',
                      fct: () async {
                        await wishlistProvider.clearWishlistFromFirebase();
                        wishlistProvider.clearLocalWishlist();
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_forever_rounded,
                      color: Colors.red),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DynamicHeightGridView(
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                builder: (context, index) {
                  return ProductWidget(
                    productId: wishlistProvider.getWishlists.values
                        .toList()[index]
                        .productId,
                  );
                },
                itemCount: wishlistProvider.getWishlists.length,
                crossAxisCount: 2,
              ),
            ),
          );
  }
}