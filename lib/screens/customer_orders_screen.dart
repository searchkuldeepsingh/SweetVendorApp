import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../services/auth_provider.dart';
import '../services/orders_provider.dart';
import '../widgets/app_side_drawer.dart';

/// Customer screen for reviewing their placed orders.
class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final allOrders = context.watch<OrdersProvider>().realOrders;
    final orders = allOrders
        .where((order) => order.customerName == authProvider.currentUsername)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Order History')),
      drawer: const AppSideDrawer(),
      body: orders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 88,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'No order history yet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your past customer orders will appear here after checkout.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _CustomerOrderCard(order: order);
              },
            ),
    );
  }
}

class _CustomerOrderCard extends StatelessWidget {
  const _CustomerOrderCard({required this.order});

  final SweetOrder order;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.id,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text('Total: ₹${order.totalAmount.toStringAsFixed(0)}'),
            const SizedBox(height: 6),
            Text('Status: ${order.status == OrderStatus.placed ? 'Order Placed' : 'Confirmed'}'),
            const SizedBox(height: 6),
            Text('Payment: ${order.paymentMethod == PaymentMethod.cashOnDelivery ? 'Cash on Delivery' : ''}'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: order.items
                  .map((item) => Chip(label: Text('${item.sweet.name} x${item.quantity}')))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
