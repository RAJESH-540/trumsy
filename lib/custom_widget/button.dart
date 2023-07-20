import 'package:flutter/material.dart';

class CustomRoundBtn extends StatefulWidget {
   final VoidCallback onPressed;
    final String btnText;
  const CustomRoundBtn({super.key, required this.onPressed, required this.btnText});

  @override
  State<CustomRoundBtn> createState() => _CustomRoundBtnState();
}

class _CustomRoundBtnState extends State<CustomRoundBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
       style: ElevatedButton.styleFrom(
         primary: Color(0xff9661FF),
         onPrimary: Colors.white,
         // shadowColor: Colors.greenAccent,
         elevation: 3,
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(32.0)),
         minimumSize: Size(200, 60),
       ),
        onPressed: widget.onPressed,
        child: Text(widget.btnText, style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),));
  }
}
