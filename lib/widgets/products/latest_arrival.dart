import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/providers/viewed_recently_provider.dart';

import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../screens/inner_screen/product_details.dart';
import '../../services/my_app_functions.dart';
import '../subtitle_text.dart';
import 'heart_btn.dart';
import 'product_image.dart';

class LatestArrivalProductsWidget extends StatelessWidget {
  const LatestArrivalProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productsModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          viewedProdProvider.addViewedProd(productId: productsModel.productId);
          await Navigator.pushNamed(context, ProductDetailsScreen.routName,
              arguments: productsModel.productId);
        },
        child: SizedBox(
          width: 300,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: ProductImage(
                    imageUrl: productsModel.productImage,
                    height: 145,
                    width: 125,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      productsModel.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          HeartButtonWidget(
                            productId: productsModel.productId,
                          ),
                          IconButton(
                            onPressed: () async {
                              if (cartProvider.isProdinCart(
                                  productId: productsModel.productId)) {
                                return;
                              }
                              try {
                                await cartProvider.addToCartFirebase(
                                    productId: productsModel.productId,
                                    qty: 1,
                                    context: context);
                              } catch (e) {
                                await MyAppFunctions.showErrorOrWarningDialog(
                                  context: context,
                                  subtitle: e.toString(),
                                  fct: () {},
                                );
                              }
                            },
                            icon: Icon(
                              cartProvider.isProdinCart(
                                productId: productsModel.productId,
                              )
                                  ? Icons.check
                                  : Icons.add_shopping_cart_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FittedBox(
                      child: SubtitleTextWidget(
                        label: "${productsModel.productPrice}\$",
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
