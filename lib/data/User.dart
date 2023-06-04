
class UserDetails {
  final String name ;
  final String email;
  final String profilePic;
  final String? lastSeen;

  UserDetails({
    required this.name,
    required this.email,
    required this.profilePic,
     this.lastSeen,
  });

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      name: map['name'],
      email: map['email'],
      profilePic: map['profilePic'],
      lastSeen: map['lastSeen'],
    );
  }

  @override
  String toString() {
    return 'UserDetails{name: $name, email: $email, profilePic: $profilePic, lastSeen: $lastSeen}';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'lastSeen': lastSeen,
    };
  }

}