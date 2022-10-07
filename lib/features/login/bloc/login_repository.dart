import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../user_data.dart';

class LogInRepository {
  UserData userData = UserData();
  logIn({
    required String email,
    required String password,
  }) async {
    LogInResponse logInResponse = LogInResponse(success: false, message: "");

    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      logInResponse.success = true;
      logInResponse.message = 'Successfully logged in.';
      UserData userData = UserData();
      userData.userId = (credential.user?.uid)!;
      await getData();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logInResponse.success = false;
        logInResponse.message = 'No user found for that email.';
        rethrow;
      } else if (e.code == 'wrong-password') {
        logInResponse.success = false;
        logInResponse.message = 'Wrong password provided for that user.';
        rethrow;
      }
    } catch (e) {
      print(e);
    }
    return logInResponse;
  }

  Future<dynamic> getData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userData.userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        final data = documentSnapshot.data() as Map?;
        if (data != null) {
          userData.bio = data['bio'].toString();
          userData.username = data['user_name'].toString();
          userData.userId = data['user_id'].toString();
          userData.profilePhoto = data['profile_photo'].toString();
        }
      } else {
        print('Document does not exist on the database');
      }
    });
    // var document =
    //     await FirebaseFirestore.instance.doc('users/${userData.userId}');
    // var data;
    //
    // await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
    //   data = snapshot.data;
    //   userData.username = data('user_name').toString();
    //   userData.bio = data('bio').toString();
    //   print(
    //       "DATAAAAA: $data        ${data('user_name').toString()}        ${data('bio').toString()}");
    // });
  }
}

class LogInResponse {
  bool success;
  String message;
  LogInResponse({required this.success, required this.message});
}
