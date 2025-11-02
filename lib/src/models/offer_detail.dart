import 'offer.dart';

/// Detailed information about an offer
class OfferDetail {
  final String id;
  final String name;
  final String category;
  final String? photoUrl;
  final String? description;
  final int? coins;
  final int? diamonds;
  final List<dynamic>? steps;
  final String? terms;
  final OfferStatus? status;
  final String url;
  final bool? isCompleted;
  final bool? isStarted;

  OfferDetail({
    required this.id,
    required this.name,
    required this.category,
    this.photoUrl,
    this.description,
    this.coins,
    this.diamonds,
    this.steps,
    this.terms,
    this.status,
    required this.url,
    this.isCompleted,
    this.isStarted,
  });

  factory OfferDetail.fromJson(Map<String, dynamic> json) {
    OfferStatus? status;
    if (json['status'] != null) {
      try {
        status = OfferStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == (json['status'] as String).toLowerCase(),
        );
      } catch (e) {
        status = null;
      }
    }

    return OfferDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      photoUrl: json['photoUrl'] as String?,
      description: json['description'] as String?,
      coins: json['coins'] as int?,
      diamonds: json['diamonds'] as int?,
      steps: json['steps'] as List<dynamic>?,
      terms: json['terms'] as String?,
      status: status,
      url: json['url'] as String,
      isCompleted: json['isCompleted'] as bool?,
      isStarted: json['isStarted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'photoUrl': photoUrl,
      'description': description,
      'coins': coins,
      'diamonds': diamonds,
      'steps': steps,
      'terms': terms,
      'status': status?.name.toUpperCase(),
      'url': url,
      'isCompleted': isCompleted,
      'isStarted': isStarted,
    };
  }
}
