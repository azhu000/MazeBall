
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(), 
      password: _passwordController.text.trim(),
      );
  }

  @override 
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
              
              //logo
              Icon(
                Icons.phone_android,
                size: 100
                ),
          
                SizedBox(height: 50), 
                
              // Welcome message
              Text(
                'Hello Again!',
                style: GoogleFonts.bebasNeue(
                  fontSize: 54,
                ),
              ),

              SizedBox(height: 10),   

              Text(
                'Welcome back! you\'ve been missed!',
                style: TextStyle(                
                  fontSize:20,
                  )
              ),
          
               SizedBox(height: 50),  
          
              // email address
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide( color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide( color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Email',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal:25.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.grey[200],
              //       border: Border.all(color: Colors.white),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.only(left: 20.0),
              //       child: TextField(
              //         decoration: InputDecoration(
              //           border:InputBorder.none,
              //           hintText: 'Email Address'
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              
              SizedBox(height: 20),  
          
              // password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide( color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide( color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Password',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                ),
              ),
                
               SizedBox(height: 20), 
          
              //sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:25.0),
                child: GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        ),
                      ),
                  ),
                ),
              ),
          
              SizedBox(height: 25), 
              //not a member? register now -> register page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle( 
                      fontWeight: FontWeight.bold,
                      )
                      ),
                  GestureDetector(
                    onTap: widget.showRegisterPage,
                    child: Text(
                      'Register Now',
                      style: TextStyle( 
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        ),
                    ),
                  ),

                ],
              ),
                
            ]),
          ),
        ),
      ),
    );
  }
}
