import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/consts/app_constants.dart';
import 'package:simple_ecommerce_app/providers/products_provider.dart';
import 'package:simple_ecommerce_app/screens/search_screen.dart';
import 'package:simple_ecommerce_app/widgets/products/ctg_rounded_widget.dart';
import 'package:simple_ecommerce_app/widgets/products/latest_arrival.dart';
import 'package:card_swiper/card_swiper.dart';

import '../services/assets_manager.dart';
import '../widgets/app_name_text.dart';
import '../widgets/products/product_widget.dart';
import '../widgets/title_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        title: const AppNameTextWidget(fontSize: 20),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, SearchScreen.routeName),
            icon: const Icon(IconlyLight.search),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: RefreshIndicator(
            onRefresh: () async {
              await productsProvider.fetchProducts();
            },
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Banner Swiper ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) => SizedBox(
                      height: constraints.maxWidth >= 700 ? 320 : 190,
                      child: Swiper(
                      autoplay: true,
                      autoplayDelay: 3500,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          AppConstants.bannersImages[index],
                          fit: BoxFit.cover,
                        );
                      },
                      itemCount: AppConstants.bannersImages.length,
                      pagination: const SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                          activeColor: Colors.white,
                          color: Colors.white54,
                          activeSize: 10,
                          size: 7,
                        ),
                      ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Flash Sale Strip ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF5E4BEC),
                              const Color(0xFF181059),
                            ]
                          : [
                              const Color(0xFF181059),
                              const Color(0xFF5E4BEC),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.flash_on,
                          color: Colors.amber, size: 28),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Flash Sale — Up to 70% OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Limited time deals on top brands',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          textStyle: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () => Navigator.pushNamed(
                            context, SearchScreen.routeName),
                        child: const Text('Shop Now'),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Categories ───────────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 20, 12, 0),
                child: TitlesTextWidget(label: 'Shop by Category'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: AppConstants.categoriesList.length,
                  itemBuilder: (context, index) {
                    final cat = AppConstants.categoriesList[index];
                    return CategoryRoundedWidget(
                      image: cat.image,
                      name: cat.name,
                    );
                  },
                ),
              ),

              // ── New Arrivals ──────────────────────────────────────────────
              if (productsProvider.getProducts.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                  child: TitlesTextWidget(label: 'New Arrivals'),
                ),
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: productsProvider.getProducts.length < 10
                        ? productsProvider.getProducts.length
                        : 10,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: productsProvider.getProducts[index],
                        child: const LatestArrivalProductsWidget(),
                      );
                    },
                  ),
                ),
              ],

              // ── Special Offer Cards ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
                child: Row(
                  children: [
                    _OfferCard(
                      icon: Icons.local_shipping_outlined,
                      title: 'Free Shipping',
                      subtitle: 'On orders over \$50',
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(width: 10),
                    _OfferCard(
                      icon: Icons.replay,
                      title: 'Easy Returns',
                      subtitle: '30-day return policy',
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 10),
                    _OfferCard(
                      icon: Icons.security,
                      title: 'Secure Pay',
                      subtitle: '100% safe checkout',
                      color: Colors.purple.shade600,
                    ),
                  ],
                ),
              ),

              // ── Trending Products ─────────────────────────────────────────
              if (productsProvider.getProducts.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 22, 12, 12),
                  child: TitlesTextWidget(label: 'Trending Products'),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 1050
                        ? 4
                        : constraints.maxWidth >= 700
                            ? 3
                            : 2;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: productsProvider.getProducts.length > 8
                            ? 8
                            : productsProvider.getProducts.length,
                        itemBuilder: (context, index) {
                          return ProductWidget(
                            productId:
                                productsProvider.getProducts[index].productId,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],

              // ── See All Button ────────────────────────────────────────────
              if (productsProvider.getProducts.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(
                          context, SearchScreen.routeName),
                      icon: const Icon(IconlyLight.bag2),
                      label: const Text('View All Products'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
  final IconData icon;
  final String title, subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
