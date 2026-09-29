import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/providers/order_provider.dart';
import 'package:simple_ecommerce_app/providers/products_provider.dart';
import 'package:simple_ecommerce_app/providers/theme_provider.dart';
import 'package:simple_ecommerce_app/firebase_options.dart';
import 'package:simple_ecommerce_app/root_screen.dart';
import 'package:simple_ecommerce_app/screens/inner_screen/address_screen.dart';
import 'package:simple_ecommerce_app/screens/inner_screen/product_details.dart';
import 'package:simple_ecommerce_app/screens/inner_screen/viewed_recently.dart';
import 'package:simple_ecommerce_app/services/product_seed_service.dart';

import 'consts/theme_data.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'providers/viewed_recently_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/auth/forgot_password.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/inner_screen/orders/orders_screen.dart';
import 'screens/inner_screen/wishlist.dart';
import 'screens/search_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/admin_products_screen.dart';
import 'screens/admin/admin_orders_screen.dart';
import 'screens/admin/admin_users_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).then((app) async {
        // Seed products to Firestore on first launch
        await ProductSeedService.seedIfEmpty();
        return app;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'ShopSmart EN',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text('Loading your store...',
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: SelectableText(snapshot.error.toString()),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => ProductsProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => WishlistProvider()),
            ChangeNotifierProvider(create: (_) => ViewedProdProvider()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'ShopSmart EN',
                theme: Styles.themeData(
                  isDarkTheme: themeProvider.getIsDarkTheme,
                  context: context,
                ),
                home: const RootScreen(),
                routes: {
                  RootScreen.routeName: (context) => const RootScreen(),
                  ProductDetailsScreen.routName: (context) =>
                      const ProductDetailsScreen(),
                  WishlistScreen.routName: (context) =>
                      const WishlistScreen(),
                  ViewedRecentlyScreen.routName: (context) =>
                      const ViewedRecentlyScreen(),
                  RegisterScreen.routName: (context) =>
                      const RegisterScreen(),
                  LoginScreen.routeName: (context) =>
                      const LoginScreen(),
                  OrdersScreenFree.routeName: (context) =>
                      const OrdersScreenFree(),
                  ForgotPasswordScreen.routeName: (context) =>
                      const ForgotPasswordScreen(),
                  SearchScreen.routeName: (context) =>
                      const SearchScreen(),
                  AddressScreen.routeName: (context) =>
                      const AddressScreen(),
                  AdminDashboard.routeName: (context) =>
                      const AdminDashboard(),
                  AdminProductsScreen.routeName: (context) =>
                      const AdminProductsScreen(),
                  AdminOrdersScreen.routeName: (context) =>
                      const AdminOrdersScreen(),
                  AdminUsersScreen.routeName: (context) =>
                      const AdminUsersScreen(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
