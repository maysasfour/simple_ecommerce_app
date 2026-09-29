import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/models/cart_model.dart';
import 'package:simple_ecommerce_app/screens/cart/quantity_btm_sheet.dart';
import 'package:simple_ecommerce_app/widgets/subtitle_text.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';

import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../widgets/products/heart_btn.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productsProvider.findByProdId(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);

    return getCurrProduct == null
        ? const SizedBox.shrink()
        : Container(
            margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.productImage,
                      height: 90,
                      width: 90,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TitlesTextWidget(
                                label: getCurrProduct.productTitle,
                                maxLines: 2,
                                fontSize: 14,
                              ),
                            ),
                            // Remove button
                            GestureDetector(
                              onTap: () async {
                                await cartProvider.removeCartItemFromFirestore(
                                  cartId: cartModel.cartId,
                                  productId: getCurrProduct.productId,
                                  qty: cartModel.quantity,
                                );
                              },
                              child: const Icon(Icons.close,
                                  color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        SubtitleTextWidget(
                          label: getCurrProduct.productCategory,
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: SubtitleTextWidget(
                                label:
                                    '\$${(double.parse(getCurrProduct.productPrice) * cartModel.quantity).toStringAsFixed(2)}',
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            // Wishlist button
                            HeartButtonWidget(
                              productId: getCurrProduct.productId,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            // Quantity chip
                            GestureDetector(
                              onTap: () async {
                                await showModalBottomSheet(
                                  backgroundColor:
                                      theme.scaffoldBackgroundColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) =>
                                      QuantityBottomSheetWidget(
                                          cartModel: cartModel),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color:
                                      theme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: theme.primaryColor
                                          .withOpacity(0.4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Qty: ${cartModel.quantity}',
                                        style: TextStyle(
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        )),
                                    const SizedBox(width: 4),
                                    Icon(IconlyLight.arrowDown2,
                                        size: 14,
                                        color: theme.primaryColor),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        SubtitleTextWidget(
                          label:
                              '\$${getCurrProduct.productPrice} each',
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}