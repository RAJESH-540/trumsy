import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

class TaskUIModel {
  final String docID;
  final String taskName;
  final String status;
  final DateTime dateTime;

  TaskUIModel(
      {required this.docID,
      required this.taskName,
      required this.status,
      required this.dateTime});

  factory TaskUIModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    Timestamp timestamp = data['date'] as Timestamp;

    return TaskUIModel(
      docID: snapshot.id,
      taskName: data['taskName'] ?? '',
      status: data['status'] ?? '',
      dateTime: timestamp.toDate(),
    );
  }
}
