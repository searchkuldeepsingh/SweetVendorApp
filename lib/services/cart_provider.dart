import 'package:flutter/foundation.dart';
import '../models/sweet_model.dart';

/// Provider class managing cart state for the Sweet Mart app.
/// Uses ChangeNotifier from provider package.
class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  /// Returns a copy of all items in the cart.
  Map<String, CartItem> get items => Map.unmodifiable(_items);

  /// Returns a list of cart items for list views.
  List<CartItem> get itemsList => _items.values.toList();

  /// Returns the total number of items in the cart.
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  /// Returns the total cart value.
  double get totalPrice => _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Adds the provided sweet to the cart.
  void addToCart(Sweet sweet) {
    if (_items.containsKey(sweet.id)) {
      _items[sweet.id]!.quantity++;
    } else {
      _items[sweet.id] = CartItem(id: sweet.id, sweet: sweet, quantity: 1);
    }
    notifyListeners();
  }

  /// Removes a cart item completely.
  void removeFromCart(String sweetId) {
    _items.remove(sweetId);
    notifyListeners();
  }

  /// Increments quantity for an existing cart item.
  void incrementQuantity(String sweetId) {
    if (_items.containsKey(sweetId)) {
      _items[sweetId]!.quantity++;
      notifyListeners();
    }
  }

  /// Decrements quantity for an existing cart item.
  void decrementQuantity(String sweetId) {
    if (!_items.containsKey(sweetId)) return;

    final item = _items[sweetId]!;
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    } else {
      removeFromCart(sweetId);
    }
  }

  /// Checks if a sweet is already in the cart.
  bool isInCart(String sweetId) => _items.containsKey(sweetId);

  /// Clears the entire cart.
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
