import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:simple_ecommerce_app/screens/cart/bottom_checkout.dart';
import 'package:simple_ecommerce_app/services/assets_manager.dart';
import 'package:simple_ecommerce_app/widgets/empty_bag.dart';
import 'package:simple_ecommerce_app/widgets/products/product_widget.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';

class WishlistScreen extends StatelessWidget {
   static const routName = "/WishlistScreen";
  const WishlistScreen({super.key});
  final bool isEmpty = true;
  @override
  Widget build(BuildContext context) {
    return isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.bagWish,
              title: "Nothing in your wishlist yet",
              subtitle:
                  "Look like your cart is empty add something and make me happy",
              buttonText: "Shop now",
            ),
          )
        : Scaffold(
            bottomSheet: const CartBottomSheetWidget(),
            appBar: AppBar(
              // elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.shoppingCart),
              ),
              title: const TitlesTextWidget(label: "Wishlist (6)"),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete_forever_rounded, color: Colors.red),
                ),
              ],
            ),

            body:  DynamicHeightGridView(
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  builder: (context, index) {
                    return const ProductWidget();
                  },
                  itemCount: 200,
                  crossAxisCount: 2,
                ),
          );
  }
}
