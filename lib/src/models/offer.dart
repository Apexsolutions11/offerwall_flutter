/// Represents an offer in the offerwall
class Offer {
  final String id;
  final String name;
  final String category;
  final String? photoUid;
  final String? photoUrl;
  final String? description;
  final int? coins;
  final int? diamonds;

  Offer({
    required this.id,
    required this.name,
    required this.category,
    this.photoUid,
    this.photoUrl,
    this.description,
    this.coins,
    this.diamonds,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      photoUid: json['photoUid'] as String?,
      photoUrl: json['photoUrl'] as String?,
      description: json['description'] as String?,
      coins: json['coins'] as int?,
      diamonds: json['diamonds'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'photoUid': photoUid,
      'photoUrl': photoUrl,
      'description': description,
      'coins': coins,
      'diamonds': diamonds,
    };
  }
}

/// Offer status enum
enum OfferStatus {
  pending,
  done,
  rejected,
  expired,
}

/// Offer category enum
enum OfferCategory {
  registration,
  playstoreReview,
  install,
  other,
}

/// User offer status enum
enum UserOfferStatus {
  new_,
  ongoing,
  completed,
}
