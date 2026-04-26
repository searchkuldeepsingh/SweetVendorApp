import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_provider.dart';
import '../services/cart_provider.dart';

/// Shared app drawer for customer and vendor flows.
class AppSideDrawer extends StatelessWidget {
  const AppSideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isVendor = authProvider.isVendor;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF7B34), Color(0xFFFF5A1F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepOrange.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cake_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authProvider.currentUsername,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isVendor ? 'Vendor Account' : 'Customer Account',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  if (!isVendor)
                    _DrawerTile(
                      icon: Icons.storefront_outlined,
                      label: 'Browse Sweets',
                      onTap: () => _go(context, '/home'),
                    ),
                  _DrawerTile(
                    icon: Icons.receipt_long_outlined,
                    label: isVendor ? 'Order History' : 'My Orders',
                    onTap: () =>
                        _go(context, isVendor ? '/vendor-orders' : '/my-orders'),
                  ),
                  if (!isVendor)
                    _DrawerTile(
                      icon: Icons.shopping_cart_outlined,
                      label: 'Cart',
                      onTap: () => _go(context, '/cart'),
                    ),
                  if (isVendor)
                    _DrawerTile(
                      icon: Icons.payments_outlined,
                      label: 'Payments',
                      onTap: () => _go(context, '/vendor-payments'),
                    ),
                  _DrawerTile(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    onTap: () =>
                        _go(context, isVendor ? '/vendor-profile' : '/profile'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _DrawerTile(
                icon: Icons.logout,
                label: 'Logout',
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<CartProvider>().clearCart();
                  context.read<AuthProvider>().logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _go(BuildContext context, String routeName) {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(routeName);
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onTap: onTap,
    );
  }
}
