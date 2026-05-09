import 'package:flutter/foundation.dart';

import '../models/dummy_data.dart';
import '../models/sweet_model.dart';
import 'supabase_api_client.dart';

class SweetsProvider extends ChangeNotifier {
  SweetsProvider({SupabaseApiClient? apiClient})
      : _apiClient = apiClient ?? SupabaseApiClient();

  final SupabaseApiClient _apiClient;
  List<Sweet> _sweets = List.of(dummySweetsData);
  bool _isLoading = false;
  String? _errorMessage;

  List<Sweet> get sweets => List.unmodifiable(_sweets);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isUsingRemoteData =>
      _apiClient.isConfigured && _errorMessage == null;

  Future<void> loadSweets() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final remoteSweets = await _apiClient.fetchSweets();
      if (remoteSweets.isNotEmpty) {
        _sweets = remoteSweets;
      }
    } catch (error) {
      _errorMessage = error.toString();
      _sweets = List.of(dummySweetsData);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
