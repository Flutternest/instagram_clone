import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String username;
  String userId;
  String profilePhoto;
  String caption;
  String url;

  Post(
      {required this.username,
      required this.userId,
      required this.profilePhoto,
      required this.caption,
      required this.url});

  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    final newPost = Post.fromJson(snapshot.data() as Map<String, dynamic>);
    newPost.userId = snapshot.reference.id;
    return newPost;
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        username: json['user_name'] as String,
        userId: json['user_id'] as String,
        profilePhoto: json['profile_photo'] as String,
        caption: json['post_caption'] as String,
        url: json['post_url'] as String);
  }

  Map<String, dynamic> toJson(Post post) {
    return <String, dynamic>{
      'user_name': post.username,
      'user_id': post.userId,
      'profile_photo': post.profilePhoto,
      'post_caption': post.caption,
      'post_url': post.url
    };
  }

  @override
  String toString() => 'Post<$username>';
}
