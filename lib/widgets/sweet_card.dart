import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/sweet_model.dart';
import '../services/cart_provider.dart';

/// Widget for displaying a single sweet product card.
class SweetCard extends StatelessWidget {
  const SweetCard({
    Key? key,
    required this.sweet,
  }) : super(key: key);

  final Sweet sweet;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.35,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  sweet.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 3),
                        Text(
                          sweet.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sweet.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    sweet.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.25,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${sweet.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, _) {
                          final isInCart = cartProvider.isInCart(sweet.id);
                          return IconButton.filled(
                            tooltip: isInCart ? 'Added to cart' : 'Add to cart',
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  isInCart ? Colors.green : Colors.deepOrange,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(38, 38),
                            ),
                            onPressed: () {
                              cartProvider.addToCart(sweet);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${sweet.name} added to cart!'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: Icon(isInCart ? Icons.check : Icons.add),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
