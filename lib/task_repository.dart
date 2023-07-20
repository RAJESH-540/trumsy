import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trumsy/TaskUIModel.dart';

class TaskRepo {
  Stream<List<TaskUIModel>> fetchTasksFromFireStore({String status = "Ongoing"}) {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    var request = FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('userTasks');
    if (status != "All") {
     return request.where("status", isEqualTo: status).snapshots().map((event) =>
         event.docs.map((e) => TaskUIModel.fromDocumentSnapshot(e)).toList());
    }
    return request.snapshots().map((event) =>
        event.docs.map((e) => TaskUIModel.fromDocumentSnapshot(e)).toList());
  }
}
