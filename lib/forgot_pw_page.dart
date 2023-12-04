import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset link sent! \nCheck your email'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bebasNeue(
                          fontSize: 54, color: Colors.deepPurple),
                    ),
                    SizedBox(height: 20),
                    //logo
                    Icon(Icons.password, size: 100),
                    SizedBox(height: 60),

                    Text(
                        'Enter your email! \n We will send you a password reset link',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                  ]),
            ),
          ),

          SizedBox(height: 20),

          // email address
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Email',
                  fillColor: Colors.grey[200],
                  filled: true),
            ),
          ),
          
          SizedBox(height: 10),

          MaterialButton(
            onPressed: passwordReset,
            child: Text(
              'Reset Password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            color: Colors.deepPurple,
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
          //   child: MaterialButton(
          //     onPressed: passwordReset,
          //     child: Container(
          //       padding: const EdgeInsets.all(20),
          //       decoration: BoxDecoration(
          //         color: Colors.deepPurple,
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       child: Center(
          //         child: Text(
          //           'Password Reset',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 20,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
