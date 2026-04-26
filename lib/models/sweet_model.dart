/// Model class representing a sweet product
class Sweet {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final double rating;
  final int reviewCount;

  Sweet({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.rating = 4.5,
    this.reviewCount = 0,
  });

  /// Create a copy of Sweet with modified fields
  Sweet copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? description,
    double? rating,
    int? reviewCount,
  }) {
    return Sweet(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  @override
  String toString() => 'Sweet(id: $id, name: $name, price: $price)';
}

/// Model class for cart items
class CartItem {
  final String id;
  final Sweet sweet;
  int quantity;

  CartItem({
    required this.id,
    required this.sweet,
    this.quantity = 1,
  });

  /// Calculate total price for this cart item
  double get totalPrice => sweet.price * quantity;

  /// Create a copy of CartItem with modified fields
  CartItem copyWith({
    String? id,
    Sweet? sweet,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      sweet: sweet ?? this.sweet,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() => 'CartItem(id: $id, quantity: $quantity, totalPrice: $totalPrice)';
}
