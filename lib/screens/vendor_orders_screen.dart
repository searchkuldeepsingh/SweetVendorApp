import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../services/orders_provider.dart';
import '../widgets/app_side_drawer.dart';

/// Vendor dashboard for reviewing customer orders.
class VendorOrdersScreen extends StatelessWidget {
  const VendorOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;

    return Scaffold(
      drawer: const AppSideDrawer(),
      appBar: AppBar(
        title: const Text('Vendor Orders'),
      ),
      body: orders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 88,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Once a customer checks out, the order will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderCard(
                  order: order,
                  isDemo: order.id.startsWith('ORD-DEMO-'),
                );
              },
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.isDemo,
  });

  final SweetOrder order;
  final bool isDemo;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  '₹${order.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (isDemo)
                  Chip(
                    label: const Text('Sample History'),
                    backgroundColor: Colors.blueGrey.shade50,
                  ),
                Chip(
                  label: Text(_paymentLabel(order.paymentMethod)),
                  backgroundColor: Colors.orange.shade50,
                ),
                Chip(
                  label: Text(_statusLabel(order.status)),
                  backgroundColor: Colors.green.shade50,
                ),
                if (order.placedByRole == UserOrderSource.agent)
                  Chip(
                    label: Text('Agent: ${order.placedByUsername}'),
                    backgroundColor: Colors.purple.shade50,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Customer: ${order.customerName}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Mobile: ${order.customerPhone}',
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Text(
              'Placed: ${_formatDateTime(order.placedAt)}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 10),
            Text(
              'Delivery Address',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.brown.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              order.deliveryAddress,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 12),
            if (order.items.isEmpty)
              const Text(
                'Sample vendor order history will be replaced once real orders are placed.',
                style: TextStyle(color: Colors.black54),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: order.items
                    .map(
                      (item) => Chip(
                        label: Text('${item.sweet.name} x${item.quantity}'),
                        backgroundColor: Colors.orange.shade50,
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 12),
            Text(
              'Items: ${order.totalItems}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDateTime(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.hour >= 12 ? 'PM' : 'AM';
    return '${value.day}/${value.month}/${value.year} $hour:$minute $period';
  }

  static String _paymentLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
    }
  }

  static String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
    }
  }
}
