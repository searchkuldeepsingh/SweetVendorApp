import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sweet_model.dart';
import '../services/cart_provider.dart';

/// Widget for displaying a single item in the cart
class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const CartItemCard({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: Image.asset(
                  cartItem.sweet.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.sweet.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${cartItem.sweet.price.toStringAsFixed(0)} each',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ₹${cartItem.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Increment Button
                Consumer<CartProvider>(
                  builder: (context, cartProvider, _) {
                    return InkWell(
                      onTap: () {
                        cartProvider.incrementQuantity(cartItem.sweet.id);
                      },
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.deepOrange,
                        size: 24,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 4),

                // Quantity Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepOrange),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${cartItem.quantity}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Decrement Button
                Consumer<CartProvider>(
                  builder: (context, cartProvider, _) {
                    return InkWell(
                      onTap: () {
                        cartProvider.decrementQuantity(cartItem.sweet.id);
                      },
                      child: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.deepOrange,
                        size: 24,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(width: 8),

            // Delete Button
            Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                return InkWell(
                  onTap: () {
                    cartProvider.removeFromCart(cartItem.sweet.id);
                  },
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 24,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
