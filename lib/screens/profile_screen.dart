import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/consts/app_colors.dart';
import 'package:simple_ecommerce_app/screens/auth/login.dart';
import 'package:simple_ecommerce_app/screens/inner_screen/address_screen.dart';
import 'package:simple_ecommerce_app/screens/inner_screen/viewed_recently.dart';
import 'package:simple_ecommerce_app/screens/inner_screen/wishlist.dart';
import 'package:simple_ecommerce_app/screens/loading_manager.dart';
import 'package:simple_ecommerce_app/services/assets_manager.dart';

import '../models/user_model.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../services/my_app_functions.dart';
import '../widgets/app_name_text.dart';
import '../widgets/title_text.dart';
import 'inner_screen/orders/orders_screen.dart';
import 'admin/admin_dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool _isLoading = true;

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() => _isLoading = true);
      userModel = await userProvider.fetchUserInfo();
    } catch (_) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        title: const AppNameTextWidget(fontSize: 20),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ── User Header Card ────────────────────────────────────────────
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF5E4BEC),
                            const Color(0xFF181059),
                          ]
                        : [
                            AppColors.lightPrimary,
                            const Color(0xFF5E4BEC),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: user == null
                    ? Column(
                        children: [
                          const Icon(Icons.person_outline,
                              color: Colors.white70, size: 50),
                          const SizedBox(height: 8),
                          const Text('Not logged in',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('Sign in to access your account',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(
                                context, LoginScreen.routeName),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.lightPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Text('Sign In'),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white24,
                            backgroundImage: userModel?.userImage != null &&
                                    userModel!.userImage.isNotEmpty
                                ? NetworkImage(userModel!.userImage)
                                : null,
                            child: userModel?.userImage == null ||
                                    userModel!.userImage.isEmpty
                                ? const Icon(Icons.person,
                                    color: Colors.white, size: 32)
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userModel?.userName ?? 'User',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userModel?.userEmail ?? '',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    '⭐ Premium Member',
                                    style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),

              // ── Stats Row ────────────────────────────────────────────────────
              if (user != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      _StatCard(label: 'Orders', value: '12', icon: IconlyLight.bag),
                      const SizedBox(width: 10),
                      _StatCard(
                          label: 'Wishlist', value: '5', icon: IconlyLight.heart),
                      const SizedBox(width: 10),
                      _StatCard(
                          label: 'Reviews', value: '3', icon: IconlyLight.star),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── My Account ───────────────────────────────────────────
                    const TitlesTextWidget(label: 'My Account'),
                    const SizedBox(height: 8),
                    _ProfileTile(
                      icon: IconlyLight.bag,
                      iconBg: Colors.blue,
                      title: 'My Orders',
                      subtitle: 'Track, return or buy again',
                      visible: user != null,
                      onTap: () => Navigator.pushNamed(
                          context, OrdersScreenFree.routeName),
                    ),
                    _ProfileTile(
                      icon: IconlyLight.heart,
                      iconBg: Colors.red,
                      title: 'Wishlist',
                      subtitle: 'Items saved for later',
                      visible: user != null,
                      onTap: () =>
                          Navigator.pushNamed(context, WishlistScreen.routName),
                    ),
                    _ProfileTile(
                      icon: IconlyLight.timeCircle,
                      iconBg: Colors.orange,
                      title: 'Recently Viewed',
                      subtitle: 'Products you browsed',
                      visible: true,
                      onTap: () => Navigator.pushNamed(
                          context, ViewedRecentlyScreen.routName),
                    ),
                    _ProfileTile(
                      icon: IconlyLight.location,
                      iconBg: Colors.green,
                      title: 'My Addresses',
                      subtitle: 'Manage delivery addresses',
                      visible: true,
                      onTap: () => Navigator.pushNamed(
                          context, AddressScreen.routeName),
                    ),

                    // ── Admin Panel ───────────────────────────────────────────
                    if (userModel?.isAdmin == true) ...
                    [
                      const SizedBox(height: 20),
                      const TitlesTextWidget(label: 'Administration'),
                      const SizedBox(height: 8),
                      _ProfileTile(
                        icon: Icons.admin_panel_settings_outlined,
                        iconBg: Colors.amber,
                        title: 'Admin Dashboard',
                        subtitle: 'Manage products, orders & users',
                        visible: true,
                        onTap: () => Navigator.pushNamed(
                            context, AdminDashboard.routeName),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ── Preferences ───────────────────────────────────────────
                    const TitlesTextWidget(label: 'Preferences'),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: SwitchListTile(
                        secondary: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              const Icon(Icons.dark_mode, color: Colors.purple, size: 20),
                        ),
                        title: Text(isDark ? 'Dark Mode' : 'Light Mode'),
                        subtitle: const Text('Switch appearance'),
                        value: isDark,
                        onChanged: (val) =>
                            themeProvider.setDarkTheme(themeValue: val),
                      ),
                    ),

                    // ── Sign Out ──────────────────────────────────────────────
                    if (user != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await MyAppFunctions.showErrorOrWarningDialog(
                                context: context,
                                subtitle: 'Are you sure you want to sign out?',
                                isError: false,
                                fct: () async {
                                  await FirebaseAuth.instance.signOut();
                                  if (!mounted) return;
                                  setState(() {
                                    user = null;
                                    userModel = null;
                                  });
                                },
                              );
                            },
                            icon: const Icon(Icons.logout, color: Colors.red),
                            label: const Text('Sign Out',
                                style: TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.label, required this.value, required this.icon});
  final String label, value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).primaryColor),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.visible,
  });
  final IconData icon;
  final Color iconBg;
  final String title, subtitle;
  final VoidCallback onTap;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBg.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconBg, size: 22),
        ),
        title:
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing:
            const Icon(IconlyLight.arrowRight2, size: 18, color: Colors.grey),
      ),
    );
  }
}