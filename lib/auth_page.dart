import 'package:flutter/material.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/register_page.dart';

class AuthPage extends StatefulWidget { 
  const AuthPage({Key? key}) : super(key: key);
  
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>{
  // initially shows loginPage
  bool showLoginPage = true;

  void toggleScreens(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build (BuildContext context){
    if (showLoginPage){
      return LoginPage(showRegisterPage: toggleScreens);
    }else{
      return RegisterPage(showLoginPage: toggleScreens);
    }
 }
} 