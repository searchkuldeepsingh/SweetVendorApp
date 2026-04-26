import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sweet_model.dart';
import '../services/cart_provider.dart';

/// Product details screen showing a large image and detailed description.
class ProductDetailsScreen extends StatelessWidget {
  final Sweet sweet;

  const ProductDetailsScreen({
    Key? key,
    required this.sweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  sweet.imageUrl,
                  height: 280,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 280,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                sweet.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '₹${sweet.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[600], size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '${sweet.rating} • ${sweet.reviewCount} reviews',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                sweet.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 32),
              Consumer<CartProvider>(
                builder: (context, cartProvider, _) {
                  final inCart = cartProvider.isInCart(sweet.id);
                  return ElevatedButton.icon(
                    onPressed: () {
                      cartProvider.addToCart(sweet);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            inCart ? 'Added another ${sweet.name} to cart' : '${sweet.name} added to cart',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(inCart ? 'Add More to Cart' : 'Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
