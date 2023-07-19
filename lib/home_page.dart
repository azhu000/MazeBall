// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  final user = FirebaseAuth.instance.currentUser!;
  
  //document IDs
  List<String> docIDs= [];

  //get docIDS;
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('user').get().then((snapshot) => snapshot.docs.forEach((document){

      print(document.reference);
      docIDs.add(document.reference.id);
    }),
    );
  }

  @override
  void initState(){
    getDocId();
    super.initState();
  }
  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Signed In as: ' + user.email!),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.deepPurple,
              child: Text('Sign Out'),
              )
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 3,
            //     itemBuilder: (context,index){
            //     return ListTile(
            //       title: Text('name')

            //     );
            //   },
            //   ),
            //   ),
          ],
        ),
        ),
    );
  }
}