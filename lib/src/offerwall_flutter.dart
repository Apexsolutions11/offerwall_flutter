import 'package:shared_preferences/shared_preferences.dart';
import 'package:offerwall_flutter/src/models/offer.dart';
import 'package:offerwall_flutter/src/models/user.dart';
import 'package:offerwall_flutter/src/models/offer_detail.dart';
import 'package:offerwall_flutter/src/services/offerwall_api_service.dart';

class OfferwallFlutter {
  final OfferwallApiService _apiService;
  String? _baseUrl;
  String? _userId;
  String? _authToken;

  OfferwallFlutter._({OfferwallApiService? apiService})
      : _apiService = apiService ?? OfferwallApiService();

  static OfferwallFlutter? _instance;

  /// Get the singleton instance of OfferwallFlutter
  static OfferwallFlutter get instance {
    _instance ??= OfferwallFlutter._();
    return _instance!;
  }

  /// Initialize the plugin with base URL
  /// 
  /// [baseUrl] - The base URL of your offerwall web app (e.g., 'https://your-domain.com')
  Future<void> initialize({required String baseUrl}) async {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    _apiService.initialize(baseUrl: _baseUrl!);
    await _loadCredentials();
  }

  /// Set authentication credentials
  /// 
  /// [userId] - The user ID from Firebase
  /// [authToken] - The Firebase ID token
  Future<void> setAuthCredentials({
    required String userId,
    required String authToken,
  }) async {
    _userId = userId;
    _authToken = authToken;
    _apiService.setAuthToken(authToken);
    
    // Save credentials locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('offerwall_user_id', userId);
    await prefs.setString('offerwall_auth_token', authToken);
  }

  /// Clear authentication credentials
  Future<void> clearAuthCredentials() async {
    _userId = null;
    _authToken = null;
    _apiService.setAuthToken(null);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('offerwall_user_id');
    await prefs.remove('offerwall_auth_token');
  }

  /// Load saved credentials from local storage
  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('offerwall_user_id');
    final authToken = prefs.getString('offerwall_auth_token');
    
    if (userId != null && authToken != null) {
      _userId = userId;
      _authToken = authToken;
      _apiService.setAuthToken(authToken);
    }
  }

  /// Get the offerwall URL with authentication parameters
  String? getOfferwallUrl() {
    if (_baseUrl == null || _userId == null || _authToken == null) {
      return null;
    }
    return '$_baseUrl?userId=${Uri.encodeComponent(_userId!)}&token=${Uri.encodeComponent(_authToken!)}';
  }

  /// Get base URL
  String? get baseUrl => _baseUrl;

  /// Get current user ID
  String? get userId => _userId;

  /// Get current auth token
  String? get authToken => _authToken;

  /// Check if the plugin is initialized
  bool get isInitialized => _baseUrl != null;

  /// Check if user is authenticated
  bool get isAuthenticated => _userId != null && _authToken != null;

  // API Methods

  /// Get available offers
  Future<List<Offer>> getOffers() async {
    _ensureInitialized();
    _ensureAuthenticated();
    return await _apiService.getOffers(_userId!);
  }

  /// Get ongoing offers
  Future<List<OfferDetail>> getOngoingOffers() async {
    _ensureInitialized();
    _ensureAuthenticated();
    return await _apiService.getOngoingOffers(_userId!);
  }

  /// Get offer history
  Future<List<OfferDetail>> getOfferHistory() async {
    _ensureInitialized();
    _ensureAuthenticated();
    return await _apiService.getOfferHistory(_userId!);
  }

  /// Get specific offer details
  Future<OfferDetail> getOfferDetail(String offerId) async {
    _ensureInitialized();
    _ensureAuthenticated();
    return await _apiService.getOfferDetail(offerId, _userId!);
  }

  /// Get user profile
  Future<User> getUserProfile() async {
    _ensureInitialized();
    _ensureAuthenticated();
    return await _apiService.getUserProfile(_userId!);
  }

  /// Get user balance
  Future<Map<String, dynamic>> getUserBalance() async {
    _ensureInitialized();
    _ensureAuthenticated();
    return await _apiService.getUserBalance(_userId!);
  }

  void _ensureInitialized() {
    if (!isInitialized) {
      throw Exception('OfferwallFlutter is not initialized. Call initialize() first.');
    }
  }

  void _ensureAuthenticated() {
    if (!isAuthenticated) {
      throw Exception('User is not authenticated. Call setAuthCredentials() first.');
    }
  }
}
