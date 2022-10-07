import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/features/firebase_repo/models/post.dart';

class PostDataRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('posts');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addPost(Post post) {
    return collection.add(post.toJson(post));
  }

  void updatePost(Post post) async {
    await collection.doc(post.userId).update(post.toJson(post));
  }

  void deletePost(Post post) async {
    await collection.doc(post.userId).delete();
  }
}
