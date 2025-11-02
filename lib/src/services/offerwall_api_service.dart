import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/offer.dart';
import '../models/offer_detail.dart';
import '../models/user.dart';

class OfferwallApiService {
  String? _baseUrl;
  String? _authToken;

  void initialize({required String baseUrl}) {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
  }

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<List<Offer>> getOffers(String userId) async {
    final url = Uri.parse('$_baseUrl/api/v1/offers')
        .replace(queryParameters: {
      'userId': userId,
      'status': 'NEW',
    });

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> offersJson = jsonData['data'] ?? [];
      return offersJson.map((json) => Offer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load offers: ${response.statusCode}');
    }
  }

  Future<List<OfferDetail>> getOngoingOffers(String userId) async {
    final url = Uri.parse('$_baseUrl/api/v1/offers')
        .replace(queryParameters: {
      'userId': userId,
      'status': 'ONGOING',
    });

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> offersJson = jsonData['data'] ?? [];
      return offersJson.map((json) => OfferDetail.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ongoing offers: ${response.statusCode}');
    }
  }

  Future<List<OfferDetail>> getOfferHistory(String userId) async {
    final url = Uri.parse('$_baseUrl/api/v1/offers')
        .replace(queryParameters: {
      'userId': userId,
      'status': 'COMPLETED',
    });

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> offersJson = jsonData['data'] ?? [];
      return offersJson.map((json) => OfferDetail.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load offer history: ${response.statusCode}');
    }
  }

  Future<OfferDetail> getOfferDetail(String offerId, String userId) async {
    final url = Uri.parse('$_baseUrl/api/v1/offers/$offerId')
        .replace(queryParameters: {
      'userId': userId,
    });

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return OfferDetail.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load offer detail: ${response.statusCode}');
    }
  }

  Future<User> getUserProfile(String userId) async {
    final url = Uri.parse('$_baseUrl/api/v1/users/$userId');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load user profile: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getUserBalance(String userId) async {
    final url = Uri.parse('$_baseUrl/api/v1/users/$userId/balance');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load user balance: ${response.statusCode}');
    }
  }
}
