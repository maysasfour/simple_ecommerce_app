import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/services/assets_manager.dart';
import 'package:simple_ecommerce_app/services/my_app_functions.dart';
import 'package:simple_ecommerce_app/widgets/empty_bag.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';

import '../../providers/viewed_recently_provider.dart';
import '../../widgets/products/product_widget.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  static const routName = '/ViewedRecentlyScreen';
  const ViewedRecentlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    return viewedProdProvider.getViewedProds.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.orderBag,
              title: 'No recently viewed products',
              subtitle: 'Browse products and they\'ll appear here',
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
                  label:
                      'Viewed Recently (${viewedProdProvider.getViewedProds.length})'),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppFunctions.showErrorOrWarningDialog(
                      isError: false,
                      context: context,
                      subtitle: 'Clear recently viewed?',
                      fct: () {
                        viewedProdProvider.clearViewedProd();
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
                    productId: viewedProdProvider.getViewedProds.values
                        .toList()[index]
                        .productId,
                  );
                },
                itemCount: viewedProdProvider.getViewedProds.length,
                crossAxisCount: 2,
              ),
            ),
          );
  }
}