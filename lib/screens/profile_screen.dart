import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_provider.dart';
import '../widgets/app_side_drawer.dart';

/// Shared profile screen for both customer and vendor.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isVendor = authProvider.isVendor;
    final isAgent = authProvider.isAgent;
    final roleLabel = authProvider.currentRole == null
        ? 'Customer'
        : AuthProvider.roleLabel(authProvider.currentRole!);

    return Scaffold(
      appBar: AppBar(
        title: Text(isVendor ? 'Vendor Profile' : '$roleLabel Profile'),
      ),
      drawer: const AppSideDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      authProvider.currentUsername.isEmpty
                          ? '?'
                          : authProvider.currentUsername[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    authProvider.currentUsername,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isVendor
                        ? 'Vendor account'
                        : isAgent
                            ? 'Agent account'
                            : 'Customer account',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _ProfileItem(
              label: 'Display Name',
              value: authProvider.currentUsername,
            ),
            _ProfileItem(
              label: 'Role',
              value: roleLabel,
            ),
            _ProfileItem(
              label: 'Support',
              value: isVendor
                  ? 'Manage your sweet shop and incoming orders'
                  : isAgent
                      ? 'Order sweets on behalf of customers'
                      : 'Browse sweets and place quick COD orders',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}
