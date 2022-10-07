import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String bio;
  String emailId;
  String? userId;
  String profilePhoto;

  User(
      {required this.username,
      required this.userId,
      required this.profilePhoto,
      required this.emailId,
      required this.bio});

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final newUser = User.fromJson(snapshot.data() as Map<String, dynamic>);
    newUser.userId = snapshot.reference.id;
    return newUser;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['user_name'] as String,
        bio: json['bio'] as String,
        emailId: json['email'] as String,
        profilePhoto: json['profile_photo'] as String,
        userId: json['user_id'] as String);
  }

  Map<String, dynamic> toJson(User user) {
    return <String, dynamic>{
      'user_name': user.username,
      'bio': user.bio,
      'email': user.emailId,
      'user_id': user.userId,
      'profile_photo': user.profilePhoto
    };
  }

  @override
  String toString() => 'Username<$username>';
}
