import 'package:flutter/foundation.dart';

import '../models/order_model.dart';
import '../models/sweet_model.dart';
import 'supabase_api_client.dart';

/// Stores customer orders and syncs them with Supabase when configured.
class OrdersProvider extends ChangeNotifier {
  OrdersProvider({SupabaseApiClient? apiClient})
      : _apiClient = apiClient ?? SupabaseApiClient();

  final SupabaseApiClient _apiClient;
  final List<SweetOrder> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SweetOrder> get realOrders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<SweetOrder> get orders {
    if (_orders.isNotEmpty) {
      return List.unmodifiable(_orders);
    }

    return List.unmodifiable([_demoOrder]);
  }

  Future<void> loadOrders() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final remoteOrders = await _apiClient.fetchOrders();
      if (remoteOrders.isNotEmpty) {
        _orders
          ..clear()
          ..addAll(remoteOrders);
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> placeOrder({
    required String customerName,
    required String customerPhone,
    required String deliveryAddress,
    required String placedByUsername,
    required UserOrderSource placedByRole,
    required List<CartItem> cartItems,
    required double totalAmount,
  }) async {
    final clonedItems = cartItems
        .map(
          (item) => item.copyWith(
            sweet: item.sweet.copyWith(),
            quantity: item.quantity,
          ),
        )
        .toList();

    final pendingOrder = SweetOrder(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      customerName: customerName,
      customerPhone: customerPhone,
      deliveryAddress: deliveryAddress,
      placedByUsername: placedByUsername,
      placedByRole: placedByRole,
      items: clonedItems,
      totalAmount: totalAmount,
      placedAt: DateTime.now(),
      paymentMethod: PaymentMethod.cashOnDelivery,
      status: OrderStatus.placed,
    );

    _orders.insert(0, pendingOrder);
    notifyListeners();

    try {
      final syncedOrder = await _apiClient.insertOrder(pendingOrder);
      final index = _orders.indexWhere((order) => order.id == pendingOrder.id);
      if (index != -1) {
        _orders[index] = syncedOrder;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  SweetOrder get _demoOrder => SweetOrder(
        id: 'ORD-DEMO-1001',
        customerName: 'demo_customer',
        customerPhone: '9876543210',
        deliveryAddress: '221 Sweet Street, Dessert Nagar, Mumbai',
        placedByUsername: 'demo_customer',
        placedByRole: UserOrderSource.customer,
        items: const [],
        totalAmount: 399,
        placedAt: DateTime.now().subtract(const Duration(hours: 2)),
        paymentMethod: PaymentMethod.cashOnDelivery,
        status: OrderStatus.confirmed,
      );
}
