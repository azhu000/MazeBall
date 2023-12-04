// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({
    Key? key,
    required this.showLoginPage,
    }) : super(key: key);
  
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController(); //we can add text controller for anything. not sure what we need

  @override 
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
  
  //User authentication
  Future signUp() async{
    //create user
    if(passwordConfirmed()){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(), 
      password: _passwordController.text.trim(),
      );
    
    // Asdd user details
    }
  }
 
  
  Future addUserDetails(String firstName, String lastName, String email) async{

    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email address': email,
    });

    addUserDetails(
      _firstNameController.text.trim(), 
      _lastNameController.text.trim(), 
      _emailController.text.trim(),
      //if variable type is int
      //int.parse(_emailController.text.trim()),
      );


  }

  bool passwordConfirmed(){

    if(_passwordController.text.trim() == _confirmpasswordController.text.trim()){
      return true;
    } else{
      return false;
    }
  }

  // initially shows loginPage
  bool showLoginPage = true;
  @override
  Widget build (BuildContext context){
    return Scaffold(

      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
             
             // Welcome message
              Text(
                'Hello There!',
                style: GoogleFonts.bebasNeue(
                  fontSize: 54,
                ),
              ),

              SizedBox(height: 10),   

              Text(
                'Register below with your details',
                style: TextStyle(                
                  fontSize:20,
                  )
              ),
          
               SizedBox(height: 50),  
              
              // firstName
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide( color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide( color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'First Name',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                ),
              ),
              
              SizedBox(height: 10), 

              // LaseName
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide( color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide( color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Last Name',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                ),
              ),
              
              SizedBox(height: 10), 
          
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
              
              SizedBox(height: 10),  
          
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
                
               SizedBox(height: 10), 

              // confirm password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  obscureText: true,
                  controller: _confirmpasswordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide( color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide( color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Confirm Password',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                ),
              ),
                
               SizedBox(height: 10), 
          
              //sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:25.0),
                child: GestureDetector(
                  onTap: signUp,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Sign Up',
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
                    'I am a member!',
                    style: TextStyle( 
                      fontWeight: FontWeight.bold,
                      )
                      ),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Text(
                      ' Login Now',
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