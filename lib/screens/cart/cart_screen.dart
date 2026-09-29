import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/providers/cart_provider.dart';
import 'package:simple_ecommerce_app/providers/products_provider.dart';
import 'package:simple_ecommerce_app/screens/cart/cart_widget.dart';
import 'package:simple_ecommerce_app/screens/loading_manager.dart';
import 'package:simple_ecommerce_app/services/assets_manager.dart';
import 'package:simple_ecommerce_app/services/my_app_functions.dart';
import 'package:simple_ecommerce_app/widgets/empty_bag.dart';
import 'package:simple_ecommerce_app/widgets/subtitle_text.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';
import 'package:uuid/uuid.dart';

import '../../providers/user_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  final _promoController = TextEditingController();
  double _discount = 0;
  bool _promoApplied = false;
  final _promoCode = 'SAVE10';

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code == _promoCode) {
      setState(() {
        _promoApplied = true;
        _discount = 10; // 10% discount
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Promo code applied! 10% off'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid promo code. Try SAVE10'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> placeOrderAdvanced({
    required CartProvider cartProvider,
    required ProductsProvider productProvider,
    required UserProvider userProvider,
  }) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: 'Please sign in before placing an order.',
        fct: () {},
      );
      return;
    }
    final uid = user.uid;
    try {
      setState(() => _isLoading = true);
      for (final value in cartProvider.getCartitems.values) {
        final getCurrProduct = productProvider.findByProdId(value.productId);
        if (getCurrProduct == null) continue;
        final orderId = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection('ordersAdvanced')
            .doc(orderId)
            .set({
          'orderId': orderId,
          'userId': uid,
          'productId': value.productId,
          'productTitle': getCurrProduct.productTitle,
          'price':
              double.parse(getCurrProduct.productPrice) * value.quantity,
          'totalPrice': cartProvider.getTotal(productsProvider: productProvider),
          'quantity': value.quantity,
          'imageUrl': getCurrProduct.productImage,
          'userName': userProvider.getUserModel?.userName ?? '',
          'orderDate': Timestamp.now(),
          'status': 'Placed',
        });
      }
      await cartProvider.clearCartFromFirebase();
      cartProvider.clearLocalCart();
      if (!mounted) return;
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: 'Order placed successfully! Thank you for shopping.',
        fct: () {},
        isError: false,
      );
    } catch (e) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final theme = Theme.of(context);

    final subtotal =
        cartProvider.getTotal(productsProvider: productsProvider);
    final shipping = subtotal >= 50 ? 0.0 : 9.99;
    final discountAmount = subtotal * (_discount / 100);
    final tax = (subtotal - discountAmount) * 0.08;
    final total = subtotal - discountAmount + shipping + tax;

    return cartProvider.getCartitems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.shoppingBasket,
              title: 'Your cart is empty',
              subtitle: 'Add some items and come back!',
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
                  label: 'Cart (${cartProvider.getCartitems.length})'),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppFunctions.showErrorOrWarningDialog(
                      isError: false,
                      context: context,
                      subtitle: 'Clear cart?',
                      fct: () async {
                        await cartProvider.clearCartFromFirebase();
                        cartProvider.clearLocalCart();
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_forever_rounded,
                      color: Colors.red),
                ),
              ],
            ),
            body: LoadingManager(
              isLoading: _isLoading,
              child: Column(
                children: [
                  // Cart items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 8),
                      itemCount: cartProvider.getCartitems.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: cartProvider.getCartitems.values
                              .toList()[index],
                          child: const CartWidget(),
                        );
                      },
                    ),
                  ),

                  // Order summary
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Promo code
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _promoController,
                                decoration: InputDecoration(
                                  hintText: 'Promo code (try SAVE10)',
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(
                                      Icons.local_offer_outlined,
                                      size: 18),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _promoApplied ? null : _applyPromo,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                  _promoApplied ? 'Applied' : 'Apply'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(),
                        _SummaryRow(
                            label: 'Subtotal',
                            value: '\$${subtotal.toStringAsFixed(2)}'),
                        if (_promoApplied)
                          _SummaryRow(
                            label: 'Discount (10%)',
                            value: '-\$${discountAmount.toStringAsFixed(2)}',
                            valueColor: Colors.green,
                          ),
                        _SummaryRow(
                          label: 'Shipping',
                          value: shipping == 0
                              ? 'FREE'
                              : '\$${shipping.toStringAsFixed(2)}',
                          valueColor:
                              shipping == 0 ? Colors.green : null,
                        ),
                        _SummaryRow(
                            label: 'Tax (8%)',
                            value: '\$${tax.toStringAsFixed(2)}'),
                        const Divider(),
                        _SummaryRow(
                          label: 'Total',
                          value: '\$${total.toStringAsFixed(2)}',
                          isBold: true,
                          valueColor: theme.primaryColor,
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await placeOrderAdvanced(
                                cartProvider: cartProvider,
                                productProvider: productsProvider,
                                userProvider: userProvider,
                              );
                            },
                            icon: const Icon(IconlyLight.bag2),
                            label: Text(
                              'Place Order - \$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            'Secure checkout',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });
  final String label, value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: isBold ? 15 : 13,
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.grey)),
          Text(value,
              style: TextStyle(
                  fontSize: isBold ? 16 : 13,
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal,
                  color: valueColor)),
        ],
      ),
    );
  }
}
