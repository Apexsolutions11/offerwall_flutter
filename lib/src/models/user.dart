/// User profile information
class User {
  final String uid;
  final String displayName;
  final String email;
  final bool emailVerified;
  final String? photoURL;
  final String? country;
  final String? appName;
  final bool isAnonymous;
  final bool isHacker;
  final int gamePlayed;
  final String createdAt;
  final String lastLoginAt;
  final String updatedAt;

  User({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.emailVerified,
    this.photoURL,
    this.country,
    this.appName,
    this.isAnonymous = false,
    this.isHacker = false,
    this.gamePlayed = 0,
    required this.createdAt,
    required this.lastLoginAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool? ?? false,
      photoURL: json['photoURL'] as String?,
      country: json['country'] as String?,
      appName: json['appName'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      isHacker: json['isHacker'] as bool? ?? false,
      gamePlayed: json['gamePlayed'] as int? ?? 0,
      createdAt: json['createdAt'] as String,
      lastLoginAt: json['lastLoginAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'emailVerified': emailVerified,
      'photoURL': photoURL,
      'country': country,
      'appName': appName,
      'isAnonymous': isAnonymous,
      'isHacker': isHacker,
      'gamePlayed': gamePlayed,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'updatedAt': updatedAt,
    };
  }
}
