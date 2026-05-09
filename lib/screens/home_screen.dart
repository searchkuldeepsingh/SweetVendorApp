import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dummy_data.dart';
import '../services/cart_provider.dart';
import '../widgets/app_side_drawer.dart';
import '../widgets/sweet_card.dart';

/// Home Screen that displays the list of sweets in a grid.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 700 ? 3 : 2;

    return Scaffold(
      drawer: const AppSideDrawer(),
      appBar: AppBar(
        title: const Text('Sweet Mart'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cart');
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
                if (cartProvider.itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartProvider.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover Delicious Sweets',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Pick your favorite treat and add it to the cart.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: dummySweetsData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final sweet = dummySweetsData[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/details', arguments: sweet);
                    },
                    child: SweetCard(sweet: sweet),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.shopping_cart),
        label: Text('Cart (${cartProvider.itemCount})'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
