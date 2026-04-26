import 'package:flutter/material.dart';
import '../models/sweet_model.dart';

/// Provider for managing the shopping cart state
/// Uses ChangeNotifier pattern from the Provider package
class CartProvider extends ChangeNotifier {
  // Map to store cart items by sweet id
  final Map<String, CartItem> _cartItems = {};

  /// Get all cart items
  Map<String, CartItem> get cartItems => _cartItems;

  /// Get list of cart items
  List<CartItem> get cartItemsList => _cartItems.values.toList();

  /// Get total number of items in cart
  int get itemCount => _cartItems.values.fold(
        0,
        (previousValue, item) => previousValue + item.quantity,
      );

  /// Get total cart price
  double get totalPrice => _cartItems.values.fold(
        0.0,
        (previousValue, item) => previousValue + item.totalPrice,
      );

  /// Add a sweet to cart
  /// If sweet already exists, increment quantity
  void addToCart(Sweet sweet) {
    if (_cartItems.containsKey(sweet.id)) {
      // Sweet already in cart, increment quantity
      _cartItems[sweet.id]!.quantity++;
    } else {
      // New sweet to cart
      _cartItems[sweet.id] = CartItem(
        id: sweet.id,
        sweet: sweet,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  /// Remove a sweet from cart completely
  void removeFromCart(String sweetId) {
    _cartItems.remove(sweetId);
    notifyListeners();
  }

  /// Update quantity of an item in cart
  void updateQuantity(String sweetId, int newQuantity) {
    if (_cartItems.containsKey(sweetId)) {
      if (newQuantity <= 0) {
        removeFromCart(sweetId);
      } else {
        _cartItems[sweetId]!.quantity = newQuantity;
        notifyListeners();
      }
    }
  }

  /// Increment quantity of an item
  void incrementQuantity(String sweetId) {
    if (_cartItems.containsKey(sweetId)) {
      _cartItems[sweetId]!.quantity++;
      notifyListeners();
    }
  }

  /// Decrement quantity of an item
  void decrementQuantity(String sweetId) {
    if (_cartItems.containsKey(sweetId)) {
      _cartItems[sweetId]!.quantity--;
      if (_cartItems[sweetId]!.quantity <= 0) {
        removeFromCart(sweetId);
      } else {
        notifyListeners();
      }
    }
  }

  /// Clear entire cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  /// Check if sweet is in cart
  bool isInCart(String sweetId) => _cartItems.containsKey(sweetId);

  /// Get quantity of a specific sweet in cart
  int getQuantity(String sweetId) {
    return _cartItems[sweetId]?.quantity ?? 0;
  }
}
