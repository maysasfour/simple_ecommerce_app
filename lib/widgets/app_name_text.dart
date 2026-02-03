import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({super.key, this.fontSize = 30});
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 22),
      baseColor: const Color.fromARGB(255, 39, 94, 176),
      highlightColor: const Color.fromARGB(129, 214, 10, 204),
      child: TitlesTextWidget(
        label: "Miso's Shop",
        fontSize: fontSize,
      ),
    );
  }
}