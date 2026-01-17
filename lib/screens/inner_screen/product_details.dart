import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_ecommerce_app/consts/app_constants.dart';
import 'package:simple_ecommerce_app/widgets/app_name_text.dart';
import 'package:simple_ecommerce_app/widgets/products/heart_btn.dart';
import 'package:simple_ecommerce_app/widgets/subtitle_text.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routName = "/ProductDetailsScreen";
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // Navigator.pop(context) ? Navigator.pop(context) : null;
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.arrow_back_ios, size: 20),
        ),

        title: const AppNameTextWidget(fontSize: 20),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FancyShimmerImage(
              imageUrl: AppConstants.imageUrl,
              height: size.height * 0.38,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          "Title" * 18,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const SubtitleTextWidget(
                        label: "30.00\$",
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeartButtonWidget(bkgColor: Colors.blue.shade100),

                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: kBottomNavigationBarHeight - 10,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),

                              onPressed: () {},
                              icon: const Icon(Icons.add_shopping_cart),
                              label: const Text("Add to Cart"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      TitlesTextWidget(label: "About this item"),
                      SubtitleTextWidget(label: "In Phone"),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SubtitleTextWidget(label: "Description" * 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
