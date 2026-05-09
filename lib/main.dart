import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'models/sweet_model.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/customer_orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/payments_screen.dart';
import 'screens/vendor_orders_screen.dart';
import 'services/auth_provider.dart';
import 'services/cart_provider.dart';
import 'services/orders_provider.dart';

/// Main entry point for the Sweet Mart application.
void main() {
  runApp(const SweetMartApp());
}

/// Root widget for the Sweet Mart application.
class SweetMartApp extends StatelessWidget {
  const SweetMartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: MaterialApp(
        title: 'Sweet Mart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 3,
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => _buildProtectedScreen(
                context,
                const HomeScreen(),
                allowedRoles: const {UserRole.customer, UserRole.agent},
              ),
          '/cart': (context) => _buildProtectedScreen(
                context,
                const CartScreen(),
                allowedRoles: const {UserRole.customer, UserRole.agent},
              ),
          '/my-orders': (context) => _buildProtectedScreen(
                context,
                const CustomerOrdersScreen(),
                allowedRoles: const {UserRole.customer, UserRole.agent},
              ),
          '/profile': (context) => _buildProtectedScreen(
                context,
                const ProfileScreen(),
                allowedRoles: const {UserRole.customer, UserRole.agent},
              ),
          '/payments': (context) => _buildProtectedScreen(
                context,
                const PaymentsScreen(),
                allowedRoles: const {UserRole.customer, UserRole.agent},
              ),
          '/checkout': (context) => _buildProtectedScreen(
                context,
                const CheckoutScreen(),
                allowedRoles: const {UserRole.customer, UserRole.agent},
              ),
          '/vendor-orders': (context) => _buildProtectedScreen(
                context,
                const VendorOrdersScreen(),
                allowedRoles: const {UserRole.vendor},
              ),
          '/vendor-profile': (context) => _buildProtectedScreen(
                context,
                const ProfileScreen(),
                allowedRoles: const {UserRole.vendor},
              ),
          '/vendor-payments': (context) => _buildProtectedScreen(
                context,
                const PaymentsScreen(),
                allowedRoles: const {UserRole.vendor},
              ),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            return MaterialPageRoute(
              builder: (context) {
                final authProvider = context.watch<AuthProvider>();
                final hasAccess =
                    authProvider.isLoggedIn && authProvider.canShop;
                if (!hasAccess) {
                  return const LoginScreen();
                }

                final sweet = settings.arguments as Sweet;
                return ProductDetailsScreen(sweet: sweet);
              },
            );
          }
          return null;
        },
      ),
    );
  }

  static Widget _buildProtectedScreen(
    BuildContext context,
    Widget child, {
    required Set<UserRole> allowedRoles,
  }) {
    final authProvider = context.watch<AuthProvider>();
    final hasAccess = authProvider.isLoggedIn &&
        allowedRoles.contains(authProvider.currentRole);
    return hasAccess ? child : const LoginScreen();
  }
}
