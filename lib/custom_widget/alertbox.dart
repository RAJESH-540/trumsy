import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trumsy/TaskUIModel.dart';
import 'package:trumsy/custom_widget/textfield.dart';

class CustomDialog extends StatefulWidget {
  final TaskUIModel? model;

  const CustomDialog({super.key, this.model});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String? dropdownValue;
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    descriptionController.text=widget.model?.taskName??"";
    if(widget.model!=null){
      dropdownValue=widget.model?.status??"Ongoing";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      backgroundColor: Colors.white,
      title: const Text(textAlign: TextAlign.center, 'Create Task'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Task Name",
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: TextFields(
                hintText: "task",
                visible: false,
                controller: descriptionController,
              )),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Tag",
            style: TextStyle(color: Colors.black),
          ),
          DropdownButtonFormField<String?>(
            decoration: InputDecoration(
              hintText: "Select",

              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(40),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(40),
              ),
              fillColor: const Color(0xFFF8F8F8),
              filled: true,
            ),
            value: dropdownValue,
            items: <String>[
              'Ongoing',
              'Completed',
              'On Hold',
              'Not Started',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                String value = dropdownValue.toString();
                String taskText = descriptionController.text;
                addTask(taskText, value,docID: widget.model?.docID);
                // ...
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  // Function to add a task to Firestore
  void addTask(String taskName, String status, {String? docID}) async {
    try {
      CollectionReference tasksCollection =
          FirebaseFirestore.instance.collection('tasks');
      DateTime currentDate = DateTime.now();
      Timestamp timestamp = Timestamp.fromDate(currentDate);
      // Add task document with auto-generated ID
      if (docID == null) {
        tasksCollection
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("userTasks")
            .add({
          'taskName': taskName,
          'status': status,
          'date': timestamp,
        }).then((value) {
          print('Task added successfully');
        });
      } else {
        tasksCollection
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("userTasks")
            .doc(docID)
            .set({
          'taskName': taskName,
          'status': status,
          'date': timestamp,
        }).then((value) {
          print('Task updated successfully');
        });
      }
      // tasksCollection.doc().set(data)

      // // Get the ID of the newly created task document
      // String taskId = taskDoc.id;
      //
      // // Add userTasks subcollection to the task document
      // CollectionReference userTasksCollection = taskDoc.collection('userTasks');
      //
      // // Create a map with the task details
      // // Map<String, dynamic> taskData = ;
      //
      // // Add the task data to the userTasks subcollection
      //
      // await userTasksCollection.add(Map.from().cast<String,dynamic>().toString());
    } catch (e) {
      print('Error adding task: $e');
    }
  }
}
