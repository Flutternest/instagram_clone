import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/features/firebase_repo/models/user.dart';

class UserDataRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  void addUser(User user) async {
    await collection.doc(user.userId).set(user.toJson(user));
  }

  void updateUser(User user) async {
    await collection.doc(user.userId).update(user.toJson(user));
  }

  void deleteUser(User user) async {
    await collection.doc(user.userId).delete();
  }
}
