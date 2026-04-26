import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_provider.dart';

/// Shared login screen with tabs for customer and vendor access.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  UserRole _selectedRole = UserRole.customer;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _switchRole(int index) {
    setState(() {
      _selectedRole = UserRole.values[index];
      _usernameController.clear();
      _passwordController.clear();
    });
  }

  void _submitLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final loggedIn = authProvider.login(
      username: _usernameController.text,
      password: _passwordController.text,
      role: _selectedRole,
    );

    if (!loggedIn) {
      final roleLabel = _selectedRole == UserRole.customer
          ? 'customer'
          : 'vendor';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Invalid $roleLabel credentials. Try the demo credentials below.',
          ),
        ),
      );
      return;
    }

    final targetRoute =
        _selectedRole == UserRole.customer ? '/home' : '/vendor-orders';
    Navigator.of(context).pushReplacementNamed(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    final isCustomer = _selectedRole == UserRole.customer;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE6CF),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -40,
            child: _GlowOrb(
              size: 260,
              colors: const [Color(0xFFFFC27A), Color(0xFFFF8C42)],
            ),
          ),
          Positioned(
            bottom: -130,
            right: -30,
            child: _GlowOrb(
              size: 280,
              colors: const [Color(0xFFFFD9B5), Color(0xFFFFB067)],
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF4EE).withOpacity(0.94),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.65),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrange.withOpacity(0.12),
                          blurRadius: 30,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            Container(
                              width: 78,
                              height: 78,
                              margin: const EdgeInsets.only(bottom: 18),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF7B34),
                                    Color(0xFFFF5A1F),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepOrange.withOpacity(0.25),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.cake_rounded,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                            const Text(
                              'Welcome to Sweet Mart',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 31,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2F2623),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Choose a role and continue with the right dashboard.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: Color(0xFF7F6B63),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF2DF),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: const Color(0xFFFFE2BF),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _RoleSegment(
                                      title: 'Customer',
                                      icon: Icons.shopping_bag_outlined,
                                      isSelected: isCustomer,
                                      onTap: () => _switchRole(0),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _RoleSegment(
                                      title: 'Vendor',
                                      icon: Icons.storefront_outlined,
                                      isSelected: !isCustomer,
                                      onTap: () => _switchRole(1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            _InfoBanner(
                              icon: isCustomer
                                  ? Icons.shopping_bag_outlined
                                  : Icons.receipt_long_outlined,
                              title: isCustomer
                                  ? 'Order sweets in a few taps'
                                  : 'Track incoming orders instantly',
                              subtitle: isCustomer
                                  ? 'Browse sweets, add to cart, and place a cash on delivery order.'
                                  : 'Monitor customer orders with delivery details and payment mode.',
                            ),
                            const SizedBox(height: 22),
                            TextFormField(
                              controller: _usernameController,
                              decoration: _inputDecoration(
                                isCustomer
                                    ? 'Customer Username'
                                    : 'Vendor Username',
                                Icons.person_outline,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter your username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: _inputDecoration(
                                isCustomer
                                    ? 'Customer Password'
                                    : 'Vendor Password',
                                Icons.lock_outline,
                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 22),
                            ElevatedButton(
                              onPressed: _submitLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Text(
                                isCustomer
                                    ? 'Login as Customer'
                                    : 'Login as Vendor',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFF5E7),
                                    Color(0xFFFFF0D7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: const Color(0xFFFFD8A8)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Demo Credentials',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    isCustomer
                                        ? 'Username: ${AuthProvider.customerUsername}'
                                        : 'Username: ${AuthProvider.vendorUsername}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF4A3B35),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isCustomer
                                        ? 'Password: ${AuthProvider.customerPassword}'
                                        : 'Password: ${AuthProvider.vendorPassword}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF4A3B35),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF7F6B63)),
      prefixIcon: Icon(icon, color: const Color(0xFF7F6B63)),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFFFFBF7),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFD9C1B3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.deepOrange,
          width: 1.5,
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.colors,
  });

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}

class _RoleSegment extends StatelessWidget {
  const _RoleSegment({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                colors: [
                  Color(0xFFFF7B34),
                  Color(0xFFFF5A1F),
                ],
              )
            : null,
        color: isSelected ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.deepOrange,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.deepOrange,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.deepOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF3E2E28),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF7F6B63),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
