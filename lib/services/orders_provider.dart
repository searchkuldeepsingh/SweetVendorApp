import 'package:flutter/foundation.dart';

import '../models/order_model.dart';
import '../models/sweet_model.dart';

/// Stores customer orders in memory for the vendor view.
class OrdersProvider extends ChangeNotifier {
  final List<SweetOrder> _orders = [];

  List<SweetOrder> get realOrders => List.unmodifiable(_orders);

  List<SweetOrder> get orders {
    if (_orders.isNotEmpty) {
      return List.unmodifiable(_orders);
    }

    return List.unmodifiable([_demoOrder]);
  }

  void placeOrder({
    required String customerName,
    required String customerPhone,
    required String deliveryAddress,
    required List<CartItem> cartItems,
    required double totalAmount,
  }) {
    final clonedItems = cartItems
        .map(
          (item) => item.copyWith(
            sweet: item.sweet.copyWith(),
            quantity: item.quantity,
          ),
        )
        .toList();

    _orders.insert(
      0,
      SweetOrder(
        id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        customerName: customerName,
        customerPhone: customerPhone,
        deliveryAddress: deliveryAddress,
        items: clonedItems,
        totalAmount: totalAmount,
        placedAt: DateTime.now(),
        paymentMethod: PaymentMethod.cashOnDelivery,
        status: OrderStatus.placed,
      ),
    );

    notifyListeners();
  }

  SweetOrder get _demoOrder => SweetOrder(
        id: 'ORD-DEMO-1001',
        customerName: 'demo_customer',
        customerPhone: '9876543210',
        deliveryAddress: '221 Sweet Street, Dessert Nagar, Mumbai',
        items: const [],
        totalAmount: 399,
        placedAt: DateTime.now().subtract(const Duration(hours: 2)),
        paymentMethod: PaymentMethod.cashOnDelivery,
        status: OrderStatus.confirmed,
      );
}
