class User {
  final String uid;
  final String phoneNumber;
  final String? displayName;
  final DateTime? lastLogin;

  User({
    required this.uid,
    required this.phoneNumber,
    this.displayName,
    this.lastLogin,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      phoneNumber: json['phoneNumber'],
      displayName: json['displayName'],
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : null,
    );
  }
}
