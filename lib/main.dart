import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/consts/theme_data.dart';
import 'package:simple_ecommerce_app/providers/theme_provider.dart';
import 'package:simple_ecommerce_app/root_screen.dart';
import 'package:simple_ecommerce_app/screens/auth/login.dart';
import 'package:simple_ecommerce_app/screens/inner_screen/product_details.dart';
import 'package:simple_ecommerce_app/screens/inner_screen/viewed_recently.dart';
import 'package:simple_ecommerce_app/screens/inner_screen/wishlist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Shop Online',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),

            // home: const RootScreen(),
            home: const LoginScreen(),
            routes: {
              ProductDetailsScreen.routName: (context) =>
                  const ProductDetailsScreen(),
                  ViewedRecentlyScreen.routName: (context) =>
                  const ViewedRecentlyScreen(),
                  WishlistScreen.routName: (context) =>
                  const WishlistScreen(),

            },
          );
        },
      ),
    );
  }
}
