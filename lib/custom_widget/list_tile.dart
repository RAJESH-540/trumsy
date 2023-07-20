import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trumsy/TaskUIModel.dart';
import 'package:trumsy/auth_repository.dart';
import 'package:trumsy/custom_widget/alertbox.dart';

class CustomListTile extends StatefulWidget {
  final TaskUIModel model;

  const CustomListTile({super.key, required this.model});

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  final repo = AuthRepository();
  List<Color> tileColors = const [
    Color(0xffFDE7FF),
    Color(0xffF9FFE7),
    Color(0xffE7F5FF),
    Color(0xffFF9F9F),
  ];
  Random randomIndex = Random();

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onLongPress: () {

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Delete User Data'),
                content: const Text(
                    'Are you sure you want to delete this user data?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () async {
                      await repo.deleteTask(widget.model.docID);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      child: SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 2,
          color: tileColors[randomIndex.nextInt(4)],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            model: widget.model,
                          );
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/images/edit.png",
                        height: 20,
                        width: 20,
                        color: const Color(0xffA4A4A4),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.taskName,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.model.status,
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: Color(0xffA4A4A4)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
