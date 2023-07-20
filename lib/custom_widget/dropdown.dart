import 'package:flutter/material.dart';

class DropDownlist extends StatefulWidget {
  @override
  _DropDownlistState createState() => _DropDownlistState();
}

class _DropDownlistState extends State<DropDownlist> {
  String dropdownValue = 'Ongoing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Example'),
      ),
      body: Center(
        child: DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
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
        ),
      ),
    );
  }
}
