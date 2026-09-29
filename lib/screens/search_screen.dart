import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/consts/app_constants.dart';
import 'package:simple_ecommerce_app/models/product_model.dart';
import 'package:simple_ecommerce_app/providers/products_provider.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import '../widgets/products/product_widget.dart';
import '../widgets/title_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  String _selectedCategory = 'All';
  String _sortOption = 'Newest';

  static const _sortOptions = ['Newest', 'Price: Low–High', 'Price: High–Low'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> _applyFilters(List<ProductModel> all) {
    // Category filter
    final catFiltered = _selectedCategory == 'All'
        ? all
        : all
            .where((p) => p.productCategory
                .toLowerCase()
                .contains(_selectedCategory.toLowerCase()))
            .toList();

    // Search filter
    final query = _searchController.text.trim().toLowerCase();
    final searched = query.isEmpty
        ? catFiltered
        : catFiltered
            .where((p) => p.productTitle.toLowerCase().contains(query))
            .toList();

    // Sort
    switch (_sortOption) {
      case 'Price: Low–High':
        searched.sort(
            (a, b) => double.parse(a.productPrice).compareTo(double.parse(b.productPrice)));
        break;
      case 'Price: High–Low':
        searched.sort(
            (a, b) => double.parse(b.productPrice).compareTo(double.parse(a.productPrice)));
        break;
      default: // Newest — keep original order
        break;
    }
    return searched;
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Support category passed via route arguments
    final passedCategory =
        ModalRoute.of(context)?.settings.arguments as String?;
    if (passedCategory != null && _selectedCategory == 'All') {
      _selectedCategory = passedCategory;
    }

    final allProducts = productsProvider.products;
    final results = _applyFilters(allProducts);

    final categories = ['All', ...AppConstants.categoriesList.map((c) => c.name)];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const TitlesTextWidget(label: 'Search & Browse'),
        ),
        body: Column(
          children: [
            // ── Search box ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            // ── Sort Row ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  const Icon(Icons.sort, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _sortOptions.map((opt) {
                          final selected = opt == _sortOption;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(opt,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        selected ? Colors.white : null,
                                  )),
                              selected: selected,
                              selectedColor: Theme.of(context).primaryColor,
                              onSelected: (_) =>
                                  setState(() => _sortOption = opt),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Category Chips ───────────────────────────────────────────────
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final selected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat,
                          style: TextStyle(
                            fontSize: 12,
                            color: selected ? Colors.white : null,
                          )),
                      selected: selected,
                      selectedColor: Theme.of(context).primaryColor,
                      checkmarkColor: Colors.white,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                    ),
                  );
                },
              ),
            ),

            // ── Results count ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
              child: Row(
                children: [
                  Text(
                    '${results.length} products found',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // ── Product grid ─────────────────────────────────────────────────
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.search_off,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          TitlesTextWidget(label: 'No products found'),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DynamicHeightGridView(
                        itemCount: results.length,
                        crossAxisCount:
                            MediaQuery.sizeOf(context).width >= 1050
                                ? 4
                                : MediaQuery.sizeOf(context).width >= 700
                                    ? 3
                                    : 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        builder: (context, index) {
                          return ProductWidget(
                            productId: results[index].productId,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
