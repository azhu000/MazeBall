// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth_page.dart';
import 'package:myapp/home_page.dart';
import 'navbar.dart';



class MainPage extends StatelessWidget{
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context, snapshot) {
          if (snapshot.hasData){
            return Navbar();
          } else{
            return AuthPage();
          }
        },
      )
    );
  }
}