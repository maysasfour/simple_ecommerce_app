import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_ecommerce_app/services/auth_guard.dart';
import 'package:simple_ecommerce_app/widgets/title_text.dart';

class AdminOrdersScreen extends StatefulWidget {
  static const routeName = '/AdminOrdersScreen';
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _statuses = ['All', 'Placed', 'Processing', 'Shipped', 'Delivered'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('ordersAdvanced')
        .doc(docId)
        .update({'status': newStatus});
  }

  static const _statusConfig = {
    'Placed': Colors.blue,
    'Processing': Colors.orange,
    'Shipped': Colors.indigo,
    'Delivered': Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return AdminGuard(
      child: Scaffold(
        appBar: AppBar(
          title: const TitlesTextWidget(label: 'Order Management'),
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ordersAdvanced')
              .orderBy('orderDate', descending: true)
              .snapshots(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final allDocs = snap.data?.docs ?? [];

            // Revenue summary
            double totalRevenue = 0;
            for (final doc in allDocs) {
              final data = doc.data() as Map<String, dynamic>;
              totalRevenue += (data['price'] as num? ?? 0).toDouble();
            }

            return Column(
              children: [
                // Revenue banner
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade700,
                        Colors.green.shade400,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_money,
                          color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Revenue',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          Text(
                            '\$${totalRevenue.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            '${allDocs.length}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text('Orders',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tabbed orders list
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _statuses.map((status) {
                      final filtered = status == 'All'
                          ? allDocs
                          : allDocs.where((d) {
                              final data =
                                  d.data() as Map<String, dynamic>;
                              return (data['status'] ?? 'Placed') ==
                                  status;
                            }).toList();

                      if (filtered.isEmpty) {
                        return Center(
                          child: Text('No $status orders',
                              style:
                                  const TextStyle(color: Colors.grey)),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          final doc = filtered[i];
                          final data =
                              doc.data() as Map<String, dynamic>;
                          final currentStatus =
                              data['status'] ?? 'Placed';
                          final color =
                              _statusConfig[currentStatus] ?? Colors.blue;
                          final date =
                              (data['orderDate'] as Timestamp).toDate();
                          final dateStr =
                              '${date.day}/${date.month}/${date.year}';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  // Date + status badge
                                  Row(children: [
                                    Text(dateStr,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11)),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color:
                                            color.withOpacity(0.12),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(currentStatus,
                                          style: TextStyle(
                                              color: color,
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 11)),
                                    ),
                                  ]),
                                  const SizedBox(height: 8),

                                  // Product row
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        child: FancyShimmerImage(
                                          imageUrl:
                                              data['imageUrl'] ?? '',
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['productTitle'] ??
                                                  '—',
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                            Text(
                                              'By: ${data['userName'] ?? '—'}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 11),
                                            ),
                                            Text(
                                              '\$${(data['price'] as num? ?? 0).toStringAsFixed(2)}  •  Qty: ${data['quantity'] ?? 1}',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Status dropdown
                                  Row(
                                    children: [
                                      const Text('Update Status:',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: DropdownButtonFormField<
                                            String>(
                                          value: currentStatus,
                                          isDense: true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10)),
                                          ),
                                          items: [
                                            'Placed',
                                            'Processing',
                                            'Shipped',
                                            'Delivered'
                                          ]
                                              .map((s) =>
                                                  DropdownMenuItem(
                                                    value: s,
                                                    child: Text(s,
                                                        style: const TextStyle(
                                                            fontSize:
                                                                13)),
                                                  ))
                                              .toList(),
                                          onChanged: (val) async {
                                            if (val != null &&
                                                val != currentStatus) {
                                              await _updateStatus(
                                                  doc.id, val);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
