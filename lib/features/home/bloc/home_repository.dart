import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/features/firebase_repo/post_repo.dart';
import 'package:path/path.dart' as path;
import '../../firebase_repo/models/post.dart';
import '../../user_data.dart';

class HomeRepository {
  UserData userData = UserData();
  final PostDataRepository postDataRepository = PostDataRepository();

  addPost({
    required File file,
    required String caption,
  }) async {
    String postLink = "";
    final storageRef = FirebaseStorage.instance.ref();
    String fileName = path.basename(file.path);
    final imagesRef = storageRef
        .child("posts/${DateTime.now().millisecondsSinceEpoch}$fileName");
    try {
      await imagesRef.putFile(file);
      postLink = await imagesRef.getDownloadURL();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("CAUGHT EXCEPTION:::::: $e");
      }
    }

    if (postLink.isNotEmpty) {
      if (kDebugMode) {
        print("adding post to firestore...");
      }
      final newPost = Post(
          username: userData.username,
          userId: userData.userId,
          profilePhoto: userData.profilePhoto,
          caption: caption,
          url: postLink);
      postDataRepository.addPost(newPost);
    }
  }
}

class LogInResponse {
  bool success;
  String message;
  LogInResponse({required this.success, required this.message});
}
