
class UserDetails {
  final String name ;
  final String email;
  final String profilePic;
  final String uid;
  final String? lastSeen;

  UserDetails({
    required this.name,
    required this.email,
    required this.profilePic,
    required this.uid,
     this.lastSeen,
  });

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      name: map['name'],
      email: map['email'],
      profilePic: map['profilePic'],
      uid: map['uid'],
      lastSeen: map['lastSeen'],
    );
  }

  @override
  String toString() {
    return 'UserDetails{name: $name, email: $email, profilePic: $profilePic, uid: $uid, lastSeen: $lastSeen}';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'uid': uid,
      'lastSeen': lastSeen,
    };
  }

}