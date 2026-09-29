import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_ecommerce_app/models/order_model.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';

class OrdersWidgetFree extends StatelessWidget {
  const OrdersWidgetFree({super.key, required this.ordersModelAdvanced});
  final OrdersModelAdvanced ordersModelAdvanced;

  static const _statusConfig = {
    'Placed': [Colors.blue, Icons.receipt_long_outlined],
    'Processing': [Colors.orange, Icons.hourglass_empty],
    'Shipped': [Colors.indigo, Icons.local_shipping_outlined],
    'Delivered': [Colors.green, Icons.check_circle_outline],
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final status = ordersModelAdvanced.status ?? 'Placed';
    final statusColor =
        (_statusConfig[status]?[0] as Color?) ?? Colors.blue;
    final statusIcon =
        (_statusConfig[status]?[1] as IconData?) ?? Icons.receipt_long_outlined;

    // Format date
    final date = ordersModelAdvanced.orderDate.toDate();
    final dateStr =
        '${date.day}/${date.month}/${date.year}';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: status badge + date
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(dateStr,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 10),

            // Product row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FancyShimmerImage(
                    height: size.width * 0.22,
                    width: size.width * 0.22,
                    imageUrl: ordersModelAdvanced.imageUrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitlesTextWidget(
                        label: ordersModelAdvanced.productTitle,
                        maxLines: 2,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          SubtitleTextWidget(
                            label: '\$${ordersModelAdvanced.price}',
                            fontSize: 15,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          const Spacer(),
                          SubtitleTextWidget(
                            label: 'Qty: ${ordersModelAdvanced.quantity}',
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Status timeline
                      _StatusTimeline(currentStatus: status),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.currentStatus});
  final String currentStatus;

  static const _steps = ['Placed', 'Processing', 'Shipped', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    final currentIdx = _steps.indexOf(currentStatus);
    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // connector line
          final stepIdx = i ~/ 2;
          final done = stepIdx < currentIdx;
          return Expanded(
            child: Container(
              height: 2,
              color: done ? Colors.green : Colors.grey.shade300,
            ),
          );
        } else {
          final stepIdx = i ~/ 2;
          final done = stepIdx <= currentIdx;
          return Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? Colors.green : Colors.grey.shade300,
            ),
          );
        }
      }),
    );
  }
}