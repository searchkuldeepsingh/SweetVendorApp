import 'sweet_model.dart';

enum PaymentMethod { cashOnDelivery }

enum OrderStatus { placed, confirmed }

extension PaymentMethodApi on PaymentMethod {
  String get apiValue {
    return switch (this) {
      PaymentMethod.cashOnDelivery => 'cash_on_delivery',
    };
  }

  static PaymentMethod fromApiValue(String? value) {
    return switch (value) {
      'cash_on_delivery' || 'cashOnDelivery' => PaymentMethod.cashOnDelivery,
      _ => PaymentMethod.cashOnDelivery,
    };
  }
}

extension OrderStatusApi on OrderStatus {
  String get apiValue {
    return switch (this) {
      OrderStatus.placed => 'placed',
      OrderStatus.confirmed => 'confirmed',
    };
  }

  static OrderStatus fromApiValue(String? value) {
    return switch (value) {
      'confirmed' => OrderStatus.confirmed,
      _ => OrderStatus.placed,
    };
  }
}

extension UserOrderSourceApi on UserOrderSource {
  String get apiValue {
    return switch (this) {
      UserOrderSource.customer => 'customer',
      UserOrderSource.agent => 'agent',
    };
  }

  static UserOrderSource fromApiValue(String? value) {
    return switch (value) {
      'agent' => UserOrderSource.agent,
      _ => UserOrderSource.customer,
    };
  }
}

/// Basic order model for vendor order tracking.
class SweetOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String placedByUsername;
  final UserOrderSource placedByRole;
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
    required this.placedByUsername,
    required this.placedByRole,
    required this.items,
    required this.totalAmount,
    required this.placedAt,
    required this.paymentMethod,
    required this.status,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}

enum UserOrderSource { customer, agent }
