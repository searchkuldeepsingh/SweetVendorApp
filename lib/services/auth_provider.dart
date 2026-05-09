import 'package:flutter/material.dart';

enum UserRole { customer, vendor, agent }

/// Simple in-memory auth provider for customer, vendor, and agent demo logins.
class AuthProvider extends ChangeNotifier {
  static const String customerUsername = 'sweetuser';
  static const String customerPassword = 'User@123';
  static const String vendorUsername = 'sweetvendor';
  static const String vendorPassword = 'Vendor@123';
  static const String agentUsername = 'sweetagent';
  static const String agentPassword = 'Agent@123';

  bool _isLoggedIn = false;
  UserRole? _currentRole;
  String? _currentUsername;

  bool get isLoggedIn => _isLoggedIn;
  UserRole? get currentRole => _currentRole;
  String get currentUsername => _currentUsername ?? '';
  bool get isCustomer => _currentRole == UserRole.customer;
  bool get isVendor => _currentRole == UserRole.vendor;
  bool get isAgent => _currentRole == UserRole.agent;
  bool get canShop => isCustomer || isAgent;

  static String roleLabel(UserRole role) {
    return switch (role) {
      UserRole.customer => 'Customer',
      UserRole.vendor => 'Vendor',
      UserRole.agent => 'Agent',
    };
  }

  static String demoUsername(UserRole role) {
    return switch (role) {
      UserRole.customer => customerUsername,
      UserRole.vendor => vendorUsername,
      UserRole.agent => agentUsername,
    };
  }

  static String demoPassword(UserRole role) {
    return switch (role) {
      UserRole.customer => customerPassword,
      UserRole.vendor => vendorPassword,
      UserRole.agent => agentPassword,
    };
  }

  bool login({
    required String username,
    required String password,
    required UserRole role,
  }) {
    final trimmedUsername = username.trim();

    final isValidUser = switch (role) {
      UserRole.customer => trimmedUsername == customerUsername,
      UserRole.vendor => trimmedUsername == vendorUsername,
      UserRole.agent => trimmedUsername == agentUsername,
    };

    final isValidPassword = switch (role) {
      UserRole.customer => password == customerPassword,
      UserRole.vendor => password == vendorPassword,
      UserRole.agent => password == agentPassword,
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
