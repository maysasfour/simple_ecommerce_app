import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/providers/cart_provider.dart';
import 'package:simple_ecommerce_app/providers/products_provider.dart';
import 'package:simple_ecommerce_app/services/my_app_functions.dart';
import 'package:simple_ecommerce_app/widgets/app_name_text.dart';
import 'package:simple_ecommerce_app/widgets/products/heart_btn.dart';
import 'package:simple_ecommerce_app/widgets/subtitle_text.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';
import 'package:simple_ecommerce_app/widgets/products/product_widget.dart';
import 'package:simple_ecommerce_app/widgets/products/product_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routName = '/ProductDetailsScreen';
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedQty = 1;
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = -1;

  static const _colors = [
    Color(0xFF1A1A2E), // midnight
    Color(0xFFC5C5C5), // silver
    Color(0xFFB5965B), // gold
    Color(0xFF3A5A8F), // blue
  ];

  static const _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final String? productId =
        ModalRoute.of(context)!.settings.arguments as String?;
    final getCurrProduct =
        productsProvider.findByProdId(productId ?? '');
    final cartProvider = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);

    final allProducts = productsProvider.getProducts;
    final related = allProducts
        .where((p) =>
            p.productId != productId &&
            p.productCategory ==
                (getCurrProduct?.productCategory ?? ''))
        .take(4)
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        title: const AppNameTextWidget(fontSize: 20),
        actions: [
          HeartButtonWidget(
            productId: getCurrProduct?.productId ?? '',
            size: 22,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: getCurrProduct == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  ClipRRect(
                    child: ProductImage(
                      imageUrl: getCurrProduct.productImage,
                      height: 420,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                theme.primaryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            getCurrProduct.productCategory,
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Title + Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                getCurrProduct.productTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '\$${getCurrProduct.productPrice}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Rating
                        Row(
                          children: [
                            ...List.generate(
                                5,
                                (i) => Icon(
                                      i < 4
                                          ? Icons.star
                                          : Icons.star_half,
                                      color: Colors.amber,
                                      size: 18,
                                    )),
                            const SizedBox(width: 6),
                            const Text(
                              '4.5  (2,847 reviews)',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Shipping info
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.local_shipping_outlined,
                                  color: Colors.green, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'Free shipping on orders over \$50',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Color selector
                        const Text('Color',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(_colors.length, (i) {
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedColorIndex = i),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  color: _colors[i],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _selectedColorIndex == i
                                        ? theme.primaryColor
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    if (_selectedColorIndex == i)
                                      BoxShadow(
                                        color: theme.primaryColor
                                            .withOpacity(0.4),
                                        blurRadius: 6,
                                      )
                                  ],
                                ),
                                child: _selectedColorIndex == i
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 16)
                                    : null,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),

                        // Size selector
                        const Text('Size',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: List.generate(_sizes.length, (i) {
                            final selected = _selectedSizeIndex == i;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedSizeIndex = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? theme.primaryColor
                                      : theme.cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: selected
                                        ? theme.primaryColor
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Text(
                                  _sizes[i],
                                  style: TextStyle(
                                    color: selected ? Colors.white : null,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),

                        // Quantity selector
                        const Text('Quantity',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _QtyButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (_selectedQty > 1) {
                                  setState(() => _selectedQty--);
                                }
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$_selectedQty',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            _QtyButton(
                              icon: Icons.add,
                              onTap: () => setState(() => _selectedQty++),
                            ),
                            const Spacer(),
                            SubtitleTextWidget(
                              label:
                                  '\$${(double.parse(getCurrProduct.productPrice) * _selectedQty).toStringAsFixed(2)} total',
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  if (cartProvider.isProdinCart(
                                      productId:
                                          getCurrProduct.productId)) {
                                    return;
                                  }
                                  try {
                                    await cartProvider.addToCartFirebase(
                                      productId: getCurrProduct.productId,
                                      qty: _selectedQty,
                                      context: context,
                                    );
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
                                          productId:
                                              getCurrProduct.productId)
                                      ? Icons.check
                                      : Icons.shopping_cart_outlined,
                                ),
                                label: Text(cartProvider.isProdinCart(
                                        productId:
                                            getCurrProduct.productId)
                                    ? 'In Cart'
                                    : 'Add to Cart'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  if (!cartProvider.isProdinCart(
                                      productId: getCurrProduct.productId)) {
                                    await cartProvider.addToCartFirebase(
                                      productId: getCurrProduct.productId,
                                      qty: _selectedQty,
                                      context: context,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.flash_on),
                                label: const Text('Buy Now'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // About this item
                        Row(
                          children: [
                            const Expanded(
                              child: TitlesTextWidget(
                                  label: 'About this item'),
                            ),
                            Text('In ${getCurrProduct.productCategory}',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          getCurrProduct.productDescription,
                          style: const TextStyle(
                              fontSize: 14, height: 1.6, color: Colors.grey),
                        ),

                        // Specs / Guarantees
                        const SizedBox(height: 20),
                        _GuaranteeItem(
                          icon: Icons.verified_outlined,
                          title: 'Authentic Product',
                          subtitle: '100% original, guaranteed',
                        ),
                        _GuaranteeItem(
                          icon: Icons.replay,
                          title: '30-Day Returns',
                          subtitle: 'Hassle-free return policy',
                        ),
                        _GuaranteeItem(
                          icon: Icons.support_agent_outlined,
                          title: '24/7 Support',
                          subtitle: 'Customer service always available',
                        ),

                        // Related Products
                        if (related.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const TitlesTextWidget(label: 'You May Also Like'),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: size.height * 0.32,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: related.length,
                              itemBuilder: (ctx, i) {
                                return SizedBox(
                                  width: size.width * 0.45,
                                  child: ProductWidget(
                                      productId: related[i].productId),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3)),
        ),
        child: Icon(icon, size: 18, color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class _GuaranteeItem extends StatelessWidget {
  const _GuaranteeItem(
      {required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              Text(subtitle,
                  style:
                      const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
