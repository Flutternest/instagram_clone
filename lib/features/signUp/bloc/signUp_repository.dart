import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/features/firebase_repo/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:instagram_clone/features/firebase_repo/models/user.dart'
    as user;

class SignUpRepository {
  final UserDataRepository repository = UserDataRepository();

  Future<SignUpResponse> signUp({
    required String email,
    required String password,
  }) async {
    SignUpResponse signUpResponse = SignUpResponse(success: false, message: "");
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      signUpResponse.success = true;
      signUpResponse.message = 'Successfully signed up.';
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('UserID', credential.user?.uid ?? "");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        signUpResponse.success = false;
        signUpResponse.message = 'The password provided is too weak.';
        rethrow;
      } else if (e.code == 'email-already-in-use') {
        signUpResponse.success = false;
        signUpResponse.message = 'The account already exists for that email.';
        rethrow;
      }
    } catch (e, st) {
      if (kDebugMode) {
        print("EXCEPTION CAUGHT::::: $e $st");
      }
    }
    return signUpResponse;
  }

  addUser(
      {required File file,
      required String username,
      required String bio,
      required String email}) async {
    SignUpResponse signUpResponse = SignUpResponse(success: false, message: "");
    String profileLink = "";
    if (file.path.isNotEmpty) {
      if (kDebugMode) {
        print("uploading image to firestore");
      }
      final storageRef = FirebaseStorage.instance.ref();
      String fileName = path.basename(file.path);
      final imagesRef = storageRef.child(
          "profilePics/${DateTime.now().millisecondsSinceEpoch}$fileName");
      try {
        await imagesRef.putFile(file);
        profileLink = await imagesRef.getDownloadURL();
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          print("CAUGHT EXCEPTION:::::: $e");
        }
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final String? userID = prefs.getString('UserID');

    if (kDebugMode) {
      print("adding user to firestore...");
    }
    final newUser = user.User(
        username: username,
        bio: bio,
        emailId: email,
        profilePhoto: profileLink,
        userId: userID);
    repository.addUser(newUser);

    signUpResponse.success = true;
    signUpResponse.message = "Added user successfully";
  }
}

class SignUpResponse {
  bool success;
  String message;
  SignUpResponse({required this.success, required this.message});
}
