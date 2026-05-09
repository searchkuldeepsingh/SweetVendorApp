import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/order_model.dart';
import '../models/sweet_model.dart';

class SupabaseApiClient {
  SupabaseApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  bool get isConfigured => ApiConfig.hasSupabaseConfig;

  Uri _uri(String path, [Map<String, String>? queryParameters]) {
    final base = ApiConfig.supabaseUrl.endsWith('/')
        ? ApiConfig.supabaseUrl.substring(0, ApiConfig.supabaseUrl.length - 1)
        : ApiConfig.supabaseUrl;
    return Uri.parse('$base/rest/v1/$path').replace(
      queryParameters: queryParameters,
    );
  }

  Map<String, String> get _headers => {
        'apikey': ApiConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${ApiConfig.supabaseAnonKey}',
        'Content-Type': 'application/json',
      };

  Future<List<Sweet>> fetchSweets() async {
    if (!isConfigured) {
      return const [];
    }

    final response = await _httpClient.get(
      _uri('sweets', {
        'select': '*',
        'order': 'review_count.desc,name.asc',
      }),
      headers: _headers,
    );
    _throwIfFailed(response);

    final rows = jsonDecode(response.body) as List<dynamic>;
    return rows
        .map((row) => Sweet.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<List<SweetOrder>> fetchOrders() async {
    if (!isConfigured) {
      return const [];
    }

    final response = await _httpClient.get(
      _uri('orders', {
        'select': '*,order_items(*)',
        'order': 'placed_at.desc',
      }),
      headers: _headers,
    );
    _throwIfFailed(response);

    final rows = jsonDecode(response.body) as List<dynamic>;
    return rows
        .map((row) => _orderFromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<SweetOrder> insertOrder(SweetOrder order) async {
    if (!isConfigured) {
      return order;
    }

    final orderResponse = await _httpClient.post(
      _uri('orders'),
      headers: {
        ..._headers,
        'Prefer': 'return=representation',
      },
      body: jsonEncode(_orderToJson(order)),
    );
    _throwIfFailed(orderResponse);

    final insertedOrderRows = jsonDecode(orderResponse.body) as List<dynamic>;
    final insertedOrder = insertedOrderRows.first as Map<String, dynamic>;
    final insertedOrderId = insertedOrder['id'].toString();

    if (order.items.isNotEmpty) {
      final itemsResponse = await _httpClient.post(
        _uri('order_items'),
        headers: {
          ..._headers,
          'Prefer': 'return=minimal',
        },
        body: jsonEncode(
          order.items.map((item) {
            return {
              'order_id': insertedOrderId,
              'sweet_id': item.sweet.id,
              'sweet_name': item.sweet.name,
              'sweet_price': item.sweet.price,
              'quantity': item.quantity,
            };
          }).toList(),
        ),
      );
      _throwIfFailed(itemsResponse);
    }

    return SweetOrder(
      id: insertedOrderId,
      customerName: order.customerName,
      customerPhone: order.customerPhone,
      deliveryAddress: order.deliveryAddress,
      placedByUsername: order.placedByUsername,
      placedByRole: order.placedByRole,
      items: order.items,
      totalAmount: order.totalAmount,
      placedAt: order.placedAt,
      paymentMethod: order.paymentMethod,
      status: order.status,
    );
  }

  SweetOrder _orderFromJson(Map<String, dynamic> json) {
    final orderItems = json['order_items'] as List<dynamic>? ?? const [];
    return SweetOrder(
      id: json['id'].toString(),
      customerName: json['customer_name'] as String? ?? '',
      customerPhone: json['customer_phone'] as String? ?? '',
      deliveryAddress: json['delivery_address'] as String? ?? '',
      placedByUsername: json['placed_by_username'] as String? ?? '',
      placedByRole: UserOrderSourceApi.fromApiValue(
        json['placed_by_role'] as String?,
      ),
      items: orderItems.map((itemJson) {
        final item = itemJson as Map<String, dynamic>;
        final sweetPrice = (item['sweet_price'] as num?)?.toDouble() ?? 0;
        return CartItem(
          id: item['sweet_id'].toString(),
          sweet: Sweet(
            id: item['sweet_id'].toString(),
            name: item['sweet_name'] as String? ?? '',
            price: sweetPrice,
            imageUrl: '',
            description: '',
          ),
          quantity: (item['quantity'] as num?)?.toInt() ?? 1,
        );
      }).toList(),
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      placedAt: DateTime.tryParse(json['placed_at'] as String? ?? '') ??
          DateTime.now(),
      paymentMethod: PaymentMethodApi.fromApiValue(
        json['payment_method'] as String?,
      ),
      status: OrderStatusApi.fromApiValue(json['status'] as String?),
    );
  }

  Map<String, dynamic> _orderToJson(SweetOrder order) {
    return {
      'id': order.id,
      'customer_name': order.customerName,
      'customer_phone': order.customerPhone,
      'delivery_address': order.deliveryAddress,
      'placed_by_username': order.placedByUsername,
      'placed_by_role': order.placedByRole.apiValue,
      'total_amount': order.totalAmount,
      'placed_at': order.placedAt.toIso8601String(),
      'payment_method': order.paymentMethod.apiValue,
      'status': order.status.apiValue,
    };
  }

  void _throwIfFailed(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw Exception(
      'Supabase request failed with ${response.statusCode}: ${response.body}',
    );
  }
}
