import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.deepPurple,
              child: Text('Sign Out'),
              )
    );
  }
}