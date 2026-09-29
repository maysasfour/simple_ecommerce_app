import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:simple_ecommerce_app/screens/admin/admin_orders_screen.dart';
import 'package:simple_ecommerce_app/screens/admin/admin_products_screen.dart';
import 'package:simple_ecommerce_app/screens/admin/admin_users_screen.dart';
import 'package:simple_ecommerce_app/services/auth_guard.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';

class AdminDashboard extends StatelessWidget {
  static const routeName = '/AdminDashboard';
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminGuard(
      child: _AdminDashboardContent(),
    );
  }
}

class _AdminDashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.admin_panel_settings, color: Colors.amber, size: 22),
            SizedBox(width: 8),
            Text('Admin Dashboard'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome Banner ────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Welcome, Admin 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Manage your store from here',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Stats Cards ───────────────────────────────────────────────
            const TitlesTextWidget(label: 'Store Overview'),
            const SizedBox(height: 12),
            _StatsGrid(),
            const SizedBox(height: 24),

            // ── Management tiles ──────────────────────────────────────────
            const TitlesTextWidget(label: 'Management'),
            const SizedBox(height: 12),
            _AdminTile(
              icon: Icons.inventory_2_outlined,
              iconColor: Colors.blue,
              title: 'Product Management',
              subtitle: 'Add, edit, and delete products',
              onTap: () => Navigator.pushNamed(
                  context, AdminProductsScreen.routeName),
            ),
            _AdminTile(
              icon: Icons.receipt_long_outlined,
              iconColor: Colors.orange,
              title: 'Order Management',
              subtitle: 'View all orders, update statuses',
              onTap: () => Navigator.pushNamed(
                  context, AdminOrdersScreen.routeName),
            ),
            _AdminTile(
              icon: Icons.people_outline,
              iconColor: Colors.green,
              title: 'User Management',
              subtitle: 'View users, manage admin roles',
              onTap: () => Navigator.pushNamed(
                  context, AdminUsersScreen.routeName),
            ),
            const SizedBox(height: 24),

            // ── Recent Orders ─────────────────────────────────────────────
            const TitlesTextWidget(label: 'Recent Orders'),
            const SizedBox(height: 12),
            _RecentOrdersList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Stats Grid ────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (ctx, prodSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ordersAdvanced')
              .snapshots(),
          builder: (ctx, orderSnap) {
            return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (ctx, userSnap) {
                final productCount =
                    prodSnap.data?.docs.length ?? 0;
                final orderDocs = orderSnap.data?.docs ?? [];
                final userCount = userSnap.data?.docs.length ?? 0;

                double revenue = 0;
                for (final doc in orderDocs) {
                  final data = doc.data() as Map<String, dynamic>;
                  revenue += (data['price'] as num? ?? 0).toDouble();
                }

                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _StatCard(
                        label: 'Products',
                        value: '$productCount',
                        icon: Icons.inventory_2_outlined,
                        color: Colors.blue),
                    _StatCard(
                        label: 'Orders',
                        value: '${orderDocs.length}',
                        icon: Icons.receipt_long_outlined,
                        color: Colors.orange),
                    _StatCard(
                        label: 'Users',
                        value: '$userCount',
                        icon: Icons.people_outline,
                        color: Colors.green),
                    _StatCard(
                        label: 'Revenue',
                        value: '\$${revenue.toStringAsFixed(0)}',
                        icon: Icons.attach_money,
                        color: Colors.purple),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label, value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  child: Text(
                    value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                ),
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Admin Tile ────────────────────────────────────────────────────────────────

class _AdminTile extends StatelessWidget {
  const _AdminTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing:
            const Icon(IconlyLight.arrowRight2, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

// ── Recent Orders List ────────────────────────────────────────────────────────

class _RecentOrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ordersAdvanced')
          .orderBy('orderDate', descending: true)
          .limit(5)
          .snapshots(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No orders yet',
                  style: TextStyle(color: Colors.grey)),
            ),
          );
        }
        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final date = (data['orderDate'] as Timestamp).toDate();
            final status = data['status'] ?? 'Placed';

            final statusColors = {
              'Placed': Colors.blue,
              'Processing': Colors.orange,
              'Shipped': Colors.indigo,
              'Delivered': Colors.green,
            };
            final color = statusColors[status] ?? Colors.blue;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(Icons.shopping_bag_outlined,
                      color: color, size: 20),
                ),
                title: Text(
                  data['productTitle']?.toString() ?? '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                subtitle: Text(
                  data['userName'] ?? '',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(status,
                          style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${(data['price'] as num? ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
