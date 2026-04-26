import 'package:flutter/material.dart';

enum UserRole { customer, vendor }

/// Simple in-memory auth provider for customer and vendor demo logins.
class AuthProvider extends ChangeNotifier {
  static const String customerUsername = 'sweetuser';
  static const String customerPassword = 'User@123';
  static const String vendorUsername = 'sweetvendor';
  static const String vendorPassword = 'Vendor@123';

  bool _isLoggedIn = false;
  UserRole? _currentRole;
  String? _currentUsername;

  bool get isLoggedIn => _isLoggedIn;
  UserRole? get currentRole => _currentRole;
  String get currentUsername => _currentUsername ?? '';
  bool get isCustomer => _currentRole == UserRole.customer;
  bool get isVendor => _currentRole == UserRole.vendor;

  bool login({
    required String username,
    required String password,
    required UserRole role,
  }) {
    final trimmedUsername = username.trim();

    final isValidUser = switch (role) {
      UserRole.customer => trimmedUsername == customerUsername,
      UserRole.vendor => trimmedUsername == vendorUsername,
    };

    final isValidPassword = switch (role) {
      UserRole.customer => password == customerPassword,
      UserRole.vendor => password == vendorPassword,
    };

    _isLoggedIn = isValidUser && isValidPassword;
    _currentRole = _isLoggedIn ? role : null;
    _currentUsername = _isLoggedIn ? trimmedUsername : null;
    notifyListeners();
    return _isLoggedIn;
  }

  void logout() {
    _isLoggedIn = false;
    _currentRole = null;
    _currentUsername = null;
    notifyListeners();
  }
}
