import 'sweet_model.dart';

enum PaymentMethod { cashOnDelivery }

enum OrderStatus { placed, confirmed }

/// Basic order model for vendor order tracking.
class SweetOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime placedAt;
  final PaymentMethod paymentMethod;
  final OrderStatus status;

  SweetOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.items,
    required this.totalAmount,
    required this.placedAt,
    required this.paymentMethod,
    required this.status,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}
