import 'package:flutter/material.dart';

class TextFields extends StatefulWidget {
   final String hintText;
   final TextEditingController? controller;
   final bool visible;
   final bool obscureText ;
    final Widget? prefixIcons;
  const TextFields({super.key, required this.hintText, required this.visible, required this.controller, this.obscureText=false,  this.prefixIcons,});

  @override
  State<TextFields> createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
       controller: widget.controller,
       obscureText: obscureText&&widget.obscureText,
       decoration: InputDecoration(
          prefixIcon:  widget.prefixIcons,
          contentPadding: EdgeInsets.all(18),
          fillColor: const Color(0xFFF8F8F8),
          filled: true,
          hintText: widget.hintText,
             suffixIcon:Visibility(
               visible: widget.obscureText,
               child: GestureDetector(
                 onTap: (){
                   setState(() {
                     obscureText =!obscureText;
                   });
                 },
                 child: Visibility(
                   visible: widget.visible,
                     child: Icon(obscureText? Icons.visibility :Icons.visibility_off, size: 18.0,)),
               ),
             ),
           focusedBorder: OutlineInputBorder(
       borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(
        color: Colors.blue,)
      ),
           enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: BorderSide(
    color: Colors.grey.shade50,
    width: 2.0,
    ),),

       ),

    );
  }
}
