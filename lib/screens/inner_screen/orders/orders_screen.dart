import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce_app/providers/order_provider.dart';
import 'package:simple_ecommerce_app/widgets/empty_bag.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';

import '../../../models/order_model.dart';
import '../../../services/assets_manager.dart';
import 'orders_widget.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';
  const OrdersScreenFree({super.key});

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _statuses = ['All', 'Placed', 'Processing', 'Shipped', 'Delivered'];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _statuses.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<OrdersModelAdvanced> _filterOrders(
      List<OrdersModelAdvanced> orders, String status) {
    if (status == 'All') return orders;
    return orders
        .where((o) =>
            (o.status?.toLowerCase() ?? 'placed') == status.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: 'My Orders'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _statuses
              .map((s) => Tab(
                    child: Text(s,
                        style: const TextStyle(fontSize: 13)),
                  ))
              .toList(),
        ),
      ),
      body: FutureBuilder<List<OrdersModelAdvanced>>(
        future: ordersProvider.fetchOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: SelectableText(snapshot.error.toString()));
          } else if (!snapshot.hasData || ordersProvider.getOrders.isEmpty) {
            return EmptyBagWidget(
              imagePath: AssetsManager.orderBag,
              title: 'No orders yet',
              subtitle: 'Your placed orders will appear here',
              buttonText: 'Shop Now',
            );
          }

          return TabBarView(
            controller: _tabController,
            children: _statuses.map((status) {
              final filtered =
                  _filterOrders(ordersProvider.getOrders, status);
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox_outlined,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text('No $status orders',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, index) {
                  return OrdersWidgetFree(
                      ordersModelAdvanced: filtered[index]);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}