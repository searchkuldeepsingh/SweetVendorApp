import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../services/auth_provider.dart';
import '../services/orders_provider.dart';
import '../widgets/app_side_drawer.dart';

/// Payments screen for customer and vendor flows.
class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isVendor = context.watch<AuthProvider>().isVendor;
    return isVendor
        ? const _VendorPaymentsScreen()
        : const _CustomerPaymentsScreen();
  }
}

class _CustomerPaymentsScreen extends StatelessWidget {
  const _CustomerPaymentsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
      ),
      drawer: const AppSideDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF1E1), Color(0xFFFFDFC0)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your orders currently use Cash on Delivery. Online payment options can be added later.',
                    style: TextStyle(
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Card(
              child: ListTile(
                leading: Icon(
                  Icons.payments_outlined,
                  color: Colors.deepOrange,
                ),
                title: Text('Cash on Delivery'),
                subtitle: Text('Pay when the sweets reach your doorstep'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorPaymentsScreen extends StatelessWidget {
  const _VendorPaymentsScreen();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();
    final orders = provider.realOrders.isNotEmpty
        ? provider.realOrders
        : _sampleVendorOrders;
    final receivedOrders = orders
        .where((order) => order.status == OrderStatus.confirmed)
        .toList();
    final pendingOrders = orders
        .where((order) => order.status != OrderStatus.confirmed)
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vendor Payments'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Received'),
              Tab(text: 'Pending'),
            ],
          ),
        ),
        drawer: const AppSideDrawer(),
        body: TabBarView(
          children: [
            _PaymentsList(
              emptyTitle: 'No received payments',
              emptyMessage: 'Completed payments will appear here.',
              orders: receivedOrders,
              isPending: false,
            ),
            _PaymentsList(
              emptyTitle: 'No pending payments',
              emptyMessage: 'Pending collections will appear here.',
              orders: pendingOrders,
              isPending: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentsList extends StatelessWidget {
  const _PaymentsList({
    required this.orders,
    required this.isPending,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  final List<SweetOrder> orders;
  final bool isPending;
  final String emptyTitle;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPending
                    ? Icons.pending_actions_outlined
                    : Icons.payments_outlined,
                size: 82,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                emptyTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _PaymentOrderCard(
          order: orders[index],
          isPending: isPending,
        );
      },
    );
  }
}

class _PaymentOrderCard extends StatelessWidget {
  const _PaymentOrderCard({
    required this.order,
    required this.isPending,
  });

  final SweetOrder order;
  final bool isPending;

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
              children: [
                Expanded(
                  child: Text(
                    order.id,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _StatusBadge(
                  label: isPending ? 'PENDING' : 'PAID',
                  color: isPending ? Colors.deepOrange : Colors.green,
                  backgroundColor:
                      isPending ? Colors.orange.shade50 : Colors.green.shade50,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Customer Name: ${order.customerName}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('Items: ${_itemNames(order)}'),
            const SizedBox(height: 8),
            Text(
              isPending
                  ? 'Amount Due: ₹${order.totalAmount.toStringAsFixed(0)}'
                  : 'Total Amount: ₹${order.totalAmount.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (isPending)
              Text('Delivery Status: ${_deliveryStatusLabel(order.status)}')
            else
              Text('Payment Method: ${_paymentMethodLabel(order.paymentMethod)}'),
            const SizedBox(height: 8),
            Text('Date: ${_formatDate(order.placedAt)}'),
          ],
        ),
      ),
    );
  }

  static String _itemNames(SweetOrder order) {
    if (order.items.isEmpty) {
      return 'Assorted sweets';
    }
    return order.items.map((item) => item.sweet.name).join(', ');
  }

  static String _paymentMethodLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cashOnDelivery:
        return 'Cash';
    }
  }

  static String _deliveryStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Out for collection';
      case OrderStatus.confirmed:
        return 'Delivered';
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

final List<SweetOrder> _sampleVendorOrders = [
  SweetOrder(
    id: 'ORD-PAID-1042',
    customerName: 'Aarav Shah',
    customerPhone: '9876543210',
    deliveryAddress: '12 Rose Avenue, Pune',
    items: const [],
    totalAmount: 540,
    placedAt: DateTime(2026, 4, 21),
    paymentMethod: PaymentMethod.cashOnDelivery,
    status: OrderStatus.confirmed,
  ),
  SweetOrder(
    id: 'ORD-PENDING-1048',
    customerName: 'Neha Verma',
    customerPhone: '9988776655',
    deliveryAddress: '44 Lake View, Delhi',
    items: const [],
    totalAmount: 320,
    placedAt: DateTime(2026, 4, 24),
    paymentMethod: PaymentMethod.cashOnDelivery,
    status: OrderStatus.placed,
  ),
];
