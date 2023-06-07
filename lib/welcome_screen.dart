import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: EdgeInsets.all(25.0),
        children: [
          TextButton(
            onPressed: () {},
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Register'),
          )
        ],
      ),
    );
  }
}
