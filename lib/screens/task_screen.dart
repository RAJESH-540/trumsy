
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trumsy/TaskUIModel.dart';
import 'package:trumsy/auth_repository.dart';
import 'package:trumsy/custom_widget/alertbox.dart';
import 'package:trumsy/custom_widget/list_tile.dart';
import 'package:trumsy/screens/create_screen.dart';
import 'package:trumsy/task_repository.dart';

import 'login_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Color randomColor = Color(Random().nextInt(0xffffffff));

  }
  String dropdownValue = 'Ongoing';
    final  repository= AuthRepository();
     final firebase= FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         centerTitle: true,
         title:Image.asset('assets/images/logo.png', height:40, width: 100,) ,
         backgroundColor: const Color(0xffD9D9D9),
          actions: [
            InkWell(
               onTap: ()  async{
                  showDialog(context: context, builder: (BuildContext context){
                    return  AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to Logout?'),
                      actions: [
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: ()  async{
                            print("logout");
                            Navigator.of(context).pop();
                            await repository.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));


                          },
                        ),
                      ],
                    );

                  });

                   // Navigator.pop(context);

               },
                child: Image.asset("assets/images/app_icon.png")),
             const SizedBox(width: 15,)
          ],

       ),
       floatingActionButton: FloatingActionButton(
         onPressed: () async{
            showDialog(context: context, builder: (BuildContext context){
             return CustomDialog();
            });
         },
          shape:  const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))
          ),
          backgroundColor: const Color(0xff9661FF),
          child: const Icon(Icons.add, color: Colors.white,),
       ),
       body:  Padding(
         padding: const EdgeInsets.all(18.0),
         child: SizedBox(
           height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width,
           child: Column(
             children: [
               DropdownButtonFormField<String>(
                 decoration: InputDecoration(
                   // contentPadding: EdgeInsets.all(16),
                   hintText: "Select",
                   enabledBorder: OutlineInputBorder(
                     borderSide: const BorderSide(color: Colors.blue, width: 2),
                     borderRadius: BorderRadius.circular(30),
                   ),
                   border: OutlineInputBorder(
                     borderSide: const BorderSide(color: Colors.blue, width: 2),
                     borderRadius: BorderRadius.circular(30),
                   ),
                   fillColor: const Color(0xFFF8F8F8),
                   filled: true,
                 ),
                 value: dropdownValue,
                 items: <String>[
                   'All',
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
                 // ..sort((a, b) => a.compareTo(b)),
                 onChanged: (String? newValue) {
                   setState(() {
                     dropdownValue = newValue!;
                   });
                 },
               ),
               StreamBuilder<List<TaskUIModel>>(builder: (_,snap){
                 print(snap);
                 if(snap.hasData){
                  return SizedBox(
                    height: MediaQuery.of(context).size.height*.70,
                    child: ListView.builder(itemBuilder: (_,index){
                      return Column(children: [


                           // SizedBox(height: 10,),
                          CustomListTile(model: snap.data![index])
                      ],);
                    },itemCount: snap.data?.length??0,),
                  );
                 }
                 return  const Center(child: CircularProgressIndicator(),);
               },
                 stream: TaskRepo().fetchTasksFromFireStore(status: dropdownValue),),
             ],
           ),
         ),
       ),
    );
  }


}
